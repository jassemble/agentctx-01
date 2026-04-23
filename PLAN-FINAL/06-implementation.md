# Implementation — 4-Phase Task Breakdown

## Phase 1: Infrastructure (Week 1)

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 1.1 | Create `.ctx/` scaffold script | Generator | `brain init` produces correct directory structure with 5 page templates |
| 1.2 | Implement `brain scan` wrapper | Tool Wrapper | Reuses agentctx scan, outputs `.ctx/modules/` with `source-hash` frontmatter |
| 1.3 | Implement `brain diff` | Tool Wrapper | Returns changed vs. unchanged modules by hash comparison |
| 1.4 | Implement `brain status` | Generator | Shows: module count, fresh/stale/unenriched, last sync date, verification status |
| 1.5 | Wikilink parser | Generator | Resolves `[[type:name]]` → `.ctx/type/name.md`, returns false if missing |
| 1.6 | Page templates (5 types) | Generator | concept, entity, module, source, pattern — all with YAML frontmatter, wikilinks |
| 1.7 | `protocol.md` (< 500t) | Generator | Defines core principles, MCP security rules, model profiles, human partner convention |
| 1.8 | Brain Generator agent definition | Generator | Defines 4-phase pipeline, MAX_ITERATIONS=3, kill criteria, personality |
| 1.9 | Brain Verifier agent definition | Reviewer | Separate from Generator, reads rubric from `.ctx/references/lint-checklist.md` |

**Phase 1 Gate**: `brain init` + `brain scan` + `brain diff` + `brain status` all work on a test project. Agent definitions load correctly.

---

## Phase 2: Lifecycle & Hook-Driven Sync (Week 2)

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 2.1 | 5-hook lifecycle setup | Tool Wrapper | SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd all wired in settings.local.json |
| 2.2 | `/brain-sync` slash command | Inversion + Pipeline | Runs full 4-phase pipeline, reports created/updated/flagged |
| 2.3 | `/brain-lint` slash command | Reviewer | Produces structured report with severity grouping, rubric from references/ |
| 2.4 | Entity page creation | Generator | Creates from scan results with wikilinks, hashes, dependency info |
| 2.5 | Cross-linking engine | Generator | Links module ↔ entity ↔ concept bidirectionally (both frontmatter + body wikilinks) |
| 2.6 | Fix-and-retry on verify failure | Pipeline | Up to 3 retries per gate, then stop and report "sync blocked: [reason]" |
| 2.7 | Token surfacing in index.md | Generator | Each catalog entry: `[[name]] — 2.3K tokens — summary` |

**Phase 2 Gate**: Full sync pipeline runs end-to-end with all 4 phases, hooks fire correctly, lint report generated with zero errors.

---

## Phase 3: Intelligence Layer (Week 3)

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 3.1 | `brain ingest` command | Inversion | Creates source page from PRD/spec, with 5 self-clarification questions |
| 3.2 | Pattern auto-distillation | Generator | Detects cross-module patterns (3+ modules share same structural pattern) |
| 3.3 | Concept proposal system | Inversion + Generator | Proposes concepts as PROPOSED, NEVER auto-creates CONFIRMED pages |
| 3.4 | Token budget enforcement | Reviewer | Lint fails if any page > 30K tokens, protocol > 500 tokens |
| 3.5 | Archival system | Pipeline | Move superseded pages to `archive/YYYY-MM/`, mark in index as `[Superseded]` |
| 3.6 | Log consolidation engine | Generator | Every 10 syncs, promote recurring patterns to top section, archive old entries |
| 3.7 | Contradiction detection | Reviewer | LLM-level: compares claims across pages, flags opposite facts about same entity/concept |
| 3.8 | Guardrails setup | Tool Wrapper | Block hooks for concept deletion, warn hooks for concept modification, MCP security wired |

**Phase 3 Gate**: `brain-synthesize` proposes a concept, human reviews and approves it, log consolidates correctly after 10 syncs, guardrails block concept deletion.

---

## Phase 4: Integration with agentctx (Week 4)

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 4.1 | Merge brain into agentctx CLI | Tool Wrapper | `agentctx brain sync` works as `brain sync` — shared command namespace |
| 4.2 | Share AST scanner | Tool Wrapper | Brain scan reuses agentctx scan — zero code duplication |
| 4.3 | Brain in multi-tool outputs | Generator | CLAUDE.md, .cursorrules, etc. include brain routing instructions |
| 4.4 | Dashboard brain tab | Generator | Shows fresh/stale counts, recent activity, sync controls, verifier report |
| 4.5 | End-to-end test on experiment-on-trpc | Pipeline | 169 modules → brain enriches → cross-links → queries work → lint clean |
| 4.6 | Documentation | Generator | README.md covers brain as additional layer, llms.txt for agent discoverability |
| 4.7 | Unit tests | Reviewer | Tests for scan, sync, lint, wikilink resolution, verification |

**Phase 4 Gate**: Full E2E test passes on experiment-on-trpc — 169 modules scanned, enriched, cross-linked, queried successfully, lint returns 0 errors.

---

## Success Criteria (Measurable)

A developer creates auth (login page + backend + DB):

1. **Sync speed**: `/brain-sync` completes in < 2 min for a 169-module project
2. **Module coverage**: 100% of non-test source directories have module docs after sync
3. **Cross-link density**: Each new entity has >=2 inbound wikilinks (from module + concept)
4. **Zero broken links**: `/brain-lint` returns 0 errors after sync
5. **Comprehension debt reduction**: Query "how does auth work here?" → synthesized answer citing pages in < 3 seconds
6. **Human-in-the-loop**: 0 concept pages auto-created without PROPOSED status; at least 1 concept reviewed and approved by human
7. **Token budgets**: No page > 30K tokens, protocol < 500 tokens
8. **Generator-Verifier split**: Verifier produces structured pass/fail report, Generator cannot edit it
9. **Memory consolidation**: After 10 syncs, `log.md` top section has promoted patterns, old entries archived
10. **Lifecycle hooks active**: SessionStart loads minimal context, SessionEnd persists observations, PostToolUse marks stale modules

See also: [[index]] for the plan index, [[07-skill-verifier-rubrics]] for the concrete lint checklist.
