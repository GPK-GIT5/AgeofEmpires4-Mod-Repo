/**
 * SCAR Blueprint Resolution Copilot Skill
 * Resolves SCAR blueprint references into structured AoE4 metadata with persistent SQLite cache
 */

import fs from 'fs';
import path from 'path';
import { CacheManager, CacheLookupResult } from './cache-manager';
import { CacheEntry } from './schema';

// ============================================================================
// TYPES & INTERFACES
// ============================================================================

export type BlueprintType = 'unit' | 'building' | 'technology';

export interface SkillInput {
  reference: string | number;
  civilizationTarget?: string;
}

export interface BatchSkillInput {
  blueprints: SkillInput[];
}

export interface SkillOutput {
  pbgid: number;
  id: string;
  baseId: string;
  attribName: string;
  type: BlueprintType;
  name: string;
  age: number;
  civs: string[];
  classes: string[];
  valid: true;
  source: 'cache' | 'json' | 'index';
  latencyMs?: number;
}

export interface SkillValidationOutput extends SkillOutput {
  civilizationAvailable: boolean;
  validationWarnings?: string[];
}

export interface SkillError {
  reference: string | number;
  valid: false;
  error: 'UNRESOLVED_BLUEPRINT' | 'INVALID_FORMAT' | 'CIV_MISMATCH' | 'BATCH_TOO_LARGE';
  suggestions?: SkillOutput[];
  details?: string;
}

export interface NormalizedReference {
  attribName?: string;
  pbgid?: number;
  civTarget?: string;
  format: 'attribName' | 'pbgid' | 'path' | 'unknown';
}

// ============================================================================
// SKILL IMPLEMENTATION
// ============================================================================

export class SCARBlueprintSkill {
  private cacheManager: CacheManager;
  private sourceFolders: { [key in BlueprintType]: string };
  private civilizationIndex: Map<string, any>;
  private blueprintLookupIndex: Map<number, { type: BlueprintType; baseId: string }>;
  private readonly BATCH_SIZE_LIMIT = 100;
  private readonly MAX_SUGGESTIONS = 3;

  constructor(skillDir: string, dataDir: string) {
    this.cacheManager = new CacheManager(skillDir);
    this.cacheManager.initialize();

    this.sourceFolders = {
      unit: path.join(dataDir, 'units'),
      building: path.join(dataDir, 'buildings'),
      technology: path.join(dataDir, 'technologies'),
    };

    this.civilizationIndex = this.loadCivilizationIndex(dataDir);
    this.blueprintLookupIndex = this.buildLookupIndex(dataDir);
  }

  /**
   * Load civilization index for validation
   */
  private loadCivilizationIndex(dataDir: string): Map<string, any> {
    const civIndexPath = path.join(dataDir, 'civilizations', 'civs-index.json');
    const index = new Map<string, any>();

    try {
      if (fs.existsSync(civIndexPath)) {
        const data = JSON.parse(fs.readFileSync(civIndexPath, 'utf-8'));
        for (const [key, value] of Object.entries(data)) {
          index.set(key, value);
        }
      }
    } catch (error) {
      console.warn(`[SKill] Failed to load civilization index: ${error}`);
    }

    return index;
  }

  /**
   * Build lightweight lookup index mapping pbgid → type (for fast routing)
   */
  private buildLookupIndex(dataDir: string): Map<number, { type: BlueprintType; baseId: string }> {
    const index = new Map<number, { type: BlueprintType; baseId: string }>();

    const types: BlueprintType[] = ['unit', 'building', 'technology'];
    for (const type of types) {
      const allJsonPath = path.join(this.sourceFolders[type], 'all.json');
      try {
        if (fs.existsSync(allJsonPath)) {
          const data = JSON.parse(fs.readFileSync(allJsonPath, 'utf-8'));
          if (Array.isArray(data)) {
            for (const entry of data) {
              if (entry.pbgid) {
                index.set(entry.pbgid, { type, baseId: entry.baseId });
              }
            }
          }
        }
      } catch (error) {
        console.warn(`[Skill] Failed to build lookup index for ${type}: ${error}`);
      }
    }

    return index;
  }

  /**
   * FUNCTION 1: Normalize input into canonical form
   */
  private normalizeInput(input: SkillInput): NormalizedReference {
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
        const basename = path.basename(reference).toLowerCase();
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
  async resolveBlueprint(input: SkillInput): Promise<SkillOutput | SkillError> {
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
      let result: SkillOutput | SkillError | null = null;

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
    } catch (error) {
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
  private async resolveByPbgid(pbgid: number, startTime: number): Promise<SkillOutput | SkillError | null> {
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
  private async resolveByAttribName(attribName: string, startTime: number): Promise<SkillOutput | SkillError | null> {
    // Try each type (units, buildings, technologies)
    const types: BlueprintType[] = ['unit', 'building', 'technology'];

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
  private async loadFromJSON(pbgid: number, type: BlueprintType): Promise<CacheEntry | null> {
    const jsonPath = path.join(this.sourceFolders[type], 'all.json');

    try {
      if (!fs.existsSync(jsonPath)) {
        return null;
      }

      const data = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));
      if (!Array.isArray(data)) {
        return null;
      }

      const entry = data.find((e: any) => e.pbgid === pbgid);
      if (entry) {
        return this.jsonToEntry(entry, type);
      }
    } catch (error) {
      console.error(`[Skill] Error loading JSON for ${type}: ${error}`);
    }

    return null;
  }

  /**
   * Load blueprint record from JSON by attribName
   */
  private async loadFromJSONByAttribName(attribName: string, type: BlueprintType): Promise<CacheEntry | null> {
    const jsonPath = path.join(this.sourceFolders[type], 'all.json');

    try {
      if (!fs.existsSync(jsonPath)) {
        return null;
      }

      const data = JSON.parse(fs.readFileSync(jsonPath, 'utf-8'));
      if (!Array.isArray(data)) {
        return null;
      }

      const entry = data.find((e: any) => e.attribName === attribName);
      if (entry) {
        return this.jsonToEntry(entry, type);
      }
    } catch (error) {
      console.error(`[Skill] Error loading JSON for ${type}: ${error}`);
    }

    return null;
  }

  /**
   * Convert raw JSON entry to CacheEntry
   */
  private jsonToEntry(rawEntry: any, type: BlueprintType): CacheEntry {
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
  private entryToOutput(entry: CacheEntry, startTime: number, source: 'cache' | 'json' | 'index'): SkillOutput {
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
  private validateCivilization(output: SkillOutput, civTarget: string): SkillValidationOutput | SkillError {
    const available = output.civs.includes(civTarget);
    const warnings: string[] = [];

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
  private generateSuggestions(normalized: NormalizedReference): SkillOutput[] {
    // Placeholder: could implement fuzzy matching or similar-blueprint recommendations
    return [];
  }

  /**
   * FUNCTION 4: Batch resolution with optimized caching
   */
  async resolveBatch(input: BatchSkillInput): Promise<(SkillOutput | SkillError)[]> {
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
    const byType: { [key in BlueprintType]: Array<{ input: SkillInput; normalized: NormalizedReference }> } = {
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
    const results: (SkillOutput | SkillError)[] = [];
    const startTime = Date.now();

    for (const type of Object.keys(byType) as BlueprintType[]) {
      const items = byType[type];
      if (items.length === 0) continue;

      // Extract pbgids for batch lookup
      const pbgids = items.filter(i => i.normalized.pbgid).map(i => i.normalized.pbgid!);

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
  public getCacheStats() {
    return this.cacheManager.getCacheStats();
  }

  /**
   * Get cache metadata
   */
  public getCacheMetadata() {
    return this.cacheManager.getMetadata();
  }

  /**
   * Reset cache (manual)
   */
  public resetCache(): void {
    this.cacheManager.resetCache();
  }

  /**
   * Shutdown Skill gracefully
   */
  public shutdown(): void {
    this.cacheManager.shutdown();
  }
}

// ============================================================================
// EXPORTS
// ============================================================================

export {
  CacheManager,
  CacheEntry,
  CacheMetadata,
  CacheLookupResult,
  BatchLookupResult,
} from './cache-manager';

export { CacheSchema } from './schema';
