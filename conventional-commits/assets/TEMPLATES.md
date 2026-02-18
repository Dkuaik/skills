# Commit Message Templates

Copy-paste these templates into your editor when creating commits.

## Simple Feature

```
feat(scope): brief description under 50 chars

Longer explanation of what changed and why. Explain the business
or technical reasoning. Keep lines under 72 characters.

Closes #1234
```

## Bug Fix with Details

```
fix(scope): describe what was broken

Explain what the issue was and how this fix solves it.
Include root cause if relevant.

Before: [behavior]
After: [behavior]

Closes #5678
```

## Breaking Change

```
feat(scope): remove or change API behavior

Details about what changed.

BREAKING CHANGE: old_function removed, use new_function instead.

Closes #1111
```

## Large Feature with Multiple Changes

```
feat(scope): add major feature

Summary of the feature in 1-2 sentences.

Changes included:
- Sub-feature 1
- Sub-feature 2
- Sub-feature 3

Why this change:
- Business need 1
- Technical improvement 2

Closes #2222
```

## Performance Improvement

```
perf(scope): optimize something

What was slow and why.

Improvements:
- Metric 1: before → after
- Metric 2: before → after

Closes #3333
```

## Refactoring

```
refactor(scope): extract component or function

Why we're refactoring:
- Improved maintainability
- Reduced duplication
- Better testability

No behavior changes.

Closes #4444
```
