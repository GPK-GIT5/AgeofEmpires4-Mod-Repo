---
name: console-commands
description: Generate valid Lua commands for the AoE4 Content Editor console, enforcing stateless single-expression constraints.
---

# Copilot Skill: Console Command Generation

**Purpose:** Generate valid Lua commands for the AoE4 Content Editor console, enforcing stateless single-expression constraints.

**Canonical spec:** `.github/instructions/core/console-commands.instructions.md` — all hard constraints, allowed patterns, forbidden→fix table, presentation format, selection heuristic, and pre-output checklist are defined there.

**When to invoke:**
- Any time a debug file has been edited in the current task
- User mentions "console" in the context of running or generating commands
- User requests Lua code for the AoE4 Content Editor console
- Output is explicitly destined for the in-game console
- User asks for a "debug command" or "test command" for in-game use

## Recognized Request Patterns

Copilot should recognize these patterns in user input and invoke the Skill:

- "Run this in the console" / "console command for X"
- "Lua code for the console"
- "Console + command" (any combination mentioning console and a command/action)
- "Debug command to check X" / "test command for Y"
- "How do I call X from the console?"
- "Print X in the console"

## Workflow

0. For debug-edit or console-command requests, output direct console commands first; include manual setup steps only when explicitly requested
1. Identify the user's intent (inspect value, call function, set flag, etc.)
2. Draft the command as a **single Lua expression or statement**
3. Validate against the **Hard Constraints** in the canonical spec
4. If the task requires control flow, state, iteration, semicolon-chained steps, delayed callbacks, or anonymous `function() ... end` wrappers — advise the user to **write a named function in a .scar file** and call that single function from the console instead
5. Format using the **Presentation Format** rules in the canonical spec (markdown table: `Step | Command | Description | Expected results` — one command per row, raw command text only in the Command cell)
6. Keep each row minimal: short Description, single expected pass signal, no filler text
7. Run the **Pre-Output Checklist** from the canonical spec before presenting the command (including: no `Scar_DoString(...)` wrappers in Command cells, no duplicate command text, and no `scar_Restart()` command rows)
8. Never fall back to numbered bullets or fenced snippets for runnable commands; if the command can be run, it must appear only in the table row.
