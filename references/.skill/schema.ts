/**
 * SQLite Schema Initialization for SCAR Blueprint Resolution Cache
 * Defines database structure, tables, indices, and version tracking
 */

import Database from 'better-sqlite3';
import path from 'path';

export interface CacheEntry {
  pbgid: number;
  id: string;
  baseId: string;
  attribName: string;
  type: 'unit' | 'building' | 'technology';
  name: string;
  age: number;
  civs: string;  // JSON array: ["ab", "en", ...]
  classes: string;  // JSON array: ["ranged_infantry", ...]
  resolved_at: string;  // ISO 8601 timestamp
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

export const DEFAULT_CACHE_METADATA: CacheMetadata = {
  cache_init_date: new Date().toISOString(),
  last_flush: new Date().toISOString(),
  total_entries: 0,
  entry_breakdown: { units: 0, buildings: 0, technologies: 0 },
  source_timestamps: {
    units: new Date(0).toISOString(),
    buildings: new Date(0).toISOString(),
    technologies: new Date(0).toISOString(),
  },
  dirty_count: 0,
  schema_version: '1.0',
  cache_invalidated: false,
  cache_hit_rate: 0,
  cache_misses: 0,
  cache_hits: 0,
  avg_resolution_ms: 0,
  sync_interval_resolutions: 50,
  last_stats_export: new Date().toISOString(),
};

export class CacheSchema {
  private db: Database.Database;
  private dbPath: string;

  constructor(dbPath: string) {
    this.dbPath = dbPath;
    this.db = new Database(dbPath);
    this.initializeDatabase();
  }

  /**
   * Initialize database with WAL mode and pragma settings
   */
  private initializeDatabase(): void {
    // Enable WAL mode for concurrent read/write access
    this.db.pragma('journal_mode = WAL');
    // Foreign key constraints
    this.db.pragma('foreign_keys = ON');
    // Synchronous mode: NORMAL for balance of safety and performance
    this.db.pragma('synchronous = NORMAL');
  }

  /**
   * Create all required tables and indices
   */
  public createTables(): void {
    const createTableSQL = `
      CREATE TABLE IF NOT EXISTS units (
        pbgid INTEGER PRIMARY KEY,
        id TEXT UNIQUE NOT NULL,
        baseId TEXT NOT NULL,
        attribName TEXT UNIQUE NOT NULL,
        type TEXT NOT NULL CHECK(type='unit'),
        name TEXT NOT NULL,
        age INTEGER CHECK(age >= 1 AND age <= 4),
        civs TEXT NOT NULL,
        classes TEXT,
        resolved_at TEXT NOT NULL,
        source TEXT NOT NULL CHECK(source IN ('cache', 'json', 'index'))
      );

      CREATE TABLE IF NOT EXISTS buildings (
        pbgid INTEGER PRIMARY KEY,
        id TEXT UNIQUE NOT NULL,
        baseId TEXT NOT NULL,
        attribName TEXT UNIQUE NOT NULL,
        type TEXT NOT NULL CHECK(type='building'),
        name TEXT NOT NULL,
        age INTEGER CHECK(age >= 1 AND age <= 4),
        civs TEXT NOT NULL,
        classes TEXT,
        resolved_at TEXT NOT NULL,
        source TEXT NOT NULL CHECK(source IN ('cache', 'json', 'index'))
      );

      CREATE TABLE IF NOT EXISTS technologies (
        pbgid INTEGER PRIMARY KEY,
        id TEXT UNIQUE NOT NULL,
        baseId TEXT NOT NULL,
        attribName TEXT UNIQUE NOT NULL,
        type TEXT NOT NULL CHECK(type='technology'),
        name TEXT NOT NULL,
        age INTEGER CHECK(age >= 1 AND age <= 4),
        civs TEXT NOT NULL,
        classes TEXT,
        resolved_at TEXT NOT NULL,
        source TEXT NOT NULL CHECK(source IN ('cache', 'json', 'index'))
      );
    `;

    // Execute table creation for all three types
    this.db.exec(createTableSQL);
  }

  /**
   * Create indices for optimized lookups
   */
  public createIndices(): void {
    const createIndicesSQL = `
      -- Units indices
      CREATE INDEX IF NOT EXISTS idx_units_attribName ON units(attribName);
      CREATE INDEX IF NOT EXISTS idx_units_baseId ON units(baseId);
      CREATE INDEX IF NOT EXISTS idx_units_civs ON units(civs);
      CREATE INDEX IF NOT EXISTS idx_units_resolved_at ON units(resolved_at);

      -- Buildings indices
      CREATE INDEX IF NOT EXISTS idx_buildings_attribName ON buildings(attribName);
      CREATE INDEX IF NOT EXISTS idx_buildings_baseId ON buildings(baseId);
      CREATE INDEX IF NOT EXISTS idx_buildings_civs ON buildings(civs);
      CREATE INDEX IF NOT EXISTS idx_buildings_resolved_at ON buildings(resolved_at);

      -- Technologies indices
      CREATE INDEX IF NOT EXISTS idx_technologies_attribName ON technologies(attribName);
      CREATE INDEX IF NOT EXISTS idx_technologies_baseId ON technologies(baseId);
      CREATE INDEX IF NOT EXISTS idx_technologies_civs ON technologies(civs);
      CREATE INDEX IF NOT EXISTS idx_technologies_resolved_at ON technologies(resolved_at);
    `;

    this.db.exec(createIndicesSQL);
  }

  /**
   * Insert a cache entry into the appropriate table
   */
  public insertEntry(entry: CacheEntry): void {
    const { type, pbgid, id, baseId, attribName, name, age, civs, classes, resolved_at, source } = entry;

    const stmt = this.db.prepare(`
      INSERT OR REPLACE INTO ${type} 
      (pbgid, id, baseId, attribName, type, name, age, civs, classes, resolved_at, source)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    `);

    stmt.run(pbgid, id, baseId, attribName, type, name, age, civs, classes, resolved_at, source);
  }

  /**
   * Batch insert entries (optimized for performance)
   */
  public batchInsertEntries(entries: CacheEntry[]): void {
    const transaction = this.db.transaction((ents: CacheEntry[]) => {
      for (const entry of ents) {
        this.insertEntry(entry);
      }
    });

    transaction(entries);
  }

  /**
   * Query by pbgid
   */
  public queryByPbgid(pbgid: number, type: string): CacheEntry | undefined {
    const stmt = this.db.prepare(`SELECT * FROM ${type} WHERE pbgid = ?`);
    return stmt.get(pbgid) as CacheEntry | undefined;
  }

  /**
   * Query by attribName
   */
  public queryByAttribName(attribName: string, type: string): CacheEntry | undefined {
    const stmt = this.db.prepare(`SELECT * FROM ${type} WHERE attribName = ?`);
    return stmt.get(attribName) as CacheEntry | undefined;
  }

  /**
   * Query multiple entries by pbgid (batch lookup)
   */
  public queryByPbgidBatch(pbgids: number[], type: string): CacheEntry[] {
    const placeholders = pbgids.map(() => '?').join(',');
    const stmt = this.db.prepare(`SELECT * FROM ${type} WHERE pbgid IN (${placeholders})`);
    return stmt.all(...pbgids) as CacheEntry[];
  }

  /**
   * Get statistics about cache content
   */
  public getCacheStats(): { units: number; buildings: number; technologies: number } {
    const units = (this.db.prepare('SELECT COUNT(*) as count FROM units').get() as any).count;
    const buildings = (this.db.prepare('SELECT COUNT(*) as count FROM buildings').get() as any).count;
    const technologies = (this.db.prepare('SELECT COUNT(*) as count FROM technologies').get() as any).count;

    return { units, buildings, technologies };
  }

  /**
   * Delete entry by pbgid
   */
  public deleteEntry(pbgid: number, type: string): void {
    const stmt = this.db.prepare(`DELETE FROM ${type} WHERE pbgid = ?`);
    stmt.run(pbgid);
  }

  /**
   * Clear all entries from a table (invalidation)
   */
  public clearTable(type: string): void {
    const stmt = this.db.prepare(`DELETE FROM ${type}`);
    stmt.run();
  }

  /**
   * Clear all cache (full reset)
   */
  public clearAllTables(): void {
    this.db.exec('DELETE FROM units; DELETE FROM buildings; DELETE FROM technologies;');
  }

  /**
   * Export cache entries as JSON
   */
  public exportToJSON(): Record<string, CacheEntry[]> {
    const units = this.db.prepare('SELECT * FROM units').all() as CacheEntry[];
    const buildings = this.db.prepare('SELECT * FROM buildings').all() as CacheEntry[];
    const technologies = this.db.prepare('SELECT * FROM technologies').all() as CacheEntry[];

    return { units, buildings, technologies };
  }

  /**
   * Get all entries modified since a timestamp
   */
  public getDirtyEntries(since: string): Record<string, CacheEntry[]> {
    const units = this.db.prepare('SELECT * FROM units WHERE resolved_at > ?').all(since) as CacheEntry[];
    const buildings = this.db.prepare('SELECT * FROM buildings WHERE resolved_at > ?').all(since) as CacheEntry[];
    const technologies = this.db.prepare('SELECT * FROM technologies WHERE resolved_at > ?').all(since) as CacheEntry[];

    return { units, buildings, technologies };
  }

  /**
   * Verify database integrity
   */
  public verifyIntegrity(): boolean {
    try {
      const result = this.db.prepare('PRAGMA integrity_check').get() as any;
      return result.integrity_check === 'ok';
    } catch {
      return false;
    }
  }

  /**
   * Close database connection
   */
  public close(): void {
    this.db.close();
  }

  /**
   * Get database instance (for advanced queries)
   */
  public getDatabase(): Database.Database {
    return this.db;
  }
}
