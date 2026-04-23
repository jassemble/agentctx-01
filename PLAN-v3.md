# Code Brain — Self-Maintaining Context Wiki for Code

## Context

Three sources converge on the same truth:

1. **agentctx CLI** already does AST scanning, AI enrichment, module docs, multi-tool output, and 156 agents. But modules are isolated — no cross-references, no concept synthesis, no self-maintenance.
2. **agentctx-idea wiki** (73 concepts from 17 Osmani sources) proves the wiki pattern works for research — interlinked concepts, entities, contradictions, progressive disclosure. But has no code scanning.
3. **experiment-on-trpc** proves the integration works — 169 modules, auto-generated, AI-enriched, with `patterns.md` and `status.md`. But the `module-index.md` is flat (169 entries, 0 relationships).

**The gap**: agentctx generates "what each file does." The wiki generates "what it all means." We need both — a brain that scans your code AND synthesizes it into a queryable knowledge graph.

---

## Part 1: Osmani's Agent Architecture — How Agents Actually Decide

The critical insight from the research: **agents don't "take decisions" — the architecture decides.** Osmani's sources converge on a distributed decision model:

### The Decision Pipeline (from Osmani's corpus)

```
SPEC (what + why)
  → ANALYSIS (is it possible? what's the priority?)  [Brain provides context here]
    → PLANNING (architecture, constraints, task explosion)
      → EXECUTION (implement, verify, retry)
        → RETRO (update AGENTS.md, compound learning)  [Brain records here]
```

**Each phase is a different intelligence. The "decision" is distributed:**

| Phase | What Decides | Agent Pattern | Brain's Role |
|---|---|---|---|
| **Spec** | What to build, why, success criteria | Inversion (interviews user) | Records the spec as a source |
| **Analysis** | Is it the right priority? Feasible? | Analyzer | Synthesizes from existing modules |
| **Planning** | How to structure work | Generator + Pipeline | Provides architecture overview + patterns |
| **Execution** | How to implement each task | Tool Wrapper | Provides concept pages + entity docs |
| **Verification** | Is it correct? | Reviewer | Contradicts or confirms against existing knowledge |
| **Retro** | What did we learn? | Compound learning | Updates modules, entities, concepts, patterns |

**Brain's role in decision-making**: The brain isn't itself an agent. It's the **context layer** that every agent consults. When a planner agent asks "what's the architecture?", the brain provides `architecture.md` + `patterns.md`. When a verifier checks "does this match established patterns?", the brain provides `concepts/authentication.md` with the documented auth strategy. When the retro asks "what changed?", the brain diff's against last scan's `source-hash`.

### Five Agent Design Patterns (from Google ADK article, validated by Osmani)

Osmani's wiki cataloged 5 composable patterns. Our brain maps each pattern to a brain layer:

| Pattern | What It Does | Brain Maps To |
|---|---|---|
| **Tool Wrapper** | Injects library/API context on-demand | `.ctx/concepts/` + `.ctx/conventions/` — loaded only when relevant |
| **Generator** | Enforces structured output with templates | `.ctx/modules/` — structured module doc generation |
| **Reviewer** | Separates what-to-check from how-to-check | `.ctx/lint` — health checks against documented patterns |
| **Inversion** | Agent interviews user before acting | `.ctx/sources/` — PRD/spec capture before implementation |
| **Pipeline** | Sequential workflow with hard gates | `.ctx/status.md` — state transitions (draft → approved → in-progress → done) |

### Osmani's Key Findings We Must Honor

1. **3-5 agents is the ceiling** (Claude Code Swarms + Parallel Agent Limit) — more adds coordination overhead, not throughput. So the brain must enable agents to work independently with good context, not require a swarm.
2. **Context expands → LLMs perform worse** — not just token limits, but attention degradation. So the brain must use progressive disclosure (routing.md → index.md → page), not dump everything.
3. **Verification is the bottleneck** (Factory Model) — not generation. So the brain must record verification status per module.
4. **Human comprehension debt** — when agents generate faster than the human understands. So the brain must surface "what changed" in plain English.
5. **Vibe coding ≠ production engineering** (Spec Writing article) — specs + tests are the bridge. So the brain must record specs alongside code context.
6. **Monolithic agent fails at scale** (Vila/MCP article) — M×N integration, context collapse, no specialization. So the brain must be modular (concepts, entities, modules) not a single blob.
7. **Human-curated > LLM-generated context** (ETH Zurich study) — AI-written AGENTS.md reduces success 3%, increases cost 20%. So the brain must support human enrichment, not fully auto-generated pages.
8. **Compound learning** (Ryan Carson's philosophy) — each improvement makes future improvements easier. So the brain must extract and promote patterns, not just record changes.
9. **Productivity paradox** (METR RCT: 19% slower, Faros AI: zero DORA improvement) — agents look fast but aren't. So the brain must track time-to-verification, not just time-to-generate.

---

## Part 2: Comparison — Our Idea vs. Osmani's Framework

| Dimension | Osmani's Research Says | Our Brain Does |
|---|---|---|
| **Agent decision-making** | Distributed across Spec → Analysis → Planning → Execution → Verification → Retro | Brain provides context at each step, records outcomes after |
| **Context management** | Progressive disclosure, modular prompts, subagent isolation | routing.md → index.md → specific page. Personas per task type |
| **Knowledge persistence** | AGENTS.md (semantic memory), progress.txt (episodic), git history, task state | `.ctx/modules/` + `.ctx/entities/` + `.ctx/concepts/` + `.ctx/log.md` |
| **Pattern tracking** | AGENTS.md compound learning, patterns.md from agentctx | `.ctx/patterns.md` auto-distilled from module changes |
| **Verification** | Factory Model step 4, VDD (40-60% safety improvement) | Status per module: fresh/stale/unenriched. Verified boolean in spec sources |
| **Quality gates** | Plan approval, hooks, AGENTS.md compound learning | Lint agent checks contradictions, orphans, broken wikilinks, stale modules |
| **Spec-driven work** | 4 phases (Specify → Plan → Tasks → Implement), YAML spec artifact | `.ctx/sources/` stores specs, links to relevant concepts and modules |
| **Human cognitive limit** | 3-4 parallel threads max, ambient anxiety tax, comprehension debt | Status page surfaces "what changed" simply. One brain per project, not per feature |
| **Anti-monolithic design** | Subagents + MCP + decomposition enforces boundaries structurally | 5 separate layers (concepts, entities, modules, conventions, sources) loaded selectively |
| **Token economics** | 193K Cisco doc nearly exhausts context window. Token count = first-class metric | Protocol under 500 tokens. Each page under 30K. Lint reports token budgets |
| **Human curation > auto** | ETH Zurich: AI-written context hurts. Human-curated AGENTS.md wins | Modules auto-generated, entities/concepts human-enriched. Hash tracking detects drift |
| **Multi-tool output** | Each AI tool has its own context file format | Inherits from agentctx — generates for 10 AI tools from one brain |

### Where Our Idea Goes Beyond Osmani

Osmani's framework **describes the problem space** — he documents patterns, bottlenecks, and anti-patterns. He doesn't build the context maintenance layer. Our brain does:

1. **Bidirectional wikilinks between code and concepts**: agentctx has modules. The wiki has concepts. Nobody connects them. The brain links `modules/auth.md` ↔ `concepts/authentication.md` ↔ `entities/auth-service.md`. This is what enables a planning agent to read the concept (strategy), reference the module (files), and consult the entity (interface) — all connected.

2. **Self-maintenance via git hooks**: Osmani documents AGENTS.md decay but no one built the maintenance subagent. The brain runs on commit: reads diff, updates modules, refreshes entities, flags concept contradictions.

3. **Hash-based freshness tracking**: Each module tracks `source-hash` vs `enriched-hash`. The brain knows exactly which pages are stale — no manual `agentctx scan` needed.

4. **Progressive disclosure as a protocol**: routing.md (400 tokens) → index.md (cluster narrowed) → specific page (loaded on demand). This makes the brain usable at any scale — 169 modules or 1,690.

### Where Osmani's Research Corrects Our Idea

1. **We can't fully automate concept pages** — ETH Zurich study shows AI-generated context hurts. Concept pages must be **human-enriched or human-reviewed**. The brain generates proposals, human approves.

2. **3-5 agent ceiling means** — we shouldn't design a brain that spawns swarms. The brain enables each agent to be more effective with less context, so you need fewer agents.

3. **Verification must come before work** — the brain should record verification criteria alongside specs, not just after-the-fact status.

---

## Part 3: Architecture

```
agentctx-01/                         ← The Framework (reusable)
├── src/
│   ├── brain/
│   │   ├── init.ts                  ← Scaffold .ctx/ from templates
│   │   ├── scan.ts                  ← Wrapper around agentctx scan
│   │   ├── sync.ts                  ← Full enrichment pipeline
│   │   ├── lint.ts                  ← Health checks
│   │   ├── ingest.ts                ← Ingest PRD/spec as source
│   │   ├── diff.ts                  ← What changed since last scan
│   │   ├── status.ts                ← Brain health dashboard data
│   │   └── wikilink.ts              ← Parse/resolve/create wikilinks
│   └── ...                          ← Existing agentctx CLI code
│
├── templates/brain/                 ← Page templates
│   ├── concept.md
│   ├── entity.md
│   ├── module.md
│   └── source.md
│
└── .claude/agents/                  ← Agent definitions
    ├── brain-maintenance.md
    └── brain-linter.md
```

```
your-project/                        ← A project using the brain
├── .agentctx/                       ← Existing agentctx context
│   ├── context/
│   │   ├── architecture.md
│   │   ├── patterns.md
│   │   ├── conventions/
│   │   └── modules/
│
├── .ctx/                            ← The Brain (created by `brain init`)
│   ├── protocol.md                  ← Entry point: "Read this first"
│   ├── index.md                     ← Content catalog with summaries
│   ├── routing.md                   ← Keyword → cluster → page lookup
│   ├── overview.md                  ← State summary + recent activity
│   ├── log.md                       ← Append-only activity log
│   ├── status.md                    ← Sync state (fresh/stale/unenriched)
│   ├── patterns.md                  ← Cross-cutting patterns
│   │
│   ├── concepts/                    ← Wiki-style (human + AI)
│   │   ├── authentication.md        ← "How auth works in THIS project"
│   │   └── _template.md
│   │
│   ├── entities/                    ← Code entities (scan + enrich)
│   │   ├── auth-service.md
│   │   └── _template.md
│   │
│   ├── modules/                     ← Auto-scanned (agentctx)
│   │   ├── auth.md                  ← Files, functions, behavior notes
│   │   └── _template.md
│   │
│   ├── sources/                     ← Specs, PRDs, requirements
│   │   └── auth-spec.md
│   │
│   └── conventions/                 ← From agentctx skills
│       ├── nextjs/
│       └── typescript/
```

### How the layers connect (wikilinks)

```
.concepts/authentication.md
  → "Uses [[entity:auth-service]] for JWT tokens"
  → "Implemented in [[module:auth]]"
  → "Strategy defined in [[source:auth-spec]]"
  → "Convention: [[convention:jwt-rotation]]"

.modules/auth.md
  → frontmatter: concept: "[[concept:authentication]]"
  → entities: [[entity:auth-service]], [[entity:auth-controller]]

.entities/auth-service.md
  → belongs to: [[module:auth]]
  → implements: [[concept:authentication]]
  → uses: [[entity:hashing-service]], [[entity:token-service]]
```

### The sync cycle (on commit)

```
1. Git hook fires → /brain-sync (or automatic via settings.json hook)
2. brain diff: compare source-code against .ctx/modules/
3. brain scan: regenerate modules with new hashes where changed
4. For each changed module:
   a. Update entity pages (new functions, changed signatures)
   b. If implementation strategy changed → flag concept for review
   c. If new domain pattern → propose new concept page
5. Cross-link: "auth module now uses [[entity:new-service]], part of [[concept:data-access]]"
6. Update patterns.md if cross-module pattern detected/changed
7. Update routing.md with new keywords
8. Update index.md catalog
9. Append to log.md: "## [YYYY-MM-DD] sync | auth module changed"
10. Update status.md counts
```

---

## Part 4: The Agents

### Agent 1: Brain Maintenance Agent

**Triggers**: Git commit (via hook), `/brain-sync` slash command.

**Personality**: Efficient, precise, non-hallucinating. Only records facts verifiable in code.

**Steps**:
1. Read `git diff HEAD~1 HEAD`
2. Parse diff → classify changes:
   - New directory = likely new module
   - Changed function signatures = entity update
   - New imports/dependencies = pattern change
   - New routes/endpoints = API entity
3. Run `brain scan` on changed areas
4. Create/update entity pages
5. Flag concept pages whose descriptions no longer match code (hash mismatch)
6. Cross-link everything
7. Update routing, index, log, status
8. Report: "Scanned X changes. Created: Y entities. Updated: Z modules. Concepts flagged: N."

**Decision logic**: The agent doesn't "decide" what architecture to build. It observes what was built and records it. It proposes concept pages but flags them for human review (honoring ETH Zurich finding).

### Agent 2: Brain Linter Agent

**Triggers**: `/brain-lint` slash command.

**Checklist** (structured, boolean results):

| Check | Severity | How |
|---|---|---|
| Broken wikilinks: `[[foo:bar]]` but `bar.md` doesn't exist | ERROR | Parse all wikilinks, resolve file paths |
| Stale modules: `source-hash` ≠ current code hash | WARNING | Compare stored vs. actual hash |
| Orphan entities: no inbound wikilinks from any page | WARNING | Backlink scan |
| Missing modules: `src/auth/` exists but no `modules/auth.md` | ERROR | Directory scan vs. module catalog |
| Pattern drift: described pattern no longer exists in code | WARNING | Compare patterns.md claims vs. code |
| Token overflow: any page > 30K tokens | WARNING | Count tokens per page |
| Stale conventions: conventions reference removed files | INFO | Cross-reference check |
| Contradiction: two sources claim opposite behavior | WARNING | LLM analysis (compares entity/concept claims) |

### Agent 3: Brain Synthesis Agent (optional, human-triggered)

**Triggers**: `/brain-synthesize` — runs when user wants AI to propose concept pages.

**Steps**:
1. Read all entity and module pages
2. Identify cross-cutting themes (e.g., "5 modules use provider switching")
3. Propose concept pages: "Proposal: `.ctx/concepts/provider-switching.md`"
4. Present to human for review/enrichment
5. If approved → create page with wikilinks to source modules

**Human-in-the-loop by design** because of ETH Zurich finding: AI-generated context hurts.

---

## Part 5: Implementation Plan

### Phase 1: Infrastructure (Week 1)

1. Create `.ctx/` scaffold with 5 page templates (concept, entity, module, source, pattern)
2. Implement `brain init` command — creates the scaffold
3. Implement `brain scan` — wrapper around existing agentctx scan, outputs to `.ctx/modules/`
4. Implement `brain diff` — compare git hashes vs. stored hashes
5. Implement `brain status` — show fresh/stale/unenriched counts
6. Add wikilink parser (resolve `[[concept:x]]` → `.ctx/concepts/x.md`)
7. Create `CLAUDE.md` that defines protocol routing for projects using the brain
8. Write the three agent definitions

### Phase 2: Sync Engine (Week 2)

9. Implement `brain sync` — the full pipeline (scan + entity creation + cross-linking + index update + log + status)
10. Implement git hook integration (settings.json post-commit hook)
11. Create `/brain-sync` slash command
12. Create `/brain-lint` slash command
13. Implement broken wikilink detection
14. Implement stale module detection (hash comparison)
15. Implement orphan entity detection
16. Test on a real project (experiment-on-trpc)

### Phase 3: Intelligence Layer (Week 3)

17. Implement `brain ingest` — ingest PRD/spec → create source page with wikilinks
18. Implement pattern auto-distillation — detect "provider switching" across modules
19. Implement concept proposal generation (synthesis agent + human review)
20. Implement progressive disclosure routing — agent reads routing.md → index.md → page
21. Add token budget enforcement to lint
22. Test end-to-end: commit → sync → query concept → agent finds right page

### Phase 4: Integration with agentctx (Week 4)

23. Merge brain commands into agentctx CLI (`agentctx brain sync`)
24. Share scan logic — brain reuses agentctx's AST scanner
25. Generate brain content into agentctx multi-tool outputs
26. Dashboard shows brain state alongside spec board and modules
27. Document the brain in README.md
28. Write tests for scan, sync, lint, wikilink resolution

---

## Part 6: Success Criteria

A developer creates a new auth feature (login page + backend + DB schema):

1. After commit, `/brain-sync` runs → creates `modules/auth.md` (scanned), `entities/auth-service.md` (enriched), proposes `concepts/authentication.md` (for review)
2. Cross-links established: concept → module → entity, all bidirectional
3. `/brain-lint` → green, no broken links, no stale modules
4. New session starts → agent reads `protocol.md` → `routing.md` finds "auth" cluster → loads `concepts/authentication.md` → understands the project's auth strategy → implements correctly
5. Developer queries: "how does auth work here?" → agent synthesizes answer from concept + entity + module pages with inline wikilink citations
6. Human enriches the proposed concept page → adds "We chose JWT refresh rotation because..." → future agents inherit this decision
7. Patterns.md updated: "Auth, Email, and SMS all use provider-switching pattern" — auto-detected across 3 modules

---

## Part 7: What We're NOT Building

1. **No agent swarms** — Osmani's ceiling is 3-5 agents. The brain enables single agents to do better work with better context, not more agents.
2. **No fully-auto concept pages** — ETH Zurich: AI context hurts. Concepts require human review.
3. **No monolithic context dump** — progressive disclosure only. If `protocol.md` > 500 tokens, lint fails.
4. **No replacement for agentctx** — the brain is a layer on top. agentctx handles scanning, multi-tool output, skills, dashboard. The brain handles wikilinks, concepts, auto-sync.
