---
name: sdlc-design-verifier
description: Verify architecture docs map to requirements and document tradeoffs.
metadata:
  phase: design
  pattern: Reviewer
---

# Design Verifier

## Rubric

| Check | Severity |
|-------|----------|
| All PRD requirements mapped to design decisions | ERROR |
| Tradeoffs documented for each architectural choice | WARNING |
| No premature optimization (performance not spec'd) | WARNING |
| ADRs created for decisions with >=2 viable options | INFO |

## Output Format
```
Summary -> Findings (by severity) -> Score -> Top 3 Recommendations
```
