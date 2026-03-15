#!/bin/bash

# pre-init initialization script
# Supports both skill templates and user custom templates
# Priority: ~/.config/pre-init/{type}/ > /agent-skills/pre-init/templates/{type}/
#
# Usage: bash init.sh [type] [--force]
# Example: bash init.sh lean4
#          bash init.sh        (auto-detect)
#          bash init.sh save-template my-type

set -e

# Get the script's directory (where skill lives)
SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_TEMPLATES_DIR="${SKILL_DIR}/templates"
USER_TEMPLATES_DIR="${HOME}/.config/pre-init"

PROJECT_TYPE="${1:-}"
FORCE_OVERWRITE="${2:-}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Helper functions
print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Find template with priority: user > skill defaults
find_template() {
    local type=$1

    # Check user custom templates first (priority)
    if [ -d "${USER_TEMPLATES_DIR}/${type}" ]; then
        echo "${USER_TEMPLATES_DIR}/${type}"
        return 0
    fi

    # Fall back to skill default templates
    if [ -d "${SKILL_TEMPLATES_DIR}/${type}" ]; then
        echo "${SKILL_TEMPLATES_DIR}/${type}"
        return 0
    fi

    return 1
}

# Auto-detect project type
detect_project_type() {
    if [ -f "lake.toml" ] || [ -n "$(find . -maxdepth 1 -name '*.lean' -type f 2>/dev/null)" ]; then
        echo "lean4"
    elif [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -n "$(find . -maxdepth 1 -name '*.py' -type f 2>/dev/null)" ]; then
        echo "python"
    else
        echo ""
    fi
}

# List available templates (both user and skill)
list_templates() {
    print_info "Available templates:"

    # List user custom templates
    if [ -d "$USER_TEMPLATES_DIR" ]; then
        for dir in "${USER_TEMPLATES_DIR}"/*; do
            if [ -d "$dir" ] && [ "$(basename "$dir")" != ".DS_Store" ]; then
                name=$(basename "$dir")
                echo "  • $name (custom)"
            fi
        done
    fi

    # List skill default templates
    for dir in "${SKILL_TEMPLATES_DIR}"/*; do
        if [ -d "$dir" ] && [ "$(basename "$dir")" != ".DS_Store" ]; then
            name=$(basename "$dir")
            # Only show if not already listed as custom
            if [ ! -d "${USER_TEMPLATES_DIR}/${name}" ]; then
                echo "  • $name (default)"
            fi
        fi
    done
}

# Copy files from template to project
copy_template_files() {
    local type=$1
    local force=$2
    local template_dir

    # Find template with priority system
    template_dir=$(find_template "$type")
    if [ -z "$template_dir" ]; then
        print_error "Template '${type}' not found"
        print_info "Available templates:"
        list_templates
        return 1
    fi

    # Show which template is being used
    if [[ "$template_dir" == "$USER_TEMPLATES_DIR"* ]]; then
        print_info "Using custom template: ${template_dir}"
    else
        print_info "Using default template: ${template_dir}"
    fi

    print_info "Initializing project with '${type}' template..."

    # Track what was copied
    local copied_count=0
    local skipped_count=0

    # Copy each file/directory from template (including hidden files)
    shopt -s dotglob
    for item in "${template_dir}"/*; do
        [ -e "$item" ] || continue

        local name=$(basename "$item")
        local target="./${name}"

        if [ "$name" = ".claude" ]; then
            # Special handling for .claude directory
            mkdir -p .claude
            for subitem in "${item}"/*; do
                [ -e "$subitem" ] || continue
                local subname=$(basename "$subitem")
                local subtarget="./.claude/${subname}"

                if [ -f "$subtarget" ] && [ "$force" != "--force" ]; then
                    print_warning "Skipped .claude/${subname} (already exists)"
                    ((skipped_count++))
                else
                    cp "$subitem" "$subtarget"
                    print_success "Copied .claude/${subname}"
                    ((copied_count++))
                fi
            done
        else
            if [ -f "$target" ] && [ "$force" != "--force" ]; then
                print_warning "Skipped ${name} (already exists)"
                ((skipped_count++))
            else
                cp "$item" "$target"
                print_success "Copied ${name}"
                ((copied_count++))
            fi
        fi
    done

    print_success "Initialization complete! Copied ${copied_count} file(s)"
    if [ $skipped_count -gt 0 ]; then
        print_info "Skipped ${skipped_count} existing file(s). Use --force to overwrite."
    fi

    # Next steps
    echo ""
    print_info "Next steps:"
    echo "  1. Review and customize: code CLAUDE.md"
    echo "  2. Edit agents guide: code AGENTS.md"
    echo "  3. Configure MCP: code .claude/settings.json"
    echo "  4. Commit: git add . && git commit -m 'feat: initialize project'"
}

# Save current project as template
save_as_template() {
    local new_type=$1
    local template_dir="${USER_TEMPLATES_DIR}/${new_type}"

    if [ -d "$template_dir" ]; then
        print_warning "Template '${new_type}' already exists at ${template_dir}"
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cancelled"
            return 0
        fi
        rm -rf "$template_dir"
    fi

    mkdir -p "$template_dir/.claude"

    print_info "Saving current project as template '${new_type}'..."

    # Copy files if they exist
    local files=("CLAUDE.md" "AGENTS.md" ".env.example" ".gitignore" "setup.sh")
    for file in "${files[@]}"; do
        if [ -f "$file" ]; then
            cp "$file" "$template_dir/"
            print_success "Saved ${file}"
        fi
    done

    # Copy .claude/settings.json if it exists
    if [ -f ".claude/settings.json" ]; then
        cp ".claude/settings.json" "$template_dir/.claude/"
        print_success "Saved .claude/settings.json"
    fi

    print_success "Template '${new_type}' saved to ${template_dir}"
    print_info "Use it with: bash ${SKILL_DIR}/init.sh ${new_type}"
}

# Main logic
main() {
    # Handle special commands
    if [ "$PROJECT_TYPE" = "save-template" ]; then
        if [ -z "$FORCE_OVERWRITE" ]; then
            print_error "Usage: bash ${SKILL_DIR}/init.sh save-template <type>"
            return 1
        fi
        save_as_template "$FORCE_OVERWRITE"
        return $?
    fi

    if [ "$PROJECT_TYPE" = "list" ]; then
        list_templates
        return 0
    fi

    # Auto-detect if not specified
    if [ -z "$PROJECT_TYPE" ]; then
        detected=$(detect_project_type)
        if [ -z "$detected" ]; then
            print_error "Could not auto-detect project type"
            print_info "Specify type explicitly: bash ${SKILL_DIR}/init.sh <type>"
            list_templates
            return 1
        fi
        PROJECT_TYPE="$detected"
        print_info "Auto-detected project type: ${PROJECT_TYPE}"
    fi

    # Copy template files
    copy_template_files "$PROJECT_TYPE" "$FORCE_OVERWRITE"
}

main
