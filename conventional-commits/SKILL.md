---
name: conventional-commits
description: >
  Creates and validates commits following Conventional Commits standard with proper message structure, scopes, and breaking changes.
  Trigger: When writing git commits, creating PR descriptions, or validating commit message format.
license: Apache-2.0
metadata:
  author: gentleman-programming
  version: "1.0"
  scope: [root]
  auto_invoke: "Creating git commits with proper conventions"
allowed-tools: Bash, Read, Write, Edit, Grep, Question
---

## When to Use

- **Creating commits** with proper type, scope, and description
- **Structuring commit messages** for multi-line bodies and footers
- **Validating** if a commit follows Conventional Commits standard
- **Documenting breaking changes** with BREAKING CHANGE: footer
- **Referencing issues** and linking to tickets in footers
- **Code reviews** to ensure commit quality and consistency

---

## Critical Patterns

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

**MUST FOLLOW these rules:**

1. **Type** (required): One of `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`
2. **Scope** (required): What changed (e.g., `auth`, `api`, `ui`, `config`)
3. **Subject** (required): Imperative mood, lowercase, NO period at end, max 50 chars
4. **Body** (optional but recommended): Explain WHAT and WHY, not HOW. Wrap at 72 chars. Use imperative mood.
5. **Footer** (optional): `Issue #123`, `Closes #456`, `BREAKING CHANGE: description`

### Real Examples

✅ **GOOD**
```
feat(auth): add JWT token refresh mechanism

Add automatic token refresh when token is 5 minutes from expiry.
This prevents unexpected session timeouts in long-running operations.
The refresh is transparent to the client and uses exponential backoff
for retry logic.

Closes #1234
```

❌ **BAD** - Type missing
```
added JWT token refresh
```

❌ **BAD** - No scope
```
feat: fixed the thing
```

❌ **BAD** - Not imperative, period at end, too vague
```
feat(auth): Fixed JWT tokens.
```

❌ **BAD** - No description of WHY
```
fix(api): typo in variable name
```

---

## Type Decision Tree

```
Changed behavior/added feature?         → feat
Fixed a bug?                            → fix
Updated documentation?                  → docs
Changed formatting (no logic)?          → style (prettier, linting)
Reorganized code (no behavior change)?  → refactor
Improved performance?                   → perf
Added/updated tests?                    → test
Updated deps, build config, tooling?    → chore
Changed CI/CD pipeline?                 → ci
Changed build process?                  → build
```

---

## Scope Guidelines

| Scope | Example | When to Use |
|-------|---------|------------|
| `auth` | `feat(auth): add 2FA support` | Authentication, authorization, session |
| `api` | `fix(api): handle 404 responses` | API endpoints, requests, responses |
| `ui` | `feat(ui): add dark mode toggle` | Components, styling, layout |
| `db` | `refactor(db): optimize query` | Database, migrations, ORM |
| `config` | `chore(config): update eslint rules` | Configuration files, setup |
| `deps` | `chore(deps): upgrade React to v19` | Dependencies, packages |
| `docs` | `docs(readme): add setup instructions` | Documentation files |
| `test` | `test(auth): add login edge cases` | Test files, test utilities |
| `ci` | `ci(github): add type check workflow` | GitHub Actions, CI pipelines |
| `build` | `build(webpack): optimize bundle size` | Build tools configuration |

**Rule**: Scope should be a NOUN (thing that changed), max 20 chars.

---

## Breaking Changes Format

When a change breaks backward compatibility, use `BREAKING CHANGE:` footer:

```
feat(api): remove deprecated endpoints

The following endpoints have been removed in favor of v2 API:
- /api/v1/users (use /api/v2/users)
- /api/v1/posts (use /api/v2/posts)

BREAKING CHANGE: v1 API endpoints removed. All clients must upgrade to v2.

Closes #5678
```

---

## Multi-Scope Commits (When Necessary)

If a commit touches MULTIPLE different scopes, pick the PRIMARY one. If unclear, it's probably doing too much - split it:

```
# ❌ AVOID
feat(auth,api,ui): major refactor

# ✅ BETTER - Split into focused commits
feat(auth): update token validation logic
feat(api): add new token endpoint
feat(ui): update login form to use new endpoint
```

---

## Real-World Scenarios

### Scenario 1: New Feature with Dependencies

```
feat(checkout): add Apple Pay support

Implemented Apple Pay as a payment method alongside existing Stripe
integration. Users can now select Apple Pay during checkout and complete
transactions using their Apple device.

Changes:
- New ApplePayProvider class
- Updated PaymentForm component to include Apple Pay button
- Added ApplePayService for token handling
- Database migration for payment_method column

Closes #1234
Related-to #1200
```

### Scenario 2: Bug Fix with Root Cause

```
fix(api): prevent race condition in user registration

Fixed a race condition where simultaneous registration requests with the
same email could create duplicate user records. Added database-level
unique constraint and application-level email verification check with
proper locking.

Root cause: Missing database-level unique index on email column allowed
concurrent inserts to bypass application validation.

Closes #2891
```

### Scenario 3: Performance Improvement

```
perf(db): add indexes to frequently queried columns

Added composite indexes on (user_id, created_at) and (status, updated_at)
to improve query performance for common filtering operations.

Benchmark results:
- User query time: 450ms → 45ms (10x improvement)
- Status filter: 800ms → 80ms (10x improvement)

Closes #3001
```

---

## Anti-Patterns (Don't Do This)

| ❌ Anti-Pattern | ✅ Why It's Wrong | ✓ What to Do |
|---|---|---|
| `feat: stuff` | Too vague, missing scope | `feat(auth): add 2FA support` |
| `fix: bug` | No scope, no detail | `fix(api): handle null response in getUserProfile` |
| `Updated code` | Not imperative, no type | `refactor(ui): extract Button to separate component` |
| `feat(auth,api,ui,db): big refactor` | Too many scopes | Split into 4 focused commits |
| `feat(authenticationSystem): ...` | Scope too long | Use shorter `feat(auth): ...` |
| `FEAT(AUTH): UPPERCASE` | Wrong casing | Use lowercase throughout |
| `feat(auth): add 2FA support.` | Period at end of subject | Remove the period |
| `feat(auth): Add 2FA support` | Capitalized subject | Start with lowercase |
| `feat(auth): added 2FA support` | Not imperative mood | Use present tense imperative |

---

## Commit Message Validation Checklist

Before running `git commit`, verify:

- [ ] Type is one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`
- [ ] Scope is a noun, lowercase, max 20 chars (or valid for project)
- [ ] Subject is imperative mood (add, fix, update, not added, fixed, updated)
- [ ] Subject starts lowercase
- [ ] Subject has NO period at end
- [ ] Subject is under 50 characters
- [ ] Body (if present) explains WHY, not WHAT
- [ ] Body lines are wrapped at 72 characters
- [ ] Breaking changes documented with `BREAKING CHANGE:` prefix
- [ ] Issue references use `Closes #123` or `Related-to #456`
- [ ] Commit is focused on ONE logical change (not multiple unrelated changes)
- [ ] No merge conflicts or incomplete work

---

## Common Commands

```bash
# Create a commit with editor (recommended for multi-line)
git commit

# Quick single-line commit (for simple changes only)
git commit -m "feat(scope): short description"

# Show recent commits to verify format
git log --oneline -10
git log --pretty=format:"%h - %s" -5

# Check commit message format (basic)
git log -1 --pretty=%B | head -1

# Interactive rebase to fix commit messages
git rebase -i HEAD~3
# Then change 'pick' to 'reword' for commits to fix
```

---

## AI Guidelines When Creating Commits

When I (AI) create a commit for you:

1. **Always ask context first** - Understand what changed and why
2. **Use imperative mood** - "add feature" not "added feature"
3. **Keep scope focused** - One logical unit per commit
4. **Explain the WHY** - In the body, explain business/technical reasoning
5. **Reference issues** - Link to tickets when applicable
6. **Validate format** - Verify against this skill before committing
7. **Never assume** - Ask user for scope if unclear
8. **Split when needed** - If touching multiple concerns, create separate commits

Example of my workflow:
```
1. User: "I added JWT token refresh logic"
2. Me: Ask - "What scope? (auth/api?), why this change?, fixes any issues?"
3. Parse response
4. Draft: feat(auth): add JWT token refresh mechanism
5. Validate against checklist
6. Present for approval before git commit
```

---

## Resources

- **Conventional Commits spec**: https://www.conventionalcommits.org/
- **Your projects**: May have custom scopes in their configs
- **GitHub**: Issues linking with `Closes #123` automatically closes tickets
- **Analytics**: Tools like `git-cliff` can generate changelogs from commits

