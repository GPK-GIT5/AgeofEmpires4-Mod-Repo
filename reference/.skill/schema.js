"use strict";
/**
 * SQLite Schema Initialization for SCAR Blueprint Resolution Cache
 * Defines database structure, tables, indices, and version tracking
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.CacheSchema = exports.DEFAULT_CACHE_METADATA = void 0;
const better_sqlite3_1 = __importDefault(require("better-sqlite3"));
exports.DEFAULT_CACHE_METADATA = {
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
class CacheSchema {
    constructor(dbPath) {
        this.dbPath = dbPath;
        this.db = new better_sqlite3_1.default(dbPath);
        this.initializeDatabase();
    }
    /**
     * Initialize database with WAL mode and pragma settings
     */
    initializeDatabase() {
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
    createTables() {
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
    createIndices() {
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
    insertEntry(entry) {
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
    batchInsertEntries(entries) {
        const transaction = this.db.transaction((ents) => {
            for (const entry of ents) {
                this.insertEntry(entry);
            }
        });
        transaction(entries);
    }
    /**
     * Query by pbgid
     */
    queryByPbgid(pbgid, type) {
        const stmt = this.db.prepare(`SELECT * FROM ${type} WHERE pbgid = ?`);
        return stmt.get(pbgid);
    }
    /**
     * Query by attribName
     */
    queryByAttribName(attribName, type) {
        const stmt = this.db.prepare(`SELECT * FROM ${type} WHERE attribName = ?`);
        return stmt.get(attribName);
    }
    /**
     * Query multiple entries by pbgid (batch lookup)
     */
    queryByPbgidBatch(pbgids, type) {
        const placeholders = pbgids.map(() => '?').join(',');
        const stmt = this.db.prepare(`SELECT * FROM ${type} WHERE pbgid IN (${placeholders})`);
        return stmt.all(...pbgids);
    }
    /**
     * Get statistics about cache content
     */
    getCacheStats() {
        const units = this.db.prepare('SELECT COUNT(*) as count FROM units').get().count;
        const buildings = this.db.prepare('SELECT COUNT(*) as count FROM buildings').get().count;
        const technologies = this.db.prepare('SELECT COUNT(*) as count FROM technologies').get().count;
        return { units, buildings, technologies };
    }
    /**
     * Delete entry by pbgid
     */
    deleteEntry(pbgid, type) {
        const stmt = this.db.prepare(`DELETE FROM ${type} WHERE pbgid = ?`);
        stmt.run(pbgid);
    }
    /**
     * Clear all entries from a table (invalidation)
     */
    clearTable(type) {
        const stmt = this.db.prepare(`DELETE FROM ${type}`);
        stmt.run();
    }
    /**
     * Clear all cache (full reset)
     */
    clearAllTables() {
        this.db.exec('DELETE FROM units; DELETE FROM buildings; DELETE FROM technologies;');
    }
    /**
     * Export cache entries as JSON
     */
    exportToJSON() {
        const units = this.db.prepare('SELECT * FROM units').all();
        const buildings = this.db.prepare('SELECT * FROM buildings').all();
        const technologies = this.db.prepare('SELECT * FROM technologies').all();
        return { units, buildings, technologies };
    }
    /**
     * Get all entries modified since a timestamp
     */
    getDirtyEntries(since) {
        const units = this.db.prepare('SELECT * FROM units WHERE resolved_at > ?').all(since);
        const buildings = this.db.prepare('SELECT * FROM buildings WHERE resolved_at > ?').all(since);
        const technologies = this.db.prepare('SELECT * FROM technologies WHERE resolved_at > ?').all(since);
        return { units, buildings, technologies };
    }
    /**
     * Verify database integrity
     */
    verifyIntegrity() {
        try {
            const result = this.db.prepare('PRAGMA integrity_check').get();
            return result.integrity_check === 'ok';
        }
        catch {
            return false;
        }
    }
    /**
     * Close database connection
     */
    close() {
        this.db.close();
    }
    /**
     * Get database instance (for advanced queries)
     */
    getDatabase() {
        return this.db;
    }
}
exports.CacheSchema = CacheSchema;
//# sourceMappingURL=schema.js.map