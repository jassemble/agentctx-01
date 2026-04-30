---
name: sdlc-deployment-verifier
description: Verify deployment readiness, rollback plans, and secret management.
metadata:
  phase: deployment
  pattern: Reviewer
---

# Deployment Verifier

## Rubric

| Check | Severity |
|-------|----------|
| Rollback path exists and is documented | ERROR |
| Secrets not in config (env vars or secret management) | ERROR |
| Monitoring covers new feature | WARNING |
| Pre-deploy checklist completed | WARNING |
| Runbook has pre-check, deploy, verify, rollback steps | INFO |

## Output Format
```
Summary -> Findings (by severity) -> Score -> Top 3 Recommendations
```
