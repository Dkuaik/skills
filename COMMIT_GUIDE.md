# Quick Reference: Conventional Commits

> Copy-paste this into your workflow or read `skills/conventional-commits/SKILL.md` for full documentation.

## Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Types

| Type | When | Example |
|------|------|---------|
| `feat` | New feature | `feat(auth): add 2FA support` |
| `fix` | Bug fix | `fix(api): handle null response` |
| `docs` | Documentation | `docs(readme): add setup guide` |
| `style` | Formatting (no logic) | `style(ui): format button styles` |
| `refactor` | Reorganize (no behavior change) | `refactor(db): extract query builder` |
| `perf` | Performance improvement | `perf(api): cache user queries` |
| `test` | Add/update tests | `test(auth): add login edge cases` |
| `chore` | Dependencies, config | `chore(deps): upgrade React` |
| `ci` | CI/CD changes | `ci(github): add type check` |
| `build` | Build process | `build(webpack): optimize bundle` |

## Scope Examples

`auth` `api` `ui` `db` `config` `deps` `docs` `test` `ci` `build`

## Rules

- ✅ Imperative mood: "add feature" (not "added feature")
- ✅ Lowercase subject
- ✅ NO period at end of subject
- ✅ Subject under 50 chars
- ✅ Body explains WHY
- ✅ Body max 72 chars per line
- ✅ Reference issues: `Closes #123`

## Examples

### ✅ Good
```
feat(auth): add JWT token refresh mechanism

Implement automatic token refresh when token expires.
Prevents session timeouts in long operations.

Closes #1234
```

### ❌ Bad
```
Added JWT tokens thing  # Missing type/scope, not imperative
```

## Templates

See `skills/conventional-commits/assets/TEMPLATES.md` for:
- Simple Feature
- Bug Fix
- Breaking Change
- Large Feature
- Performance
- Refactoring

## Checklist

Before commit, verify:
- [ ] Type is valid
- [ ] Scope is noun
- [ ] Subject is imperative
- [ ] Subject under 50 chars
- [ ] Body explains WHY
- [ ] No period at end
- [ ] Issue referenced

Full checklist: `skills/conventional-commits/assets/CHECKLIST.md`

## Commands

```bash
# Create commit with editor (recommended)
git commit

# View recent commits
git log --oneline -5

# Check your last commit
git log -1 --pretty=%B
```

## Breaking Changes

```
feat(api): remove deprecated endpoints

Details about what changed.

BREAKING CHANGE: old_function removed. Use new_function instead.
```

---

**Full documentation**: Read `skills/conventional-commits/SKILL.md`
