/**
 * SQLite Schema Initialization for SCAR Blueprint Resolution Cache
 * Defines database structure, tables, indices, and version tracking
 */
import Database from 'better-sqlite3';
export interface CacheEntry {
    pbgid: number;
    id: string;
    baseId: string;
    attribName: string;
    type: 'unit' | 'building' | 'technology';
    name: string;
    age: number;
    civs: string;
    classes: string;
    resolved_at: string;
    source: 'cache' | 'json' | 'index';
}
export interface CacheMetadata {
    cache_init_date: string;
    last_flush: string;
    total_entries: number;
    entry_breakdown: {
        units: number;
        buildings: number;
        technologies: number;
    };
    source_timestamps: {
        units: string;
        buildings: string;
        technologies: string;
    };
    dirty_count: number;
    schema_version: string;
    cache_invalidated: boolean;
    cache_hit_rate: number;
    cache_misses: number;
    cache_hits: number;
    avg_resolution_ms: number;
    sync_interval_resolutions: number;
    last_stats_export: string;
}
export declare const DEFAULT_CACHE_METADATA: CacheMetadata;
export declare class CacheSchema {
    private db;
    private dbPath;
    constructor(dbPath: string);
    /**
     * Initialize database with WAL mode and pragma settings
     */
    private initializeDatabase;
    /**
     * Create all required tables and indices
     */
    createTables(): void;
    /**
     * Create indices for optimized lookups
     */
    createIndices(): void;
    /**
     * Insert a cache entry into the appropriate table
     */
    insertEntry(entry: CacheEntry): void;
    /**
     * Batch insert entries (optimized for performance)
     */
    batchInsertEntries(entries: CacheEntry[]): void;
    /**
     * Query by pbgid
     */
    queryByPbgid(pbgid: number, type: string): CacheEntry | undefined;
    /**
     * Query by attribName
     */
    queryByAttribName(attribName: string, type: string): CacheEntry | undefined;
    /**
     * Query multiple entries by pbgid (batch lookup)
     */
    queryByPbgidBatch(pbgids: number[], type: string): CacheEntry[];
    /**
     * Get statistics about cache content
     */
    getCacheStats(): {
        units: number;
        buildings: number;
        technologies: number;
    };
    /**
     * Delete entry by pbgid
     */
    deleteEntry(pbgid: number, type: string): void;
    /**
     * Clear all entries from a table (invalidation)
     */
    clearTable(type: string): void;
    /**
     * Clear all cache (full reset)
     */
    clearAllTables(): void;
    /**
     * Export cache entries as JSON
     */
    exportToJSON(): Record<string, CacheEntry[]>;
    /**
     * Get all entries modified since a timestamp
     */
    getDirtyEntries(since: string): Record<string, CacheEntry[]>;
    /**
     * Verify database integrity
     */
    verifyIntegrity(): boolean;
    /**
     * Close database connection
     */
    close(): void;
    /**
     * Get database instance (for advanced queries)
     */
    getDatabase(): Database.Database;
}
//# sourceMappingURL=schema.d.ts.map