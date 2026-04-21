---
applyTo: "**/*.scar"
---

# Console Command Rules — Canonical Spec

> **Single source of truth** for all AoE4 Content Editor console constraints, formatting, and validation.
> All other files (skills, coding instructions, testing rules) delegate here.

---

## Hard Constraints

1. **Single expression/statement only** — no multi-line scripts.
2. **NO `local`** — console discards local scope after each input. All variables must be global.
3. **NO control-flow blocks** — no `if/then/end`, `for/do/end`, `while/do/end`, `repeat/until`.
4. **NO cross-command state** — never assume a variable assigned in one command exists in the next. Each command is self-contained.
5. **NO multi-statement lines** — do not combine assignment + print or assignment + conditional. One statement per command.
6. **NO `scar_exec` prefix** — raw Lua only.
7. **Wrapper name is case-sensitive** — never use `scar_DebugConsoleExecute`; valid wrapper is `Scar_DebugConsoleExecute` only.
8. **NO `Scar_DoString(...)` wrappers in response commands** — always emit direct callable command text (for example `CBA_AIPlayer_Status()`).
9. **NO semicolon chaining** — do not join statements with `;`. A semicolon-separated line is still multiple statements and is invalid.
10. **NO inline anonymous functions** — do not emit `function() ... end`, callback wrappers, or timer lambdas in console commands.
11. **If task requires control flow, state, iteration, delayed callbacks, or repeated polling** → write a named function in a `.scar` file and call that single function from the console.
12. **Response text only** — console commands are literal text in the chat response body. Never emit them via file-editing tools, terminal-run tools, code-application mechanisms, or any tool that writes to a file or executes code. The command must appear in the markdown table inside the response message.
13. **NO restart commands** — never emit `scar_Restart()` in any console/testing command table.

## Presentation Format

Every console command in any response context is presented as a row in a **markdown table** with four columns. This applies universally — `## Testing` sections, inline answers, follow-ups, and any other output containing a runnable command. Never use fenced code blocks (` ``` ` or ` ```lua `) for console commands — use the table format exclusively.

### Table Schema

| Step | Command | Description | Expected results |
|------|---------|-------------|------------------|
| 1 | Debug_ExampleCommand() | Step 1. What this command tests and why it is being run. | What to look for in the console log. Extra context fits here too. |

### Column Rules

- **Step** — A sequential integer (`1`, `2`, `3`) when execution order matters. Use `—` when commands are independent.
- **Command** — Raw command text only. No backticks, no fences, no inline markup.
- **Description** — One sentence explaining what the command does and why. Prefix with `Step N.` when Step column is numeric.
- **Expected results** — What a passing run looks like in the console log. Extra context or notes go here when space permits.

### Minimal Entry Style

- Keep every row compact and direct.
- **Description** should be one short sentence with no filler.
- **Expected results** should list only the primary pass signal.
- Prefer explicit validators or orchestrators that capture progression in one run instead of repeating the same inspector command in multiple rows.

### Table Rules

1. **ONE command per row.** Each row contains exactly one single-line raw command in the Command cell.
2. **No comments or markup inside the Command cell.** Raw text only.
3. **Max 5 rows per response.** When multiple distinct `Debug_*` functions each target a different area of the edit, list each one. Never suppress individual commands solely because an orchestrator calls them. When one `Debug_*` suite covers the entire edit, one row is sufficient.
4. **No duplicate coverage.**
5. **No duplicate command text.** The same command string must not appear in more than one row in the same table.
6. **Use the Step column for ordering** — set to `—` when execution order does not matter. Numeric steps imply ordered execution in the same test pass.
7. **No runnable commands outside the table** — not in bullets, inline code, or prose.
8. **No bullet-list fallback** — do not introduce commands with labels like "1. Toggle crash regression test" followed by a runnable snippet. If a command is runnable, it must live in a table row.

## Allowed Patterns (reference — one command per table row)

| Pattern | Example |
|---------|---------|
| Single function call | `Validator_PlayerCivDump()` |
| Single global assignment | `DLC_DEBUG = true` |
| Print wrapping a call or field | `print(Validator_RestrictionParity().ok)` |
| Function call with arguments | `Simulate_PlayerProgression("english", 2)` |
| Inline ternary (single expr) | `print(Validator_RestrictionParity().ok and "PASS" or "FAIL")` |

## Forbidden → Fix

| Forbidden | Fix |
|-----------|-----|
| `local result = f()` | `print(f().field)` |
| `if cond then print("yes") end` | `print(cond and "yes" or "no")` |
| `result = f()` then `print(result.ok)` | `print(f().ok)` |
| `A(); B()` or `A(); Rule_AddInterval(...)` | Write a wrapper in .scar, call it |
| `Rule_AddInterval(function() ... end, 0.5)` | Write a named helper in .scar, call it |
| `for k,v in pairs(t) do print(k) end` | Write a wrapper in .scar, call it |
| `Scar_DoString("CBA_AIPlayer_Status()")` | `CBA_AIPlayer_Status()` |
| `scar_DebugConsoleExecute("...")` | `FunctionName(...)` (preferred) or `Scar_DebugConsoleExecute("...")` when required |
| `CBA_AIPlayer_Status()` in multiple rows | Use one orchestrator/tracker command for progression, then use distinct non-duplicate follow-up commands only if needed |
| `scar_Restart()` | Do not list restart commands in console/testing tables |

## Command Selection Heuristic

1. **Every command must directly validate the specific edit goal.** Generic smoke tests (`Debug_RunSmokeTests()`) are only acceptable as a Tier 1 baseline alongside a targeted command — never as the sole validation.
2. **Prefer `Debug_*` functions** when they cover the exact area changed.
3. **Match commands to the area changed** — limits → limit inspectors, leaver → leaver validators, etc.
4. For the full command catalog, see `.skills/scar-debug/SKILL.md` → Command Catalog.

## Console Output Gate

A **bare command** is any `Debug_*()`, `print(...)`, `Validator_*()`, `Simulate_*()`, or `GLOBAL = value` string outside the command table — appearing on its own line, in inline backticks, in a bullet or numbered list, in a bold-label pair, in prose as a runnable instruction, or after the table as an addendum.

Output is **invalid** if it contains `scar_exec`, a bare command outside a table row, fenced code blocks wrapping a console command, numbered/bulleted runnable-command lists, bold-label + command pairs, inline runnable commands in prose, commands after or outside the table, >1 command per table row, or a file-edit/terminal-run tool invocation that delivers a console command instead of placing it in the response body table. **Regenerate before responding.**

## Pre-Send Self-Check

Before sending, every item must pass — if any fails, rewrite.

1. Every command is a row in a markdown table with columns Step | Command | Description | Expected results
2. No Command cell contains >1 command or any markup — raw text only
3. No `Debug_*()` / `print(...)` / `Validator_*()` appears outside a table row as runnable instruction
4. No fenced code blocks (` ``` ` or ` ```lua `) wrapping console commands
5. No `scar_exec`, no `Scar_DoString(...)`, no `local`, no control-flow blocks, no semicolon chaining, no anonymous `function() ... end` wrappers
6. No cross-command state assumptions
7. No `scar_Restart()` in any command row
8. No duplicate command text across rows in the same table
9. ≤ 5 rows total; command selection follows the heuristic above
10. No numbered bullets, bold labels, or prose examples contain runnable commands outside the table
11. No console command was delivered via a file-editing tool, terminal tool, or code-application tool — all commands appear literally in the response body table
