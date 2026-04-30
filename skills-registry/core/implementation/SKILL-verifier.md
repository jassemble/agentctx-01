---
name: sdlc-implementation-verifier
description: Verify implementation has tests, passes checks, and uses atomic commits.
metadata:
  phase: implementation
  pattern: Reviewer
---

# Implementation Verifier

## Rubric

| Check | Severity |
|-------|----------|
| Test files exist for all changed logic paths | ERROR |
| All tests pass (RED-GREEN-REFACTOR completed) | ERROR |
| Typecheck clean (no errors) | ERROR |
| Lint clean (no warnings) | WARNING |
| Screenshots for UI changes | WARNING |
| Security review for auth/data changes | WARNING |
| No performance regressions in critical paths | WARNING |
| One commit per task (atomic commits) | INFO |

## Output Format
```
Summary -> Findings (by severity) -> Score -> Top 3 Recommendations
```
