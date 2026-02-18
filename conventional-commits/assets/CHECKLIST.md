# Commit Message Validation Checklist

Use this before running `git commit`:

## Type & Scope
- [ ] Type is one of: feat, fix, docs, style, refactor, perf, test, chore, ci, build
- [ ] Scope is present and is a noun (auth, api, ui, db, config, etc)
- [ ] Scope is lowercase, no uppercase
- [ ] Scope is under 20 characters
- [ ] Format is exactly: `type(scope): subject`

## Subject Line
- [ ] Subject uses **imperative mood** (add, fix, update, not added/fixed/updated)
- [ ] Subject starts with **lowercase** letter
- [ ] Subject has **NO period** at the end
- [ ] Subject is under **50 characters** total
- [ ] Subject clearly explains WHAT was changed

## Body (if included)
- [ ] Body explains **WHY** the change was made
- [ ] Body is **not a duplicate** of the subject
- [ ] Body lines are wrapped at **72 characters** max
- [ ] Body uses **imperative mood** throughout
- [ ] Body is separated from subject by a **blank line**

## Footers
- [ ] Breaking changes documented with `BREAKING CHANGE:` prefix
- [ ] Issue references use `Closes #123` or `Related-to #456`
- [ ] Footer is separated from body by a **blank line**

## Overall Quality
- [ ] Commit addresses **ONE logical change** (not multiple unrelated changes)
- [ ] Commit message would be **clear to someone reading history in 6 months**
- [ ] Commit is **focused enough to revert safely** if needed
- [ ] No merge conflicts or incomplete work

---

## Quick Validation Commands

```bash
# Show your last commit to review
git log -1 --pretty=format:"%h%n%s%n%b"

# Show last 5 commits' subjects
git log --oneline -5

# Check commit message format (basic)
git log -1 --pretty=%B | head -1
```

---

## Examples to Review Before Committing

### ✅ GOOD
```
feat(auth): add JWT token refresh mechanism

Implement automatic token refresh when token is 5 minutes from expiry.
This prevents unexpected session timeouts during long operations.
Uses exponential backoff for retry logic.

Closes #1234
```

### ❌ BAD - Scope missing, vague, period at end
```
feat: fixed the thing.
```

### ❌ BAD - Not imperative, capitalized
```
fix(api): Fixed typo in variable name
```

---

## Before Each Commit

1. ✅ Run through checklist above
2. ✅ Review `git diff` to confirm what you're committing
3. ✅ Check `git status` to see all files
4. ✅ Use templates if you need guidance
5. ✅ Ask yourself: "Is this one logical change?"

---

## Pro Tip

Use `git commit` without `-m` to open your editor. This forces you to:
- Write longer, more thoughtful messages
- Include body and footer
- Review the diff while writing

```bash
git commit  # Opens editor - recommended for important commits
git commit -m "quick fix"  # Use only for trivial changes
```
