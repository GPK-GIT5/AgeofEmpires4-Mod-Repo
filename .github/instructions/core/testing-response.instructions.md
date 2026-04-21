---
applyTo: "**"
---

# Testing Section Rule

Every response that edits or creates `.scar` files **must** end with a `## Testing` section. Omit the section entirely for pure documentation, research, or informational answers.

Trigger: if a debug function or `.scar` file is added, removed, or updated → always include `## Testing`.

## Output Format — Table Only

All runnable commands appear as rows in a **single markdown table**. No other format is permitted anywhere in the response.

| Step | Command | Description | Expected results |
|------|---------|-------------|------------------|

### Column rules

- **Step** — Sequential integer when order matters; `—` when independent.
- **Command** — Raw text only. No backticks, no fences, no markup.
- **Description** — What the command validates and why.
- **Expected results** — What a passing run looks like in the console log.

### Minimal Row Style

- Keep rows concise: one command, one clear purpose, one primary pass signal.
- Avoid repeated inspector rows. If progression tracking is needed, prefer one orchestrator/tracker command that reports staged progress in a single run.
- Never include `scar_Restart()` in the testing command table.

### Banned formats — regenerate before sending

| Banned format | Why it recurs | Fix |
|---------------|---------------|-----|
| Fenced code blocks | Habit from code responses | Move command into a table row |
| Numbered/bulleted command lists | Seems natural for sequences | Use Step column for ordering |
| Inline runnable commands in prose | Explaining what to run | Move to table; describe without the command text in prose |
| Bold-label + command pairs | Labeling commands | Remove label; use table Description column |
| Commands after or outside the table | Addendum habit | All runnable commands go in the table |
| Commands delivered via tools | File-edit, terminal, code-apply | Commands are response-body text only |

A command is runnable if it can be pasted into the AoE4 console. If it's runnable, it belongs in the table and nowhere else.

## Placement

`## Testing` is always the **last section**. Nothing follows it.

- No summaries, skills lists, or design notes after the table.
- No preamble like "Console commands for testing:" between content and the table.
- Search or exploration notes go **before** `## Testing`.

## Command Selection

> **Full rules:** `console-commands.instructions.md` § Command Selection Heuristic
> **Full catalog:** `.skills/scar-debug/SKILL.md` § Command Catalog

- ≤ 3 commands preferred; up to 5 only when targeting different areas.
- Every command must directly validate the specific edit — no generic smoke tests as sole validation.
- When one `Debug_*` suite covers the entire edit, one row is sufficient.
- No duplicate command text in the same table.
- Never add `scar_Restart()` as a command row.

| Change scope | Minimum | Example |
|--------------|---------|---------|
| Single-file, cosmetic | 1 area-matched command | Targeted inspector |
| Multi-file or logic change | 2–3 area-matched commands | Limits + Leaver inspectors |
| New debug function or stress fix | Up to 5 targeted commands | Suite + targeted inspectors |

Never exceed 5 commands.

## Iterative Validation Gates

When a SCAR edit is part of an ongoing multi-attempt fix, the following gates should be passed in order before running console tests. These are advisory — skip when clearly unnecessary.

1. **Syntax gate** — Verify the file parses (no `<eof> expected`, mismatched `end`, nil reference). If syntax fails, fix before proceeding.
2. **Logic gate** — Trace the edited call path: is the function reachable? Are guard conditions met? Is the rule registered? If logic is unreachable, fix before running in-game.
3. **Runtime gate** — Run console test. Expect either new evidence (changed scarlog output) or a new error. If output is identical to the prior attempt, return to the logic gate rather than iterating the same edit.

If repeated observation is required, prefer a single purpose-built `Debug_*`/`debug.run(...)` command that aggregates checkpoints rather than repeating the same status command across rows.

Hypothesis and evidence-delta notes belong in prose **before** `## Testing`. Runnable commands remain table-only inside `## Testing`.

## Gap Handling

When no existing `Debug_*` covers the change:

1. Flag: `<!-- DEBUGGER_GAP: [area] — [what is missing] -->`
2. Log: append a row to `references/audits/debugger-gap-log.md`
3. Provide the best alternative (e.g., `print()`) in the table.

If validation needs control flow or multi-step logic → create a `Debug_*` helper in a debug `.scar` file so the check is a single console command.

## Enforcement

- Every `.scar` edit response includes ≥1 console command in the table. No exceptions.
- Commands are literal response-body text — never delivered via file-editing, terminal, or code-application tools.
- **A response is invalid if any runnable command appears outside the table.**
- Render failure: re-emit the table in a fresh message or fresh chat session. Never write commands to files as a workaround.

## Canonical Spec

> **Hard constraints, allowed patterns, forbidden→fix, output gate, pre-send checklist:** `.github/instructions/core/console-commands.instructions.md`
