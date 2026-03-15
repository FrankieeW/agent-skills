# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This repository contains **reusable skills** for Claude Code agents. Skills are specialized instruction sets that handle common workflows efficiently. They're invoked via `/skill-name` commands in Claude Code sessions.

**Key insight**: Each skill is self-contained with its own SKILL.md documentation, making them independently discoverable and usable.

## Repository Structure

```
agent-skills/
├── README.md                 # Overview and skill listing
├── AGENTS.md                 # Development guidelines (outdated, update with CLAUDE.md)
├── CLAUDE.md                 # This file
├── {skill-name}/
│   ├── SKILL.md             # Skill definition (YAML frontmatter + markdown docs)
│   ├── init.sh              # (optional) Executable scripts
│   ├── templates/           # (optional) Template files
│   ├── references/          # (optional) Reference documentation
│   └── README.md            # (optional) Internal implementation docs
└── .claude/
    └── settings.local.json   # Session permissions (auto-generated)
```

## What Makes a Skill

A skill is a directory containing a **SKILL.md** file with:

1. **YAML Frontmatter** (required):
   ```yaml
   ---
   name: skill-name
   description: >
     One-line description. Use when: trigger conditions.
   ---
   ```

2. **Markdown Documentation** (required):
   - Overview
   - When to use
   - Usage examples
   - Step-by-step workflows
   - Common patterns

3. **Supporting Files** (optional):
   - Scripts (`init.sh`, etc.)
   - Templates (configuration examples)
   - Reference docs

**Example**: `pre-init/SKILL.md` shows a well-structured skill with defaults and user customization support.

## Adding New Skills

### Step 1: Understand the Pattern

Each skill should solve a specific, well-defined problem. Look at existing skills:
- `pre-init/` - Configuration template initialization
- `tmux/` - Terminal multiplexer patterns
- `mathlib-workflow/` - Domain-specific workflow (Lean 4)

### Step 2: Create Skill Directory

```bash
mkdir -p {skill-name}
touch {skill-name}/SKILL.md
```

### Step 3: Write SKILL.md

```markdown
---
name: my-skill
description: >
  What this skill does. Use when: specific trigger/scenario.
---

# My Skill

## Overview
[Clear explanation of purpose]

## When to Use
[Specific triggers and scenarios]

## How It Works
[Step-by-step explanation]

## Examples
[Practical usage examples]

## Common Patterns
[Reusable techniques]

## Tips
[Optimization and best practices]
```

### Step 4: Test the Skill

1. Verify YAML frontmatter is valid
2. Check all links and code examples work
3. Test references to paths (if any)
4. Ensure clear "when to use" triggers

### Step 5: Update README.md

Add to the skills table in `README.md`:
```markdown
| [skill-name](./skill-name/) | Short description |
```

### Step 6: Commit

```bash
git add {skill-name}/SKILL.md README.md
git commit -m "feat: add {skill-name} skill for {purpose}"
```

## Skill Design Patterns

### Pattern 1: Self-Contained Documentation

Each skill is independent - someone can read just its SKILL.md and understand everything needed.

✅ Good: Clear triggers, complete examples, step-by-step instructions
❌ Bad: References to external docs, assumes prior knowledge

### Pattern 2: Two-Tier Configuration (optional)

For skills that benefit from user customization (like `pre-init`):

- **Skill layer**: Built-in defaults in skill directory
- **User layer**: Custom configs in `~/.config/` (takes priority)

Implement with:
1. Check user config first (`~/.config/{name}/`)
2. Fall back to skill defaults
3. Show which source is being used

See `pre-init/init.sh` for implementation example.

### Pattern 3: Integration with /init

Skills that handle project initialization should integrate with `/init`:

1. Create initialization logic (shell script)
2. Mark skill as "internal" in description if auto-called
3. Document manual usage for edge cases

**Example**: `pre-init` is auto-called by `/init` for all new projects.

## Common Development Commands

### View a Skill's Status

```bash
# Check if skill is discoverable
ls {skill-name}/SKILL.md

# View skill documentation
cat {skill-name}/SKILL.md

# Check internal implementation (if applicable)
cat {skill-name}/README.md
cat {skill-name}/init.sh
```

### Test Template/Configuration Skills

For skills with templates or scripts:

```bash
# Test auto-detection (if applicable)
cd /tmp/test-project && touch test.lean
bash {skill-name}/init.sh

# Test explicit type
bash {skill-name}/init.sh lean4

# Test priority system (if applicable)
mkdir -p ~/.config/{skill-name}/type
echo "CUSTOM" > ~/.config/{skill-name}/type/FILE.md
bash {skill-name}/init.sh type
```

### Lint SKILL.md

Check for common issues:

```bash
# Verify YAML is valid
cat {skill-name}/SKILL.md | head -10  # Check frontmatter

# Check for broken links
grep -E '\[.*\]\(' {skill-name}/SKILL.md

# Verify code blocks have language specified
grep -E '^\`\`\`$' {skill-name}/SKILL.md  # Should be ```bash, not ```
```

### Update README

After adding a skill:

```bash
# Add skill to README.md table
code README.md

# Commit
git add README.md
git commit -m "docs: add {skill-name} to skills list"
```

## Architecture Decisions

### Why Skills Are Self-Contained

Each skill is a complete, independent unit because:

1. **Discoverability** - Users can understand a skill by reading just SKILL.md
2. **Reusability** - Skills work across different projects
3. **Maintainability** - Changes to one skill don't affect others
4. **Testability** - Each skill can be tested independently

### Why Two-Tier Configuration (in applicable skills)

For customizable skills like `pre-init`:

- **Skill layer** (`/agent-skills/pre-init/templates/`): Defaults that ship with the skill
- **User layer** (`~/.config/pre-init/`): User's custom templates

This design ensures:
- ✅ Skill updates don't break user customizations
- ✅ Users can customize without modifying the skill repo
- ✅ Defaults are always available as fallback

### Why /init Integration

`/init` is Claude Code's official project initialization command. Skills that handle initialization should:

1. Be triggered automatically by `/init` (marked as "internal")
2. Support manual usage via `/skill-name` for edge cases
3. Document which is the recommended approach

## Skill Categories

### Infrastructure & Tools
- `tmux` - Terminal multiplexing
- `ssh` - Remote access patterns

### Domain-Specific Workflows
- `mathlib-workflow` - Lean 4 library contribution
- `mathlib-style` - Lean 4 code style guide

### Automation & Integration
- `pre-init` - Project configuration (integrated with `/init`)
- `openclaw-rss` - RSS feed + OpenClaw integration

### Development Workflows
- `pr-worktree-workflow` - Worktree + PR creation
- `lmfdb-cli` - Number theory database queries

## Testing a New Skill

Before committing:

1. **YAML Syntax**: Verify frontmatter is valid
   ```bash
   # Manual check
   head -10 SKILL.md | grep -E '^(name|description|---|)'
   ```

2. **Documentation**: Read SKILL.md end-to-end
   - Clear "when to use" section?
   - Examples that match the documented behavior?
   - No broken links or references?

3. **Scripts** (if applicable):
   ```bash
   # For shell scripts
   bash -n {skill-name}/script.sh  # Check syntax
   bash {skill-name}/script.sh test # Run basic test
   ```

4. **Integration** (if applicable):
   - Does it integrate with `/init` correctly?
   - Does it work in isolation (manual invocation)?
   - Are error messages helpful?

## Git Workflow

Use the standard commit convention:

```bash
# Adding a new skill
git add {skill-name}/
git commit -m "feat: add {skill-name} skill for {purpose}"

# Updating an existing skill
git commit -m "docs: improve {skill-name} examples"
git commit -m "refactor: restructure {skill-name} templates"
```

Keep commits atomic - one skill per commit when possible.

## Documentation Standards

### SKILL.md Format

- Use clear section headings (`## Section`)
- Use code blocks with language: ` ```bash ` not ` ``` `
- Include real usage examples, not abstract descriptions
- Explain the "why" not just the "what"

### Internal Documentation

- Use `README.md` in skill directory for implementation details
- Document architecture decisions clearly
- Keep internal docs separate from SKILL.md (user-facing)

## Current Skills Overview

| Name | Purpose | Key Feature |
|------|---------|------------|
| `pre-init` | Project initialization | Two-tier templates, /init integration |
| `tmux` | Terminal multiplexing | Comprehensive patterns, session management |
| `ssh` | Remote access | Key management, tunnel creation |
| `mathlib-workflow` | Lean 4 contribution | Complete GitHub workflow |
| `mathlib-style` | Lean 4 style guide | Naming conventions, formatting |
| `pr-worktree-workflow` | Git workflow | Worktree + PR creation |
| `lmfdb-cli` | Number theory queries | LMFDB API integration |
| `openclaw-rss` | Feed parsing | OpenClaw notifications |

## Extending This Repository

### Adding a Domain-Specific Skill

If you're adding skills for a specific domain (like `mathlib-*`):

1. Create separate skills for different concerns
   - `mathlib-workflow/` - How to contribute
   - `mathlib-style/` - Code standards

2. Reference each other when appropriate
3. Keep SKILL.md focused on one workflow

### Adding Infrastructure Skills

For tools like `tmux` and `ssh`:

1. Document all common patterns
2. Include troubleshooting sections
3. Show both correct and incorrect approaches

### Adding Integration Skills

For external services (like `openclaw-rss`):

1. Document setup/configuration
2. Show how to trigger from Claude Code
3. Include error handling examples

## Notes for Future Contributors

- **English only**: All skill descriptions and documentation in English
- **Self-contained**: Don't rely on external documentation beyond necessary links
- **Examples first**: Lead with practical examples, not theory
- **Clear triggers**: Make it obvious when to use each skill
- **Test before commit**: Verify YAML, links, and code examples work

## See Also

- `README.md` - Skill listing and overview
- `AGENTS.md` - Development guidelines (being merged with CLAUDE.md)
- Individual skill `README.md` files for implementation details
- `/init` - Official Claude Code project initialization command
