# Hook Configuration Guide

## Progressive Adoption

Enable hooks one at a time, starting with SessionStart:

1. **SessionStart** — Start here. Loads brain context at session start.
2. **UserPromptSubmit** — Skill routing on every prompt.
3. **PostToolUse** — Breadcrumbs and stale marking after file edits.
4. **PreToolUse** — Guardrails (blocks dangerous operations).
5. **Stop** — Checkpoint on pause.
6. **SessionEnd** — Persist observations and decisions.

## Disabling Hooks

### Disable all hooks at once
Add to `settings.local.json`:
```json
"disableAllHooks": true
```

### Disable individual hooks
Remove the hook entry from the `hooks` object in `settings.local.json`.
Keep a backup of the removed entry to re-enable later.

## Hook Reference

| Hook | Script | Purpose |
|------|--------|---------|
| SessionStart | `scripts/hooks/session-start.sh` | Load protocol + decisions + log + skill routing |
| UserPromptSubmit | `scripts/hooks/user-prompt-submit.sh` | Intent match + skill activation |
| PreToolUse | `scripts/hooks/guardrails.sh` | Block dangerous operations |
| PostToolUse | `scripts/hooks/post-tool-use.sh` | Breadcrumbs + stale marking |
| Stop | `scripts/hooks/stop.sh` | Checkpoint + log pause |
| SessionEnd | `scripts/hooks/session-end.sh` | Persist + decisions + consolidate |
