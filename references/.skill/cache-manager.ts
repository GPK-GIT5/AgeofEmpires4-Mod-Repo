/**
 * Cache Manager: Handles initialization, lookup, and persistence
 * Manages SQLite cache with warm-up, dirty tracking, and periodic sync
 */

import fs from 'fs';
import path from 'path';
import { CacheSchema, CacheEntry, CacheMetadata, DEFAULT_CACHE_METADATA } from './schema';

// Helper: Map singular type to plural breakdown key
function getBreakdownKey(type: 'unit' | 'building' | 'technology'): 'units' | 'buildings' | 'technologies' {
  const mapping = {
    unit: 'units' as const,
    building: 'buildings' as const,
    technology: 'technologies' as const,
  };
  return mapping[type];
}

export interface CacheLookupResult {
  hit: boolean;
  entry?: CacheEntry;
  source: 'cache' | 'json' | 'index' | 'miss';
  latencyMs: number;
}

export interface BatchLookupResult {
  hits: CacheEntry[];
  misses: string[] | number[];  // References not found in cache
  hitRate: number;
  totalLatencyMs: number;
}

export class CacheManager {
  private schema: CacheSchema;
  private metadata: CacheMetadata;
  private metadataPath: string;
  private dbPath: string;
  private resolutionCounter: number = 0;
  private dirtyEntries: Set<number> = new Set();
  private performanceBuffer: number[] = [];

  constructor(skillDir: string) {
    this.dbPath = path.join(skillDir, 'blueprints.db');
    this.metadataPath = path.join(skillDir, 'cache-metadata.json');
    
    this.schema = new CacheSchema(this.dbPath);
    this.metadata = this.loadMetadata();
    this.validateCacheHealth();
  }

  /**
   * Initialize cache on first use
   */
  public initialize(): void {
    // Check if DB already has tables
    const stats = this.schema.getCacheStats();
    const isNew = stats.units === 0 && stats.buildings === 0 && stats.technologies === 0;

    if (isNew) {
      this.schema.createTables();
      this.schema.createIndices();
      this.metadata = { ...DEFAULT_CACHE_METADATA, cache_init_date: new Date().toISOString() };
      this.saveMetadata();
    }
  }

  /**
   * Check cache health: verify file timestamps and integrity
   */
  private validateCacheHealth(): void {
    // Verify DB integrity
    if (!this.schema.verifyIntegrity()) {
      console.warn('[CacheManager] Database integrity check failed; cache may be corrupted');
      this.metadata.cache_invalidated = true;
    }

    // Check source file timestamps
    this.checkSourceTimestamps();
  }

  /**
   * Compare source file timestamps vs. cached timestamps
   */
  private checkSourceTimestamps(): void {
    const dataDir = path.join(__dirname, '../../..', 'data');
    const sourceFiles = {
      units: path.join(dataDir, 'units', 'all.json'),
      buildings: path.join(dataDir, 'buildings', 'all.json'),
      technologies: path.join(dataDir, 'technologies', 'all.json'),
    };

    let anyStale = false;

    for (const [type, filePath] of Object.entries(sourceFiles)) {
      if (fs.existsSync(filePath)) {
        const stats = fs.statSync(filePath);
        const fileModTime = stats.mtime.toISOString();
        const cachedTime = this.metadata.source_timestamps[type as keyof typeof sourceFiles];

        if (new Date(fileModTime) > new Date(cachedTime)) {
          console.warn(`[CacheManager] Source file ${type}/all.json is newer than cache; marking stale`);
          anyStale = true;
        }
      }
    }

    if (anyStale) {
      this.metadata.cache_invalidated = true;
      this.saveMetadata();
    }
  }

  /**
   * Lookup blueprint in cache by attribName
   */
  public lookupByAttribName(attribName: string, type: 'unit' | 'building' | 'technology'): CacheLookupResult {
    const startTime = Date.now();

    try {
      const entry = this.schema.queryByAttribName(attribName, type);
      const latency = Date.now() - startTime;

      if (entry) {
        this.metadata.cache_hits++;
        this.recordPerformance(latency);
        return { hit: true, entry, source: 'cache', latencyMs: latency };
      } else {
        this.metadata.cache_misses++;
        return { hit: false, source: 'miss', latencyMs: latency };
      }
    } catch (error) {
      console.error(`[CacheManager] Error during attribName lookup: ${error}`);
      return { hit: false, source: 'miss', latencyMs: Date.now() - startTime };
    }
  }

  /**
   * Lookup blueprint in cache by pbgid
   */
  public lookupByPbgid(pbgid: number, type: 'unit' | 'building' | 'technology'): CacheLookupResult {
    const startTime = Date.now();

    try {
      const entry = this.schema.queryByPbgid(pbgid, type);
      const latency = Date.now() - startTime;

      if (entry) {
        this.metadata.cache_hits++;
        this.recordPerformance(latency);
        return { hit: true, entry, source: 'cache', latencyMs: latency };
      } else {
        this.metadata.cache_misses++;
        return { hit: false, source: 'miss', latencyMs: latency };
      }
    } catch (error) {
      console.error(`[CacheManager] Error during pbgid lookup: ${error}`);
      return { hit: false, source: 'miss', latencyMs: Date.now() - startTime };
    }
  }

  /**
   * Batch lookup by pbgids (optimized for multiple queries)
   */
  public batchLookupByPbgid(pbgids: number[], type: 'unit' | 'building' | 'technology'): BatchLookupResult {
    const startTime = Date.now();

    try {
      const entries = this.schema.queryByPbgidBatch(pbgids, type);
      const foundPbgids = new Set(entries.map(e => e.pbgid));
      const misses = pbgids.filter(id => !foundPbgids.has(id));

      const hitRate = entries.length / pbgids.length;
      this.metadata.cache_hits += entries.length;
      this.metadata.cache_misses += misses.length;

      const totalLatency = Date.now() - startTime;
      this.recordPerformance(totalLatency / pbgids.length);

      return {
        hits: entries,
        misses,
        hitRate,
        totalLatencyMs: totalLatency,
      };
    } catch (error) {
      console.error(`[CacheManager] Error during batch lookup: ${error}`);
      return { hits: [], misses: pbgids, hitRate: 0, totalLatencyMs: Date.now() - startTime };
    }
  }

  /**
   * Insert resolved blueprint into cache
   */
  public insertEntry(entry: CacheEntry): void {
    try {
      this.schema.insertEntry(entry);
      this.dirtyEntries.add(entry.pbgid);
      this.metadata.dirty_count++;
      this.metadata.total_entries++;
      this.metadata.entry_breakdown[getBreakdownKey(entry.type)]++;

      this.resolutionCounter++;

      // Trigger periodic sync if threshold reached
      if (this.resolutionCounter % this.metadata.sync_interval_resolutions === 0) {
        this.periodicSync();
      }
    } catch (error) {
      console.error(`[CacheManager] Error inserting entry: ${error}`);
    }
  }

  /**
   * Batch insert entries (optimized)
   */
  public batchInsertEntries(entries: CacheEntry[]): void {
    try {
      this.schema.batchInsertEntries(entries);

      for (const entry of entries) {
        this.dirtyEntries.add(entry.pbgid);
        this.metadata.entry_breakdown[getBreakdownKey(entry.type)]++;
      }

      this.metadata.dirty_count += entries.length;
      this.metadata.total_entries += entries.length;
      this.resolutionCounter += entries.length;

      if (this.resolutionCounter % this.metadata.sync_interval_resolutions === 0) {
        this.periodicSync();
      }
    } catch (error) {
      console.error(`[CacheManager] Error batch inserting entries: ${error}`);
    }
  }

  /**
   * Periodic sync: export dirty entries and reset counters
   */
  public periodicSync(): void {
    try {
      const lastFlush = new Date(this.metadata.last_flush);
      const dirtyEntries = this.schema.getDirtyEntries(lastFlush.toISOString());

      const backupPath = path.dirname(this.dbPath);
      const exportFile = path.join(backupPath, 'blueprint-cache-export.json');

      fs.writeFileSync(exportFile, JSON.stringify(dirtyEntries, null, 2));

      this.metadata.last_flush = new Date().toISOString();
      this.metadata.dirty_count = 0;
      this.dirtyEntries.clear();
      this.metadata.last_stats_export = new Date().toISOString();

      this.saveMetadata();

      console.log(`[CacheManager] Periodic sync completed: exported ${Object.values(dirtyEntries).flat().length} entries`);
    } catch (error) {
      console.error(`[CacheManager] Error during periodic sync: ${error}`);
    }
  }

  /**
   * Manual invalidation of a specific entry
   */
  public invalidateEntry(pbgid: number, type: 'unit' | 'building' | 'technology', reason?: string): void {
    try {
      this.schema.deleteEntry(pbgid, type);
      this.metadata.total_entries--;
      this.metadata.entry_breakdown[getBreakdownKey(type)]--;
      console.log(`[CacheManager] Invalidated entry ${pbgid} (${type}) - Reason: ${reason || 'manual'}`);
      this.saveMetadata();
    } catch (error) {
      console.error(`[CacheManager] Error invalidating entry: ${error}`);
    }
  }

  /**
   * Full cache reset (synchronous)
   */
  public resetCache(): void {
    try {
      this.schema.clearAllTables();
      this.metadata = { ...DEFAULT_CACHE_METADATA, cache_init_date: this.metadata.cache_init_date };
      this.dirtyEntries.clear();
      this.resolutionCounter = 0;
      this.performanceBuffer = [];
      this.saveMetadata();
      console.log('[CacheManager] Cache fully reset');
    } catch (error) {
      console.error(`[CacheManager] Error resetting cache: ${error}`);
    }
  }

  /**
   * Record performance metric for averaging
   */
  private recordPerformance(latencyMs: number): void {
    this.performanceBuffer.push(latencyMs);

    // Keep buffer bounded
    if (this.performanceBuffer.length > 1000) {
      this.performanceBuffer = this.performanceBuffer.slice(-500);
    }

    // Update average
    if (this.performanceBuffer.length > 0) {
      const avg = this.performanceBuffer.reduce((a, b) => a + b, 0) / this.performanceBuffer.length;
      this.metadata.avg_resolution_ms = parseFloat(avg.toFixed(2));
    }
  }

  /**
   * Update cache hit rate
   */
  public updateHitRate(): void {
    const total = this.metadata.cache_hits + this.metadata.cache_misses;
    if (total > 0) {
      this.metadata.cache_hit_rate = parseFloat((this.metadata.cache_hits / total).toFixed(4));
    }
  }

  /**
   * Load metadata from file
   */
  private loadMetadata(): CacheMetadata {
    try {
      if (fs.existsSync(this.metadataPath)) {
        const data = fs.readFileSync(this.metadataPath, 'utf-8');
        return JSON.parse(data);
      }
    } catch (error) {
      console.warn(`[CacheManager] Error loading metadata: ${error}`);
    }

    return { ...DEFAULT_CACHE_METADATA };
  }

  /**
   * Save metadata to file
   */
  private saveMetadata(): void {
    try {
      this.updateHitRate();
      fs.writeFileSync(this.metadataPath, JSON.stringify(this.metadata, null, 2));
    } catch (error) {
      console.error(`[CacheManager] Error saving metadata: ${error}`);
    }
  }

  /**
   * Get current metadata
   */
  public getMetadata(): CacheMetadata {
    this.updateHitRate();
    return this.metadata;
  }

  /**
   * Export full cache as JSON
   */
  public exportCacheAsJSON(): Record<string, CacheEntry[]> {
    return this.schema.exportToJSON();
  }

  /**
   * Get cache statistics
   */
  public getCacheStats() {
    const stats = this.schema.getCacheStats();
    return {
      ...stats,
      total: stats.units + stats.buildings + stats.technologies,
      hitRate: this.metadata.cache_hit_rate,
      avgLatencyMs: this.metadata.avg_resolution_ms,
      isDirty: this.metadata.dirty_count > 0,
      isInvalidated: this.metadata.cache_invalidated,
    };
  }

  /**
   * Graceful shutdown
   */
  public shutdown(): void {
    try {
      if (this.dirtyEntries.size > 0) {
        this.periodicSync();
      }
      this.updateHitRate();
      this.saveMetadata();
      this.schema.close();
      console.log('[CacheManager] Shutdown complete');
    } catch (error) {
      console.error(`[CacheManager] Error during shutdown: ${error}`);
    }
  }
}

// Re-export types from schema for convenience
export type { CacheEntry, CacheMetadata, CacheSchema } from './schema';

