/**
 * Cache Manager: Handles initialization, lookup, and persistence
 * Manages SQLite cache with warm-up, dirty tracking, and periodic sync
 */
import { CacheEntry, CacheMetadata } from './schema';
export interface CacheLookupResult {
    hit: boolean;
    entry?: CacheEntry;
    source: 'cache' | 'json' | 'index' | 'miss';
    latencyMs: number;
}
export interface BatchLookupResult {
    hits: CacheEntry[];
    misses: string[] | number[];
    hitRate: number;
    totalLatencyMs: number;
}
export declare class CacheManager {
    private schema;
    private metadata;
    private metadataPath;
    private dbPath;
    private resolutionCounter;
    private dirtyEntries;
    private performanceBuffer;
    constructor(skillDir: string);
    /**
     * Initialize cache on first use
     */
    initialize(): void;
    /**
     * Check cache health: verify file timestamps and integrity
     */
    private validateCacheHealth;
    /**
     * Compare source file timestamps vs. cached timestamps
     */
    private checkSourceTimestamps;
    /**
     * Lookup blueprint in cache by attribName
     */
    lookupByAttribName(attribName: string, type: 'unit' | 'building' | 'technology'): CacheLookupResult;
    /**
     * Lookup blueprint in cache by pbgid
     */
    lookupByPbgid(pbgid: number, type: 'unit' | 'building' | 'technology'): CacheLookupResult;
    /**
     * Batch lookup by pbgids (optimized for multiple queries)
     */
    batchLookupByPbgid(pbgids: number[], type: 'unit' | 'building' | 'technology'): BatchLookupResult;
    /**
     * Insert resolved blueprint into cache
     */
    insertEntry(entry: CacheEntry): void;
    /**
     * Batch insert entries (optimized)
     */
    batchInsertEntries(entries: CacheEntry[]): void;
    /**
     * Periodic sync: export dirty entries and reset counters
     */
    periodicSync(): void;
    /**
     * Manual invalidation of a specific entry
     */
    invalidateEntry(pbgid: number, type: 'unit' | 'building' | 'technology', reason?: string): void;
    /**
     * Full cache reset (synchronous)
     */
    resetCache(): void;
    /**
     * Record performance metric for averaging
     */
    private recordPerformance;
    /**
     * Update cache hit rate
     */
    updateHitRate(): void;
    /**
     * Load metadata from file
     */
    private loadMetadata;
    /**
     * Save metadata to file
     */
    private saveMetadata;
    /**
     * Get current metadata
     */
    getMetadata(): CacheMetadata;
    /**
     * Export full cache as JSON
     */
    exportCacheAsJSON(): Record<string, CacheEntry[]>;
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
     * Graceful shutdown
     */
    shutdown(): void;
}
export type { CacheEntry, CacheMetadata, CacheSchema } from './schema';
//# sourceMappingURL=cache-manager.d.ts.map