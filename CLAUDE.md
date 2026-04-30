# Read .ctx/protocol.md for project brain context

## Slash Commands

### /brain-sync
Run the full brain sync pipeline (extract -> update -> verify -> commit).
Execute: `bash scripts/sync/run-sync.sh`
If sync is blocked, show the Tier 4 escalation report.

### /brain-lint
Run brain verification (Phase 3 only) as a read-only audit.
Execute: `bash scripts/sync/phase3-verify.sh --read-only`
Does not modify any files.

### /brain-add-skill
Manually install an available skill by name.
Execute: `bash scripts/install-skills.sh add-skill <name>`
Check `skills-registry/registry.json` for available skills.
