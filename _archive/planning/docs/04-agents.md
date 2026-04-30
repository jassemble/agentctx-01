# Agents — 4 Agent Roles

## Sync Agent (Pipeline + Generator + Tool Wrapper)

**Triggers**: Git commit (via hook), `/brain-sync` command.

**Sync phases** (4, not 5 — investigation and implementation are separate cognitive operations):

1. **INVESTIGATE** — git diff + AST scan → structured change map
2. **UPDATE** — create/update pages with wikilinks, mark concepts as PROPOSED
3. **VERIFY** — deterministic + heuristic checks (separate agent)
4. **COMMIT** — routing, index, log, status, patterns, consolidated patterns

MAX_ITERATIONS: 3 (kill criteria from quality gates research).

## Generator Agent (NEW v5)

**Why split from Verify**: Self-review is less reliable than separate-agent review. The Generator writes/maintains pages. A separate Verifier reads them back.

Generates:
- Module docs from AST scan results
- Entity pages from function signatures + imports
- Concept proposals from cross-module patterns
- Routing table entries from new keywords

## Verifier Agent (NEW v5)

Reads (not writes):
- All pages the Generator created/updated
- Code files that those pages claim to describe
- patterns.md claims against actual code
- Two pages for contradictory claims

Output: `Summary → Findings (by severity) → Score → Top 3 Recommendations`

**Rubric** (from references/lint-checklist.md, swappable):

| Check | Criterion | Severity | Machine-verifiable? |
|---|---|---|---|
| Broken wikilinks | Every `[[type:name]]` resolves | ERROR | Yes | |
| Stale modules | `source-hash` matches git hash | WARNING | Yes | |
| Orphan entities | ≥1 inbound wikilink | WARNING | Yes | |
| Missing modules | Every source dir has module | ERROR | Yes | |
| Pattern drift | patterns.md claims match code | WARNING | Partial | |
| Token overflow | No page > 30K tokens | WARNING | Yes | |
| Protocol bloat | `protocol.md` < 500 tokens | ERROR | Yes | |
| Contradiction | No opposite claims | WARNING | Partial | |
| Missing verification | Has status entry | WARNING | Yes | |

## Synthesis Agent (Human-initiated Inversion)

**Triggers**: `/brain-synthesize` — human-initiated, never automatic.

Proposes concepts, human approves. Self-clarification: 5 questions before generating (domain, pattern, specificity, success criteria, constraints).

## Cross-References

- [[01-decisions]] — Generator-Verifier split rationale
- [[06-verification]] — layered verification the Verifier applies
- [[05-guardrails]] — boundaries for each agent's actions
- [[08-implementation]] — task definitions for each agent
