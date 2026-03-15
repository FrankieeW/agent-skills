---
name: pre-init
description: >
  Initialize new projects with customizable templates (CLAUDE.md, AGENTS.md, MCP config).
  Copies project-type-specific configurations from ~/.config/pre-init/{type}/ to the current project.
  Supports Lean4 and Python with extensible template system. Use when: starting a new project, switching project types, or refreshing project configuration.
---

# pre-init Skill

## Overview

`pre-init` initializes projects with configuration templates. It supports a two-tier system:

1. **Default templates** - Built-in templates in `/agent-skills/pre-init/templates/{type}/`
2. **User templates** - Custom templates in `~/.config/pre-init/{type}/` (takes priority)

This ensures consistent setup while allowing flexible customization without being affected by skill updates.

## When to Use

**Use pre-init when:**
- Starting a new project (Lean4, Python, etc.)
- Switching project types
- Refreshing/updating project configuration
- Setting up MCP servers for a new project

## Quick Start

```bash
# Initialize with project type (lean4 or python)
/pre-init lean4

# Or let the skill detect your project type
/pre-init
```

## Workflow

### 1. Run the Skill

```bash
/pre-init [type]
```

- `type` (optional): `lean4`, `python`, or custom type
- If omitted, skill auto-detects based on project files

### 2. What Gets Initialized

For each project type, the skill copies:

- **CLAUDE.md** - Claude Code personal rules (coding style, git workflow, testing)
- **AGENTS.md** - Project-level agent guidelines
- **.claude/settings.json** - MCP server configuration and hooks
- **Other files** - Type-specific setup files (e.g., `.env.example`)

### 3. Customize for This Project

After initialization, edit these files for project-specific needs:

```bash
# Review and customize for your project
code CLAUDE.md
code AGENTS.md
code .claude/settings.json
```

## Project Types

### Lean4
Mathematical proofs and theorem proving.

**Includes:**
- Lean 4 compiler hooks
- Lake build configuration
- Mathdoc setup
- Mathlib contributor guidelines

**Location:** `/agent-skills/pre-init/templates/lean4/` (skill default) or `~/.config/pre-init/lean4/` (custom)

### Python
Data science, tools, and scripts.

**Includes:**
- pytest configuration
- Type checking (mypy)
- Poetry/pip setup
- Pre-commit hooks

**Location:** `/agent-skills/pre-init/templates/python/` (skill default) or `~/.config/pre-init/python/` (custom)

### Custom Types

Add your own by creating `~/.config/pre-init/{your-type}/` with the same file structure:

```
~/.config/pre-init/
├── lean4/              (custom Lean4 - overrides skill default)
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   └── .claude/settings.json
├── python/             (custom Python - overrides skill default)
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   └── .claude/settings.json
└── django/             (your custom type)
    ├── CLAUDE.md
    └── ...
```

## Auto-Detection

When you run `/pre-init` without a type, it checks for:

| File Pattern | Detected Type |
|---|---|
| `lake.toml`, `*.lean` | `lean4` |
| `pyproject.toml`, `requirements.txt`, `*.py` | `python` |

## Save Your Template

Want to save current project as a template for future projects?

```bash
/pre-init save-template my-type
```

This copies all config files to `~/.config/pre-init/my-type/` for reuse.

**Example:**
```bash
# Current project is a Django app - save it as template
/pre-init save-template django

# Later: initialize new Django projects
/pre-init django
```

## Template Structure

### Skill Default Templates
Located in `/agent-skills/pre-init/templates/`:

```
/agent-skills/pre-init/templates/
├── lean4/              # Lean 4 theorem proving
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   └── .claude/settings.json
└── python/             # Python data science/tools
    ├── CLAUDE.md
    ├── AGENTS.md
    └── .claude/settings.json
```

### User Custom Templates
Located in `~/.config/pre-init/`:

```
~/.config/pre-init/
├── lean4/              # Custom Lean (overrides default)
├── python/             # Custom Python (overrides default)
└── django/             # Your custom types
    └── ... (same structure)
```

**Priority System:**
- `~/.config/pre-init/{type}/` (custom) - checked **first**
- `/agent-skills/pre-init/templates/{type}/` (default) - used if custom doesn't exist

This means you can customize any template without affecting skill updates.

## Initialization Script

The skill includes `init.sh` that:

1. **Detects** project type (if not specified)
2. **Finds** template with priority system (user > skill default)
3. **Copies** files to `./{file}`
4. **Reports** what was initialized

Usage:
```bash
# Explicit type
bash init.sh lean4

# Auto-detect
bash init.sh

# Save current as template
bash init.sh save-template my-type

# List all available templates
bash init.sh list
```

## Overwrite Behavior

- **Existing files**: Skipped (use `--force` to overwrite)
- **New files**: Created
- **Directories**: Created if missing

```bash
# Force overwrite all files
/pre-init lean4 --force
```

## Debugging

Check what template would be used:

```bash
# List available templates
ls -la ~/.config/pre-init/

# View template files
cat ~/.config/pre-init/lean4/CLAUDE.md
```

If initialization fails:

1. Verify template exists: `ls ~/.config/pre-init/{type}/`
2. Check permissions: `ls -la ~/.config/pre-init/`
3. Verify file structure is correct

## Example: Initialize a Lean4 Project

```bash
# 1. Create project
mkdir my-mathlib-contrib
cd my-mathlib-contrib
git init

# 2. Initialize with pre-init
/pre-init lean4

# 3. Customize for your project
code CLAUDE.md       # Edit coding standards
code AGENTS.md       # Edit agent guidelines
code .claude/settings.json  # Enable Lean MCP

# 4. Start working
git add .
git commit -m "feat: initialize Lean4 project"
```

## Example: Create Your Own Template

**Method 1: Manual Creation**

```bash
# Set up your custom Django template
mkdir -p ~/.config/pre-init/django/.claude

# Copy your current project config
cp CLAUDE.md ~/.config/pre-init/django/
cp AGENTS.md ~/.config/pre-init/django/
cp .claude/settings.json ~/.config/pre-init/django/.claude/

# Now use it for future Django projects
cd ../new-django-project
/pre-init django
```

**Method 2: Save from Existing Project**

```bash
# Finish setting up your Django project perfectly
# Then save it as a reusable template:
bash init.sh save-template django

# Later: initialize new Django projects
cd ../another-django-app
/pre-init django
```

**Method 3: Override Skill Templates**

```bash
# You can customize the default lean4 template
# Just create your version in ~/.config/pre-init/lean4/

mkdir -p ~/.config/pre-init/lean4/.claude
cp my-lean-standards/CLAUDE.md ~/.config/pre-init/lean4/
cp my-lean-standards/AGENTS.md ~/.config/pre-init/lean4/
cp my-lean-standards/.claude/settings.json ~/.config/pre-init/lean4/.claude/

# All new Lean4 projects will use your custom version
cd ../my-math-project
/pre-init    # Will use your custom lean4 template
```

## Tips

- **Version control**: Keep `~/.config/pre-init/` in git (separate dotfiles repo)
- **Team templates**: Share custom templates with team via git
- **Regular updates**: Update templates when you refine your standards
- **Dry run**: Review files before committing after initialization

## Checklist After Initialization

- [ ] Review CLAUDE.md for project-specific needs
- [ ] Review AGENTS.md for agent guidelines
- [ ] Configure .claude/settings.json (MCP servers, hooks)
- [ ] Commit changes: `git add . && git commit -m "feat: initialize project"`
- [ ] Start work with your agent setup ready
