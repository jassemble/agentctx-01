# Environment Variable Management

- Use `.env.example` with placeholder values (never real secrets)
- Never commit `.env` — ensure it's in `.gitignore`
- Use secret managers (Vault, AWS SSM, GCP Secret Manager) in production
- Validate required env vars at startup, fail fast if missing
- Prefix app-specific vars: `APP_DATABASE_URL`, `APP_JWT_SECRET`
- Rotate secrets on schedule, not just after incidents
