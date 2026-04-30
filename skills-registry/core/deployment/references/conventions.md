# Deployment Phase Conventions

- Automate all deployment steps; no manual intervention in production
- Use immutable artifacts built once and promoted through environments
- Gate production deploys on passing tests in staging
- Maintain rollback capability for every deployment
- Log deployment metadata (version, timestamp, actor) for auditability
