# pre-init Skill - Implementation

This is the internal documentation for the `pre-init` skill.

## File Structure

```
pre-init/
├── SKILL.md                      # User-facing skill documentation
├── init.sh                        # Main initialization script
├── templates/                     # Default templates (for all users)
│   ├── lean4/
│   │   ├── CLAUDE.md
│   │   ├── AGENTS.md
│   │   └── .claude/settings.json
│   └── python/
│       ├── CLAUDE.md
│       ├── AGENTS.md
│       └── .claude/settings.json
└── README.md                      # This file
```

## How It Works

### Template Priority System

```
User runs: /pre-init lean4
    ↓
Script checks: ~/.config/pre-init/lean4/
    ↓
    ├─ Found? → Use custom template
    │
    └─ Not found? → Check /agent-skills/pre-init/templates/lean4/
        ↓
        ├─ Found? → Use default template
        │
        └─ Not found? → Error
```

### Key Features

1. **Two-tier templates**
   - User custom: `~/.config/pre-init/{type}/` (priority)
   - Skill defaults: `/agent-skills/pre-init/templates/{type}/`

2. **Auto-detection**
   - Lean4: Detects `lake.toml` or `*.lean`
   - Python: Detects `pyproject.toml`, `requirements.txt`, `setup.py`, or `*.py`

3. **Template saving**
   - `bash init.sh save-template my-type` creates user template
   - Saved to `~/.config/pre-init/my-type/`

4. **Selective copying**
   - Skips existing files by default
   - `--force` flag to override

## Usage Examples

### Basic Usage

```bash
# Auto-detect and initialize
cd my-project
/pre-init

# Explicit type
/pre-init lean4

# List available templates
bash init.sh list

# Force overwrite
/pre-init python --force
```

### Template Management

```bash
# Save current project as template
bash init.sh save-template django

# View templates
ls ~/.config/pre-init/
ls templates/
```

## Testing

### Test Auto-detection

```bash
# Test Lean4 detection
mkdir /tmp/test-lean && cd /tmp/test-lean
touch test.lean
bash init.sh
# Should detect as 'lean4'

# Test Python detection
mkdir /tmp/test-python && cd /tmp/test-python
touch test.py
bash init.sh
# Should detect as 'python'
```

### Test Template Priority

```bash
# 1. Create custom Lean4 template
mkdir -p ~/.config/pre-init/lean4
echo "CUSTOM" > ~/.config/pre-init/lean4/CLAUDE.md

# 2. Initialize project
mkdir /tmp/test-priority && cd /tmp/test-priority
touch test.lean
bash init.sh

# 3. Verify CLAUDE.md contains "CUSTOM"
cat CLAUDE.md
# Should show your custom version
```

## Default Templates

### Lean4 (`templates/lean4/`)

- **CLAUDE.md**: Lean 4 coding standards
- **AGENTS.md**: Lean 4 agent guidelines
- **.claude/settings.json**: MCP config for Lean 4

### Python (`templates/python/`)

- **CLAUDE.md**: Python coding standards
- **AGENTS.md**: Python agent guidelines (TDD, testing)
- **.claude/settings.json**: MCP config for Python (mypy, black, pytest)

## Implementation Notes

### init.sh Script

- **SKILL_DIR**: Points to the directory containing the script
- **SKILL_TEMPLATES_DIR**: `${SKILL_DIR}/templates`
- **USER_TEMPLATES_DIR**: `~/.config/pre-init`

### find_template() Function

```bash
find_template() {
    local type=$1
    # Check user templates first (priority)
    if [ -d "${USER_TEMPLATES_DIR}/${type}" ]; then
        echo "${USER_TEMPLATES_DIR}/${type}"
        return 0
    fi
    # Check skill defaults
    if [ -d "${SKILL_TEMPLATES_DIR}/${type}" ]; then
        echo "${SKILL_TEMPLATES_DIR}/${type}"
        return 0
    fi
    return 1
}
```

### Color Output

- 🔵 `ℹ`: Information (blue)
- ✅ `✓`: Success (green)
- ⚠️ `⚠`: Warning (yellow)
- ❌ `✗`: Error (red)

## Adding New Default Template

1. Create directory: `templates/{new-type}/.claude`
2. Add files: `CLAUDE.md`, `AGENTS.md`, `.claude/settings.json`
3. Test: `bash init.sh {new-type}`
4. Update `SKILL.md` documentation

## Maintenance

### Update Default Templates

Edit files in `templates/{type}/`:

```bash
code templates/lean4/CLAUDE.md
code templates/python/AGENTS.md
```

Changes apply to all new projects using defaults.

### Monitor User Templates

Users can customize in `~/.config/pre-init/{type}/`:

```bash
ls ~/.config/pre-init/
```

Your defaults are never overwritten.

## Troubleshooting

### init.sh Can't Find Templates

Check that skill paths are correct:

```bash
# Verify script location
echo $0  # Should show path to init.sh

# Verify template paths
ls /agent-skills/pre-init/templates/
ls ~/.config/pre-init/
```

### Auto-detection Not Working

Check detection logic in `detect_project_type()`:

```bash
# Manual test
cd /tmp/test-project
bash init.sh
# Should auto-detect or show error
```

## Related

- **SKILL.md**: User-facing documentation
- **~/.config/pre-init/README.md**: User customization guide
- **init.sh**: Main script (detailed comments included)
