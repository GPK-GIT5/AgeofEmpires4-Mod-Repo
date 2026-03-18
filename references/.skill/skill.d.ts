/**
 * SCAR Blueprint Resolution Copilot Skill
 * Resolves SCAR blueprint references into structured AoE4 metadata with persistent SQLite cache
 */
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
export declare class SCARBlueprintSkill {
    private cacheManager;
    private sourceFolders;
    private civilizationIndex;
    private blueprintLookupIndex;
    private readonly BATCH_SIZE_LIMIT;
    private readonly MAX_SUGGESTIONS;
    constructor(skillDir: string, dataDir: string);
    /**
     * Load civilization index for validation
     */
    private loadCivilizationIndex;
    /**
     * Build lightweight lookup index mapping pbgid → type (for fast routing)
     */
    private buildLookupIndex;
    /**
     * FUNCTION 1: Normalize input into canonical form
     */
    private normalizeInput;
    /**
     * FUNCTION 2: Resolve blueprint (core function with cache L1 lookup)
     */
    resolveBlueprint(input: SkillInput): Promise<SkillOutput | SkillError>;
    /**
     * Resolve by pbgid
     */
    private resolveByPbgid;
    /**
     * Resolve by attribName
     */
    private resolveByAttribName;
    /**
     * Load blueprint record from JSON by pbgid
     */
    private loadFromJSON;
    /**
     * Load blueprint record from JSON by attribName
     */
    private loadFromJSONByAttribName;
    /**
     * Convert raw JSON entry to CacheEntry
     */
    private jsonToEntry;
    /**
     * Convert CacheEntry to SkillOutput
     */
    private entryToOutput;
    /**
     * FUNCTION 3: Validate civilization availability
     */
    private validateCivilization;
    /**
     * Generate suggestions for unresolved blueprints
     */
    private generateSuggestions;
    /**
     * FUNCTION 4: Batch resolution with optimized caching
     */
    resolveBatch(input: BatchSkillInput): Promise<(SkillOutput | SkillError)[]>;
    /**
     * Get cache statistics
     */
    getCacheStats(): {
        total: number;
        hitRate: number;
        avgLatencyMs: number;
        isDirty: boolean;
        isInvalidated: boolean;
        units: number;
        buildings: number;
        technologies: number;
    };
    /**
     * Get cache metadata
     */
    getCacheMetadata(): import("./schema").CacheMetadata;
    /**
     * Reset cache (manual)
     */
    resetCache(): void;
    /**
     * Shutdown Skill gracefully
     */
    shutdown(): void;
}
export { CacheManager, CacheEntry, CacheMetadata, CacheLookupResult, BatchLookupResult, } from './cache-manager';
export { CacheSchema } from './schema';
//# sourceMappingURL=skill.d.ts.map