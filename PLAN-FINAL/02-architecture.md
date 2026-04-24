# Architecture — Three Layers + Code Brain

## Layer 1: Schema Layer (Entry Point)

```
agentctx-sdlc/                          # The Framework
├── protocol.md                         # Routing: personas, skill index, core principles (<500t)
├── CLAUDE.md                           # <500 tokens: "Read protocol.md first"
├── README.md                           # Human overview
├── llms.txt                            # Machine-readable framework catalog for any agent
├── SKILLS-INDEX.md                     # Routing table: trigger phrases + paths globs → skill packages (consulted automatically by the Skill Routing Engine, not manually)
├── profiles.md                         # Phase-appropriate model recommendations
│                                       # (Sonnet fast/Opus reasoning/Haiku speed)
└── pipelines/                          # Composable multi-phase workflows
    ├── spec-to-design.md               # Requirements → Design
    ├── design-to-code.md               # Design → Implementation
    ├── test.md                         # Testing (parallel or after impl)
    ├── deploy-to-production.md         # Deployment
    └── full-sdlc.md                    # All 6 phases end-to-end
```

**protocol.md** must stay under 500 tokens. It defines core principles, MCP security rules, model profiles, references to skills, and the "human partner" naming convention.

**llms.txt** serves the same purpose for non-Claude agents — a single machine-readable file describing the entire framework.

## Layer 2: Wiki Layer (Persistent, Compounding)

```
wiki/                                   # The Karpathy pattern
├── index.md                            # Categorized catalog + token counts per page
├── overview.md                         # Active topics, recent activity, codebase patterns
│   ├── ## Codebase Patterns            # Read first — promoted recurring patterns
│   ├── ## Active State                 # Current wiki health, recent syncs
│   └── ## Recent Activity              # Last N operations summary
├── log.md                              # Append-only: ingests, queries, lint passes
│   ├── ## Recent Patterns              # Promoted recurring patterns (semantic memory)
│   └── ## Activity History             # Raw per-event entries (episodic memory)
├── routing.md                          # Keyword → wiki entry (<400 tokens)
│
├── concepts/                           # Methodology & architecture pages
│   ├── distributed-decision-model.md   # 6-phase decision pipeline
│   ├── generator-verifier-architecture.md  # Split roles for reliability
│   ├── task-explosion-pattern.md       # Explode tasks into 8-15 subtasks
│   ├── self-clarification-pattern.md   # 5 questions before generation
│   ├── proof-over-vibes.md             # Evidence over claims
│   ├── anti-slop-rigor.md              # Boolean pass/fail only
│   ├── constitutional-ai.md            # Three-tier boundary philosophy
│   ├── context-bloat.md                # How we prevent context decay
│   ├── skill-atrophy.md                # When skills drift from codebase
│   ├── human-partner-convention.md     # Terminology conventions
│   ├── mcp-security.md                 # MCP tool auditing rules
│   └── _template.md                    # Wiki page template
├── phases/                             # Per-phase wiki overviews
│   ├── requirements.md                 # Phase 1
│   ├── design.md                       # Phase 2
│   ├── implementation.md               # Phase 3
│   ├── testing.md                      # Phase 4
│   ├── deployment.md                   # Phase 5
│   └── maintenance.md                  # Phase 6
├── entities/                           # Agent personas, patterns, developer profiles
│   ├── agent-profile.md                # Behavioral developer preferences
│   └── _template.md
├── sources/                            # External research references
│   └── _template.md
└── scripts/
    ├── wiki-lint.sh                    # Check broken wikilinks, stale pages
    ├── skill-verify.sh                 # Validate SKILL.md against schema
    ├── skill-dependencies.sh           # Build dependency map from related_skills
    └── consolidate-log.sh              # Promote patterns every 10 entries
```

**Every wiki page** follows this frontmatter and content schema:

```yaml
---
title: "Descriptive Title"
category: concept | methodology | architecture | phase | entity
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: ["tag-one", "tag-two"]
phase: requirements | design | implementation | testing | deployment | maintenance  # optional
related_skills:
  - "sdlc-requirements"
related_templates:
  - "prd.md"
---
```

```markdown
# Title
## Definition                → One-paragraph summary
## Current Understanding     → Detailed explanation
## Phase Mapping             → Which SDLC phases use this
## Contradictions & Debates  → Open questions, trade-offs
## Related Concepts          → [[wikilinks]] to other wiki pages
## Sources                   → External research or internal docs
```

**Wiki Operations** (Karpathy's 3 operations):

1. **Ingest**: New research/sources → LLM reads, extracts, integrates into 10-15 wiki pages, updates index.md, appends log.md
2. **Query**: User asks question → LLM reads relevant wiki pages, synthesizes with inline citations, files good answers back
3. **Lint**: Periodic health check → find contradictions, stale claims, orphan pages, missing cross-references, fix them

**Token budgets**: protocol.md < 500t, routing.md < 400t, SKILL.md < 500 lines, wiki pages < 30K tokens. Lint enforces these.

**Relationship to .ctx/ (Code Brain)**: The Wiki Layer is framework-level methodology knowledge that **ships with the agentctx-sdlc framework** — it contains SDLC concepts, research, and methodology pages. It is NOT built per-project. The `.ctx/` Code Brain (Layer 4 below) is project-specific knowledge built by `brain init`. They serve different purposes:

| Layer | What | Scope | Built when |
|---|---|---|---|
| Wiki Layer (`agentctx-sdlc/wiki/`) | SDLC methodology, research, patterns | Framework-wide, shared across all projects | Ships with the framework |
| Code Brain (`.ctx/`) | Modules, entities, decisions, concepts for THIS project | Project-specific | `brain init` per project |

The implementation plan (see [[06-implementation]]) focuses on building `.ctx/` because that's what gets created per-project. The wiki layer is authored content that ships as part of the framework distribution.

## Layer 3: Skills Layer (Executable Behavior)

```
skills/                                     # 12 skills (6 Generator + 6 Verifier)
├── requirements/                           # Phase 1: Requirements & Discovery
│   ├── SKILL.md                            # Generator + Inversion pattern
│   ├── SKILL-verifier.md                   # Reviewer pattern
│   ├── references/
│   │   ├── elicitation.md
│   │   ├── acceptance-criteria.md
│   │   └── stakeholder-mapping.md
│   └── templates/
│       ├── prd.md                          # PRD with self-clarification block
│       ├── user-story.md                   # As a/I want/so that + AC
│       └── epic.md
│
├── design/                                 # Phase 2: Design & Architecture
│   ├── SKILL.md                            # Generator + Pipeline
│   ├── SKILL-verifier.md                   # Reviewer
│   ├── references/
│   │   ├── architecture-patterns.md
│   │   ├── api-design.md
│   │   └── data-modeling.md
│   └── templates/
│       ├── architecture.md                 # Context, decisions, tradeoffs
│       ├── adr.md                          # Option A vs B, decision, consequences
│       └── api-spec.md
│
├── implementation/                         # Phase 3: Implementation
│   ├── SKILL.md                            # Generator + Pipeline + RED-GREEN-REFACTOR
```

```
---

**SKILL.md body structure** (always under 500 lines):
```yaml
---
name: sdlc-requirements
description: Gather requirements and generate PRDs with boolean acceptance criteria.
license: MIT
metadata:
  author: agentctx
  version: "1.0"
  phase: requirements
  pattern: Generator
paths:
  - "**/*.md"
trigger_phrases:
  - "gather requirements"
  - "write a PRD"
related_skills:
  - "self-clarification"
  - "task-explosion"
  - "sdlc-requirements-verifier"
---
```

```
| SKILL.md | Generator: "implement feature", "build component" |
| SKILL-verifier.md | Reviewer: "review code", "code review" |
| references/ | coding-conventions.md, error-handling.md, security.md, patterns.md (→ patterns.dev-skills) |
| templates/ | component.md, api-handler.md, test-scaffold.md |

├── testing/                                # Phase 4: Testing & Verification
│   ├── SKILL.md | Generator + Inversion: "write tests for", "test coverage" |
│   ├── SKILL-verifier.md | Reviewer: "review tests", "audit test quality" |
│   ├── references/ | test-taxonomy.md, mocking-strategies.md, test-data-patterns.md, browser-automation.md, pre-delivery-checklist.md |
│   └── templates/ | test-plan.md (scope, strategy, exit criteria), test-case.md (given/when/then) |
│
├── deployment/                             # Phase 5: Deployment
│   ├── SKILL.md | Pipeline only (no creativity — safety first): "deploy to production", "CI/CD" |
│   ├── SKILL-verifier.md | Reviewer: "check deployment readiness" |
│   ├── references/ | ci-cd-patterns.md, rollout-strategies.md, rollback-procedures.md |
│   └── templates/ | deployment-plan.md, runbook.md (pre-check → deploy → verify → rollback) |
│
└── maintenance/                            # Phase 6: Maintenance & Iteration
    ├── SKILL.md | Generator + Pipeline + compound learning: "fix bug", "improve performance" |
    ├── SKILL-verifier.md | Reviewer: "review postmortem", "audit deprecation" |
    ├── references/ | triage-procedures.md, deprecation-strategies.md, changelog-conventions.md |
    └── templates/ | bug-report.md, postmortem.md, improvement-proposal.md |
```

**SKILL.md body structure** (always under 500 lines):
```
# Skill Name
## When to Use              → 2-3 scenarios where this skill applies
## Instructions              → 5-10 imperative rules (MUST vs SHOULD)
## Phase Pipeline            → Numbered steps with gates between phases
## Gate Conditions           → PRE/POST what must be true to proceed
## Templates                 → Which templates/ to load and when
## References                → Which references/ to load on-demand
## Verifier Handoff          → How to run the verifier (fix-and-retry, MAX_ITERATIONS=3)
## Three-Tier Boundaries     → Always/Ask/Never table
## Details                   → Progressive disclosure (only loaded on request)
## Source                    → Reference links
```

SKILL-verifier.md replaces Instructions/Pipeline with:
```
## Rubric                   → Load rubrics file, boolean pass/fail per item
## Output Format             → Summary → Findings (by severity) → Score → Top 3 Recommendations
```

**Per-phase design**:

| Phase | Pattern | Pipeline | Outputs |
|---|---|---|---|
| **Requirements** | Generator + Inversion | Self-clarify (5 questions) → Generate PRD → Explode into 8-15 tasks → Verify → Gate | prd.md, task list with boolean ACs |
| **Design** | Generator + Pipeline | Ingest PRD → Generate architecture → Create ADRs per decision → Verify against PRD → Gate | architecture.md, ADRs, api-spec.md |
| **Implementation** | Generator + TDD | RED (write failing test) → Investigate → GREEN (minimum code) → REFACTOR → Quality gates → Commit | Source changes + test files + one commit per task |
| **Testing** | Generator + Inversion | Self-clarify scope → Generate test plan → Implement tests → Run suite → Verify coverage → Gate | test-plan.md, test cases, coverage report |
| **Deployment** | Pipeline (only) | Verify tests pass → Generate deploy plan → Verify readiness → Execute → Post-verify | deployment-plan.md, runbook.md |
| **Maintenance** | Generator + Compound Learning | Ingest issue → Classify → Fix via Impl pipeline OR propose feature → Feed into Phase 1 | Fixed code, postmortem.md, updated wiki |

## Layer 4: Code Brain per Project (.ctx/)

The Code Brain (.ctx/) sits inside any project that the framework uses. It's separate from SDLC skills:

```
your-project/
├── .agentctx/                       # Existing agentctx context (unchanged)
│   ├── context/
│   ├── conventions/
│   └── ...
│
├── .ctx/                            # The Brain (created by `brain init`)
│   ├── graph/                       # Intelligence Engine outputs
│   │   ├── graph.json               # Knowledge graph — nodes, edges, communities (queryable)
│   │   ├── graph.html               # Interactive visualization — human browsing
│   │   ├── GRAPH_REPORT.md          # Audit: god nodes, surprises, gaps, questions
│   │   ├── cache/                   # Per-file extraction cache (SHA256)
│   │   ├── manifest.json            # File state for incremental updates
│   │   └── wiki/                    # Generated wiki articles
│   │       ├── index.md             # Community + god node catalog
│   │       └── <community>.md       # Per-cluster articles with backlinks
│   ├── protocol.md                  # <500t: "Read routing.md first, query brain MCP"
│   ├── routing.md                   # Keyword → cluster → page (<400t)
│   ├── index.md                     # Content catalog with fingerprints + token counts (from graph.json)
│   ├── community_map.md             # Responsibility clusters (from Leiden output)
│   ├── overview.md                  # State summary + codebase patterns
│   ├── decisions.md                 # All decisions + consolidated summary (agent reads on session start)
│   ├── decisions/                   # Individual ADRs (detailed, rarely read by default)
│   │   ├── 001-auth-strategy.md     # Why JWT over sessions, tradeoffs, date, links
│   │   └── _template.md             # ADR template
│   ├── log.md                       # Append-only: episodic + semantic sections
│   ├── status.md                    # Fresh/stale/unenriched/verified per module
│   ├── patterns.md                  # Cross-cutting patterns (from hyperedges + analysis)
│   ├── skills/                      # Auto-detected skills (installed by `brain init`)
│   │   └── manifest.json            # What was installed, why, and what's available
│   ├── references/                  # Swappable rubrics
│   │   └── lint-checklist.md        # Lint rubric (replaceable without code change)
│   ├── concepts/                    # Wiki-style (PROPOSED → REVIEWED → CONFIRMED)
│   │   ├── authentication.md        # Human-enriched or human-reviewed
│   │   └── _template.md             # Template
│   ├── entities/                    # Generated from brain nodes with confidence-scored edges
│   │   ├── auth-service.md          # Service docs (from brain class/function nodes)
│   │   └── _template.md             # Template
│   ├── modules/                     # Generated from brain file-level nodes + wikilinks
│   │   ├── auth.md                  # Directory-level docs
│   │   └── _template.md             # Template
│   ├── sources/                     # Ingested specs/PRDs (via `brain ingest` for URLs)
│   │   └── auth-spec.md             # Auth requirements
│   ├── conventions/                 # From agentctx skills (read-only)
│   │   └── nextjs/                  # Next.js patterns
│   └── archive/                     # Superseded pages (YYYY-MM/)
```

### Three-Layer Cognitive Stack

The Brain is a tiered cognitive stack balancing **Truth**, **Efficiency**, and **Usability**:

| Layer | Goal | Powered By | Components |
|---|---|---|---|
| **Intelligence Engine** (Truth) | Build a high-fidelity, topologically-aware knowledge graph | **brain** extraction engine | AST extraction (Tree-sitter, 25 languages), Semantic extraction (LLM), Leiden clustering, confidence scoring, graph analysis |
| **Context Router** (Efficiency) | Maximize reasoning density while minimizing token expenditure | brain governance + MCP | Fingerprinting (index.md metadata), Tiered Loading (Pointer → Snippet → Full File), Token Budgeting (protocol.md guardrails), MCP query server |
| **Navigation Interface** (Ergonomics) | Make the Brain feel like a natural extension of the IDE | brain exports + wiki | graph.html (interactive visualization), Breadcrumbs (PostToolUse injection), Community Maps, Semantic Wiki (concepts/ + entities/), Obsidian vault |

### brain as Intelligence Engine

**brain** is both the CLI and the extraction/graph engine that powers Layer 1. Instead of building AST scanning, clustering, confidence scoring, and visualization as separate tools, brain handles all of this in one package:

| Brain Need | brain Capability |
|---|---|
| AST extraction (Tree-sitter) | `extract.py` — 25 languages, classes, functions, imports, call graphs, docstrings |
| Semantic enrichment (LLM) | `extract.py` — concepts, entities, relationships, design rationale from docs/papers/images |
| Confidence scoring (EXTRACTED/INFERRED/AMBIGUOUS) | `validate.py` — every edge typed and scored, INFERRED gets `confidence_score` 0.0-1.0 |
| Leiden community detection | `cluster.py` — Leiden with Louvain fallback, cohesion scoring, oversized community splitting |
| God nodes / surprising connections | `analyze.py` — high-degree abstractions, cross-community edges, suggested questions |
| Incremental updates (hash-based) | `cache.py` — SHA256 per-file, `detect_incremental()` only re-processes changed files |
| Human-readable visualization | `export.py` → `graph.html` — interactive vis.js, search, filter by community, click to explore |
| AI-readable query interface | `serve.py` — MCP server with BFS/DFS traversal, token budgets (~2000t cap) |
| Wiki export with backlinks | `wiki.py` — `index.md` + per-community articles + per-god-node articles, Obsidian `[[backlinks]]` |
| Multimodal ingestion | Images (vision), video/audio (faster-whisper transcription), PDFs, DOCX, XLSX |
| URL ingestion | arXiv papers, tweets, YouTube videos, GitHub repos, generic web pages |
| Multiple export formats | JSON (queryable), HTML (interactive), GraphML (Gephi), Neo4j Cypher, SVG, Obsidian vault |

**What the extraction engine does NOT handle** (the governance layer's responsibility):

| Governance Responsibility | Why extraction can't do this |
|---|---|
| Concept governance (PROPOSED → REVIEWED → CONFIRMED) | Requires human-in-the-loop approval workflow |
| Decision tracking / self-learning loop (decisions.md) | Domain logic, not graph construction |
| SDLC skill routing (6 phases × Generator + Verifier) | Behavioral layer, not extraction |
| Lifecycle hooks (SessionStart/End, PostToolUse) | Session-aware governance, not graph ops |
| Generator-Verifier agent split | Separate agents for write vs review |
| Log consolidation (episodic → semantic) | Memory management |
| Anti-bloat enforcement (token budgets, archival) | Governance constraints |
| Status lifecycle (UNENRICHED → FRESH → STALE → VERIFIED) | Per-module quality tracking |

### brain Integration Points

```
your-project/
├── .ctx/                            # The Brain (governance + routing + intelligence)
│   ├── graph/                       # Intelligence Engine outputs
│   │   ├── graph.json               # The knowledge graph (persistent, queryable)
│   │   ├── graph.html               # Human-readable interactive visualization
│   │   ├── GRAPH_REPORT.md          # Audit: god nodes, surprises, gaps, questions
│   │   ├── cache/                   # Per-file extraction cache (SHA256)
│   │   ├── manifest.json            # File state for incremental updates
│   │   └── wiki/                    # Generated wiki articles
│   │       ├── index.md             # Community + god node catalog
│   │       └── <community>.md       # Per-cluster articles with backlinks
│   ├── skills/                      # Auto-detected skills
│   │   └── manifest.json            # Installed skills + detection reasons
│   ├── protocol.md                  # Context Router entry point (<500t)
│   ├── routing.md                   # Keyword → cluster → page (<400t)
│   ├── ...                          # (decisions, concepts, entities, modules, etc.)
```

**Data flow**: brain builds `graph.json` → Brain reads it to populate `.ctx/` pages → Brain governs what's PROPOSED vs CONFIRMED → Brain routes agents to relevant pages → brain MCP server handles live queries.

**Dual readability**:
- **Humans**: Open `.ctx/graph/graph.html` — click nodes, search, filter by community, see neighbors and edge confidence. Or browse `.ctx/graph/wiki/` in Obsidian.
- **AI agents**: Query via brain MCP server (`query_graph`, `get_neighbors`, `shortest_path`, `god_nodes`) with token budgets. Or read `.ctx/` wiki pages with wikilinks.

### brain CLI Integration

```bash
# Build the graph (Intelligence Engine)
brain .                           # full extraction + clustering + visualization
brain . --update                  # incremental (changed files only, cached)
brain . --mode deep               # aggressive INFERRED edges
brain . --watch                   # auto-rebuild on code changes

# Query the graph (AI or human)
brain query "auth flow"           # BFS traversal with token budget
brain query "auth flow" --dfs     # DFS for tracing specific paths
brain path "AuthService" "User"   # shortest path between concepts
brain explain "Authentication"    # plain-language explanation

# Export
brain . --obsidian                # Obsidian vault with backlinks
brain . --wiki                    # index.md + community articles
brain . --neo4j                   # Neo4j Cypher export

# MCP server (for agent access)
brain serve .ctx/graph/graph.json
# Exposes: query_graph, get_node, get_neighbors, get_community,
#          god_nodes, graph_stats, shortest_path
```

### Pointer-First Principle

The agent must always attempt to satisfy a query using the lowest-cost tier before requesting a higher one:

```
Tier 1: Metadata     → index.md fingerprint (name, summary, token count)
                       OR brain MCP → graph_stats / god_nodes
Tier 2: Snippet       → routing.md keyword match → relevant page section
                       OR brain MCP → query_graph (BFS, ~2000t budget)
Tier 3: Full File     → Load entire .ctx/ page or source file
                       (only when Tier 1-2 insufficient)
```

brain's 71.5x token reduction (on 50+ file corpora) makes Tier 2 dramatically cheaper than reading raw files.

### Community Map (from brain Leiden Clustering)

`community_map.md` is generated from brain's `cluster.py` output — Leiden algorithm with cohesion scoring:

```markdown
## Auth Cluster (4 modules, 6 entities) — cohesion: 0.72
- [[module:auth]], [[module:sessions]], [[module:middleware-auth]], [[module:users]]
- Key entities: [[entity:auth-service]], [[entity:token-service]], [[entity:user-model]]
- God nodes: AuthService (degree 12), TokenService (degree 8)
- Surprising connections: AuthService ↔ RateLimiter (cross-community, INFERRED 0.7)

## Data Cluster (3 modules, 4 entities) — cohesion: 0.85
- [[module:db]], [[module:migrations]], [[module:seeds]]
- Key entities: [[entity:prisma-client]], [[entity:connection-pool]]
```

Also available interactively via `.ctx/graph/graph.html` — filter by community, click to expand, see edge confidence.

### Fingerprinting in index.md

Every `index.md` entry includes a fingerprint (metadata summary) so agents can decide whether to load the full page without reading it:

```markdown
- [[concept:authentication]] — 2.3K tokens — JWT + refresh rotation, provider-switching — cluster:auth
- [[entity:auth-service]] — 1.1K tokens — Handles login/logout, issues JWT — cluster:auth — degree:12
- [[module:auth]] — 0.8K tokens — /src/auth/ (4 files) — last sync: 2026-04-20 — cluster:auth
```

The fingerprint = summary + token count + cluster membership + graph degree. This enables the Pointer-First loading principle. Fingerprints are derived from brain's `graph.json` node attributes.

## Wikilink Connections

```
 concepts/authentication.md
   → "Uses [[entity:auth-service]] for JWT tokens"
   → "Implemented in [[module:auth]]"
   → "Strategy defined in [[source:auth-spec]]"
   → "Convention: [[convention:jwt-rotation]]"

.modules/auth.md
   → frontmatter: concept: "[[concept:authentication]]"
   → entities: [[entity:auth-service]], [[entity:auth-controller]]

 entities/auth-service.md
   → "Belongs to [[module:auth]]"
   → "Implements [[concept:authentication]]"
   → "Uses [[entity:hashing-service]], [[entity:token-service]]"
```

This gives bidirectional connections: concept ↔ module ↔ entity. A planning agent reads the concept (strategy), reference the module (files), and consult the entity (interface) — all connected.

### Weighted Edges & Confidence Scoring (from brain)

brain's `validate.py` enforces that every edge is typed and scored. This prevents hallucinated connections from being treated as fact:

| Edge Type | Description | Confidence | Example |
|---|---|---|---|
| **EXTRACTED** | Found directly in source via AST/Tree-sitter (imports, call-graphs, type refs) | `1.0` | `auth-service.ts` imports `token-service.ts` |
| **INFERRED** | Logical connection derived via LLM reasoning (semantic similarity, naming patterns) | `0.0 - 0.9` | `auth` module and `sessions` module likely related |
| **AMBIGUOUS** | Flagged for human review due to low certainty | `0.0` | Unclear if `utils/hash.ts` belongs to auth or crypto domain |

brain stores this in `graph.json` edge attributes:
```json
{
  "source": "auth_service",
  "target": "token_service",
  "relation": "imports_from",
  "confidence": "EXTRACTED",
  "confidence_score": 1.0,
  "source_file": "/src/auth/auth-service.ts",
  "source_location": "L3"
}
```

The Brain translates these into wikilink frontmatter when generating `.ctx/` pages:
```yaml
related_entities:
  - name: "token-service"
    edge: EXTRACTED        # from brain AST extraction
    confidence: 1.0
  - name: "rate-limiter"
    edge: INFERRED         # from brain semantic extraction
    confidence: 0.7
```

brain also produces **hyperedges** — 3+ nodes grouped by shared pattern (e.g., all functions in an auth flow). These map to concept proposals in the brain.

**brain's GRAPH_REPORT.md** surfaces:
- **God nodes**: Most connected abstractions (what the codebase revolves around)
- **Surprising connections**: Cross-community edges scored by novelty
- **Ambiguous edges**: Flagged for human review with suggested verification questions
- **Knowledge gaps**: Isolated nodes, thin communities, high ambiguity ratios

The Brain Verifier cross-references these against `.ctx/` pages:
- EXTRACTED edges must resolve to actual code references
- INFERRED edges with confidence < 0.5 are flagged for human review
- AMBIGUOUS edges are surfaced in the lint report as INFO items
- God nodes should have corresponding entity or concept pages

## Integration: Brain + SDLC Framework

```
┌─────────────────────────────────────────────────────────────┐
│  brain (Intelligence Engine)                              │
│  AST + semantic extraction → graph.json → graph.html         │
│  Leiden clustering → community detection → god nodes          │
│  MCP server → BFS/DFS queries with token budgets             │
└────────────────────────┬────────────────────────────────────┘
                         │ graph.json + wiki/ + GRAPH_REPORT.md
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  Code Brain (.ctx/) (Governance + Routing)                    │
│  Reads graph → populates modules/, entities/, concepts/       │
│  Governs: PROPOSED → REVIEWED → CONFIRMED                    │
│  Tracks: decisions.md, log.md, status.md, patterns.md        │
│  Routes: protocol.md → routing.md → relevant page            │
└────────────────────────┬────────────────────────────────────┘
                         │ .ctx/ pages with wikilinks
                         ▼
┌─────────────────────────────────────────────────────────────┐
│  SDLC Framework (Behavioral Layer)                           │
│  6 phases × Generator + Verifier skills                      │
│  Templates, references, rubrics, pipelines                   │
│  Reads .ctx/ for project context before each phase           │
└─────────────────────────────────────────────────────────────┘
```

| brain | Code Brain (.ctx/) | SDLC Framework |
|---|---|---|
| Extracts truth from code | Governs and routes context | Guides how agents work |
| graph.json = knowledge graph | decisions.md = project memory | skills/ = executable behavior |
| graph.html = human visualization | concepts/ = human-reviewed knowledge | templates/ = artifact scaffolds |
| MCP server = AI query interface | routing.md = agent navigation | rubrics = quality gates |
| Incremental (cache + hash) | Session-aware (lifecycle hooks) | Trigger-activated (phrases) |

When an SDLC agent runs on a project with a brain:
1. SessionStart hook loads minimal context (protocol.md, decisions.md, recent logs)
2. Agent queries brain MCP for relevant graph context (god nodes, neighbors, community)
3. Agent loads relevant SDLC skill (trigger-matched)
4. Skill loads its templates + references
5. Agent produces artifact (PRD, architecture doc, code, test plan, etc.)
6. Brain SessionEnd hook persists observation, updates status
7. Brain Verifier checks artifact quality against rubrics
8. brain `--update` re-extracts changed files into graph on next sync

## Pipeline File Format (XML tags)

Pipeline files use XML tags for machine-parseable structure:
```xml
<task>Implement the login component</task>
<acceptance_criteria>
  <criterion>User can submit email and password</criterion>
  <criterion>Errors display inline</criterion>
</acceptance_criteria>
<verification>
  <check>Tests pass</check>
  <check>Lint clean</check>
</verification>
<files src="app/login/" />
```

This gives explicit hierarchy and clear section boundaries that help models parse complex instructions more reliably than free-form prose.

## Skill Registry & Smart Init

### Two-Phase Init

`brain init` is a two-phase process:

```
brain init
  Phase A: Scaffold .ctx/ directory + run extraction (graph.json, etc.)
  Phase B: Detect project stack → pull matching skills from registry
```

### Detection Heuristics

| Signal | Detection Method | Skills Activated |
|---|---|---|
| `package.json` with `react` | JSON parse dependencies | react/, javascript/ |
| `package.json` with `vue` | JSON parse dependencies | vue/, javascript/ |
| `package.json` with `next` | JSON parse dependencies | react/, deployment/ (Vercel) |
| `tsconfig.json` exists | File exists | typescript/ |
| `go.mod` exists | File exists | go/ |
| `Cargo.toml` exists | File exists | rust/ |
| `requirements.txt` or `pyproject.toml` | File exists | python/ |
| `.github/workflows/` exists | Dir exists | deployment/ (GitHub Actions) |
| `Dockerfile` exists | File exists | deployment/ (Docker) |
| `prisma/schema.prisma` | File exists | data-modeling/ |
| `*.test.*` or `*.spec.*` files | Glob pattern | testing/ |
| `.env` or `.env.example` | File exists | security/ (env management) |
| `k8s/` or `kubernetes/` | Dir exists | deployment/ (Kubernetes) |

### Skill Tiers

| Tier | When installed | Examples |
|---|---|---|
| **Core** (always) | Every `brain init` | requirements/, design/, implementation/, testing/, maintenance/ |
| **Detected** (auto) | Stack matches | react/, vue/, go/, deployment/, data-modeling/ |
| **Available** (manual) | User runs `brain add-skill <name>` | kubernetes/, graphql/, mobile/ |

### Skill Registry Structure

Skills ship bundled with the brain package as **complete skill packages** — not just SKILL.md files. Each skill is a full directory following the 5 skill design patterns (Tool Wrapper, Generator, Reviewer, Inversion, Pipeline):

```
brain/skills-registry/                    # Bundled with brain package
├── registry.json                         # Master index: tier + detect rules per skill
├── core/                                 # Always installed on brain init
│   ├── requirements/
│   │   ├── SKILL.md                      # Generator + Inversion pattern
│   │   ├── SKILL-verifier.md             # Reviewer pattern
│   │   ├── references/
│   │   │   ├── elicitation.md
│   │   │   ├── acceptance-criteria.md
│   │   │   └── stakeholder-mapping.md
│   │   └── templates/
│   │       ├── prd.md
│   │       ├── user-story.md
│   │       └── epic.md
│   ├── design/                           # Full skill package (Generator + Pipeline)
│   ├── implementation/                   # Full skill package (Generator + TDD)
│   ├── testing/                          # Full skill package (Generator + Inversion)
│   ├── deployment/                       # Full skill package (Pipeline only)
│   └── maintenance/                      # Full skill package (Generator + Compound Learning)
│
├── detected/                             # Auto-matched by stack detection
│   ├── react/
│   │   ├── SKILL.md                      # Tool Wrapper — React conventions
│   │   └── references/
│   │       ├── conventions.md            # React best practices, hooks rules
│   │       └── patterns.md              # Component patterns, state management
│   ├── typescript/
│   │   ├── SKILL.md
│   │   └── references/conventions.md
│   ├── vue/
│   ├── go/
│   ├── rust/
│   ├── python/
│   ├── data-modeling/
│   │   ├── SKILL.md
│   │   └── references/
│   │       └── prisma-conventions.md
│   └── security/
│       ├── SKILL.md                      # Reviewer pattern
│       └── references/
│           └── env-management.md
│
└── available/                            # Manual install via brain add-skill
    ├── kubernetes/
    ├── graphql/
    ├── mobile/
    └── web-quality/                      # Core Web Vitals, a11y, SEO
        ├── SKILL.md
        ├── references/
        │   ├── LCP.md
        │   ├── WCAG.md
        │   └── A11Y-PATTERNS.md
        └── scripts/
            └── analyze.sh               # JSON output for automation
```

**Detection rules** live in `registry.json` — the single source of truth for what signals map to which skills:

```json
{
  "version": "1.0",
  "skills": {
    "core/requirements": { "tier": "core", "detect": "always" },
    "core/testing": { "tier": "core", "detect": "always" },
    "detected/react": {
      "tier": "detected",
      "detect": [
        { "file": "package.json", "contains": "\"react\"" }
      ],
      "also_installs": ["detected/typescript"]
    },
    "detected/typescript": {
      "tier": "detected",
      "detect": [
        { "file_exists": "tsconfig.json" }
      ]
    },
    "detected/go": {
      "tier": "detected",
      "detect": [
        { "file_exists": "go.mod" }
      ]
    },
    "detected/data-modeling": {
      "tier": "detected",
      "detect": [
        { "file_exists": "prisma/schema.prisma" }
      ]
    },
    "detected/security": {
      "tier": "detected",
      "detect": [
        { "file_exists": ".env" },
        { "file_exists": ".env.example" }
      ]
    },
    "available/kubernetes": { "tier": "available", "detect": "manual" },
    "available/graphql": { "tier": "available", "detect": "manual" }
  }
}
```

### Installation Flow

On `brain init`:

1. Brain scans project structure
2. Reads `registry.json` and evaluates each `detect` rule against the filesystem
3. Copies matched skill packages (entire directories) into `.ctx/skills/`
4. Writes `.ctx/skills/manifest.json` recording what was installed and why

After install, `.ctx/skills/` mirrors the registry structure but only contains matched skills:

```
.ctx/skills/
├── manifest.json                         # What's installed + detection audit trail
├── requirements/                         # Core — full skill package copied
│   ├── SKILL.md
│   ├── SKILL-verifier.md
│   ├── references/
│   └── templates/
├── react/                                # Detected — full skill package copied
│   ├── SKILL.md
│   └── references/
├── typescript/                           # Detected
│   ├── SKILL.md
│   └── references/
└── data-modeling/                        # Detected
    ├── SKILL.md
    └── references/
```

**manifest.json** records the audit trail:

```json
{
  "installed": "2026-04-23",
  "registry_version": "1.0",
  "detected_stack": ["react", "typescript", "prisma", "github-actions"],
  "skills": {
    "core/requirements": { "reason": "core — always installed" },
    "core/testing": { "reason": "core — always installed" },
    "detected/react": { "reason": "detected: package.json → react@19.1.0" },
    "detected/typescript": { "reason": "detected: tsconfig.json exists" },
    "detected/data-modeling": { "reason": "detected: prisma/schema.prisma exists" }
  },
  "available": ["kubernetes", "graphql", "mobile", "web-quality"]
}
```

### Continuous Re-Detection (Every Prompt, Zero Tokens)

Skill detection runs on **every user prompt** via a `UserPromptSubmit` hook — but it's a pure filesystem check, no LLM calls:

```
UserPromptSubmit hook → brain detect-skills --quiet
  1. Read .ctx/skills/manifest.json (what's installed)
  2. Run fs checks: Dockerfile exists? new test files? new go.mod?
  3. Compare against manifest
  4. If new signal found → print 1-line suggestion (~20 tokens)
  5. If no delta → silent (0 extra tokens)
```

Cost: ~5ms shell execution per prompt. Zero API tokens on 99% of prompts. Only when a genuinely new file appears (Dockerfile added, prisma schema created, etc.) does it inject a suggestion.

This also runs on `brain sync` for the same check, but the per-prompt hook catches changes even between syncs — if someone adds a Dockerfile mid-session, the next prompt sees it.

This is an "Ask First" action (not auto-install) — matches the three-tier boundary philosophy.

### Skill Package Format

Each skill is a complete directory, not just a SKILL.md file. The five skill design patterns determine which components a skill needs:

| Component | Required | Used By | Purpose |
|---|---|---|---|
| `SKILL.md` | Yes | All patterns | Contract: trigger phrases, instructions, gates (<500 lines) |
| `SKILL-verifier.md` | No | Reviewer | Separate rubric-based review (Generator-Verifier split) |
| `references/` | No | Tool Wrapper, Reviewer, Generator | Conventions, checklists, domain guides (progressive disclosure) |
| `templates/` | No | Generator, Pipeline | Output scaffolds (PRD, ADR, test-plan, component) |
| `scripts/` | No | Tool Wrapper, Pipeline | Automation scripts (must output JSON) |

The existing SKILL.md format (frontmatter + markdown) doesn't change. The detection system only controls which skill packages are present in `.ctx/skills/` — activation within an installed skill is handled by the Skill Routing Engine below.

### Skill Routing Engine

Skills activate **implicitly** — users never type "use the react skill." The routing engine checks three signals on every interaction and loads the matching skill's context automatically:

| Signal | When | How | Example |
|---|---|---|---|
| **File context** (`paths` match) | PostToolUse — agent edits/reads a file | Match file path against installed skills' `paths` globs → inject matched skill's references as context | Edit `src/components/Button.tsx` → react skill's `references/conventions.md` loaded |
| **Intent match** (`trigger_phrases`) | UserPromptSubmit — user sends prompt | Match user prompt against installed skills' `trigger_phrases` → activate matched skill | "write tests for auth" → testing skill activates |
| **Stack context** (detected stack) | SessionStart — session begins | Read `manifest.json` detected_stack → pre-load relevant skill references into routing context | Project has React+TS → react and typescript skill references available in routing |

**Routing priority**: File context > Intent match > Stack context. Most specific wins. When multiple skills match, the narrowest `paths` glob takes precedence.

**Key principle**: The system sees the user editing a `.tsx` file and loads React conventions automatically via PostToolUse. It sees "write a PRD" in the prompt and activates the requirements skill via UserPromptSubmit. Slash commands exist only as escape hatches for when implicit routing picks the wrong skill — they are not the primary activation path.

**How routing works at runtime**:
1. `SessionStart` → read `.ctx/skills/manifest.json` + all installed `SKILL.md` frontmatter → build in-memory routing table: `{phrase → skill path}` for trigger_phrases, `{glob → skill path}` for paths fields. This is built once per session, not per prompt
2. `UserPromptSubmit` → case-insensitive substring scan of prompt against routing table's trigger_phrases → set active skill for this interaction. Three trigger types (from agentskills.io research):
   - **Domain jargon** (exact): "LCP", "WCAG", "prisma" → routes unambiguously
   - **Intent-based** (action verbs): "write tests", "deploy to" → matches action + context
   - **Low-jargon entry** (broad): "quality review", "best practices" → catches non-specialists
3. `PostToolUse` → match edited/read file path against routing table's `paths` globs → inject matched skill's conventions as breadcrumb context
4. If multiple signals fire, File context (most specific) wins over Intent match, which wins over Stack context (most general)

**Multi-skill conflict resolution** (when multiple skills match within the same signal tier):
- **Same-tier tiebreaker**: Use surrounding context to disambiguate. "Optimize this React component" matches both performance and react skills — but the file context (`.tsx`) resolves to react, and "optimize" resolves to performance. Both load, because progressive disclosure keeps references small
- **When still ambiguous**: Load all matched skills' references. Skills are designed for progressive disclosure (SKILL.md < 500 lines, references/ loaded on demand), so loading 2-3 skills' conventions costs ~1-2K extra tokens — acceptable overhead vs. guessing wrong
- **User correction tracking**: If a user explicitly invokes a slash command after implicit routing missed, log the correction. After N corrections for the same pattern, suggest a trigger_phrase update (skill atrophy detection)

### Migration & Adoption Path

`brain init` is **additive** — it creates `.ctx/` as a new namespace and never modifies existing project configuration. This enables incremental adoption for projects with existing context setups:

**Coexistence guarantees**:
- Existing `.agentctx/` directories are untouched — `.ctx/` is a separate namespace
- Existing `CLAUDE.md` files are respected and never overwritten. `brain init` adds a single line to CLAUDE.md pointing to `.ctx/protocol.md` (or creates a new CLAUDE.md if none exists)
- Existing `.cursorrules`, `.github/copilot-instructions.md`, etc. are preserved — `brain init` doesn't modify tool-specific config files unless explicitly requested via `agentctx` multi-tool output

**Progressive adoption** (from guardrails-hierarchy research: "start with warnings, then escalate to blocks"):
1. **Start**: `brain init` — scaffold `.ctx/`, run extraction, detect skills. Zero hooks, zero automation. The brain exists but is passive
2. **Add hooks gradually**: Enable SessionStart first (load context). Then PostToolUse (breadcrumbs). Then UserPromptSubmit (skill routing). Each hook is independently useful
3. **Enable skill routing**: Once hooks are stable, the routing engine activates implicitly. No configuration change needed — hooks already consult `.ctx/skills/`
4. **Full automation**: Enable SessionEnd persistence, `/brain-sync` on commit. The brain is now self-maintaining

**Non-breaking installation** (learned from compound-product's install.sh pattern):
- `brain init` checks for existing config before creating: "Config file already exists, skipping..."
- All brain files live inside `.ctx/` — no files added to project root except the CLAUDE.md pointer
- `.ctx/` can be added to `.gitignore` during evaluation without affecting the project

See also: [[03-agents]] for agent roles, [[04-memory-and-lifecycle]] for memory model and hooks, [[06-implementation]] for the task breakdown.
