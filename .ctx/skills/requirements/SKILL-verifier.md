---
name: sdlc-requirements-verifier
description: Verify PRDs have complete acceptance criteria and no ambiguity.
metadata:
  phase: requirements
  pattern: Reviewer
---

# Requirements Verifier

## Rubric

| Check | Severity |
|-------|----------|
| PRD has goal, scope, non-goals sections | ERROR |
| Each requirement has boolean acceptance criteria | ERROR |
| Stakeholders identified in PRD | WARNING |
| Self-clarification questions answered or marked N/A | WARNING |
| No ambiguous language ("should", "might", "could") | INFO |

## Output Format
```
Summary -> Findings (by severity) -> Score -> Top 3 Recommendations
```
