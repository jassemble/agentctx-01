# Implementation Plan — Phased Delivery

## Phase 1: Infrastructure (Days 1-7)

| # | Task | Acceptance Criteria |
|---|---|---|
| 1.1 | `.ctx/` scaffold script | `brain init` produces correct directory structure + templates |
| 1.2 | `brain scan` wrapper | Reuses agentctx scan, outputs `.ctx/modules/` with source-hash |
| 1.3 | `brain diff` | Returns changed vs. unchanged modules by hash comparison |
| 1.4 | `brain status` | Shows: module count, fresh/stale/unenriched, last sync date |
| 1.5 | Wikilink parser | Resolves `[[type:name]]` → `.ctx/type/name.md`, returns false if missing |
| 1.6 | Page templates (5 types) | YAML frontmatter, wikilinks, kebab-case, ISO dates |
| 1.7 | `CLAUDE.md` for brain-using projects | Routing protocol <500 tokens, references `protocol.md` |
| 1.8 | Brain Generator agent definition | 4-phase pipeline, MAX_ITERATIONS=3, kill criteria |
| 1.9 | Brain Verifier agent definition | Separate from Generator, reads rubric from references/ |

## Phase 2: Hook-Driven Sync Engine (Days 8-14)

| # | Task | Acceptance Criteria |
|---|---|---|
| 2.1 | 5-hook lifecycle setup | SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd all wired |
| 2.2 | `/brain-sync` slash command | Runs full 4-phase pipeline, reports created/updated/flagged |
| 2.3 | `/brain-lint` slash command | Structured report with severity grouping, rubric from references/ |
| 2.4 | Entity page creation | From scan results with wikilinks, hashes |
| 2.5 | Cross-linking engine | module↔entity↔concept bidirectional |
| 2.6 | Log consolidation engine | Promotes patterns every 10 syncs, archives old entries |
| 2.7 | Archive system | Move superseded pages to `archive/YYYY-MM/`, mark in index |
| 2.8 | Fix-and-retry on verification failure | Up to 3 retries per gate, then stop and report |

## Phase 3: Intelligence Layer (Days 15-21)

| # | Task | Acceptance Criteria |
|---|---|---|
| 3.1 | `brain ingest` | Creates source page from PRD/spec, with 5 self-clarification questions |
| 3.2 | Pattern auto-distillation | Detects cross-module patterns (3+ modules share pattern) |
| 3.3 | Concept proposal system | PROPOSED only, human review mandatory |
| 3.4 | Token budget enforcement | Lint fails if page > 30K tokens, protocol > 500 |
| 3.5 | Contradiction detection | LLM: compares claims across pages, flags opposites |
| 3.6 | Guardrails setup | Block hooks for concept deletion, warn hooks for modifications |

## Phase 4: Integration with agentctx (Days 22-28)

| # | Task | Acceptance Criteria |
|---|---|---|
| 4.1 | Merge brain into agentctx CLI | `agentctx brain sync` works as standalone `brain sync` |
| 4.2 | Share AST scanner | No code duplication — brain reuses agentctx scan |
| 4.3 | Brain in multi-tool outputs | CLAUDE.md, .cursorrules include brain routing |
| 4.4 | Dashboard brain tab | Fresh/stale counts, sync controls, verifier report |
| 4.5 | E2E test on experiment-on-trpc | 169 modules → brain enriches → concept links → queries work |
| 4.6 | Documentation | README.md covers brain as an additional layer |
| 4.7 | Unit tests | Scan, sync, lint, wikilink, verification |

## Success Criteria

A developer creates auth (login page + backend + DB):

1. **Sync speed**: `/brain-sync` completes in < 2 min for 169 modules
2. **Module coverage**: 100% of non-test source dirs have module docs after sync
3. **Cross-link density**: Each new entity has ≥2 inbound wikilinks (from module + concept)
4. **Zero broken links**: `/brain-lint` returns 0 errors after sync
5. **Comprehension debt reduction**: Query "how does auth work here?" → synthesized answer citing specific pages in < 3 seconds
6. **Human-in-the-loop**: 0 concept pages auto-created without PROPOSED status; at least 1 concept reviewed and approved by human
7. **Token budgets**: No page exceeds 30K tokens, protocol stays under 500
8. **Generator-Verifier agreement**: Verifier produces structured pass/fail, no human review needed for Layer 1 checks
9. **Memory consolidation**: After 10 syncs, `log.md` top section has promoted patterns, old entries aren't needed for comprehension
10. **Lifecycle hooks active**: SessionStart loads minimal context, SessionEnd persists observations, PostToolUse marks stale modules

## Cross-References

- [[04-agents]] — agent definitions referenced in implementation tasks
- [[06-verification]] — verification checks that Phase 2-3 tasks implement
- [[05-guardrails]] — guardrails that Phase 3 task 3.6 sets up
- [[01-decisions]] — distributed model that phases map onto
- [[09-constraints]] — boundaries the implementation honors
