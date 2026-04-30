---
name: sdlc-maintenance-verifier
description: Verify bug fixes have regression tests and postmortems where needed.
metadata:
  phase: maintenance
  pattern: Reviewer
---

# Maintenance Verifier

## Rubric

| Check | Severity |
|-------|----------|
| Root cause identified and documented | ERROR |
| Regression test added for bug fix | ERROR |
| Postmortem written for P0/P1 incidents | WARNING |
| Changelog updated | WARNING |
| Related issues checked for similar pattern | INFO |

## Output Format
```
Summary -> Findings (by severity) -> Score -> Top 3 Recommendations
```
