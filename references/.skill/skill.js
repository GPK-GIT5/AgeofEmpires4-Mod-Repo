"use strict";
/**
 * SCAR Blueprint Resolution Copilot Skill
 * Resolves SCAR blueprint references into structured AoE4 metadata with persistent SQLite cache
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CacheSchema = exports.CacheManager = exports.SCARBlueprintSkill = void 0;
const fs_1 = __importDefault(require("fs"));
const path_1 = __importDefault(require("path"));
const cache_manager_1 = require("./cache-manager");
// ============================================================================
// SKILL IMPLEMENTATION
// ============================================================================
class SCARBlueprintSkill {
    constructor(skillDir, dataDir) {
        this.BATCH_SIZE_LIMIT = 100;
        this.MAX_SUGGESTIONS = 3;
        this.cacheManager = new cache_manager_1.CacheManager(skillDir);
        this.cacheManager.initialize();
        this.sourceFolders = {
            unit: path_1.default.join(dataDir, 'units'),
            building: path_1.default.join(dataDir, 'buildings'),
            technology: path_1.default.join(dataDir, 'technologies'),
        };
        this.civilizationIndex = this.loadCivilizationIndex(dataDir);
        this.blueprintLookupIndex = this.buildLookupIndex(dataDir);
    }
    /**
     * Load civilization index for validation
     */
    loadCivilizationIndex(dataDir) {
        const civIndexPath = path_1.default.join(dataDir, 'civilizations', 'civs-index.json');
        const index = new Map();
        try {
            if (fs_1.default.existsSync(civIndexPath)) {
                const data = JSON.parse(fs_1.default.readFileSync(civIndexPath, 'utf-8'));
                for (const [key, value] of Object.entries(data)) {
                    index.set(key, value);
                }
            }
        }
        catch (error) {
            console.warn(`[SKill] Failed to load civilization index: ${error}`);
        }
        return index;
    }
    /**
     * Build lightweight lookup index mapping pbgid → type (for fast routing)
     */
    buildLookupIndex(dataDir) {
        const index = new Map();
        const types = ['unit', 'building', 'technology'];
        for (const type of types) {
            const allJsonPath = path_1.default.join(this.sourceFolders[type], 'all.json');
            try {
                if (fs_1.default.existsSync(allJsonPath)) {
                    const data = JSON.parse(fs_1.default.readFileSync(allJsonPath, 'utf-8'));
                    if (Array.isArray(data)) {
                        for (const entry of data) {
                            if (entry.pbgid) {
                                index.set(entry.pbgid, { type, baseId: entry.baseId });
                            }
                        }
                    }
                }
            }
            catch (error) {
                console.warn(`[Skill] Failed to build lookup index for ${type}: ${error}`);
            }
        }
        return index;
    }
    /**
     * FUNCTION 1: Normalize input into canonical form
     */
    normalizeInput(input) {
        const { reference, civilizationTarget } = input;
        if (typeof reference === 'number') {
            return {
                pbgid: reference,
                civTarget: civilizationTarget,
                format: 'pbgid',
            };
        }
        if (typeof reference === 'string') {
            // Check if it's a pbgid string (numeric)
            if (/^\d+$/.test(reference)) {
                return {
                    pbgid: parseInt(reference, 10),
                    civTarget: civilizationTarget,
                    format: 'pbgid',
                };
            }
            // Check if it's a SCAR attribName (contains _ and lowercase)
            if (/^[a-z_]+$/.test(reference)) {
                return {
                    attribName: reference,
                    civTarget: civilizationTarget,
                    format: 'attribName',
                };
            }
            // Check if it's a legacy path format (contains \\ or /)
            if (reference.includes('\\') || reference.includes('/')) {
                // Extract basename for fuzzy matching
                const basename = path_1.default.basename(reference).toLowerCase();
                return {
                    attribName: basename,
                    civTarget: civilizationTarget,
                    format: 'path',
                };
            }
        }
        return { civTarget: civilizationTarget, format: 'unknown' };
    }
    /**
     * FUNCTION 2: Resolve blueprint (core function with cache L1 lookup)
     */
    async resolveBlueprint(input) {
        const startTime = Date.now();
        const normalized = this.normalizeInput(input);
        if (normalized.format === 'unknown') {
            return {
                reference: input.reference,
                valid: false,
                error: 'INVALID_FORMAT',
                details: 'Reference must be attribName (lowercase_with_underscores), pbgid (integer), or file path',
            };
        }
        try {
            let result = null;
            // Try pbgid first (if available)
            if (normalized.pbgid) {
                result = await this.resolveByPbgid(normalized.pbgid, startTime);
            }
            // Fallback to attribName
            if (!result && normalized.attribName) {
                result = await this.resolveByAttribName(normalized.attribName, startTime);
            }
            if (!result) {
                return {
                    reference: input.reference,
                    valid: false,
                    error: 'UNRESOLVED_BLUEPRINT',
                    details: `Could not resolve blueprint reference: ${input.reference}`,
                    suggestions: this.generateSuggestions(normalized),
                };
            }
            // Apply civilization validation if requested
            if (normalized.civTarget && result && 'valid' in result && result.valid) {
                return this.validateCivilization(result, normalized.civTarget);
            }
            return result;
        }
        catch (error) {
            return {
                reference: input.reference,
                valid: false,
                error: 'UNRESOLVED_BLUEPRINT',
                details: `Resolution error: ${error}`,
            };
        }
    }
    /**
     * Resolve by pbgid
     */
    async resolveByPbgid(pbgid, startTime) {
        // First, determine type from lookup index
        const typeInfo = this.blueprintLookupIndex.get(pbgid);
        if (!typeInfo) {
            return null;
        }
        const type = typeInfo.type;
        // L1: Cache lookup
        const cacheResult = this.cacheManager.lookupByPbgid(pbgid, type);
        if (cacheResult.hit && cacheResult.entry) {
            return this.entryToOutput(cacheResult.entry, startTime, 'cache');
        }
        // L2: JSON file lookup
        const entry = await this.loadFromJSON(pbgid, type);
        if (entry) {
            // Insert to cache for future hits
            this.cacheManager.insertEntry({ ...entry, source: 'json' });
            return this.entryToOutput(entry, startTime, 'json');
        }
        return null;
    }
    /**
     * Resolve by attribName
     */
    async resolveByAttribName(attribName, startTime) {
        // Try each type (units, buildings, technologies)
        const types = ['unit', 'building', 'technology'];
        for (const type of types) {
            // L1: Cache lookup
            const cacheResult = this.cacheManager.lookupByAttribName(attribName, type);
            if (cacheResult.hit && cacheResult.entry) {
                return this.entryToOutput(cacheResult.entry, startTime, 'cache');
            }
            // L2: JSON file lookup
            const entry = await this.loadFromJSONByAttribName(attribName, type);
            if (entry) {
                this.cacheManager.insertEntry({ ...entry, source: 'json' });
                return this.entryToOutput(entry, startTime, 'json');
            }
        }
        return null;
    }
    /**
     * Load blueprint record from JSON by pbgid
     */
    async loadFromJSON(pbgid, type) {
        const jsonPath = path_1.default.join(this.sourceFolders[type], 'all.json');
        try {
            if (!fs_1.default.existsSync(jsonPath)) {
                return null;
            }
            const data = JSON.parse(fs_1.default.readFileSync(jsonPath, 'utf-8'));
            if (!Array.isArray(data)) {
                return null;
            }
            const entry = data.find((e) => e.pbgid === pbgid);
            if (entry) {
                return this.jsonToEntry(entry, type);
            }
        }
        catch (error) {
            console.error(`[Skill] Error loading JSON for ${type}: ${error}`);
        }
        return null;
    }
    /**
     * Load blueprint record from JSON by attribName
     */
    async loadFromJSONByAttribName(attribName, type) {
        const jsonPath = path_1.default.join(this.sourceFolders[type], 'all.json');
        try {
            if (!fs_1.default.existsSync(jsonPath)) {
                return null;
            }
            const data = JSON.parse(fs_1.default.readFileSync(jsonPath, 'utf-8'));
            if (!Array.isArray(data)) {
                return null;
            }
            const entry = data.find((e) => e.attribName === attribName);
            if (entry) {
                return this.jsonToEntry(entry, type);
            }
        }
        catch (error) {
            console.error(`[Skill] Error loading JSON for ${type}: ${error}`);
        }
        return null;
    }
    /**
     * Convert raw JSON entry to CacheEntry
     */
    jsonToEntry(rawEntry, type) {
        return {
            pbgid: rawEntry.pbgid,
            id: rawEntry.id,
            baseId: rawEntry.baseId,
            attribName: rawEntry.attribName,
            type,
            name: rawEntry.name,
            age: rawEntry.age || 1,
            civs: JSON.stringify(rawEntry.civs || []),
            classes: JSON.stringify(rawEntry.classes || []),
            resolved_at: new Date().toISOString(),
            source: 'json',
        };
    }
    /**
     * Convert CacheEntry to SkillOutput
     */
    entryToOutput(entry, startTime, source) {
        const latency = Date.now() - startTime;
        return {
            pbgid: entry.pbgid,
            id: entry.id,
            baseId: entry.baseId,
            attribName: entry.attribName,
            type: entry.type,
            name: entry.name,
            age: entry.age,
            civs: typeof entry.civs === 'string' ? JSON.parse(entry.civs) : entry.civs,
            classes: typeof entry.classes === 'string' ? JSON.parse(entry.classes) : entry.classes,
            valid: true,
            source,
            latencyMs: latency,
        };
    }
    /**
     * FUNCTION 3: Validate civilization availability
     */
    validateCivilization(output, civTarget) {
        const available = output.civs.includes(civTarget);
        const warnings = [];
        if (!available) {
            const civInfo = this.civilizationIndex.get(civTarget);
            const civName = civInfo?.name || civTarget;
            warnings.push(`Blueprint not available for civilization: ${civName}`);
            warnings.push(`Available for: ${output.civs.join(', ')}`);
            return {
                ...output,
                civilizationAvailable: false,
                validationWarnings: warnings,
            };
        }
        return {
            ...output,
            civilizationAvailable: true,
        };
    }
    /**
     * Generate suggestions for unresolved blueprints
     */
    generateSuggestions(normalized) {
        // Placeholder: could implement fuzzy matching or similar-blueprint recommendations
        return [];
    }
    /**
     * FUNCTION 4: Batch resolution with optimized caching
     */
    async resolveBatch(input) {
        const { blueprints } = input;
        if (blueprints.length > this.BATCH_SIZE_LIMIT) {
            // Return error for oversized batch
            return [
                {
                    reference: `batch_${blueprints.length}`,
                    valid: false,
                    error: 'BATCH_TOO_LARGE',
                    details: `Batch size ${blueprints.length} exceeds limit ${this.BATCH_SIZE_LIMIT}. Please split into multiple requests.`,
                },
            ];
        }
        // Normalize all inputs
        const normalized = blueprints.map(b => ({ input: b, normalized: this.normalizeInput(b) }));
        // Separate by type for optimized lookups
        const byType = {
            unit: [],
            building: [],
            technology: [],
        };
        for (const item of normalized) {
            const typeInfo = item.normalized.pbgid ? this.blueprintLookupIndex.get(item.normalized.pbgid) : null;
            if (typeInfo) {
                byType[typeInfo.type].push(item);
            }
        }
        // Batch cache lookups per type
        const results = [];
        const startTime = Date.now();
        for (const type of Object.keys(byType)) {
            const items = byType[type];
            if (items.length === 0)
                continue;
            // Extract pbgids for batch lookup
            const pbgids = items.filter(i => i.normalized.pbgid).map(i => i.normalized.pbgid);
            if (pbgids.length > 0) {
                const batchResult = this.cacheManager.batchLookupByPbgid(pbgids, type);
                // Process hits
                for (const entry of batchResult.hits) {
                    results.push(this.entryToOutput(entry, startTime, 'cache'));
                }
                // For misses, fall back to single resolution
                for (const miss of batchResult.misses) {
                    // Find original input for this pbgid
                    const item = items.find(i => i.normalized.pbgid === miss);
                    if (item) {
                        const resolved = await this.resolveBlueprint(item.input);
                        results.push(resolved);
                    }
                }
            }
        }
        return results;
    }
    /**
     * Get cache statistics
     */
    getCacheStats() {
        return this.cacheManager.getCacheStats();
    }
    /**
     * Get cache metadata
     */
    getCacheMetadata() {
        return this.cacheManager.getMetadata();
    }
    /**
     * Reset cache (manual)
     */
    resetCache() {
        this.cacheManager.resetCache();
    }
    /**
     * Shutdown Skill gracefully
     */
    shutdown() {
        this.cacheManager.shutdown();
    }
}
exports.SCARBlueprintSkill = SCARBlueprintSkill;
// ============================================================================
// EXPORTS
// ============================================================================
var cache_manager_2 = require("./cache-manager");
Object.defineProperty(exports, "CacheManager", { enumerable: true, get: function () { return cache_manager_2.CacheManager; } });
var schema_1 = require("./schema");
Object.defineProperty(exports, "CacheSchema", { enumerable: true, get: function () { return schema_1.CacheSchema; } });
//# sourceMappingURL=skill.js.map