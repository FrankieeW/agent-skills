# CLAUDE.md - Python Project

Personal rules for Claude Code in this Python project.

## Project Type

Python scripts, tools, data science, or libraries.

## Coding Standards

### Style & Conventions

- Follow **PEP 8**
- Use **type hints** for all functions
- Maximum line length: **100 characters**
- Use **snake_case** for variables and functions
- Use **UPPER_CASE** for constants

### Code Organization

- Small focused modules (< 500 lines each)
- Organize by feature/domain, not by type
- Extract common utilities to `utils/` or `lib/`
- Clear separation: business logic, I/O, tests

### Functions

```python
def process_data(items: list[str], limit: int = 10) -> dict[str, int]:
    """Process items and return counts.

    Args:
        items: List of items to process
        limit: Maximum items to process (default 10)

    Returns:
        Dictionary mapping items to counts
    """
    result = {}
    for item in items[:limit]:
        result[item] = result.get(item, 0) + 1
    return result
```

### Error Handling

```python
try:
    result = risky_operation()
except SpecificError as e:
    logger.error(f"Operation failed: {e}")
    raise ValueError("User-friendly error message") from e
```

## Testing

### Minimum Coverage: 80%

Run tests:
```bash
pytest --cov
```

### Test Structure

```python
# tests/test_module.py
import pytest
from module import function

class TestFunction:
    def test_success_case(self):
        result = function("input")
        assert result == "expected"

    def test_error_case(self):
        with pytest.raises(ValueError):
            function(None)
```

## Git Workflow

### Commits

```
<type>: <description>

<optional body>
```

Types: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`

## Dependencies

- **Package manager**: pip (or poetry)
- **Virtual environment**: `venv` required
- **Lock file**: `requirements.txt` or `poetry.lock`

## Tool Preferences

- **Linting**: `ruff` or `pylint`
- **Type checking**: `mypy`
- **Testing**: `pytest`
- **Formatting**: `black`

## Pre-commit Checks

Enable pre-commit hooks:
```bash
pip install pre-commit
pre-commit install
```

## When to Ask for Help

- Import errors or module issues
- Type hint confusion
- Test coverage gaps
- Performance optimization questions
