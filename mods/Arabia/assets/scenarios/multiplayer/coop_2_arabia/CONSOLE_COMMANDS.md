# Arabia CO-2 Scenario — Console Debug Commands

## Overview

These console commands enable runtime testing of the coop_2_arabia mission without restarting. All commands are **stateless** and safe to run during gameplay.

**Access the console:** Press `Shift+Ctrl+Alt+L` during mission playback to open the scarlog debug console.

---

## Section 1: Enable/Disable Debug Logging

### Enable Full Debug Event Logging

```lua
DEBUG_ENABLED = true
print("Debug logging ENABLED - all events will be logged to scarlog")
```

**Effect:** Activates chronological event capture. Any subsequent mission events are timestamped and buffered.

---

### Disable Debug Logging

```lua
DEBUG_ENABLED = false
print("Debug logging DISABLED")
```

---

### Flush Event Log to Scarlog

```lua
Debug_Flush()
```

**Output:** Prints all buffered events in chronological order with timestamps (elapsed seconds from mission start).

**Example output:**
```
[DEBUG] ===== CHRONOLOGICAL EVENT LOG (Mission Duration) =====
[DEBUG] Total Events: 12
[DEBUG]
[DEBUG] [00.00s] [01] MISSION_START      Mission initialized, difficulty=1
[DEBUG] [01.23s] [01] PLAYER_READY       Ready to command english
[DEBUG] [05.67s] [01] OBJECTIVE_STARTED  Destroy Siege Workshop
[DEBUG] [42.34s] [01] OBJECTIVE_COMPLETED Destroy Siege Workshop
[DEBUG] [42.35s] [01] SIEGE_UNLOCK       Siege weapons unlocked
... (continues chronologically)
```

---

## Section 2: Real-time Statistics & Analysis

### Print Event Statistics

```lua
Debug_PrintStats()
```

**Output:** Shows:
- Total events logged
- Mission duration (elapsed seconds)
- Events grouped by type (OBJECTIVE_STARTED, SIEGE_UNLOCK, etc.)
- Events grouped by player ID

**Example:**
```
[DEBUG] ===== STATISTICS =====
[DEBUG] Total Events: 45
[DEBUG] Mission Duration: 125.4 seconds
[DEBUG]
[DEBUG] Events by Type:
[DEBUG]   OBJECTIVE_COMPLETED: 5
[DEBUG]   SIEGE_UNLOCK: 2
[DEBUG]   SPAWN_WAVE: 12
... (etc)
```

---

### Get Events Since a Time Threshold

```lua
local recent_events = Debug_GetEventsSince(60.0)  -- All events after 60 seconds
for _, evt in ipairs(recent_events) do
    print("  " .. evt.elapsed_sec .. "s: [P" .. evt.player_id .. "] " .. evt.event_type)
end
```

**Use case:** Filter to events that occurred during a specific phase (e.g., after minute 5).

---

### Get Events by Type

```lua
local siege_events = Debug_GetEventsByType(DEBUG_EVT_SIEGE_UNLOCK)
print("Total siege unlocks: " .. #siege_events)
```

**Valid event types:**
```lua
DEBUG_EVT_MISSION_START
DEBUG_EVT_MISSION_END
DEBUG_EVT_PLAYER_READY
DEBUG_EVT_PLAYER_DISCONNECT
DEBUG_EVT_PLAYER_TAKEOVER
DEBUG_EVT_RESTRICTION_APPLIED
DEBUG_EVT_OBJECTIVE_STARTED
DEBUG_EVT_OBJECTIVE_COMPLETED
DEBUG_EVT_PHASE_ENTERED
DEBUG_EVT_SPAWN_WAVE
DEBUG_EVT_SIEGE_UNLOCK
DEBUG_EVT_WORKSHOP_UNLOCK
DEBUG_EVT_PLAYER_DEFEAT
DEBUG_EVT_PLAYER_VICTORY
```

---

### Get Events by Player

```lua
local player1_events = Debug_GetEventsByPlayer(1)
print("Player 1 event count: " .. #player1_events)
```

---

## Section 3: Test Harnesses (Data Layer Validation)

All test harnesses are **console-safe** — they do NOT call Player_Set* APIs, only validate data structures.

### Test Player Progression Chain

```lua
Debug_SimulatePlayerProgression()
```

**Output:** For each player, displays:
- Civ name and resolved civ (with parent chain if DLC)
- Current restriction state (what's locked/unlocked)
- Profile chain progression (starting → siege_available → engineers_available → workshop_available)

**Example:**
```
[TEST] Player 1 (english → english):
[TEST]   [START] Restriction profile applied: 'starting'
[TEST]      ✓ Siege locked
[TEST]      ✓ Engineers locked
[TEST]      ✓ Workshop locked
[TEST]   [PHASE2] Profile applied: 'siege_available'
[TEST]      ✓ Siege unlocked
[TEST]   Profile chain:
[TEST]      [1] starting ✓
[TEST]      [2] siege_available ✓
```

---

### Test DLC Civ Resolution

```lua
Debug_SimulateDLCResolution()
```

**Output:** For each player:
- Raw raceName (from Player_GetRaceName)
- Resolved civ (after parent chain lookup)
- AGS_ENTITY_TABLE entry status (✓ or ✗)
- DLC parent chain (if applicable)
- Siege weapon lookup (mangonel attribName)

**Example:**
```
[TEST] Player 2 (abbasid_ha_01 → abbasid):
[TEST]   Raw: abbasid_ha_01
[TEST]   Resolved: abbasid
[TEST]   AGS_ENTITY_TABLE entry: ✓
[TEST]   Parent chain: abbasid_ha_01 → abbasid
[TEST]   DLC registration: ✓
[TEST]   Siege weapon (Mangonel): ✓ unit_mangonel_3_field_construct_abb_ha_01
```

---

### Dump Current Restriction State

```lua
Debug_DumpRestrictionState()
```

**Output:** For each player, shows:
- Current profile name (`starting`, `siege_available`, `engineers_available`, `workshop_available`)
- What's ACTUALLY unlocked/locked (interprets the profile name to show player state)

**Profile meanings:**
- `starting` = All locked (siege, engineers, workshop)
- `siege_available` = Siege UNLOCKED, engineers/workshop locked
- `engineers_available` = Siege + Engineers UNLOCKED, workshop locked
- `workshop_available` = All UNLOCKED

**Use case:** Check if a profile transition occurred after objective completion. Compare before/after objective to verify restriction unlocks.

**Example output after "Destroy Siege Workshop" objective:**
```
[TEST] Player plyr_mt: 0000018DCE098700:
[TEST]   Current profile: engineers_available
[TEST]   Siege: UNLOCKED
[TEST]   Engineers: UNLOCKED
[TEST]   Workshop: LOCKED
```

---

### Compare Arabia vs Japan Feature Parity

```lua
Debug_ComparisonWithJapan()
```

**Output:** Checklist showing Arabia v1.4 features and improvements over Japan v1.3.

---

### Validate Spawn Wave Compositions

```lua
Debug_SpawnWaveSimulation()
```

**Output:** Checks that all critical spawn wave keys exist in Unit_Types table:
```
[TEST] Critical spawn compositions:
[TEST]   units_camp: ✓ (8 unit entries)
[TEST]   units_patrol_hard: ✓ (5 unit entries)
[TEST]   wave_city_5m: ✓ (15 unit entries)
```

---

## Section 4: Real-time Log Snapshot Commands

### Print Current Difficulty Config

```lua
print(string.format("Current Difficulty Tier: %d (%s)", AI_Difficulty, DC.label))
print(string.format("Restrict Siege: %s", DC.restrict_siege and "yes" or "no"))
print(string.format("Restrict Engineers: %s", DC.restrict_engineers and "yes" or "no"))
print(string.format("Restrict Workshop: %s", DC.restrict_workshop and "yes" or "no"))
print(string.format("Restrict Age 4: %s", DC.restrict_age4 and "yes" or "no"))
print(string.format("Phase 2 Siege Profile: %s", DC.phase2_siege_profile))
print(string.format("Phase 2 Workshop Unlock: %s", DC.phase2_workshop_unlock and "yes" or "no"))
```

---

### Print All Player Civs (Raw & Resolved)

```lua
for _, player in pairs(PLAYERS) do
    local raw = string.lower(Player_GetRaceName(player.id))
    local resolved = GetPlayerCiv(player.id)
    print("P" .. player.id .. ": " .. raw .. " → " .. resolved)
end
```

---

### Validate Restriction Profiles Exist

```lua
Validator_RestrictionState()
```

**Output:** Checks that all players have valid profiles applied.

---

### Validate DLC Civ Registry

```lua
Validator_CivRegistry()
```

**Output:** Runs full DLC resolution validation:
- Parent cycle detection
- Parent existence verification
- Override structure validation
- Composition synchronization

---

## Section 5: Integrated Test Workflow

### Full Debug Session (Recommended)

```lua
-- [1] Enable logging
DEBUG_ENABLED = true

-- [2] Run all data layer tests
print("=== STARTING TEST SUITE ===")
Debug_SimulateDLCResolution()
Debug_SimulatePlayerProgression()
Debug_SpawnWaveSimulation()
Validator_CivRegistry()
Validator_RestrictionState()

-- [3] Let mission run for a few minutes, then flush
-- (Wait ~3-5 minutes in-game, then continue:)

-- [4] Flush events and stats
Debug_PrintStats()
Debug_Flush()

-- [5] Compare with Japan
Debug_ComparisonWithJapan()
```

---

### Quick Validation (30 seconds)

```lua
Debug_SimulatePlayerProgression()
Debug_SimulateDLCResolution()
Validator_RestrictionState()
```

---

### Event Log Analysis (After Mission Completes)

```lua
DEBUG_ENABLED = true
-- (Play mission to completion, then:)
Debug_Flush()
Debug_PrintStats()

-- Optional: Filter to specific event type
local siege_unlocks = Debug_GetEventsByType(DEBUG_EVT_SIEGE_UNLOCK)
print("Siege unlocks: " .. #siege_unlocks)

-- Optional: Filter to specific time window
local phase2_events = Debug_GetEventsSince(300)  -- Events after 5 minutes
print("Phase 2 events: " .. #phase2_events)
```

---

## Section 6: Troubleshooting Scenarios

### Tests to Run If Siege Weapons Don't Unlock

```lua
-- [1] Check civ resolution
Debug_SimulateDLCResolution()

-- [2] Check DLC registry
Validator_CivRegistry()

-- [3] Verify profile was applied
Debug_DumpRestrictionState()

-- [4] Check CBA_SIEGE_TABLE entry
if AGE_ENTITY_TABLE.english then
    print("English entry exists: ✓")
else
    print("English entry exists: ✗")
end

-- [5] Manually verify AGS_GetSiegeSquad
local mangonel = AGS_GetSiegeSquad("english", BP_SIEGE_MANGONEL)
if mangonel then
    print("Mangonel lookup: ✓ " .. tostring(mangonel))
else
    print("Mangonel lookup: ✗ NOT FOUND")
end
```

---

### Tests to Run If Objectives Don't Progress

```lua
-- [1] Check event log for objective completion attempts
local completed = Debug_GetEventsByType(DEBUG_EVT_OBJECTIVE_COMPLETED)
print("Objectives completed: " .. #completed)

-- [2] Check if restriction unlocks are firing
local unlocks = Debug_GetEventsByType(DEBUG_EVT_SIEGE_UNLOCK)
print("Siege unlocks: " .. #unlocks)

-- [3] Validate profile chain
Debug_SimulatePlayerProgression()
```

---

### Tests to Run If Difficulty Scaling Is Wrong

```lua
-- [1] Verify difficulty tier
print("Current Tier: " .. AI_Difficulty)
print("Config Label: " .. DC.label)

-- [2] Check DC field values
print(string.format("restrict_siege: %s", tostring(DC.restrict_siege)))
print(string.format("restrict_engineers: %s", tostring(DC.restrict_engineers)))
print(string.format("phase2_siege_profile: %s", DC.phase2_siege_profile))

-- [3] Validate Difficulty_Config table
for tier, dc in pairs(Difficulty_Config) do
    print("Tier " .. tier .. ": " .. dc.label)
end
```

---

## Section 7: Console Command Format Reference

### Basic Syntax

```lua
-- Single-line commands (paste directly into console):
DEBUG_ENABLED = true; print("Debug enabled")

-- Multi-line scripts (paste all at once):
DEBUG_ENABLED = true
print("Line 1")
print("Line 2")
```

### Accessing Nested Values

```lua
-- Current player's civ
local civ = GetPlayerCiv(1)

-- Current difficulty config
local restrict = DC.restrict_siege

-- Check if entry exists in table
if AGS_ENTITY_TABLE.english then
    print("Found")
end

-- Loop through players
for _, player in pairs(PLAYERS) do
    print("Player " .. player.id)
end
```

---

## Section 8: Output Interpretation

### When You See ✓ (Check Mark)

- Data integrity verified
- Table entry exists
- DLC registration found
- Profile is present and functional

### When You See ✗ (Cross Mark)

- **Critical issue** — mission functionality may be broken
- Check copilot-instructions.md for troubleshooting
- Validate AGS_ENTITY_TABLE and CBA_SIEGE_TABLE entries

### Elapsed Time Format

- `[00.00s]` = 0 seconds (mission start)
- `[05.67s]` = 5.67 seconds elapsed
- `[120.45s]` = 2 minutes 0.45 seconds

---

## Quick Command Reference (Copy-Paste Ready)

```lua
-- Enable/disable
DEBUG_ENABLED = true
DEBUG_ENABLED = false

-- Flush & analyze
Debug_Flush()
Debug_PrintStats()

-- Test suite (pick one)
Debug_SimulatePlayerProgression()
Debug_SimulateDLCResolution()
Debug_DumpRestrictionState()
Debug_ComparisonWithJapan()
Debug_SpawnWaveSimulation()

-- Validators
Validator_CivRegistry()
Validator_RestrictionState()

-- Filters
Debug_GetEventsByType(DEBUG_EVT_SIEGE_UNLOCK)
Debug_GetEventsBySince(60.0)
Debug_GetEventsByPlayer(1)
```

---

## Testing Procedure (Step-by-Step)

1. **Load Arabia CO-2 mission** (any difficulty, 2-player co-op)
2. **Open console** (Shift+Ctrl+Alt+L)
3. **Paste test commands from Section 5** (Full Debug Session)
4. **Run mission** (play for 2-5 minutes)
5. **Return to console** and paste flush commands
6. **Review scarlog output** for:
   - All test items marked ✓
   - Event log shows correct chronological order
   - No ERROR or FAIL messages
7. **Compare against Section 8** output interpretation

---

## Integration with coop_2_arabia_debug.scar

The debug module must be imported in main.scar for these commands to work:

```lua
import("Coop_2_Arabia_debug.scar")
```

If you see "function not defined" errors, verify the import is present in main.scar.

