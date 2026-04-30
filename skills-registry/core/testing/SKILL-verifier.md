---
name: sdlc-testing-verifier
description: Verify test coverage, data quality, and no flaky tests.
metadata:
  phase: testing
  pattern: Reviewer
---

# Testing Verifier

## Rubric

| Check | Severity |
|-------|----------|
| Test plan covers unit, integration, and E2E scopes | ERROR |
| Tests use production-like data (not hand-crafted fixtures) | ERROR |
| Edge cases covered (not just happy path) | WARNING |
| No flaky tests (repeated runs pass) | WARNING |
| UI changes have browser automation tests | WARNING |
| Coverage meets team-defined threshold | INFO |

## Output Format
```
Summary -> Findings (by severity) -> Score -> Top 3 Recommendations
```
