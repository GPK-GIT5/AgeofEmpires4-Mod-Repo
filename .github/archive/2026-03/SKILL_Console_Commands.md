---
name: copilot-skill-console-commands
description: Generate valid Lua commands for the AoE4 Content Editor console, enforcing stateless single-expression constraints.
---

# Copilot Skill: Console Command Generation

**Purpose:** Generate valid Lua commands for the AoE4 Content Editor console, enforcing stateless single-expression constraints.

**Context:** The console is a stateless single-expression REPL. Each input is compiled and executed independently; there is no shared scope between inputs.

**When to invoke:**
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

1. Identify the user's intent (inspect value, call function, set flag, etc.)
2. Draft the command as a **single Lua expression or statement**
3. Comment the expected result for every command.
4. Validate against the **Hard Constraints** below
5. If the task requires control flow, state, or iteration — advise the user to **write a named function in a .scar file** and call that single function from the console instead
6. Run the **Pre-Output Checklist** before presenting the command

## Hard Constraints

1. **NO `local`** — Console discards local scope after each input. All variables must be global.
2. **NO control-flow blocks** — No `if/then/end`, `for/do/end`, `while/do/end`, `repeat/until`. One expression or statement per input.
3. **NO cross-command state** — Never assume a variable assigned in one command exists in the next. Each command is self-contained.
4. **NO multi-statement lines** — Do not combine assignment + print or assignment + conditional. One statement per command.
5. **NO paste blocks** — Each command is a separate console submission; never present a group as "paste this block".

## Allowed Patterns

```lua
-- Single function call
Validator_PlayerCivDump()

-- Single global assignment
DLC_DEBUG = true

-- Print wrapping a call or field access
print(Validator_RestrictionParity().ok)
print(Validator_RestrictionParity().balance_count)

-- Function call with arguments
Simulate_PlayerProgression("english", 2)

-- Inline ternary (single expression)
print(Validator_RestrictionParity().ok and "PASS" or "FAIL")
```

## Forbidden → Fix

```lua
-- FORBIDDEN: local keyword
local result = f()           --> print(f().field)

-- FORBIDDEN: if block
if cond then print("yes") end --> print(cond and "yes" or "no")

-- FORBIDDEN: cross-command state
result = f()                  -- cmd 1
print(result.ok)              -- cmd 2 (result lost)
                              --> print(f().ok)

-- FORBIDDEN: loop
for k,v in pairs(t) do print(k) end
                              --> write a wrapper in .scar, call it

-- FORBIDDEN: multi-statement line
result = f() print(result.ok) --> print(f().ok)
```

## Design Principle

If a command requires control flow, state, or iteration — **write a named function in a .scar file** and call that single function from the console. The console is an invocation surface only.

## Pre-Output Checklist

Before outputting any console command, verify every item:

- [ ] No `local` keyword
- [ ] No `if`, `for`, `while`, `repeat` blocks
- [ ] Exactly one statement per command
- [ ] No command references a variable from a previous command
- [ ] Output is a flat list of independent single-line calls
