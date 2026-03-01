# Arabia Mod — Implementation Plan

> **Copilot Execution Prompt:** "Execute the Arabia implementation plan. Read `mods/Arabia/IMPLEMENTATION-PLAN.md`, verify each phase against `coop_2_arabia.scar`, and implement any incomplete phases incrementally. Backup before editing. Update `reference/mods/arabia-mod-index.md` after code changes. Mark phases complete as you go."

**Date:** 2026-02-28  
**Goal:** Port critical improvements from Japan mod to Arabia 2-player co-op scenario  
**Status:** ✅ Implemented (2026-02-28)

---

## Executive Summary

After analysis of Japan mod (4-player, 5,097 lines) vs. Arabia mod (2-player, 1,911 lines), the following improvements are ready for implementation. All changes target **robustness and player experience** in co-op multiplayer.

**Excluded improvements:**
- ❌ **Custom HUD Pattern** — Using `UI_SetPlayerDataContext` override instead per workspace standards
- ❌ **Game_GetLocalPlayer()** — Not needed with standard MissionOMatic objectives
- ❌ **Timer/Counter HUD** — Existing `Objective_StartTimer()` works correctly

---

## Implementation Checklist

### Phase 1: Core Stability (30 min)

#### 1.1 Disable Condensed Objectives UI
**File:** `coop_2_arabia.scar` — `Mission_Start()` or `Mission_Preset()`  
**Priority:** ⚡ HIGH  
**Effort:** 5 min

```lua
-- After player setup (player1, player2 created)
-- In Mission_Start() or Mission_Preset()
for _, player in pairs(PLAYERS) do
    UI_SetPlayerDataContext(player.id, {hide_condensed_objectives_override = true})
end
```

**Rationale:** Prevents condensed UI from interfering with objective chain display.

---

#### 1.2 Disable Annihilation Win Conditions
**File:** `coop_2_arabia.scar` — `Mission_Start()`  
**Priority:** ⚡ HIGH  
**Effort:** 5 min

```lua
-- In Mission_Start(), after Objective_Start calls
-- Disable 'Annihilation' defeat condition to prevent false defeats
Rule_RemoveGlobalEvent(Annihilation_OnEntityKilled)
Rule_RemoveGlobalEvent(Annihilation_OnLandmarkDestroyed)
Rule_RemoveGlobalEvent(Annihilation_OnConstructionComplete)
```

**Rationale:** Prevents premature defeat if players lose landmarks during co-op play. The timed objective (`OBJ_SeizeCity`) and mission-specific conditions handle victory/defeat.

---

### Phase 2: Player Management (60 min)

#### 2.1 Add AI Takeover Prevention System
**File:** `coop_2_arabia.scar` — `Mission_Start()` + new functions  
**Priority:** 🟡 MEDIUM  
**Effort:** 30 min

**Step 1: Global state tracking**
```lua
-- Add after GetRecipe(), before Mission_SetupPlayers()

-- Track original human/AI state for personality enforcement
g_original_player_types = {}

-- All player slots (human co-op + AI enemy)
ALL_PLAYER_SLOTS = {}  -- populated in Mission_Start
```

**Step 2: Snapshot initial player types**
```lua
-- In Mission_Start(), after player globals exist, before objective starts
ALL_PLAYER_SLOTS = { player1, player2, player3 }

-- Snapshot initial player types before any disconnects
for i, pid in ipairs(ALL_PLAYER_SLOTS) do
    g_original_player_types[i] = Player_IsHuman(pid)
end
```

**Step 3: Register AI enforcement rules**
```lua
-- In Mission_Start(), after player snapshot
-- Prevent AI takeover
Rule_AddGlobalEvent(Reset_AI, GE_AIPlayer_Migrated)
Rule_AddGlobalEvent(Reset_AI_OnTakeOver, GE_AITakeOver)
Rule_AddInterval(Reset_AI, 1)
```

**Step 4: Add Reset_AI function**
```lua
-- Add after Defeat_Function(), end of file

-- Prevent AI personality drift (enforces 'default_campaign')
-- Registered as both global event + 1s interval
-- Event catches migration/takeover; interval catches silent drift
function Reset_AI(context)
    for i, pid in ipairs(ALL_PLAYER_SLOTS) do
        -- Only enforce personality if player is currently AI-controlled
        if not Player_IsHuman(pid) then
            local current_personality = AI_GetPersonality(pid)
            if current_personality ~= "default_campaign" then
                print(string.format("[AI] Personality drift on player%d: '%s' → 'default_campaign'", 
                    i, current_personality))
                AI_SetPersonality(pid, "default_campaign")
            end
        end
    end
end

function Reset_AI_OnTakeOver(context)
    Reset_AI(context)
end
```

**Rationale:** Prevents AI from taking over disconnected players and running buggy personalities. Critical for co-op stability.

---

#### 2.2 Add Player Disconnect Transfer System
**File:** `coop_2_arabia.scar` — new global state + functions  
**Priority:** ⚡ HIGH (for co-op experience)  
**Effort:** 30 min

**Step 1: Add global tracking**
```lua
-- Add after g_original_player_types declaration

-- Track which human slots have already been transferred
g_transferred_slots = {}

-- Resource types for transfer
RESOURCE_TYPES = { RT_Food, RT_Wood, RT_Gold, RT_Stone }
```

**Step 2: Add transfer helper functions**
```lua
-- Add after Reset_AI_OnTakeOver(), before end of file

-- ============================================================
-- Player Disconnect: Unit & Resource Transfer
-- ============================================================
-- When a human player (1-2) disconnects and AI takes over,
-- transfer their units and resources to the remaining human.
-- ============================================================

-- Find the first remaining human player (excluding disconnected slot)
function FindRecipientPlayer(exclude_pid)
    for i = 1, 2 do
        local pid = ALL_PLAYER_SLOTS[i]
        if pid ~= exclude_pid and Player_IsHuman(pid) then
            return pid, i
        end
    end
    return nil, nil
end

-- Transfer all resources from one player to another
function TransferResources(from_pid, to_pid, from_slot, to_slot)
    for _, rt in ipairs(RESOURCE_TYPES) do
        local amount = Player_GetResource(from_pid, rt)
        if amount > 0 then
            Player_AddResource(to_pid, rt, amount)
            Player_SetResource(from_pid, rt, 0)
        end
    end
    print(string.format("[DC] Resources transferred: player%d → player%d", from_slot, to_slot))
end

-- Transfer all squads from one player to another
function TransferUnits(from_pid, to_pid, from_slot, to_slot)
    Player_GetAll(from_pid)
    local count = SGroup_CountSpawned(sg_allsquads)
    if count > 0 then
        SGroup_SetPlayerOwner(sg_allsquads, to_pid)
        print(string.format("[DC] %d squad(s) transferred: player%d → player%d", count, from_slot, to_slot))
    else
        print(string.format("[DC] No squads to transfer from player%d", from_slot))
    end
end

-- Transfer all entities (buildings) from one player to another
function TransferBuildings(from_pid, to_pid, from_slot, to_slot)
    Player_GetAll(from_pid)
    local count = EGroup_CountSpawned(eg_allentities)
    if count > 0 then
        EGroup_SetPlayerOwner(eg_allentities, to_pid)
        print(string.format("[DC] %d building(s) transferred: player%d → player%d", count, from_slot, to_slot))
    else
        print(string.format("[DC] No buildings to transfer from player%d", from_slot))
    end
end

-- Main disconnect handler: detect newly disconnected players and transfer
-- Called by Reset_AI interval (1s)
function CheckPlayerDisconnects()
    for i = 1, 2 do  -- 2-player co-op (player1, player2)
        -- Only process slots that started as human and haven't been transferred
        if g_original_player_types[i] and not g_transferred_slots[i] then
            local pid = ALL_PLAYER_SLOTS[i]
            if not Player_IsHuman(pid) then
                -- Player disconnected — mark as transferred immediately
                g_transferred_slots[i] = true
                
                local to_pid, to_slot = FindRecipientPlayer(pid)
                if to_pid ~= nil then
                    print(string.format("[DC] Player%d disconnected — transferring to player%d", i, to_slot))
                    TransferResources(pid, to_pid, i, to_slot)
                    TransferUnits(pid, to_pid, i, to_slot)
                    TransferBuildings(pid, to_pid, i, to_slot)
                else
                    print(string.format("[DC] Player%d disconnected — no human players remain", i))
                end
            end
        end
    end
end
```

**Step 3: Integrate into Reset_AI**
```lua
-- Modify Reset_AI function to include disconnect check
function Reset_AI(context)
    -- Check for disconnected players first
    CheckPlayerDisconnects()
    
    -- Then enforce AI personality
    for i, pid in ipairs(ALL_PLAYER_SLOTS) do
        if not Player_IsHuman(pid) then
            local current_personality = AI_GetPersonality(pid)
            if current_personality ~= "default_campaign" then
                print(string.format("[AI] Personality drift on player%d: '%s' → 'default_campaign'", 
                    i, current_personality))
                AI_SetPersonality(pid, "default_campaign")
            end
        end
    end
end
```

**Rationale:** When a player disconnects in co-op, their army and resources are immediately transferred to the remaining player, allowing mission to continue.

---

### Phase 3: Documentation (15 min)

#### 3.1 Update arabia-mod-index.md
**File:** `reference/mods/arabia-mod-index.md`  
**Priority:** 🟢 LOW  
**Effort:** 15 min

**Sections to update:**
1. **Function Catalog** — Add new functions:
   - `Reset_AI(context)`
   - `Reset_AI_OnTakeOver(context)`
   - `CheckPlayerDisconnects()`
   - `FindRecipientPlayer(exclude_pid)`
   - `TransferResources(from_pid, to_pid, from_slot, to_slot)`
   - `TransferUnits(from_pid, to_pid, from_slot, to_slot)`
   - `TransferBuildings(from_pid, to_pid, from_slot, to_slot)`

2. **Variable Naming Conventions** — Add new globals:
   - `g_original_player_types` — Player type snapshot
   - `g_transferred_slots` — Disconnect transfer tracking
   - `ALL_PLAYER_SLOTS` — Player reference array
   - `RESOURCE_TYPES` — Resource transfer enum

3. **Debugging Strategy** — Add console commands:
   ```lua
   -- Check disconnect state
   print(g_original_player_types[1])  -- Expected: true (human)
   print(Player_IsHuman(player1))     -- Expected: true/false
   
   -- Check transfer status
   print(g_transferred_slots[1])      -- Expected: nil or true
   ```

4. **Key Systems** — Add new section:
   ```markdown
   ### 7. Player Disconnect Management
   - **Snapshot on Mission_Start**: Records initial human/AI state
   - **1s interval monitoring**: Checks for human→AI transitions
   - **Automatic transfer**: Units/resources move to remaining human
   - **Single-transfer guarantee**: `g_transferred_slots` prevents double-xfer
   ```

---

## Testing Checklist

### Pre-Implementation
- [ ] Backup current `coop_2_arabia.scar` to `coop_2_arabia.scar.backup`
- [ ] Verify no syntax errors in current build
- [ ] Document current line count (851 lines)

### Post-Implementation (Phase 1)
- [ ] Build mod successfully (no errors in Content Editor)
- [ ] Start scenario solo — verify objectives appear correctly
- [ ] Check console for "Annihilation" event errors (should be none)
- [ ] Verify condensed objectives UI is hidden

### Post-Implementation (Phase 2)
- [ ] Host 2-player lobby
- [ ] Player 2 disconnects after 5 min — verify units transfer to Player 1
- [ ] Check console for `[DC]` transfer messages
- [ ] Verify AI personality stays `default_campaign` after disconnect
- [ ] Check console for `[AI]` drift messages (should be none)

### Post-Implementation (Phase 3)
- [ ] Validate arabia-mod-index.md renders correctly (Markdown preview)
- [ ] Cross-reference function signatures match implementation
- [ ] Verify console test commands work

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Transfer fires twice for same player | MEDIUM | `g_transferred_slots` prevents double-transfer |
| AI personality reset breaks AI behavior | LOW | `default_campaign` is standard for co-op |
| Resource transfer fails if over cap | LOW | `Player_AddResource` handles overflow |
| Global events conflict with MissionOMatic | LOW | `Rule_RemoveGlobalEvent` is standard pattern |
| Player 3 (enemy AI) gets included in transfer | MEDIUM | Loop only checks index 1-2 (player1, player2) |

---

## Rollback Plan

If implementation causes critical issues:

1. **Restore backup:**
   ```powershell
   Copy-Item "mods\Arabia\assets\scenarios\multiplayer\coop_2_arabia\coop_2_arabia.scar.backup" `
             "mods\Arabia\assets\scenarios\multiplayer\coop_2_arabia\coop_2_arabia.scar" -Force
   ```

2. **Rebuild mod** in Content Editor

3. **Test vanilla scenario** to verify rollback

---

## Expected Outcomes

### Code Changes
- **Lines added:** ~120 lines
- **New functions:** 7
- **New globals:** 3
- **Final line count:** ~970 lines

### Player Experience
- ✅ Objectives display cleanly without condensed UI interference
- ✅ No premature defeats from landmark loss
- ✅ Disconnected player's army automatically transfers to partner
- ✅ AI personality stays stable after disconnect
- ✅ Console provides disconnect/transfer feedback

### Maintenance
- 🟢 Minimal — all patterns are self-contained
- 🟢 No external dependencies
- 🟢 Works with existing MissionOMatic framework
- 🟢 Compatible with difficulty scaling system

---

## Implementation Command

Once approved, execute:

```powershell
# From workspace root
cd "c:\Users\Jordan\Documents\AoE4-Workspace"

# Start implementation
code "mods\Arabia\assets\scenarios\multiplayer\coop_2_arabia\coop_2_arabia.scar"
```

---

**Approval Status:** ✅ Implemented  
**Actual Line Count:** 975 lines (+124 from 851)  
**Backup:** `coop_2_arabia.scar.backup`
