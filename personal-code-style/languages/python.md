# Python Style Guide

**uv only — no conda.**

## Tier 1: Essential

```bash
# Project setup
uv init --name my-project
uv add pytest ruff

# Run
uv run python script.py
uv run pytest
uv run ruff format
```

```python
# ✅ REQUIRED: Type hints on all public functions
def process_data(items: list[str]) -> dict[str, int]:
    """Count occurrences in input list."""
    return {item: items.count(item) for item in set(items)}

# ✅ REQUIRED: Docstrings on modules and classes
"""User authentication module.

Handles login, logout, and session management.
"""

class UserAuth:
    """Authenticate and manage user sessions."""

    def login(self, username: str, password: str) -> bool:
        """Attempt user login. Returns True on success."""
        ...
```

## Tier 2: Naming & Imports

```python
# MODULES: short, lowercase, underscores
import my_module

# CLASSES: UpperCamelCase
class UserProfile: ...

# FUNCTIONS/VARIABLES: snake_case
def calculate_total(): ...
user_count = 0

# CONSTANTS: UPPER_SNAKE_CASE
MAX_RETRIES = 3

# IMPORTS: stdlib → third-party → absolute
import os                    # stdlib
import mypackage             # third-party
from src.my_project import X # absolute
```

## Tier 2: Project Structure

```
my_project/
├── pyproject.toml
├── src/
│   └── my_project/
│       ├── __init__.py
│       └── main.py
└── tests/
    └── test_main.py
```

```toml
# pyproject.toml
[project]
name = "my_project"
version = "0.1.0"
requires-python = ">=3.11"

[tool.ruff]
line-length = 100
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]

[tool.ruff.format]
quote-style = "double"
indent-style = "space"
```

## Tier 3: Testing

```python
# tests/test_main.py
import pytest
from my_project import add

def test_add():
    assert add(2, 3) == 5

@pytest.mark.parametrize("a,b,expected", [
    (2, 3, 5),
    (-1, 1, 0),
])
def test_add_parametrized(a, b, expected):
    assert add(a, b) == expected
```

## Tier 3: Error Handling

```python
# ✅ Specific exceptions
def read_config(path: str) -> dict:
    try:
        with open(path) as f:
            return json.load(f)
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError as e:
        raise ValueError(f"Invalid JSON in {path}") from e

# ✅ Context managers
with open("data.txt") as f:
    content = f.read()

# ❌ NO bare except
try:
    risky()
except:
    pass
```

## Common Mistakes

- ❌ Using `conda` → use `uv`
- ❌ Missing type hints
- ❌ Manual formatting → `ruff format`
- ❌ Bare `except:`
