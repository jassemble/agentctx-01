# Guardrails — Multi-Layer Enforcement

## Layers

The guardrails hierarchy research is explicit: guardrails sit at multiple points, not just one.

| Layer | What | Mechanism |
|---|---|---|
| **Pre-input** | Validate spec/PRD being ingested | Block hooks: reject if contains `<private>` markers, PII |
| **Pre-execution** | Block destructive ops on brain | Block hooks: no deletion of concepts, no overwriting CONFIRMED |
| **Post-output** | Validate brain pages are correct | Generator-Verifier split checks accuracy |
| **Lifecycle** | Prevent context rot within sessions | SessionStart minimal context, SessionEnd compress |

## What Goes Where vs CLAUDE.md

**CLAUDE.md** (model-interpreted, can be overridden):
- Brain routing instructions, tone guidelines, page format conventions

**Warn hooks** (non-blocking alerts):
- Flag modification of CONFIRMED concept pages
- Flag entity page creation for review

**Block hooks** (unconditional, exit code 2):
- Block deletion of any `.ctx/concepts/*.md`
- Block modification of human-authored markers
- Block file writes exceeding 30K tokens

**Lesson**: The $30K API key incident proved CLAUDE.md is a suggestion, not enforcement. Only block hooks enforce constraints unconditionally.

## Three-Tier Boundaries for Brain Operations

| Action | Tier | Mechanism |
|---|---|---|
| Sync module docs (hash changed) | Always | Auto |
| Update entity signatures | Always | Auto |
| Update routing.md keywords | Always | Auto |
| Append to log.md | Always | Auto |
| Create new concept page | Ask First | PROPOSED status, human review |
| Change concept description | Ask First | [Proposed change], human approves |
| Archive a page | Ask First | Move to archive/, date stamp |
| Modify patterns.md | Ask First | Propose, human reviews |
| Delete entity page | Ask First | No inbound links, human confirms |
| Delete concept page | Never | Concepts archival only |
| Overwrite human-enriched content | Never | Append with `[Superseded]` |
| Sync without verification | Never | Block — fix or report stuck |

## Cross-References

- [[06-verification]] — post-output layer uses the Verifier
- [[09-constraints]] — no CLAUDE.md-as-security, no fully-auto concepts
