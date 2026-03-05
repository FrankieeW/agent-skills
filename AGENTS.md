# AGENTS.md

Guidelines for working with this repository.

## Project Context

This repository stores custom skills for AI coding agents. Each skill provides specialized instructions for specific workflows.

## Skills

### pr-worktree-workflow

Complete workflow combining git worktree creation with PR workflow.

**Triggers:**
- User wants to start feature work in isolated workspace
- User mentions creating worktree and PR together

**Workflow:**
1. Invoke `using-git-worktrees` skill to create isolated workspace
2. Implement feature in worktree
3. Create PR using gh CLI
4. Invoke `my-pull-requests` skill to verify PR status

## Development

### Adding New Skills

1. Create directory: `<skill-name>/`
2. Write `SKILL.md` with:
   - YAML frontmatter (name, description)
   - Full documentation in English
   - Examples and code snippets

### Skill Guidelines

- Use English for all skill descriptions
- Include clear triggers ("Use when:")
- Provide practical examples
- Keep descriptions concise but complete

### Testing Skills

Before committing:
- Verify skill file syntax (valid YAML frontmatter)
- Check all links work
- Ensure examples are accurate

## Git Workflow

Use `pr-worktree-workflow` skill for any changes:

```bash
# Creates worktree and PR in one flow
gh pr create --fill
```

## Directory Structure

```
.
├── README.md           # Project overview
├── AGENTS.md          # This file
└── pr-worktree-workflow/
    └── SKILL.md       # Worktree + PR workflow skill
```
