# BoonUI — Beginner's Guide

A friendly, no-jargon guide to **BoonUI**: a small, drop-in pop-up menu for
SCAR-based Age of Empires IV mods. It lets a player choose between 2–4
"cards" (a title, an icon, a description, and a Select button) and runs
whatever code you want when they pick one.

> **Who this is for:** Modders and curious players with **no programming
> background**. You only need a text editor (Notepad, Notepad++, VS Code…)
> and a mod project to drop the files into.

---

## 1. What is BoonUI?

BoonUI is a small "menu in a box." You give it a question and a few
choices; it shows them on screen with nice cards; when the player clicks
one, you decide what happens next.

It looks roughly like this:

```
        ┌──────────────────────────────────┐
        │     Welcome — Pick a Bonus       │
        │     Choose one. The other is     │
        │             lost.                │
        │                                  │
        │   [icon]        [icon]           │
        │  +500 Wood    +500 Food          │
        │  Lumberjack    Farmer            │
        │  Receive…      Receive…          │
        │  [Select]      [Select]          │
        │                                  │
        │      Auto-selects in 30s         │
        └──────────────────────────────────┘
```

**Three things to know:**

1. It supports **1 to 4 cards** at a time.
2. It can **auto-pick** a default card after a timer (or wait forever).
3. When the player clicks, **one function you wrote gets called**. That's
   where you give them the reward, change the game, etc.

---

## 2. The Ready-to-Use Folder

The starter pack lives next to this guide:

[boonui-starter/](boonui-starter/)

It contains three files:

| File | What it does | Do you edit it? |
|---|---|---|
| `boon_selection.scar` | The "engine" that opens, closes, and times the menu. | **No.** Drop in as-is. |
| `boon_selection_xaml.scar` | The visual look (colors, layout, fonts). | Optional — only if you want to restyle. |
| `boon_examples.scar` | Three or four ready-made example menus. **This is your starting point.** | **Yes — copy and modify.** |

---

## 3. Installing the Starter Pack (one-time setup)

1. Copy the **entire `boonui-starter/` folder** into your mod's SCAR
   scripts directory. A common location is something like:
   `<your-mod>/assets/scar/boonui/`.
2. In your mod's **main script** (often `<your-mod>.scar` or whichever file
   already has `import(...)` lines at the top), add:

   ```lua
   import("boonui/boon_selection.scar")
   import("boonui/boon_examples.scar")
   ```

   Adjust the path so it matches where you placed the folder.
3. Save and reload the mod. That's it — BoonUI is now installed.

> If your mod uses a different folder structure, the only rule is:
> `boon_selection.scar` must be **import**ed before any code that calls
> `BoonSelection_Show(...)`.

---

## 4. The 30-Second API

You only need to know **one function**:

```lua
BoonSelection_Show({
    title          = "Header text",
    subtitle       = "Smaller text under the title (optional)",
    timeout        = 30,        -- seconds; use 0 to wait forever
    default_choice = 1,         -- which card auto-picks if the timer ends

    choices = {
        { title = "Card 1", unit = "Tag", desc = "Short description", icon = "" },
        { title = "Card 2", unit = "Tag", desc = "Short description", icon = "" },
        -- up to 4 cards total
    },

    on_select = function(index)
        -- index is 1, 2, 3, or 4 — whichever card the player clicked.
    end,
})
```

That's the **whole** API for everyday use.

---

## 5. Step-by-Step — Your First Custom Menu

Goal: show a 2-card menu that gives the player **+500 wood** or **+500 food**.

### Step 1 — Open the examples file
Open `boonui-starter/boon_examples.scar` in your text editor.

### Step 2 — Find `Example_WelcomeBonus`
Use **Ctrl + F** and search for `Example_WelcomeBonus`. It's already a
2-card wood/food menu — you can use it as your blueprint.

### Step 3 — Copy the function
Select the whole `function Example_WelcomeBonus() ... end` block, copy it,
and paste it back in the file under a new name, e.g.
`function MyMod_StartingChoice()`.

### Step 4 — Edit the cards
Change the `title`, `unit`, `desc`, and the action inside `on_select`. For
example, change `+500 Wood` to `+1000 Wood` and update the
`Player_AddResource` line to match.

### Step 5 — Trigger the menu
In your mod's startup script, add:

```lua
Rule_AddOneShot(MyMod_StartingChoice, 5.0)
```

This shows the menu **5 seconds after the match begins**. Save, reload the
mod, and start a match.

That's it — you have your own boon menu.

---

## 6. Copy-Paste Templates

### Template A — Minimal 2-card menu

```lua
function MyMenu_Simple()
    BoonSelection_Show({
        title   = "<Your Question>",
        timeout = 0,                 -- wait forever
        choices = {
            { title = "<Option A>", desc = "<What it does>" },
            { title = "<Option B>", desc = "<What it does>" },
        },
        on_select = function(index)
            -- Put your code here. index is 1 or 2.
        end,
    })
end
```

### Template B — 4-card menu with timer + default

```lua
function MyMenu_Full()
    BoonSelection_Show({
        title          = "<Header>",
        subtitle       = "<Smaller text under the header>",
        timeout        = 45,
        default_choice = 1,
        choices = {
            { title = "<A>", unit = "<tag>", desc = "<...>", icon = "" },
            { title = "<B>", unit = "<tag>", desc = "<...>", icon = "" },
            { title = "<C>", unit = "<tag>", desc = "<...>", icon = "" },
            { title = "<D>", unit = "<tag>", desc = "<...>", icon = "" },
        },
        on_select = function(index)
            print("[MYMOD] Picked option " .. tostring(index))
        end,
    })
end
```

### Template C — Trigger your menu from another script

```lua
-- Show the menu 60 seconds into the game:
Rule_AddOneShot(MyMenu_Simple, 60.0)

-- Or show it once a player reaches a certain age:
-- (See SCAR docs for Rule_AddGlobalEvent and GE_PlayerAgeUp.)
```

---

## 7. Customizing the Cards

Every card in `choices` can have these fields. All are optional — leave a
field out and BoonUI will use a sensible default.

| Field | What it does | Notes |
|---|---|---|
| `title` | Big white text on the card | Keep short — 1–3 words |
| `unit` | Smaller blue tag under the title | Use it for a category like "Economy" or leave blank |
| `desc` | Small gray description | One short sentence is best |
| `icon` | Picture shown at the top of the card | Use `""` for no icon, or a `pack://` path (see Section 9) |

### Example — change a card's wording

Find this card in `boon_examples.scar`:

```lua
{ title = "+500 Wood", unit = "Lumberjack's Gift", desc = "Receive 500 wood immediately.", icon = "" },
```

Change it to:

```lua
{ title = "+1000 Wood", unit = "Royal Grant", desc = "A massive wood shipment arrives.", icon = "" },
```

Save and reload. Done.

---

## 8. Troubleshooting — Common Problems

**The menu doesn't appear.**
- Make sure `import("boonui/boon_selection.scar")` is in your main script
  and that the path matches where you put the folder.
- Make sure something actually calls `BoonSelection_Show(...)` — for
  example via `Rule_AddOneShot`.
- Open the in-game console (if available) and look for `[BOON_SELECTION]`
  log lines.

**The menu appears but cards are missing.**
- Check that you have **at least 1 and at most 4** entries in `choices`.
- Each card line must end with a comma `,` and the curly braces `{ ... }`
  must be balanced.

**Clicking a card does nothing.**
- Your `on_select` function probably has a typo. Check the `[BOON_SELECTION][ERROR]`
  line in the console — it will print the Lua error.

**My description shows weird symbols (`â€™` etc.).**
- You pasted "smart quotes" from Word or Google Docs. Replace them with
  plain straight quotes: `"like this"`, never `“like this”`.

**The mod won't load after my edit.**
- Almost always one of:
  - A missing comma at the end of a line.
  - A missing or extra `}` (curly brace).
  - A missing closing quote on a `title =` or `desc =`.
- Open the file again and compare each entry to the others. If in doubt,
  undo (`Ctrl + Z`) and try smaller changes.

---

## 9. Advanced — For Experienced Modders

Skip this section if you're just getting started.

### 9.1 Custom icons

`icon` accepts any WPF `pack://` path that the AoE4 client can resolve.
Most built-in icons live under `WPFGUI` and use this shape:

```lua
icon = "pack://application:,,,/WPFGUI;component/icons/<sub-path>/<file>.png"
```

If you want the engine to look up an upgrade's official icon
automatically, the starter pack also ships a helper inside
`boon_selection_data.scar` (in the source mod). The relevant snippet is:

```lua
local ubp = BP_GetUpgradeBlueprint(upg_name)
local uiinfo = BP_GetUpgradeUIInfo(ubp)
local icon = string.format(
    "pack://application:,,,/WPFGUI;component/%s.png",
    string.gsub(uiinfo.iconName, "\\", "/"))
```

Both `BP_GetUpgradeBlueprint` and `BP_GetUpgradeUIInfo` are documented in
the official SCAR API reference.

### 9.2 Hiding or canceling the menu manually

```lua
BoonSelection_Hide()                -- visually hide the panel (no callback fires)
BoonSelection_IsActive()            -- returns true if a menu is open
BoonSelection_ForceSelect(2)        -- programmatically click card 2
BoonSelection_Cleanup()             -- fully remove panel (use on game end)
```

### 9.3 Per-player menus in multiplayer

`BoonSelection_Show` is **per-local-player** — only the machine that runs
it sees the panel. To present a menu on every human player's screen,
loop over `World_GetPlayerCount()`:

```lua
for i = 1, World_GetPlayerCount() do
    local p = World_GetPlayerAt(i)
    -- … call BoonSelection_Show with a closure that captures p …
end
```

A complete version of this pattern is `Example_PerPlayerWelcome` in
`boon_examples.scar`.

### 9.4 Restyling the panel

Open `boon_selection_xaml.scar`. The XAML inside the `[[ ... ]]` block is
plain WPF. Common edits:

- **Card colors**: search for `BoonCardButtonStyle` and change the
  `Background` / `BorderBrush` hex values (e.g. `#CC1A2332`).
- **Title color**: search for `Foreground="#FFD54F"` (the gold title) and
  pick your own hex color.
- **Card width**: change `MinWidth="200" MaxWidth="220"` on the card
  border.

> **Safety rules** when editing the XAML (these are non-negotiable):
> - Don't bind `Opacity` directly inside an `ItemsControl` template — use
>   alpha-encoded `Fill` strings instead. The current XAML has no
>   `ItemsControl`, so as long as you keep it that way you're fine.
> - Don't bind raw numbers; bind only strings and the existing `BoolToVis`
>   visibility flags.

These two rules prevent a known D3D crash class. They are part of the
project's hardened UI conventions.

### 9.5 Replacing the data layer

The starter `boon_examples.scar` is just **one** way to provide cards.
You can build your own data layer (a table per civ, a random rotation, a
condition-driven dispatcher, …) and pass it to `BoonSelection_Show` the
same way. The engine doesn't care where the `choices` table came from.

---

## 10. Summary — The 30-Second Version

- Drop the **`boonui-starter/`** folder into your mod.
- `import("boonui/boon_selection.scar")` in your main script.
- Call **`BoonSelection_Show({ title=…, choices=…, on_select=… })`**.
- Up to **4 cards**. `timeout = 0` means "wait forever."
- Edit `boon_examples.scar` for ready-made copy-paste menus.
- If something breaks: check commas, quotes, braces — almost always the
  culprit.

Have fun building menus!
