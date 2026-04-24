# Implementation — 4-Phase Task Breakdown

**Key change**: brain handles extraction, clustering, visualization, and MCP serving. The brain focuses on governance, routing, decision tracking, and SDLC skills. This eliminates the need to build AST scanning, community detection, confidence scoring, and visualization from scratch.

## Phase 1: Infrastructure + brain Integration

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 1.1 | Create `.ctx/` scaffold script + skill detection | Generator | `brain init` produces correct directory structure with 5 page templates + `.ctx/graph/` + detects project stack and installs matching skills into `.ctx/skills/` with manifest.json. Additive: never modifies existing `.agentctx/`, `CLAUDE.md`, `.cursorrules`. Adds single pointer line to CLAUDE.md if it exists, creates new one if not. All brain files inside `.ctx/` namespace |
| 1.2 | brain initial run | Tool Wrapper | `brain . --wiki` produces `graph.json`, `graph.html`, `GRAPH_REPORT.md`, `wiki/` for test project |
| 1.3 | Graph-to-pages translator | Generator | Reads `graph.json` nodes → generates `.ctx/modules/` and `.ctx/entities/` pages with confidence-scored wikilinks |
| 1.4 | Implement `brain status` | Generator | Shows: module count, fresh/stale/unenriched, last sync date, graph stats (nodes/edges/communities), verification status |
| 1.5 | Wikilink parser | Generator | Resolves `[[type:name]]` → `.ctx/type/name.md`, returns false if missing |
| 1.6 | Page templates (5 types) | Generator | concept, entity, module, source, pattern — all with YAML frontmatter, wikilinks, edge confidence fields |
| 1.7 | `protocol.md` (< 500t) | Generator | Defines core principles, MCP security rules, model profiles, human partner convention, brain query instructions |
| 1.8 | Brain Generator agent definition | Generator | Reads brain outputs, generates .ctx/ pages, MAX_ITERATIONS=3, kill criteria |
| 1.9 | Brain Verifier agent definition | Reviewer | Separate from Generator, cross-references .ctx/ pages against graph.json, reads rubric from `.ctx/references/lint-checklist.md` |
| 1.10 | Skill registry + detection engine | Generator | Bundled skill catalog in `brain/skills-registry/`. Detection heuristics scan project for `package.json`, `go.mod`, `Cargo.toml`, `tsconfig.json`, `Dockerfile`, etc. Produces `.ctx/skills/manifest.json` with tier (core/detected/available) and detection reason per skill |
| 1.11 | `brain add-skill <name>` command | Generator | Manually install an available skill from the registry into `.ctx/skills/`. Updates manifest.json |

**Phase 1 Gate**: `brain init` + `brain .` + graph-to-pages translator work end-to-end on a test project. `.ctx/` pages have wikilinks with confidence scores from brain. Agent definitions load correctly. `.ctx/skills/manifest.json` lists core + detected skills with reasons.

---

## Phase 2: Lifecycle & Hook-Driven Sync

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 2.1 | 5-hook lifecycle setup | Tool Wrapper | SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd all wired in settings.local.json |
| 2.2 | `/brain-sync` slash command | Inversion + Pipeline | Runs `brain . --update` then 4-phase brain pipeline, reports created/updated/flagged |
| 2.3 | `/brain-lint` slash command | Reviewer | Produces structured report cross-referencing .ctx/ pages against graph.json, rubric from references/ |
| 2.4 | Entity page creation from graph | Generator | Reads brain nodes (classes, services, functions) → creates .ctx/entities/ with edges, community membership |
| 2.5 | Cross-linking engine | Generator | Translates brain edges into bidirectional wikilinks (both frontmatter + body), preserves confidence scores |
| 2.6 | 4-tier error recovery | Pipeline | Tier 1: fix-and-retry (3x). Tier 2: forced reflection ("What failed? Am I repeating?") → 1 more retry. Tier 3: kill + reassign to fresh agent with clean context. Tier 4: human escalation with structured report. Idle detection: no progress in 5 retries → skip to Tier 3. Budget pause at 85% token spend. Partial sync recovery: completed phases preserved |
| 2.7 | Fingerprinting in index.md | Generator | Each catalog entry: `[[name]] — 2.3K tokens — summary — cluster:X — degree:N` from graph.json attributes |
| 2.8 | Community map generation | Generator | Reads brain cluster output → generates `community_map.md` with cohesion scores, god nodes, surprising connections |
| 2.9 | brain MCP server setup | Tool Wrapper | `brain serve .ctx/graph/graph.json` configured for agent queries (BFS/DFS with token budgets) |
| 2.10 | Breadcrumb injection | Tool Wrapper | PostToolUse hook queries brain MCP for file context → injects local hints (module, entities, concept links) |
| 2.11 | Skill routing engine | Pipeline | PostToolUse matches edited/read files against `.ctx/skills/*/SKILL.md` `paths` globs → injects skill conventions. UserPromptSubmit matches prompts against installed skills' `trigger_phrases` → sets active skill. SessionStart pre-loads skill references for detected stack. Three signals (file context > intent match > stack context), zero explicit invocation needed. Slash commands exist only as escape hatches |

| 2.12 | System observability metrics | Generator | Each `log.md` sync entry includes: sync duration (ms), pass/fail, token cost, pages over budget count. Each session entry includes: skill routing hit rate (implicit activations vs. user corrections). `status.md` tracks overflow count. Metrics feed self-learning loop — trending sync duration triggers investigation |

**Phase 2 Gate**: Full sync pipeline runs end-to-end — brain extracts → brain generates pages → verifier cross-references graph.json → lint report with zero errors. MCP server responds to queries. Breadcrumbs inject on file edit.

---

## Phase 3: Intelligence Layer + Governance

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 3.1 | `brain ingest` command | Inversion | Uses `brain add <url>` for URLs (arXiv, tweets, YouTube) + creates .ctx/sources/ page with 5 self-clarification questions |
| 3.2 | Pattern auto-distillation | Generator | Reads brain hyperedges + cross-community patterns → distills into patterns.md |
| 3.3 | Concept proposal system | Inversion + Generator | Reads brain's surprising connections + god nodes → proposes concepts as PROPOSED, NEVER auto-creates CONFIRMED |
| 3.4 | Token budget enforcement + overflow handling | Reviewer + Pipeline | Lint fails if any page > 30K tokens, protocol > 500 tokens. On overflow: (1) split by responsibility cluster into sub-pages with summary links, (2) summarize-and-link verbose sections, (3) archive older content. Lint report suggests split points for oversized pages |
| 3.5 | Archival system | Pipeline | Move superseded pages to `archive/YYYY-MM/`, mark in index as `[Superseded]` |
| 3.6 | Log consolidation engine | Generator | Every 10 syncs, promote recurring patterns to top section, archive old entries |
| 3.7 | Contradiction detection | Reviewer | Cross-references brain AMBIGUOUS edges + LLM comparison of claims across .ctx/ pages |
| 3.8 | Guardrails setup | Tool Wrapper | Block hooks for concept deletion, warn hooks for concept modification, MCP security wired |
| 3.9 | brain watch mode integration | Tool Wrapper | `brain . --watch` auto-rebuilds graph on code changes, brain hook detects graph.json changes → lightweight sync |
| 3.10 | brain deep mode for synthesis | Tool Wrapper | `/brain-synthesize` runs `brain . --mode deep` first for aggressive INFERRED edges, then proposes concepts |
| 3.11 | Skill re-detection on sync | Tool Wrapper | `brain detect-skills --quiet` runs after Phase 1 of sync pipeline + on every `UserPromptSubmit` hook (~5ms, 0 tokens). Compares project fs against manifest, suggests new skills if delta found. "Ask First" — never auto-installs |

**Phase 3 Gate**: `brain-synthesize` reads brain deep analysis → proposes concept → human reviews and approves. Log consolidates after 10 syncs. Guardrails block concept deletion. brain watch mode triggers brain sync on code changes. Skill re-detection suggests new skills when project structure changes.

---

## Phase 4: Integration with agentctx

| # | Task | Skill Pattern | Acceptance Criteria |
|---|---|---|---|
| 4.1 | Merge brain into agentctx CLI | Tool Wrapper | `agentctx brain sync` wraps brain + brain pipeline — single command |
| 4.2 | brain as agentctx dependency | Tool Wrapper | `pip install brain` as part of agentctx setup — zero code duplication for extraction |
| 4.3 | Brain in multi-tool outputs | Generator | CLAUDE.md, .cursorrules, etc. include brain routing + brain MCP instructions |
| 4.4 | Dashboard brain tab | Generator | Shows graph stats (nodes/edges/communities), fresh/stale counts, graph.html embed or link, verifier report |
| 4.5 | End-to-end test on experiment-on-trpc | Pipeline | 169 modules → brain extracts → brain populates .ctx/ → cross-links → MCP queries work → lint clean |
| 4.6 | Documentation | Generator | README.md covers brain + brain architecture, llms.txt for agent discoverability |
| 4.7 | Tests | Reviewer | Tests for graph-to-pages translation, sync pipeline, lint, wikilink resolution, MCP query, verification |
| 4.8 | brain Obsidian export | Generator | `brain . --obsidian` generates browsable vault alongside .ctx/ for team knowledge sharing |

**Phase 4 Gate**: Full E2E test passes on experiment-on-trpc — brain extracts 169 modules into graph → brain generates .ctx/ pages → cross-linked → MCP queries return relevant context → lint returns 0 errors. graph.html is browsable.

---

## Success Criteria (Measurable)

A developer creates auth (login page + backend + DB):

1. **Sync speed**: `/brain-sync` (brain --update + brain pipeline) completes in < 2 min for a 169-module project
2. **Module coverage**: 100% of non-test source directories have module docs after sync (from brain nodes)
3. **Cross-link density**: Each new entity has >=2 inbound wikilinks with confidence scores (from brain edges)
4. **Zero broken links**: `/brain-lint` returns 0 errors after sync (cross-referenced against graph.json)
5. **Human readability**: `graph.html` shows auth cluster with clickable nodes, searchable, filterable by community
6. **AI readability**: brain MCP query "auth flow" returns relevant context in < 2000 tokens via BFS traversal
7. **Comprehension debt reduction**: Query "how does auth work here?" → synthesized answer citing .ctx/ pages in < 3 seconds
8. **Human-in-the-loop**: 0 concept pages auto-created without PROPOSED status; brain surprising connections inform proposals
9. **Token budgets**: No page > 30K tokens, protocol < 500 tokens. brain achieves 71.5x token reduction on 50+ file corpora
10. **Token efficiency**: Cached brain runs on unchanged code cost 0 LLM tokens (AST-only via tree-sitter)
11. **Generator-Verifier split**: Verifier cross-references .ctx/ pages against graph.json, produces structured pass/fail report
12. **Memory consolidation**: After 10 syncs, `log.md` top section has promoted patterns from brain hyperedges, old entries archived
13. **Lifecycle hooks active**: SessionStart loads minimal context + brain MCP, SessionEnd persists observations, PostToolUse injects breadcrumbs from graph
14. **Dual output**: Both graph.html (human) and MCP server (AI) provide traversable access to the same underlying graph
15. **Error recovery**: Sync pipeline recovers from failures via 4-tier escalation (retry → reflection → reassign → human). Partial sync results preserved across tiers
16. **System observability**: `log.md` entries include sync duration, token cost, pass/fail rate. Skill routing hit rate tracked per session
17. **Migration safety**: `brain init` on a project with existing `.agentctx/` + `CLAUDE.md` preserves both, creates `.ctx/` alongside without conflicts

See also: [[index]] for the plan index, [[07-skill-verifier-rubrics]] for the concrete lint checklist.
