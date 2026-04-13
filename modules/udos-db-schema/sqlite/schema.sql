-- uDos T1 SQLite — cell/cube registry baseline (v1)
-- Pairs: uDosDev UDOS_FIVE_TIER_DATABASE_STRATEGY_LOCKED_v1.md

PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;

CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  username TEXT UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS cells (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users(id),
  layer TEXT CHECK(layer IN ('L300','L400','L500','L600','L700')),
  x INTEGER,
  y INTEGER,
  data TEXT,
  size INTEGER,
  encrypted BOOLEAN DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(layer, x, y)
);

CREATE TABLE IF NOT EXISTS cubes (
  id TEXT PRIMARY KEY,
  user_id TEXT REFERENCES users(id),
  layer TEXT CHECK(layer IN ('L300','L400','L500','L600','L700')),
  x INTEGER,
  y INTEGER,
  z INTEGER,
  data TEXT,
  size INTEGER,
  encrypted BOOLEAN DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(layer, x, y, z)
);

CREATE TABLE IF NOT EXISTS spatial_links (
  id TEXT PRIMARY KEY,
  from_cube_id TEXT REFERENCES cubes(id),
  to_cube_id TEXT REFERENCES cubes(id),
  link_type TEXT CHECK(link_type IN ('portal','path','reference','teleport')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS sync_state (
  device_id TEXT PRIMARY KEY,
  last_sync TIMESTAMP,
  version_vector TEXT
);
