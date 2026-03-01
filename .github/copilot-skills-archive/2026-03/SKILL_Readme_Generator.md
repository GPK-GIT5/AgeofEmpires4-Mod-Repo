---
name: gamemode-mod-readme-generator
description: 'Generate comprehensive README files for AoE4 gamemode and mod folders by analyzing .scar files, MOD-INDEX.md, and reference documentation. Creates structured documentation with project description, architecture, file structure, API index, and development notes.'
---

# Gamemode/Mod README Generator

Generate a comprehensive README.md for an AoE4 gamemode or mod folder. Follow these steps:

## 1. Scan Target Folder
Analyze files in the specified gamemode/mod directory:
- All `.scar` files (for structure and function signatures)
- `MOD-INDEX.md` (if exists in `mods/[name]/`)
- Related files in `reference/mods/[name]*` directories
- Existing README.md for migration

## 2. README Structure

### Project Header
```markdown
# [Name] — AoE4 [Type]

[![AoE4 Version](badge)](link)
[![Type](badge)](.)
[![Players](badge)](.)

Brief description (2-3 sentences) covering:
- What it is (co-op scenario, game mode, etc.)
- Player count and roles
- Core objective or gameplay loop

Credits/attribution section.
```

### Technology Stack (Table)
| Component | Technology | Version |
|-----------|-----------|---------|
| Game Engine | Age of Empires IV | Latest |
| Scripting | SCAR (Lua) | AoE4 Editor |
| Framework | [e.g., MissionOMatic.scar] | Relic |

Include "Core Dependencies" code block with import statements.

### Project Architecture
- High-level ASCII tree structure
- Key Systems breakdown with tables
- Objective chain flow diagrams
- Examples: `mods/Arabia/README.md`

### Getting Started
- Loading in Content Editor
- Playing the scenario
- Controls and initial setup

### File Structure (Table)
| File | Lines | Purpose | Key Functions |
|------|-------|---------|---------------|

### API/Function Index
- Custom function signatures
- Link to MOD-INDEX.md if available

### Development Notes (Optional)
- Known issues
- Future work
- Technical considerations

## 3. Exclude These Sections
❌ Installation prerequisites  
❌ License information  
❌ Contributing guidelines  
❌ CI/CD badges  
❌ Repo-level folder structure  

## 4. Reference Examples
✅ Comprehensive: `mods/Arabia/README.md`  
✅ Index style: `mods/Japan/MOD-INDEX.md`  
✅ Function catalog: `reference/mods/MOD-INDEX.md`

## 5. Format Guidelines
- Use proper Markdown with code blocks
- Include tables for structured data
- Add ASCII diagrams for architecture
- Cross-link to reference documentation
- Keep concise but informative

## 6. Manual Invocation
To use this skill, reference it in your request:
- "Use the gamemode-mod-readme-generator to document gamemodes/Advanced Game Settings"
- "Generate a README for mods/[name] using the README generator skill"
