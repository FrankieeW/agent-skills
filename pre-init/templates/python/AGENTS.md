# AGENTS.md - Python Project

Agent guidelines for this Python project.

## When to Use Agents

### python-patterns Agent

Use for:
- PEP 8 compliance reviews
- Type hint guidance
- Pythonic idioms
- Code organization questions

### tdd-guide Agent

Use when:
- Writing new features
- Fixing bugs
- Need to verify test coverage

```bash
# Start with test-driven development
/tdd
```

### code-reviewer Agent

Use after:
- Writing new code
- Completing features
- Before committing

## Development Workflow

1. **Plan** - Use `/plan` for complex features
2. **Test First** - Write tests with `/tdd`
3. **Implement** - Code to pass tests
4. **Review** - Use `/code-review` on changes
5. **Commit** - Detailed commit messages

## Common Patterns

### Data Processing

```python
def process_batch(items: list[dict]) -> list[dict]:
    """Process items with error handling."""
    results = []
    for item in items:
        try:
            result = transform(item)
            results.append(result)
        except ValueError as e:
            logger.warning(f"Skipping item: {e}")
    return results
```

### Testing with Fixtures

```python
@pytest.fixture
def sample_data():
    return {"key": "value"}

def test_with_fixture(sample_data):
    result = process(sample_data)
    assert result is not None
```

## Testing Requirements

- Unit tests for all functions
- Integration tests for workflows
- Minimum 80% code coverage
- Use `pytest` for test runner

Check coverage:
```bash
pytest --cov=src tests/
```

## Performance

For performance-critical code:
- Profile with `cProfile`
- Use `timeit` for benchmarks
- Ask Claude for optimization suggestions

## Dependencies & Versions

Keep dependencies:
- Minimal and focused
- Pinned in lock file
- Security updates applied
- Documented with reasons

## Project-Specific Notes

<!-- Add project-specific agent guidance -->
-
