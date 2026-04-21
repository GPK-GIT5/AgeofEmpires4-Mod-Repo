---
applyTo: "**/*.scar"
---

# XamlPresenter UI — AoE4

Rules for SCAR scripts that create custom UI panels via `UI_AddChild("ScarDefault", "XamlPresenter", ...)`.

## Scope & Relevance Detection

These rules auto-load for every `.scar` file. **Skip entirely** if the file contains none of the trigger tokens below.

| Trigger (any match activates) | Apply sections |
|---|---|
| File contains a XAML string literal (multi-line string with `<Grid`, `<StackPanel`, `<TextBlock`, `<Border`, `<Rectangle`, or `XamlPresenter`) or lives under `playerui/` `observerui/` `xaml/` path | All — Part A (§1–§5) + Part B (§6–§7) |
| File contains `UI_AddChild` or `UI_CreateDataContext` calls (but no XAML strings) | Part B only (§6–§7) |
| File contains `UI_SetDataContext` or `UI_Remove` calls only | §6.2–§6.4 lifecycle patterns only |
| **None of the above** | **Skip — do not apply any rules** |

## Active Enforcement

These rules are **not passive documentation**. When generating or editing `.scar` code:

1. **Generation gate:** Before emitting any XAML string, scan it against §1 FATAL patterns. If a FATAL pattern is present, **do not emit** — apply the listed auto-fix and emit the corrected version instead.
2. **FATAL fallback:** When blocking a FATAL pattern, always emit working replacement code (not just a comment or warning). Use the auto-fix table for the specific FATAL rule. If no auto-fix clearly applies, use the most conservative safe alternative: static value baked into the XAML string at construction time.
3. **Lifecycle scaffolding:** When generating `UI_AddChild` calls, always emit the full §6.1 creation sequence (AddChild → SetDataContext → flag). Never emit bare `UI_AddChild` without the accompanying `UI_SetDataContext` and creation-flag set.
4. **Review on edit:** When editing existing XAML strings, scan the modified fragment against §1–§4. Report any matches by tier inline.
5. **No false positives:** Do **not** flag WARN-LOW patterns when their initialization requirements are met. Do **not** flag SAFE patterns. Do **not** apply XAML-content rules to files that only contain lifecycle calls.

## Severity Tiers

| Tier | Meaning | Evidence Required | Agent Action |
|---|---|---|---|
| **FATAL** | Confirmed client crash, no recovery | ≥2 independent explicit crash/fatal statements in code comments, OR active workaround proving the pattern was tried and failed, OR isolated runtime reproduction | **Block** — refuse to emit; apply auto-fix and emit corrected code |
| **WARN-HIGH** | Likely crash, untested pathway, or engine error on misuse | 1 explicit code comment, OR consistent pattern avoidance across ≥3 modules, OR 0 test coverage for a non-trivial pathway | **Flag** — emit with warning comment; prefer safe alternative |
| **WARN-LOW** | Working in production but undefined on bad input | Validated with constraints; silent visual bug on violation | **Flag only if** initialization constraints are unmet |
| **SAFE** | Proven stable across ≥3 independent modules | Codebase-wide adoption | **Enforce** — default choice for new code |

**Evidence policy:**
- **pcall wrapping is defensive coding, not crash evidence.** A `pcall` guard proves the author was cautious — it does not prove the unguarded call crashes. Do not cite pcall as evidence for any tier.
- **"Unvalidated" ≠ "confirmed crash."** A comment stating a pattern is "unvalidated" or "not tested" means it belongs in WARN-HIGH (untested pathway), not FATAL.
- **Pattern avoidance is circumstantial.** If N modules avoid a pattern but none document a crash, classify as WARN-HIGH, not FATAL.
- **Upgrade path:** Any WARN-HIGH rule can be promoted to FATAL when a second independent crash confirmation or runtime repro is obtained. Note the upgrade condition on each WARN-HIGH rule.

Each rule below includes an **Evidence** block classifying what confirmed it.

---

## Quick Decision Index

Use this matrix for instant rule lookup. See detailed sections below for evidence and context.

| Pattern | Classification | Scope | Evidence | Action |
|---|---|---|---|---|
| `Width="{Binding`  | FATAL-1 | All XAML | ags_limits_ui.scar L721, L922; cba_debug_ui_prompts.scar L33 | Block — emit static/ElementName auto-fix |
| `Height="{Binding` | FATAL-1 | All XAML | ags_limits_ui.scar L721, L922; cba_debug_ui_prompts.scar L33 | Block — emit static/ElementName auto-fix |
| `Opacity="{Binding` inside `<ItemsControl.ItemTemplate>` on default-visible elements | FATAL-2 | Templated icon/list rows | playerui_hud.scar crash (2026-03-30); xaml-ui safety header | Block — use ARGB Fill binding (e.g., `glowFill`) or Visibility gating |
| `Opacity="{Binding` | WARN-HIGH-1 | All XAML | ags_limits_ui.scar L646 (unvalidated); preemptive avoidance pattern | Flag — prefer Visibility+BoolToVis |
| `ToolTip` on non-Button | WARN-HIGH-3 | All XAML | ags_limits_ui.scar L22 (single source) | Flag — use Button/ToggleButton wrapper |
| `<Storyboard>` + `<DataTrigger>` | WARN-HIGH-4 | Legacy templates only; **disallow for new generation** | observe2players.scar L464–480, 976–994 (production in Observer, not player UI) | Allow in existing Observer templates; flag for new Player/Gameplay generation |
| `Property="(Grid.Column)"` setter | WARN-HIGH-5 | All `<Setter>` elements | playerui_hud.scar regression (revert confirmed); observe pattern safety (L677–679) | Flag — rewrite to engine form `Property="Grid.Column"` |
| `UI_SetDataContext` every tick | WARN-HIGH-7 | Lifecycle code | ags_diplomacy_ui.scar L720 ("expensive"); universal interval/guard adoption | Flag — gate behind ≥0.1s interval or dirty-flag |
| `Margin="{Binding` | WARN-LOW-1 | All XAML (if init met) | playerui_hud.scar L159 (proven; requires `"0,0,0,0"` init) | Flag only if uninitialized or wrong format |
| `FontSize="{Binding` | WARN-LOW-2 | All XAML (if init met) | playerui_hud.scar L272 (proven; requires numeric >0 init) | Flag only if uninitialized or non-numeric |
| `AddChild` → `SetDataContext` → flag | Best Practice | All lifecycle code | Universal adoption across 8+ modules | Enforce — scaffold in every generation |

---

## Known Incidents

Common pitfalls and verified fixes:

### Incident 1: Attached-Property Setter Syntax Regression

> **Registry:** [KI-XAML-003](known-issues.instructions.md#ki-xaml-003-attached-property-setter-syntax-crash)

**Problem:** Switching from engine form `Property="Grid.Column"` to WPF form `Property="(Grid.Column)"` causes XamlPresenter runtime crash during element reordering (eliminated-row mirroring).  
**Root Cause:** AoE4 XamlPresenter engine has custom attached-property parsing; WPF parenthesized form not recognized.  
**Verified Fix:** Always use engine form `Property="Grid.Column"` / `Property="Grid.Row"` in `<Setter>` elements.  
**Evidence:** playerui_hud.scar introduced regression during Phase 1 work, isolated by reverting to observer template syntax (teamvteam.scar L677–679); revert confirmed stable.

### Incident 2: Width DataContext Binding Crash — Static Injection Workaround

> **Registry:** [KI-XAML-001](known-issues.instructions.md#ki-xaml-001-widthheight-datacontext-binding-crash)

**Problem:** `Width="{Binding [bar_width]}"` triggers XamlPresenter crash on first render.  
**Root Cause:** Width is computed at creation time by layout engine; dynamic binding interferes with panel initialization.  
**Verified Fix:** Use string placeholder + `string.gsub(xaml, "BAR_WIDTH_PH", tostring(val))` at panel creation time, OR use `ElementName` proxy from an off-screen width-source element, OR recreate entire panel on width change.  
**Evidence:** ags_limits_ui.scar L721 documents crash; L922 documents full recreate workaround; observerui uses ElementName proxies for progress bars.

### Incident 3: Ranking Threshold Blocks Elimination Bottom-Drop Animation

> **Registry:** [KI-XAML-004](known-issues.instructions.md#ki-xaml-004-ranking-threshold-blocks-elimination-animation)

**Problem:** When alive player scores are low (near 15-point margin threshold), eliminated player fails to animate to bottom position because ranking score delta does not trigger reorder.  
**Root Cause:** Eliminated sentinel score initialized as `-1`, which is only ~1 point below lowest alive player; threshold gate (`delta >= 15`) blocks reorder.  
**Verified Fix:** Use eliminated sentinel score of `-100000` instead of `-1`. This guarantees any alive player score will exceed 15-point margin, triggering animation with FLIP frames in Phase 5.  
**Evidence:** Session validation in playerui_ranking.scar Phase 4–5; confirmed by scarlog diagnostic output.

---

# Part A — Generation-Time Rules (XAML String Construction)

Apply when writing, generating, or reviewing XAML template strings in Lua/SCAR code.

## 1  FATAL — Confirmed Crash Patterns

Only Width/Height DataContext binding meets the FATAL evidence threshold (≥2 explicit crash statements + active workaround).

### FATAL-1: Width / Height DataContext Binding

> **Registry:** [KI-XAML-001](known-issues.instructions.md#ki-xaml-001-widthheight-datacontext-binding-crash)

```xml
<!-- CRASHES — never emit -->
<Rectangle Width="{Binding [my_width]}" />
<Grid Height="{Binding [my_height]}" />
```

XamlPresenter crashes when `Width` or `Height` are bound via `{Binding [field]}`.

> **Evidence (3 independent sources — meets FATAL threshold):**
> - `ags_limits_ui.scar` L721: *"Width DataContext binding is FATAL in XamlPresenter"* — explicit crash statement
> - `ags_limits_ui.scar` L922: active workaround (static injection + full panel recreate) — proves the pattern was tried and failed
> - `cba_debug_ui_prompts.scar` L33: *"No Width/Height/Opacity bindings (fatal in XamlPresenter)"* — independent file confirms
> - Observer UI systematically uses `ElementName` bindings, never DataContext for Width/Height

**Auto-fix (always emit replacement code, never just a warning):**

| Situation | Replacement |
|---|---|
| Value known at creation | `string.gsub(xaml, "WIDTH_PH", tostring(val))` |
| Value changes at runtime | `UI_Remove` → rebuild XAML with static value → `UI_AddChild` |
| Progress bar | Full-width Rectangle + `Fill` color binding |
| Dynamic proxy | `ElementName` + `MultiBinding` (proven in observerui) |

---

### FATAL-2: Opacity DataContext Binding in Visible ItemsControl ItemTemplate Rows

> **Registry:** [KI-XAML-002](known-issues.instructions.md#ki-xaml-002-opacity-binding-in-itemscontrol-itemtemplate--d3d-crash)

```xml
<!-- CRASHES in this context — never emit -->
<ItemsControl.ItemTemplate>
    <DataTemplate>
        <StackPanel Opacity="{Binding [opacity]}"> ... </StackPanel>
    </DataTemplate>
</ItemsControl.ItemTemplate>
```

XamlPresenter can crash when `Opacity` is DataContext-bound inside `ItemsControl.ItemTemplate` on elements rendered as visible by default.

> **Evidence:**
> - `playerui_hud.scar` header safety rule explicitly forbids DataContext Opacity binding.
> - 2026-03-30 runtime repro: PlayerUI toggle produced native D3D crash with no SCAR error until Opacity bindings in reward icon template were removed/replaced.

**Auto-fix (always emit replacement code):**

| Situation | Replacement |
|---|---|
| Animated overlay alpha | Bind `Fill` to precomputed `#AARRGGBB` (for example `glowFill`) |
| Show/hide | Bind `Visibility` with `BoolToVis` |
| Row fade effect | Use static Opacity per template variant and switch template/state from SCAR |

---

## 2  WARN-HIGH — Likely Crash, Untested, or Engine-Error Patterns

Flag these during generation and review. Prefer the safe alternative; do not block outright.

### WARN-HIGH-1: Opacity DataContext Binding

```xml
<!-- Likely crashes — avoid -->
<TextBlock Opacity="{Binding [my_opacity]}" />
<Grid Opacity="{Binding [fade_level]}" />
```

> **Evidence (below FATAL threshold):**
> - `ags_limits_ui.scar` L646: *"Opacity DataContext binding removed (unvalidated in XamlPresenter)"* — says **"unvalidated"**, not "confirmed crash". Preemptive removal, not a crash report.
> - `cba_debug_ui_prompts.scar` L33: groups Opacity with Width/Height as "fatal" — but may be the same author's assumption carried forward, not independent confirmation.
> - No active workaround exists (Opacity was never attempted and then fixed — it was avoided preemptively).

**Recommendation:** Avoid. Use `Visibility` + `BoolToVis` for show/hide. For graduated fade, swap XAML templates with different static Opacity values via recreate cycle. Note: if this appears inside a visible `ItemsControl.ItemTemplate` row, treat as **FATAL-2** and block.

> **Upgrade to FATAL-2** if runtime reproduction confirms crash, or a second independent source explicitly documents a crash.

### WARN-HIGH-2: MergedDictionaries + Local Effect Resources

```xml
<!-- Likely crashes — avoid -->
<Grid.Resources>
    <ResourceDictionary>
        <ResourceDictionary.MergedDictionaries>
            <ResourceDictionary Source="pack://..." />
        </ResourceDictionary.MergedDictionaries>
        <DropShadowEffect x:Key="Shadow" />  <!-- likely fatal -->
    </ResourceDictionary>
</Grid.Resources>
```

> **Evidence (pattern avoidance — no crash statement):**
> - 5 UI modules all use bare MergedDictionaries; none combine MergedDictionaries with local Effect/Brush keyed resources.
> - `ags_match_ui.scar` uses Pattern B (Style siblings only — no Effects).
> - No code comment explicitly says this pattern crashed. Classification is based on consistent avoidance across all modules.

**Recommendation:** Use bare MergedDictionaries (Pattern A) or MergedDictionaries + Style-only siblings (Pattern B):

```xml
<!-- Pattern A (preferred) -->
<Grid.Resources>
    <ResourceDictionary.MergedDictionaries>
        <ResourceDictionary Source="pack://application:,,,/WPFUI;component/Styles/HUDResources.xaml" />
    </ResourceDictionary.MergedDictionaries>
</Grid.Resources>
```

For `DropShadowEffect`, define inline on the element — never as `StaticResource` key.

> **Upgrade to FATAL** if a crash is explicitly documented or reproduced.

### WARN-HIGH-3: ToolTip Binding on Non-Interactive Elements

```xml
<!-- Likely crashes — avoid -->
<StackPanel ToolTip="{Binding [tip_text]}"> ... </StackPanel>
```

> **Evidence (1 source — below FATAL threshold):**
> - `ags_limits_ui.scar` L22: *"XamlPresenter crashes when ToolTip bindings are placed on non-interactive elements."* No second confirmation or isolated repro.
> - ToolTip fields remain in data_context, reserved for future Button-based pattern.

**Recommendation:** Remove ToolTip from non-interactive elements. Wrap content in `Button` with transparent chrome if hover info is needed.

> **Upgrade to FATAL** if a second independent crash is confirmed.

### WARN-HIGH-4: XAML-Side Storyboard / DataTrigger Animations — Legacy-Safe-Only

```xml
<DataTrigger Binding="{Binding [pulse]}" Value="True">
    <DataTrigger.EnterActions>
        <BeginStoryboard> ... </BeginStoryboard>
    </DataTrigger.EnterActions>
</DataTrigger>
```

> **Evidence & Scope:**
> - `ags_limits_ui.scar` L27–29: *"XAML-side Storyboard/DataTrigger animations are untested and should NOT be used until validated."* — documented as unvalidated in Player UI context.
> - `observe2players.scar` L464–480, 976–994: **active Storyboard production usage** — age-up animations rotating UI elements via DoubleAnimation in DataTrigger.EnterActions (Observer UI only).
> - **Classification split:** Observer UI Storyboards are proven stable; Player UI Storyboards remain unvalidated.

**Recommendation:**
- **For EXISTING Observer UI templates:** Allow Storyboard/DataTrigger per observe2players.scar pattern (legacy-safe).
- **For NEW generation (any context):** Do NOT generate Storyboard/DataTrigger. Use SCAR-side interval rule + `UI_SetDataContext` to animate instead.
- **For Player UI editing:** Avoid — no validated examples exist.

**Pattern (when allowed):** Storyboard must be wrapped in `DataTrigger.EnterActions` / `ExitActions` with explicit binding lifecycle (enter trigger fires animation; exit trigger cleans up). Never use bare `BeginStoryboard` at root level.

> **Upgrade to FATAL** if a crash is reproduced in new generation contexts.

### WARN-HIGH-5: Attached Property Setter Syntax Must Use Engine Form

> **Registry:** [KI-XAML-003](known-issues.instructions.md#ki-xaml-003-attached-property-setter-syntax-crash)

```xml
<!-- WRONG for AoE4 XamlPresenter regression-prone path -->
<Setter TargetName="MyGrid" Property="(Grid.Column)" Value="2"/>

<!-- RIGHT: use the proven in-engine syntax -->
<Setter TargetName="MyGrid" Property="Grid.Column" Value="2"/>
```

AoE4 XamlPresenter should follow the attached-property setter syntax already proven in shipping observer UI templates: `Property="Grid.Column"`.

> **Evidence:**
> - `observerui/xaml/teamvteam.scar` L677-L679 uses `Property="Grid.Column"` for left/right mirroring in production.
> - `playerui/xaml/playerui_hud.scar` introduced `Property="(Grid.Column)"` during eliminated-row mirroring and immediately regressed into a runtime crash; reverting to the observer syntax isolates the change back to the known-good engine form.

**Recommendation:** When setting attached properties from `Setter`, use the observer-style engine form (`Grid.Column`, `Grid.Row`, etc.), not WPF parenthesized setter syntax.

---

## 3  WARN-LOW — Working but Fragile on Bad Input

These are **proven working** in production. Only flag if their initialization constraints are violated. Do **not** flag when properly initialized — that produces false positives.

### WARN-LOW-1: Dynamic Margin Binding

```xml
<Grid Margin="{Binding [offsetMargin]}"> ... </Grid>
```

> **Evidence (working):**
> - `playerui_hud.scar` L159, L246: binds `rankOffsetMargin` as `"0,0,0,0"` string — stable in production.
> - `initialize_datacontext.scar` L38: initialized to `"0,0,0,0"` before first SetDataContext.

**When to flag:** Only if the DataContext field is nil, empty, non-string, or not `"L,T,R,B"` format. **Do not flag** if properly initialized.

### WARN-LOW-2: FontSize DataContext Binding

```xml
<TextBlock FontSize="{Binding [pulseFontSize]}" />
```

> **Evidence (working):**
> - `playerui_hud.scar` L272: binds `killScorePulseFontSize` — stable in production with SCAR-side animation.

**When to flag:** Only if the DataContext field is nil, non-numeric, or ≤0. **Do not flag** if initialized to a valid number (e.g., `14`).

### WARN-LOW-3: Uninitialized DataContext Fields

```lua
-- Missing [count] — renders as empty/zero
local data = { header = "Limits" }
UI_SetDataContext("MyPanel", data)
```

> **Evidence (silent visual bug, not crash):**
> - All 8 UI modules fully initialize DataContext tables before first call.
> - Missing fields render as empty/zero — no crash, no engine error, but difficult to diagnose.

**When to flag:** Only during initial DataContext construction — check that every `{Binding [field]}` in the XAML has a matching key. **Do not flag** on subsequent `UI_SetDataContext` update calls that intentionally update a subset of fields (the engine preserves previously-set values).

---

## 4  SAFE — Proven Bindings (Enforce)

Default choice for all new XAML code. Do not flag these.

| Property | Binding Pattern | Evidence (verified in) | Init Default |
|---|---|---|---|
| Text | `Text="{Binding [field]}"` | All 8+ modules | `""` |
| Foreground | `Foreground="{Binding [color]}"` | playerui_hud, ags_limits_ui, cba_debug_ui_prompts | `"#FFFFFFFF"` |
| Fill | `Fill="{Binding [fill]}"` | ags_limits_ui (bar colors) | `"#00000000"` |
| Visibility | `Visibility="{Binding [flag], Converter={StaticResource BoolToVis}}"` | All 8+ modules | `true` / `false` |
| Source | `Source="{Binding [icon]}"` | playerui_hud, observerui | `pack://` path |
| Command | `Command="{Binding [cmd]}"` | All button panels | `UI_CreateCommand(...)` |

**Conditional SAFE** (safe when init requirements met — see WARN-LOW):

| Property | Binding Pattern | Init Requirement |
|---|---|---|
| Margin | `Margin="{Binding [m]}"` | `"0,0,0,0"` string |
| FontSize | `FontSize="{Binding [fs]}"` | Valid number >0 |

**Forbidden / Restricted** (cross-reference):

| Property | Tier | Action |
|---|---|---|
| Width via DataContext | FATAL-1 | Block — use static/ElementName |
| Height via DataContext | FATAL-1 | Block — use static |
| Opacity via DataContext | WARN-HIGH-1 | Flag — use Visibility |
| MergedDictionaries + Effect `x:Key` | WARN-HIGH-2 | Flag — use Pattern A/B |
| ToolTip on non-Button | WARN-HIGH-3 | Flag — avoid |
| Storyboard / DataTrigger | WARN-HIGH-4 | Flag — use SCAR-side animation |

---

# Part B — Runtime Rules (Lua/SCAR Lifecycle Code)

Apply when writing, generating, or reviewing Lua/SCAR code that manages UI panels. These are **correctness patterns** — classified by observed behavior, not crash tier.

## 6  Panel Lifecycle

### 6.1 Creation Sequence (WARN-HIGH if violated)

Always emit this full sequence when generating `UI_AddChild` calls:

```lua
-- 1. Build XAML string (Part A rules apply here)
local xaml = _BuildMyPanelXaml(config)

-- 2. Create panel
UI_AddChild("ScarDefault", "XamlPresenter", "MyPanel", xaml)

-- 3. (Optional but recommended for WPF stability) Pre-warm render cycle
-- For complex XAML with DataContext bindings, call SetDataContext immediately,
-- then optionally hide within ~100ms to let WPF renderer initialize before first show.
UI_SetDataContext("MyPanel", initial_data)
-- At this point the panel renders off-screen or with visibility Hidden.
-- If panel is complex (many bindings), allow 1–2 frames for WPF layout pass.
-- Then set Visibility=Visible or show via animation interval.
Rule_AddOneShot(function()  
    UI_SetVisibility("MyPanel", true)  -- show after pre-warm settle
end, 0.1)

-- 4. Store creation state (use universal naming convention: is_ui_created, _created, panel_created)
_my_module.is_ui_created = true
```

**Pre-warm rationale:** XamlPresenter's WPF renderer initializes layout on the first SetDataContext call. Complex templates with many bindings benefit from this initialization cycle before the panel becomes visible to the user, reducing first-frame binding errors.

> **Evidence:**
> - All 8 major UI modules follow AddChild → SetDataContext → flag sequence — universal adoption.
> - `playerui.scar` L174–188: implements pre-warm-then-collapse pattern (create visible, then collapse after ~1s settle time) for MainHUD complex template.
> - Reversed order (SetDataContext before AddChild) silently loses data — confirmed by pattern: no module ever calls SetDataContext before AddChild.
> - Note: `playerui_updateui.scar` L427 wraps SetDataContext in `pcall`, but pcall wrapping is defensive coding (cautious author), not crash evidence per se.

### 6.2 Update Pattern (creation-flag guard)

```lua
if not _my_module.is_ui_created then return end
UI_SetDataContext("MyPanel", updated_data)
```

> **Evidence:**
> - All 8 modules guard `UI_SetDataContext` with `is_ui_created` or `panel_created` flag — universal adoption.
> - Calling `UI_SetDataContext` on a non-existent panel has undefined behavior (could be silent no-op or engine error — no confirmed crash, but universally guarded against).

### 6.3 Recreate Pattern (for width/layout changes)

```lua
if _my_module.is_ui_created then
    UI_Remove("MyPanel")
end
local xaml = _BuildMyPanelXaml(new_config)
UI_AddChild("ScarDefault", "XamlPresenter", "MyPanel", xaml)
UI_SetDataContext("MyPanel", data)
-- is_ui_created remains true
```

> **Evidence:**
> - `ags_limits_ui.scar` uses this exact recreate-on-width-change cycle — proven pattern.
> - `UI_Remove` on non-existent panel has undefined behavior (universally guarded with `is_ui_created` flag; `cba_debug_ui_prompts.scar` L485 uses pcall defensively, but that is cautious coding, not crash evidence).
> - Duplicate `UI_AddChild` without `UI_Remove` orphans the original panel (no crash evidence, but resource leak).

### 6.4 Removal Pattern

```lua
if _my_module.is_ui_created then
    UI_Remove("MyPanel")
    _my_module.is_ui_created = false
end
```

### 6.5 Parent Elements

| Parent | Use for |
|---|---|
| `"ScarDefault"` | Standard gameplay panels (hidden during replay) |
| `"ScarNotReplay"` | Gameplay-only panels (explicitly excluded from replays) |
| `""` | Root — observer/replay panels that must always render |

### 6.6 Update Frequency

| Trigger | Interval | Example |
|---|---|---|
| Interval rule | 0.1s–0.25s (4–10 fps) | ags_limits_ui, diplomacy_ui |
| Event handler | On game event only | ags_match_ui |
| Deferred + events | Init + event-driven | playerui |
| One-shot | Once at init | Button/toggle panels |

Do NOT call `UI_SetDataContext` in a tight loop or every simulation tick.

### 6.7 WARN-HIGH: Excessive UI_SetDataContext Frequency

```lua
-- WRONG — updates on every simulation tick (60+ fps)
function OnTick()
    UI_SetDataContext("MyPanel", data)  -- no change check, no interval guard
end
```

`UI_SetDataContext` is expensive (noted in `ags_diplomacy_ui.scar` L720: *"UI_SetDataContext() is expensive so only call it once per frame"*). Calling it without diffing or interval gating wastes CPU and can cause visual stutter.

> **Evidence:**
> - `ags_diplomacy_ui.scar` L720: explicit performance comment — "expensive, once per frame".
> - All 8 UI modules gate updates behind interval rules (0.1s–0.25s) or event handlers.
> - No module calls `UI_SetDataContext` unconditionally on every tick.

**When to flag:** Flag if `UI_SetDataContext` is called:
- Inside a function registered with `Rule_AddInterval` at <0.1s without a change-detection guard
- Inside an `OnTick` or per-frame callback without a dirty flag or value-comparison check
- Unconditionally in any loop that could execute more than once per 0.1s

**Do not flag** if the update is behind an interval rule ≥0.1s, an event handler, a dirty-flag guard, or a value-comparison check.

**Recommendation:** Gate with a dirty flag or value comparison:

```lua
function _MyModule_UpdateUI()
    if not _my_module.is_ui_created then return end
    if not _my_module.ui_dirty then return end
    UI_SetDataContext("MyPanel", _my_module.data)
    _my_module.ui_dirty = false
end
```

---

## 9  Operational Guardrails

Best practices validated through session testing and production module patterns.

### Visibility Strategy: Hidden vs Collapsed

When hiding elements in XAML templates, prefer `Visibility="Hidden"` (hide but preserve layout space) over `Visibility="Collapsed"` (hide and reclaim space) when width-dependent UI is involved.

> **Evidence:**
> - `playerui_hud.scar` L346–420: eliminated-player row uses `Hidden` to preserve column widths during rank animation; switching to `Collapsed` breaks layout stability during FLIP transitions.
> - Columns compute spacing based on visible children; hiding with `Collapsed` causes remaining rows to shift horizontally, breaking alignment.

**Recommendation:** Use Hidden for toggle/show-hide that must preserve grid geometry. Use Collapsed only when reclaiming space is explicitly desired.

### Crash Guard Pattern (Defensive Coding)

Many modules wrap risky UI operations in `pcall` for defensive safety:

```lua
-- Defensive wrap (not crash evidence per se, just cautious coding)
pcall(function()
    UI_SetDataContext("MyPanel", data)
end)
```

Note: `pcall` wrapping **does not prove** the unguarded code crashes. It shows the author was cautious. Do not cite pcall presence as FATAL/WARN-HIGH evidence — cite explicit crash comments instead.

> **Evidence:**
> - `playerui_updateui.scar` L427: wrapped SetDataContext in pcall (cautious, not crash-indicative).
> - `cba_debug_ui_prompts.scar` L485: wrapped UI_Remove in pcall (defensive, not crash-indicative).
> - Contrast with `ags_limits_ui.scar` L721, which **explicitly states** "Width binding is FATAL" — this is crash evidence.

### Panel Creation at Init Time

Major UI panels (HUD, ObserverUI templates, gameplay overlays) should be created once at OnInit or module load time, not dynamically created/destroyed during gameplay loop.

> **Evidence:**
> - All 8+ UI modules follow create-once-at-init pattern.
> - Repeated UI_AddChild/UI_Remove cycles in gameplay loop can cause memory fragmentation and renderer stalls.

Exception: Temporary debug/test overlays may use dynamic lifecycle per use case.

---

## 7  Width / Height Dynamic Sizing — Safe Alternatives

### ElementName + MultiBinding (proven in observerui)
```xml
<FrameworkElement Name="WidthProxy" Width="200" Visibility="Collapsed"/>
<Rectangle Width="{Binding ElementName=WidthProxy, Path=Width}" />
```

### XAML String Injection (proven in ags_limits_ui)
```lua
local bar_width = math.floor(pct * MAX_BAR_WIDTH)
local xaml = string.gsub(XAML_TEMPLATE, "BAR_WIDTH_PH", tostring(bar_width))
UI_AddChild("ScarDefault", "XamlPresenter", panel_name, xaml)
```

### Full Recreate on Change (proven in ags_limits_ui)
```lua
UI_Remove(panel_name)
local xaml = _BuildXaml(new_values)
UI_AddChild("ScarDefault", "XamlPresenter", panel_name, xaml)
UI_SetDataContext(panel_name, data_context)
```

---

## 8  Review Checklist

### Generation-time (XAML strings — Part A)

1. **FATAL scan** — reject `Width="{Binding` and `Height="{Binding`. Emit auto-fix replacement code (never just a warning).
2. **WARN-HIGH scan** — flag `Opacity="{Binding`; flag MergedDictionaries with sibling Effect/Brush `x:Key` resources; flag ToolTip on non-Button elements; flag Storyboard/DataTrigger. Emit with warning comment and safe alternative.
3. **Setter syntax scan** — inside `Style`/`DataTrigger` setters, use `Property="Grid.Column"` / `Property="Grid.Row"` for attached properties. Flag parenthesized forms like `Property="(Grid.Column)"` and rewrite them to the engine form.
4. **WARN-LOW scan** — flag Margin/FontSize bindings **only if** init defaults are missing or wrong type. Do not flag when properly initialized.
5. **SAFE — no flag.** Do not comment on or flag SAFE bindings.

### Runtime (Lua/SCAR — Part B)

5. **Creation sequence** — `UI_AddChild` → `UI_SetDataContext` → set flag. Never reversed.
6. **Recreate guard** — `UI_Remove` before `UI_AddChild` with same panel name.
7. **Creation flag** — all `UI_SetDataContext` and `UI_Remove` guarded by `is_ui_created`.
8. **Field initialization** — first `UI_SetDataContext` call includes all bound fields with typed defaults.
9. **Update frequency** — `UI_SetDataContext` behind interval rule (≥0.1s), event handler, or dirty-flag guard. Flag unconditional per-tick calls.
