# Skills Repository

Agent skills for consistent project scaffolding and patterns.

## Commands

```bash
# Run all tests
./setup_test.sh && ./skill-sync/assets/sync_test.sh

# Run single test file
./setup_test.sh                    # setup.sh tests
./skill-sync/assets/sync_test.sh   # sync.sh tests

# Shellcheck (static analysis)
shellcheck setup.sh skill-sync/assets/sync.sh

# Sync skill metadata to AGENTS.md
./skill-sync/assets/sync.sh --dry-run  # Preview first
./skill-sync/assets/sync.sh             # Apply changes

# Setup AI assistants
./setup.sh --all                   # All assistants
./setup.sh --claude --codex        # Specific ones
```

---

## Available Skills

| Skill | Purpose | Trigger |
|-------|---------|---------|
| `fastapi-clean` | FastAPI clean architecture scaffolding | Creating new FastAPI projects |
| `skill-creator` | Creates new AI agent skills | Documenting reusable patterns |
| `skill-sync` | Syncs skill metadata to AGENTS.md | After modifying skills |

## Skill Structure

```
skills/{skill-name}/
├── SKILL.md              # Required - main instructions with YAML frontmatter
└── assets/               # Optional - templates, scripts, examples
```

---

## Code Style Guidelines

### Shell Scripts (Bash)

```bash
#!/usr/bin/env bash
# Brief description
# Usage: ./script.sh [options]
#
# shellcheck disable=SC2317  # Reason for disable

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
```

**Conventions:**
- Functions: `snake_case` (e.g., `setup_test_env`, `run_all_tests`)
- Local variables: `local var="$1"`
- Test functions: `test_<category>_<description>()`
- Assertions: `assert_equals`, `assert_contains`, `assert_file_exists`
- Setup/teardown: `setup_test_env()`, `teardown_test_env()`

### Python (Templates)

**Import order:** stdlib → third-party → local

**Naming:**
- Files: `snake_case.py`
- Classes: `PascalCase` (e.g., `HealthService`)
- Functions/variables: `snake_case` (e.g., `get_health`)
- Constants: `UPPER_SNAKE_CASE`

**Type hints:**
```python
def get_health() -> HealthStatus: ...
def get_by_id(self, user_id: int) -> User | None: ...
```

**Error handling:**
```python
from fastapi import HTTPException

@router.get("/{item_id}")
def get_item(item_id: int):
    item = service.get_by_id(item_id)
    if not item:
        raise HTTPException(status_code=404, detail="Item not found")
    return item
```

### Markdown (SKILL.md)

```yaml
---
name: skill-name
description: >
  Brief description.
  Trigger: When this happens.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
---
```

**Sections:** When to Use → Critical Patterns → Code Examples → Commands → Resources

---

## Architecture Patterns

### FastAPI Clean Architecture

```
app/
├── main.py           # Entry point
├── core/             # Config, dependencies
├── routers/          # HTTP endpoints (thin)
├── services/         # Business logic
└── schemas/          # Pydantic models
```

**Key Rule:** Routers delegate to services. Business logic lives in `services/`, not routers.

### Docker Compose Strategy

| File | Purpose | Load |
|------|---------|------|
| `docker-compose.yml` | Base config | Always |
| `docker-compose.override.yml` | Dev settings | Auto-loaded |
| `docker-compose.prod.yml` | Prod settings | Explicit `-f` flag |

---

## Testing Conventions

### Shell Tests

```bash
test_sync_creates_table() {
    run_sync > /dev/null
    assert_file_contains "$TEST_DIR/ui/AGENTS.md" "### Auto-invoke Skills" \
        "Should create Auto-invoke section"
}
```

### Python Tests

```python
@pytest.fixture
def client():
    from app.main import app
    return TestClient(app)

def test_health_returns_200(client):
    response = client.get("/health")
    assert response.status_code == 200
```

---

## Creating New Skills

1. Create `skills/{name}/SKILL.md` with frontmatter
2. Add `assets/` directory with templates
3. Run `./skill-sync/assets/sync.sh` to register
4. Update this AGENTS.md table

## AI Assistant Setup

```bash
./setup.sh --all      # Configure all assistants
```

Supported: Claude Code, Gemini CLI, Codex (OpenAI), GitHub Copilot
