# Batch 1 — Instructions, Skills, Agents & Prompt Engineering

> **Scope:** 20 GitHub URLs crawled and synthesized  
> **Date:** 2026-02-26  
> **Purpose:** High-signal patterns for reliable one-shot outputs and extensible system design  
> **Optimized for:** Downstream AI consumption (clarity, hierarchy, reusability)

---

## Table of Contents

1. [Customization File Architecture](#1-customization-file-architecture)
2. [Precedence & Loading Rules](#2-precedence--loading-rules)
3. [Instruction File Patterns](#3-instruction-file-patterns)
4. [Skill Design Patterns](#4-skill-design-patterns)
5. [Agent Design Patterns](#5-agent-design-patterns)
6. [Prompt Engineering Fundamentals](#6-prompt-engineering-fundamentals)
7. [Context Engineering — Advanced](#7-context-engineering--advanced)
8. [Cross-Platform Compatibility](#8-cross-platform-compatibility)
9. [Source Index](#9-source-index)

---

## 1. Customization File Architecture

### 1.1 GitHub Copilot File Map

| Feature | File / Location | Trigger | Scope |
|---|---|---|---|
| **Custom instructions** | `.github/copilot-instructions.md` | Automatic (always-on) | Repo-wide coding standards, project context |
| **Path-specific instructions** | `.github/instructions/*.instructions.md` | Automatic (file-match via `applyTo` glob in YAML frontmatter) | File-type or directory-scoped guidance |
| **Prompt files** | `.github/prompts/*.prompt.md` | Manual (user references in chat via `#` or slash command) | Reusable task templates, can embed file refs |
| **Custom agents** | `.github/agents/<name>.agent.md` | Manual (dropdown select in Copilot Chat) | Specialist personas with tool restrictions |
| **Agent skills** | `.github/skills/<name>/SKILL.md` | Automatic (relevance-based, from description) | Multi-step workflows with bundled resources |
| **Agent instructions** | `AGENTS.md` / `COPILOT.md` (root or any dir) | Automatic (merged from all ancestor dirs) | Third-party agent compatibility |
| **Memory** | Copilot Memory (cloud) | Automatic recall | Cross-session user preferences and facts |
| **MCP servers** | `.vscode/mcp.json` or agent YAML `mcp-servers` | Named tool access | External system integration |

### 1.2 Third-Party Agent Config File Names

| Tool | Primary Config | Skills Path | Agents Path |
|---|---|---|---|
| Claude Code | `CLAUDE.md` | `.claude/skills/` | `.claude/agents/` |
| GitHub Copilot | `.github/copilot-instructions.md` | `.github/skills/` | `.github/agents/` |
| Cursor | `.cursor/rules` | `.cursor/skills/` | — |
| Gemini CLI | `GEMINI.md` | `.gemini/skills/` | — |
| OpenAI Codex | `AGENTS.md` | `codex/skills/` | — |
| Windsurf | `.windsurfrules` | `.windsurf/skills/` | — |
| Antigravity | `.antigravity/instructions.md` | `.antigravity/skills/` | — |
| OpenCode | `opencode.md` | `.opencode/skills/` | — |

---

## 2. Precedence & Loading Rules

### 2.1 GitHub Copilot Instruction Priority (highest → lowest)

1. **Personal instructions** — User-level settings (VS Code `github.copilot.chat.codeGeneration.instructions`)
2. **Path-specific instructions** — `.github/instructions/*.instructions.md` matching current file via `applyTo`
3. **Repository-wide instructions** — `.github/copilot-instructions.md`
4. **Agent instructions** — `AGENTS.md` files (merged from current dir up to root)
5. **Organization instructions** — GitHub org-level policy (admin-configured)

### 2.2 Key Loading Behaviors

- **Additive merge:** All matching instruction sources are concatenated, not overridden. Higher-priority sources appear first in the prompt context.
- **`applyTo` glob patterns:** Standard glob syntax (`**/*.scar`, `src/components/**`). Multiple patterns allowed. Instructions only load when the active file matches.
- **YAML frontmatter required** for `.instructions.md` and `.agent.md` files. Minimum fields: `applyTo` (instructions) or `name`/`description` (agents).
- **Prompt files** are NOT automatically loaded — they require explicit user reference.
- **Skills** load automatically when their `description` field matches the user's prompt by relevance scoring.
- **`AGENTS.md` inheritance:** Files are read from every ancestor directory of the current file up to the repo root. All are merged.

### 2.3 Character / Size Limits

| Item | Limit | Notes |
|---|---|---|
| `copilot-instructions.md` | ~8,000 chars recommended | Longer files may be truncated |
| `.instructions.md` description | < 200 chars | Must fit in YAML frontmatter |
| `.agent.md` prompt body | ≤ 30,000 chars | YAML frontmatter + Markdown body |
| Skill `SKILL.md` | No hard limit | Progressive disclosure keeps effective size small |
| GitHub Code Review instructions | < 4,000 chars per file | Applies to PR review context |

---

## 3. Instruction File Patterns

### 3.1 `.instructions.md` Template

```yaml
---
applyTo: "**/*.scar"
---
```
```markdown
# SCAR Scripting Standards

- Use `Scartype` annotations on all function parameters
- Wrap AI state in `Rule_AddInterval` / `Rule_RemoveMe` lifecycle
- Prefer `EGroup` iteration over raw entity loops
```

### 3.2 `copilot-instructions.md` Best Practices

- **DO:** State project language, framework, naming conventions, testing patterns
- **DO:** Include repo-specific context (e.g., "This is an AoE4 mod using SCAR/Lua")
- **DO:** Reference key architecture decisions and file structure
- **DON'T:** Include secrets, API keys, or credentials
- **DON'T:** Add instructions that conflict with path-specific files
- **DON'T:** Exceed ~8K chars — brevity improves compliance

### 3.3 `AGENTS.md` Pattern

No YAML frontmatter. Plain Markdown. Works with Claude Code, Codex, and Copilot (via agent instructions support).

```markdown
# Project Guidelines

## Architecture
- Modular SCAR scripts under `assets/scar/`
- Helpers in `helpers/` subdirectory
- UI panels in `gameplay/` subdirectory

## Testing
- Run `npm test` for unit tests
- Manual test via AoE4 Content Editor

## Code Style
- 4-space indentation in Lua/SCAR
- CamelCase for functions, snake_case for locals
```

---

## 4. Skill Design Patterns

### 4.1 SKILL.md File Format (Anthropic Standard)

```yaml
---
name: "scar-debug"
description: "Debug SCAR/Lua runtime errors in AoE4 mods. Use when: user reports nil errors, entity crashes, or AI state machine failures."
tools: ["read_file", "grep_search", "semantic_search", "run_in_terminal"]
---
```
```markdown
# SCAR Debug Skill

## Activation
This skill activates when the user reports runtime errors in SCAR scripts...

## Procedure
1. Identify the error type from the stack trace
2. Search for the function name in the codebase
3. Check entity blueprint validity
4. Suggest fix with before/after code blocks

## Resources
- See `references/api/scar-api-functions.md` for API reference
- See `data/buildings/` for blueprint data
```

### 4.2 Skill Quality Standards (Community Consensus)

| Criterion | Standard |
|---|---|
| **Description voice** | Third person, specific keywords, includes "Use when" clause |
| **Metadata size** | < 100 tokens (frontmatter only) |
| **Body size** | < 500 lines |
| **Path references** | Relative only — no absolute paths |
| **Tool scoping** | Declare minimum necessary tools in `tools` array |
| **Activation clarity** | Description must contain words a user would naturally type |
| **Progressive disclosure** | Metadata → Instructions → Resources (3-tier loading) |

### 4.3 Progressive Disclosure Model

```
┌─────────────────────────────────────────┐
│ Tier 1: METADATA (always loaded)        │
│   - name, description (~100 tokens)     │
│   - Used for relevance scoring          │
├─────────────────────────────────────────┤
│ Tier 2: INSTRUCTIONS (loaded on match)  │
│   - Procedure steps, rules, patterns    │
│   - Referenced resources                │
├─────────────────────────────────────────┤
│ Tier 3: RESOURCES (loaded on demand)    │
│   - Bundled data files, templates       │
│   - External file references            │
└─────────────────────────────────────────┘
```

### 4.4 Skills vs Agents (Role Distinction)

| Dimension | Skills | Agents |
|---|---|---|
| **Purpose** | Specialized knowledge/procedures | High-level reasoning/orchestration |
| **Activation** | Automatic (pattern matching) | Manual (user selects) |
| **Context** | Injected into existing agent | Replaces default agent context |
| **Granularity** | Narrow (one task domain) | Broad (persona + multiple domains) |
| **File format** | `SKILL.md` with resources | `.agent.md` single file |
| **Composability** | Multiple skills can activate together | One agent at a time |

---

## 5. Agent Design Patterns

### 5.1 `.agent.md` Template

```yaml
---
name: "scar-specialist"
description: "Expert in AoE4 SCAR/Lua scripting. Handles gameplay logic, AI behaviors, UI panels, and mod debugging."
tools: ["read_file", "replace_string_in_file", "run_in_terminal", "grep_search", "semantic_search"]
mcp-servers: []
---
```
```markdown
# SCAR Specialist Agent

You are an expert in Age of Empires 4 modding using the SCAR scripting language (Lua-based).

## Core Knowledge
- SCAR API functions and event system
- Entity/Squad/Player object model
- Blueprint system (EBP, SBP, UBP)
- XamlPresenter UI panels (with known crash patterns)

## Rules
- Always check blueprint validity before referencing
- Use `branch_civ` pattern for DLC variant coverage
- Never bind Width/Height/Opacity via DataContext in XamlPresenter
- Test entity operations against nil before calling methods

## Workflow
1. Read the relevant SCAR files to understand context
2. Check references/ for API documentation
3. Check data/ for blueprint validation
4. Implement changes with minimal edits
5. Validate with terminal if possible
```

### 5.2 Subagent Architecture (Claude Code Pattern)

```yaml
# .claude/agents/code-reviewer.yaml
name: "code-reviewer"
description: "Reviews code for correctness, security, and style. Read-only access."
model: "sonnet"        # Smart model routing: opus=deep reasoning, sonnet=everyday, haiku=quick
tools:
  - Read
  - Grep
  - Glob
  - WebFetch           # For checking docs
# Explicitly NO Write/Edit/Bash
```

**Model Routing Heuristic:**

| Complexity | Model | Use Case |
|---|---|---|
| Deep reasoning, architecture | `opus` | System design, complex debugging |
| Everyday coding, reviews | `sonnet` | Implementation, refactoring, reviews |
| Quick lookups, formatting | `haiku` | Linting, simple edits, data formatting |

**Tool Permission Tiers:**

| Tier | Tools | Use Case |
|---|---|---|
| Read-only | Read, Grep, Glob | Research, analysis, review |
| Research | +WebFetch, WebSearch | Documentation lookup |
| Code writer | +Write, Edit, Bash | Implementation |
| Full access | +MCP servers, all tools | Orchestration agents |

### 5.3 Subagent Design Principles

- **Independent context windows** — Each subagent gets a clean context, preventing cross-contamination
- **Domain-specific intelligence** — Narrow expertise produces higher quality than broad generalists
- **Granular tool permissions** — Principle of least privilege per agent role
- **Project subagents override global** — Same-named project agent takes precedence over `~/.claude/agents/`

---

## 6. Prompt Engineering Fundamentals

### 6.1 Anthropic's 10-Component Framework

| # | Component | Purpose | Required? |
|---|---|---|---|
| 1 | **Task Context** | WHO Claude is, WHAT role to play | Yes |
| 2 | **Tone Context** | HOW to communicate (formal, casual, technical) | Recommended |
| 3 | **Background Data** | Relevant documents, context, data | When applicable |
| 4 | **Detailed Task Description** | Explicit requirements, rules, constraints | Yes |
| 5 | **Examples** | 1-3 examples of desired input/output | Highly recommended |
| 6 | **Conversation History** | Relevant prior context | When applicable |
| 7 | **Immediate Task Description** | Specific deliverable needed NOW | Yes |
| 8 | **Thinking Step-by-Step** | Encourage deliberate reasoning (CoT) | Recommended |
| 9 | **Output Formatting** | Define structure explicitly (JSON, Markdown, etc.) | Yes |
| 10 | **Prefilled Response** | Start Claude's response to guide format/style | Optional (removed in 4.6) |

> **BREAKING (Feb 2026):** Claude Opus 4.6 and Sonnet 4.6 return 400 error on assistant prefilling. Migrate Component 10 to system prompt instructions instead.

### 6.2 Core Techniques

| Technique | Pattern | When to Use |
|---|---|---|
| **XML Tags** | `<instructions>`, `<context>`, `<examples>` | Always — Claude natively understands XML structure |
| **Chain of Thought** | "Think step by step before answering" | Complex reasoning, math, multi-step logic |
| **Extended Thinking** | `thinking` parameter in API | Deep analysis, long-horizon planning |
| **Role Prompting** | "You are a senior SCAR developer..." | Domain expertise, consistent voice |
| **Few-Shot Examples** | 2-3 input/output pairs in `<examples>` | Output formatting, classification, style matching |
| **Prompt Chaining** | Break task into sequential prompts | Complex multi-stage workflows |
| **Separating Data** | XML-delimited data blocks | Preventing instruction injection from data |

### 6.3 Anthropic Interactive Tutorial — Chapter Map

| Level | Chapter | Core Lesson |
|---|---|---|
| Beginner | 1. Basic Prompt Structure | System vs user prompts, message format |
| Beginner | 2. Being Clear and Direct | Specificity, avoiding ambiguity |
| Beginner | 3. Assigning Roles | Persona-based prompting |
| Intermediate | 4. Separating Data from Instructions | XML tags, injection prevention |
| Intermediate | 5. Formatting Output | Structured responses, speaking for Claude |
| Intermediate | 6. Precognition (Step by Step) | Chain of thought, reasoning traces |
| Intermediate | 7. Using Examples | Few-shot patterns, output calibration |
| Advanced | 8. Avoiding Hallucinations | Grounding, citation, uncertainty expression |
| Advanced | 9. Complex Prompts | Industry use cases (chatbot, legal, financial, coding) |
| Appendix | Chaining, Tool Use, Search & Retrieval | Multi-step orchestration |

### 6.4 High-Signal Prompt Patterns

**Pattern: Technical Code Review**
```
<role>Senior code reviewer with expertise in [language]</role>
<task>Review the following code for security, performance, and best practices</task>
<code>{code_block}</code>
<format>
For each issue found:
1. Severity: critical/warning/info
2. Line reference
3. Problem description
4. Suggested fix with code
</format>
```

**Pattern: Long-Horizon Coding Task**
```
<context>
Project: {project_description}
Architecture: {architecture_summary}
Current state: {what_exists}
</context>
<task>
Implement {feature} following these constraints:
- {constraint_1}
- {constraint_2}
</task>
<approach>
Think step by step:
1. Analyze existing code structure
2. Plan the implementation approach
3. Implement with minimal changes
4. Verify against constraints
</approach>
```

**Pattern: Research & Synthesis**
```
<role>Research analyst</role>
<task>Analyze {topic} and produce a structured report</task>
<sources>{source_list}</sources>
<output_format>
## Executive Summary (3 sentences)
## Key Findings (numbered list)
## Evidence Matrix (table)
## Recommendations (prioritized)
</output_format>
```

### 6.5 Best Practices for Claude 4.x

- **Be explicit** — Claude 4.x responds to precise instructions over vague guidance
- **Add context ("why")** — Explain purpose, not just mechanics
- **Use examples** — Show, don't just tell (few-shot dramatically improves formatting compliance)
- **Encourage reasoning** — "Think step by step" before complex answers
- **Define output format** — Be specific about structure (JSON schema, Markdown template, etc.)
- **Leverage parallel tools** — Claude 4.x can execute multiple tool calls simultaneously
- **State tracking** — For long conversations, periodically summarize state
- **Avoid hallucinations** — Ask Claude to say "I don't know" when uncertain; provide ground truth data

---

## 7. Context Engineering — Advanced

### 7.1 Multi-Agent Orchestration

**Problem:** Single-agent context windows accumulate irrelevant information ("context rot"), degrading output quality over long sessions.

**Solution:** Decompose work across specialized agents with independent context windows.

```
┌──────────────────────────────────────────────┐
│              ORCHESTRATOR AGENT               │
│  Decomposes task → delegates → synthesizes    │
├──────────┬──────────┬────────────┬───────────┤
│ Research │ Implement│ Review     │ Test      │
│ Agent    │ Agent    │ Agent      │ Agent     │
│ (read)   │ (write)  │ (read)     │ (bash)    │
└──────────┴──────────┴────────────┴───────────┘
```

### 7.2 Quality Gates (LLM-as-Judge)

From NeoLabHQ Context Engineering Kit:

- **Evidence-based scoring:** Rubric with specific criteria, not subjective quality
- **Verification chain:** Generate → Self-Review → Fix → Verify → Ship
- **Multi-agent voting:** 3+ agents independently assess, majority rules
- **Structured rubrics:**
  ```
  Score 1-5 on each criterion:
  - Correctness: Does the code compile and produce expected output?
  - Completeness: Are all requirements addressed?
  - Style: Does it follow project conventions?
  - Safety: Are there security or crash risks?
  ```

### 7.3 MAKER Pattern (NeoLabHQ)

A pattern for maximizing agentic work quality:

1. **Clean-state launches** — Each agent starts with a fresh context (no inherited confusion)
2. **Filesystem memory** — Agents persist intermediate state to files, not context windows
3. **Multi-agent voting** — Multiple independent agents attempt the same task; best output wins
4. **Spec-driven development** — `task specs → implement → verify against spec`

### 7.4 Reflexion Loop

```
┌─────────┐    ┌──────────┐    ┌─────────┐    ┌──────────┐
│ Generate │───→│ Evaluate │───→│ Reflect │───→│ Refine   │
└─────────┘    └──────────┘    └─────────┘    └──────────┘
                    │                               │
                    └──────── Loop until pass ───────┘
```

- Agent generates output → Evaluator scores against rubric → If score < threshold, agent reflects on failures → Generates improved version
- Typically converges in 2-3 iterations
- Based on: Self-Refine (Madaan et al.), Reflexion (Shinn et al.)

### 7.5 Structured Reasoning Templates

| Template | Structure | Use Case |
|---|---|---|
| **Zero-shot CoT** | "Think step by step" appended | General reasoning improvement |
| **Few-shot CoT** | Examples include reasoning traces | Domain-specific reasoning |
| **Tree of Thoughts** | Branch → Evaluate → Prune → Select | Complex problem solving with alternatives |
| **Problem Decomposition** | Break into sub-problems → solve → synthesize | Multi-part engineering tasks |
| **Self-Critique** | Generate → Critique → Revise | Quality improvement without external evaluator |
| **Chain-of-Verification** | Answer → Generate verification questions → Answer them → Revise | Fact-checking and accuracy |

### 7.6 Context Engineering Principles

1. **Context is the new programming** — The quality of AI output is bounded by the quality of its input context
2. **Progressive disclosure** — Load metadata always, details on demand, resources on explicit need
3. **Separation of concerns** — Instructions (how) vs. data (what) vs. examples (calibration) in distinct sections
4. **Minimal effective context** — Include only what's necessary; more context ≠ better output past a threshold
5. **Structured over natural language** — XML tags, YAML, JSON schemas > prose for machine consumption
6. **Ground truth anchoring** — Provide reference data to prevent hallucination
7. **Explicit > implicit** — State everything; assume nothing about the model's inference

---

## 8. Cross-Platform Compatibility

### 8.1 Universal Skill Structure

The emerging open standard (agentskills.io / VoltAgent) proposes a cross-platform skill format:

```
.claude/skills/my-skill/       # Claude Code
.github/skills/my-skill/       # GitHub Copilot
.cursor/skills/my-skill/       # Cursor
.gemini/skills/my-skill/       # Gemini CLI

my-skill/
├── SKILL.md                   # Main entry point (all platforms)
├── resources/                 # Bundled data files
│   ├── schema.json
│   └── examples/
└── tests/                     # Optional validation
```

### 8.2 Cross-Platform Instruction Mapping

| Concept | Copilot | Claude Code | Cursor | Gemini CLI |
|---|---|---|---|---|
| Repo instructions | `copilot-instructions.md` | `CLAUDE.md` | `.cursor/rules` | `GEMINI.md` |
| Per-file rules | `.instructions.md` + `applyTo` | `CLAUDE.md` in subdirectory | `.cursor/rules` with globs | Per-directory `GEMINI.md` |
| Prompt templates | `.prompt.md` | Slash commands (`.claude/commands/`) | — | — |
| Agent profiles | `.agent.md` | `.claude/agents/*.yaml` | — | — |
| Memory | Copilot Memory (cloud) | `~/.claude/memory.json` | — | — |
| MCP config | `.vscode/mcp.json` | `.mcp.json` | `.cursor/mcp.json` | — |

### 8.3 Portability Recommendations

- **Use `AGENTS.md` at repo root** — Recognized by Copilot, Claude Code, and Codex
- **Keep skills in SKILL.md format** — Emerging standard across 8+ platforms
- **Prefer Markdown with YAML frontmatter** — Universal parser support
- **Avoid platform-specific syntax** — No VS Code settings references in skill bodies
- **Relative paths only** — Never use absolute paths in skills or instructions
- **Description-first design** — All platforms use description for relevance matching; invest in clear, keyword-rich descriptions

---

## 9. Source Index

| # | URL | Category | Key Extraction |
|---|---|---|---|
| 1 | github.com/docs/copilot/customizing-copilot/adding-repository-custom-instructions-for-github-copilot | Copilot Docs | `copilot-instructions.md` format, character limits |
| 2 | github.com/docs/copilot/customizing-copilot/adding-custom-instructions-for-github-copilot | Copilot Docs | Path-specific `.instructions.md` with `applyTo` globs |
| 3 | github.com/docs/copilot/customizing-copilot/extending-the-capabilities-of-github-copilot-in-your-organization | Copilot Docs | Org-level instruction policies |
| 4 | github.com/docs/copilot/customizing-copilot/copilot-agent-skills | Copilot Docs | SKILL.md format, progressive disclosure |
| 5 | github.com/docs/copilot/customizing-copilot/adding-custom-agents-for-copilot | Copilot Docs | `.agent.md` format, tool restrictions, MCP |
| 6 | github.com/docs/copilot/customizing-copilot/copilot-memory | Copilot Docs | Memory system, cross-session recall |
| 7 | github.com/docs/copilot/customizing-copilot/customizing-the-response-of-github-copilot-in-your-organization | Copilot Docs | Org response customization |
| 8 | github.com/docs/copilot/customizing-copilot/managing-copilot-knowledge-bases | Copilot Docs | Support matrix for customization features |
| 9 | github.com/docs/copilot/copilot-customization-cheat-sheet | Copilot Docs | Quick reference for all customization options |
| 10 | github.com/docs/copilot/tutorials/creating-copilot-agent-skills | Copilot Docs | Step-by-step skill creation tutorial |
| 11 | github.com/docs/copilot/tutorials/creating-a-custom-copilot-agent | Copilot Docs | Agent creation walkthrough |
| 12 | github.com/anthropics/skills | Anthropic | Official SKILL.md spec, entry points, resource bundling |
| 13 | github.com/anthropics/claude-cookbooks | Anthropic | Recipe collection: tool use, RAG, extended thinking |
| 14 | github.com/anthropics/prompt-eng-interactive-tutorial | Anthropic | 9-chapter course: basic→advanced prompt engineering |
| 15 | github.com/VoltAgent/awesome-agent-skills | Community | 549+ skills, cross-platform paths, quality criteria |
| 16 | github.com/VoltAgent/awesome-claude-code-subagents | Community | 127+ subagents, model routing, tool permissions |
| 17 | github.com/wshobson/agents | Community | 129 skills, 27 plugins, 3-tier progressive disclosure |
| 18 | github.com/zircote/.claude | Community | 100+ agents, 60+ skills, CLAUDE.md config patterns |
| 19 | github.com/NeoLabHQ/context-engineering-kit | Community | MAKER pattern, reflexion loops, multi-agent voting, quality gates |
| 20 | github.com/ThamJiaHe/claude-prompt-engineering-guide | Community | 10-component framework, 22 skills, ClaudeForge tool |
| 21 | github.com/thibaultyou/prompt-blueprint | Community | Meta-prompts, unified best practices, prompt agent |

---

## Quick Reference Card

### Minimum Viable Instruction Set

```
.github/
├── copilot-instructions.md          # Always-on repo context
├── instructions/
│   └── scar.instructions.md         # applyTo: "**/*.scar"
├── agents/
│   └── scar-specialist.agent.md     # Manual specialist persona
├── skills/
│   └── scar-debug/
│       └── SKILL.md                 # Auto-activating debug workflow
└── prompts/
    └── review-scar.prompt.md        # Reusable review template
```

### Instruction Writing Checklist

- [ ] State the project language and framework in `copilot-instructions.md`
- [ ] Keep each instruction file under 4K chars (Code Review) / 8K chars (Chat)
- [ ] Use `applyTo` globs to scope path-specific instructions
- [ ] Put "Use when" in every skill description
- [ ] Scope agent tools to minimum necessary permissions
- [ ] Use XML tags to separate instructions from data in prompts
- [ ] Include 2-3 examples for any output format requirement
- [ ] Test skills by searching for their trigger words in Copilot Chat

### Prompt Quality Checklist

- [ ] Role defined (Component 1)
- [ ] Task explicitly described (Component 4 + 7)
- [ ] Output format specified (Component 9)
- [ ] Examples included for non-trivial formats (Component 5)
- [ ] Step-by-step reasoning encouraged for complex tasks (Component 8)
- [ ] Data separated from instructions with XML tags (Component 3)
- [ ] No assumptions about model knowledge — ground truth provided
