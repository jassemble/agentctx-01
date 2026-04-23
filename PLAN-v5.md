# Code Brain — Self-Maintaining Context Wiki for Code (v5)

## Context

After a deep read-through of all 10 topic clusters from the agentctx-idea wiki (73 concepts, 24 entities, 17 sources) plus all their linked concept pages, the v4 plan was structurally sound but architecturally incomplete. The v4 plan described directories, commands, and agents — but missed four critical dimensions that the cross-cluster research reveals:

1. **Lifecycle hooks architecture** beyond a single git post-commit hook
2. **Generator-Verifier split** in the Verify phase (layered verification: deterministic vs heuristic vs human)
3. **Progress consolidation** — separating episodic memory (what happened per sync) from semantic memory (what the codebase is like), with a top-level "Codebase Patterns" section
4. **Investigation vs implementation separation** — the task explosion pattern says investigation and implementation must be separate tasks; the brain's sync pipeline was combining them

This v5 rewrites the plan with cross-cluster synthesis applied.

---

## Part 1: How Agents "Take Decisions" — The Distributed Model

**Core insight from Osmani's research**: Agents don't decide. The architecture decides across six phases (from the Factory Model):

```
Spec → Analysis → Planning → Execution → Verification → Retro
```

The brain is not an agent. It is the **context layer** consulted by every agent at each phase. This maps directly onto the **layered verification** model (deterministic → heuristic → human) — the brain is the context infrastructure that makes verification possible.

| Phase | Agent Pattern | Brain Consults | Brain Records |
|---|---|---|---|
| Spec | Inversion | existing concepts/sources | the spec as a source page |
| Analysis | Tool Wrapper | architecture.md + patterns.md | nothing (read-only) |
| Planning | Generator | module-index + entities | new concept proposals |
| Execution | Pipeline | relevant concept + entity pages | module doc updates |
| Verification | Reviewer | patterns.md + conventions + prior status | verification status per module |
| Retro | Generator | nothing | updates modules, entities, concepts, patterns, log |

**NEW (v5 change from Generator-Verifier architecture research)**: The brain itself should be split into **Generator** (writes pages from facts) and **Verifier** (reads pages back against code to check accuracy). These are separate roles, not the same agent. This mirrors the Anthropic/DeepMind/Meta research convergence: "verification is easier than generation" — splitting these roles eliminates self-review bias.

---

## Part 2: Architecture — The Brain Services + Lifecycle Hooks

### 2A: The Brain Services (Same as v4, clarified)

| Brain Service | Skill Pattern | What It Does | Trigger |
|---|---|---|---|
| **Scan** | Tool Wrapper | Reads code, injects module context on-demand | `brain scan`, git commit |
| **Enrich** | Generator | Produces structured entity/concept pages from modules | `brain sync` |
| **Verify** | Reviewer | Checks brain accuracy against code (lint) | `brain lint`, post-commit |
| **Sync Pipeline** | Pipeline | scan → classify → update → verify → commit (5 gates) | `brain sync`, git hook |
| **Ingest** | Inversion | Interviews user about a spec/PRD before creating source page | `brain ingest` |

### 2B: NEW — Lifecycle Hooks Architecture (v5 addition)

The v4 plan mentioned a single git post-commit hook. The wiki research on lifecycle hooks architecture defines a more comprehensive hook model:

| Hook | When | What the brain does |
|---|---|---|
| **SessionStart** | Agent starts new session | Load `.ctx/protocol.md` + 5 most recent `log.md` entries + relevant brain pages based on task type |
| **UserPromptSubmit** | User sends a prompt | Store the query for future context matching |
| **PostToolUse** | Agent modifies a file | If file is in `.ctx/`, validate the change (no accidental deletion, human-approved content protected). If file is in source code, mark related modules as potentially stale |
| **Stop** | Agent pauses | Checkpoint current task progress to `status.md` |
| **SessionEnd** | Agent finishes | Persist any ephemeral observations to `log.md`, update `status.md`, trigger lightweight sync if source files changed |

This makes the brain **session-aware**, not just commit-aware. Currently, if an agent works on code between commits, the brain doesn't know. Hooks close this gap.

---

## Part 3: Directory Structure — With Memory Consolidation

```
your-project/
├── .agentctx/                       ← Existing agentctx (unchanged)
│    └── ...
│
├── .ctx/                            ← The Brain
│    ├── protocol.md                 ← Layer 1: <500 tokens
│    ├── routing.md                  ← Keyword → cluster → page (<400 tokens)
│    ├── index.md                    ← Content catalog with token counts
│    ├── overview.md                 ← State summary
│    │    ├── ## Codebase Patterns  ← NEW: Top-level consolidated patterns
│    │    │                         ← (from compound-product progress.txt model)
│    │    ├── ## Active State       ← Current brain health, recent syncs
│    │    └── ## Recent Activity    ← Last N syncs summary
│    │
│    ├── log.md                      ← Append-only, parseable entries
│    │    ├── ## Recent Patterns     ← Promoted recurring patterns (read first)
│    │    └── ## Sync History        ← Per-sync raw entries (chronological)
│    │
│    ├── status.md                   ← Fresh/stale/unenriched/verified per module
│    ├── patterns.md                 ← Cross-cutting patterns (auto-distilled)
│    ├── references/                 ← NEW: Swappable rubrics (Reviewer pattern)
│    │    └── lint-checklist.md      ← Lint rubric (replaceable without code change)
│    │
│    ├── concepts/                   ← Wiki-style (PROPOSED → REVIEWED → CONFIRMED)
│    ├── entities/                   ← Auto-generated with hash tracking
│    ├── modules/                    ← Auto-scanned with wikilinks
│    ├── sources/                    ← PRDs, specs, requirements
│    ├── conventions/                ← From agentctx skills (read-only in brain)
│    └── archive/                    ← Superseded pages (never deleted)
│         └── 2026-04/old-auth.md
```

### NEW (v5) — Memory Consolidation Model

From the compound-product progress.txt research, the brain separates **episodic** from **semantic** memory:

| Memory Type | File | What It Contains | Read When |
|---|---|---|---|
| **Episodic** | `log.md` entries | What happened in sync N: changed files, created pages, flagged concepts | Debugging "why did this page change?" |
| **Semantic** | `log.md` top section, `patterns.md` | Reusable patterns distilled from repeated observations: "All API routes use middleware chain" | Every new agent session start |

**Consolidation rule**: Every 10 syncs, promote recurring patterns from log.md entries to the top `## Codebase Patterns` section. Archive old sync entries to `archive/YYYY-MM/`. This prevents context bloat while preserving actionable knowledge.

---

## Part 4: The Brain Agents — With Investigation/Implementation Split

### Agent 1: Brain Sync Agent (Pipeline + Generator + Tool Wrapper)

**NEW (v5 change from Task Explosion Pattern research)**: The sync pipeline's "classify" and "update" phases were combined investigation+implementation. The research is explicit:

> "You must **never combine 'find the problem' with 'fix the problem' in a single task**. These are fundamentally different cognitive operations — one is exploratory, the other is surgical — and mixing them produces vague acceptance criteria."

**Revised sync phases**:

```
Phase 1: INVESTIGATE (Tool Wrapper)
  - Run git diff + AST scan to understand current state
  - Parse diff → classify: new files, changed functions, deleted directories
  - Cross-reference against existing modules/entities → identify what needs changes
  - Exit criteria: structured change map complete

Phase 2: UPDATE (Generator + Pipeline)
  - For each change in the map: create/update pages with wikilinks
  - Mark concept proposals as PROPOSED
  - Exit criteria: all changed pages touched, unchanged pages verified stable

Phase 3: VERIFY (Reviewer — separate from Generator!)
  - Deterministic checks: wikilink resolution, hash comparison, token budgets
  - Heuristic checks: pattern drift, contradiction detection (separate verifier agent per Generator-Verifier research)
  - Exit criteria: all checks pass or flagged

Phase 4: COMMIT (Pipeline)
  - Update routing, index, log, status, patterns, consolidated patterns
```

**This is 4 phases, not 5** — the "Scan" and "Classify" phases from v4 merged into "Investigate" because investigation is the cognitive operation, not the mechanism.

### Agent 2: Brain Generator Agent (NEW v5)

**Why split from Verify**: The Generator-Verifier architecture research shows that self-review is less reliable than separate-agent review. The brain's Generator writes/maintains pages. A separate Verifier reads them back and checks against reality. This is the P-vs-NP principle: "verification is easier than generation."

Generates:
- Module docs from AST scan results
- Entity pages from function signatures + imports
- Concept proposals from cross-module patterns
- Routing table entries from new keywords

### Agent 3: Brain Verifier Agent (NEW v5)

Reads (not writes):
- All pages the Generator created/updated
- Code files that those pages claim to describe
- patterns.md claims against actual code
- Two pages for contradictory claims

Produces a structured report: `Summary → Findings (by severity) → Score → Top 3 Recommendations`

Exactly the Reviewer pattern output format.

**Rubric items** (from `.ctx/references/lint-checklist.md`, swappable):

| Check | Criterion | Severity | Machine-verifiable? |
|---|---|---|---|
| Broken wikilinks | Every `[[type:name]]` resolves to a file | ERROR | Yes — file exists |
| Stale modules | `source-hash` matches git hash | WARNING | Yes — hash comparison |
| Orphan entities | Entity has ≥1 inbound wikilink | WARNING | Yes — backlink grep |
| Missing modules | Every non-test source dir has a module page | ERROR | Yes — dir scan vs catalog |
| Pattern drift | patterns.md claims exist in referenced code | WARNING | Partial — LLM confirm |
| Token overflow | No page exceeds 30K tokens | WARNING | Yes — word count × 0.75 |
| Protocol bloat | `protocol.md` under 500 tokens | ERROR | Yes |
| Contradiction | No two pages claim opposite facts | WARNING | Partial — LLM comparison |
| Orphan concepts | Concept has ≥1 inbound link | INFO | Yes — backlink grep |
| Stale log | Log's last entry ≤7 days old | INFO | Yes — date comparison |
| Missing verification | Source pages exist without verification status | WARNING | Yes — status.md check |

### Agent 4: Brain Synthesis Agent (Human-initiated Inversion)

Same as v4 — proposes concepts, human approves. Never automatic. ETH Zurich: AI-generated context hurts.

---

## Part 5: Guardrails — Input AND Output

### NEW (v5) — Guardrails at Multiple Points

The guardrails hierarchy research is explicit:

> "Guardrails should sit at multiple points: **before input** reaches the model (PII detection, prompt injection checks), **before tool execution** (input validation), and **after output** is generated (hallucination checks, PII leak checks). Neither layer alone is sufficient."

The v4 plan only described post-output guardrails (block hooks on deletion). The v5 plan adds:

| Layer | What | Mechanism |
|---|---|---|
| **Pre-input** | Validate spec/PRD being ingested | Block hooks: reject if contains `<private>` markers, PII patterns |
| **Pre-execution** | Block destructive ops on brain | Block hooks: no deletion of concepts, no overwriting CONFIRMED pages |
| **Post-output** | Validate brain pages are correct | Generator-Verifier split: separate agent checks accuracy |
| **Lifecycle** | Prevent context rot within sessions | SessionStart hook loads minimal context, SessionEnd compresses and persists |

### Three-Tier Boundaries for Brain Operations (Same as v4)

| Action | Tier | Mechanism |
|---|---|---|
| Sync module docs (hash changed) | Always | Auto |
| Update entity signatures | Always | Auto |
| Update routing.md keywords | Always | Auto |
| Append to log.md | Always | Auto |
| Create new concept page | Ask First | PROPOSED status, human review required |
| Change concept description | Ask First | [Proposed change], human approves |
| Archive a page | Ask First | Move to archive/ with date stamp |
| Modify patterns.md | Ask First | Propose pattern change, human reviews |
| Delete entity page | Ask First | Only if no inbound links, human confirms |
| Delete concept page | Never | Concepts archival only |
| Overwrite human-enriched content | Never | Always append with `[Superseded]` |
| Sync without verification passing | Never | Block phase — fix or report stuck |

---

## Part 6: Verification — With Generator-Verifier Split

From layered verification research (deterministic → heuristic → human):

**Layer 1 — Deterministic** (fast, runs every sync, the Generator self-checks):
- Hash comparisons, wikilink resolution, token budgets, directory completeness

**Layer 2 — Heuristic/ML** (runs separate Verifier agent):
- Pattern drift detection, contradiction detection, comprehension debt assessment
- The Verifier agent is a **separate** agent from the Generator (Anthropic dual-agent research)

**Layer 3 — Human** (runs on review):
- Concept page approval, pattern additions/removals, archive decisions

**NEW (v5) — The Verifier as a First-Class Agent**

The v4 plan had the sync agent verify its own work (Phase 4: Verify). Research shows this is suboptimal. The Verifier agent:
- Runs **after** the Generator completes
- Has read-only access to brain pages + source code
- Produces a structured report the Generator cannot edit
- Is the brain-level implementation of the `@reviewer` teammate pattern from code-agent-orchestra research

**Status lifecycle** (per module):
```
UNENRICHED → FRESH → STALE (code changed) → RESYNCED → FRESH → VERIFIED (after human review)
```

---

## Part 7: Cognitive Constraints — The Human Dimension

### NEW (v5) — What the Brain Must NOT Do to Humans

From the "Human Cognitive Limits" cluster (parallel-agent-limit, cognitive-load, comprehension-debt, ambient-anxiety-tax):

1. **The 3-4 agent ceiling**: The brain must not create more supervision work than a human can handle. Each sync should be a single report, not multiple parallel agent outputs to review.

2. **Comprehension debt reduction**: The brain's job is to REDUCE comprehension debt, not add to it. If reading the brain is harder than reading the code, the system failed. This means:
   - Summaries before details (progressive disclosure)
   - One-line token counts in index.md (budget awareness)
   - `log.md` top section has the reusable patterns, not raw per-sync noise

3. **Ambient anxiety tax eliminated**: The brain must give a single definitive answer, not multiple possible answers requiring human judgment. This means the Verifier produces pass/fail, not "here are 4 possible issues."

4. **The METR RCT finding**: Experienced developers were 19% slower with AI while believing they were 20% faster. The brain must track **actual verification time**, not just "sync completed" status. Success = code changed and verified correct, not just code changed.

---

## Part 8: Implementation Plan

### Phase 1: Infrastructure (Days 1-7)

| # | Task | Acceptance Criteria |
|---|---|---|
| 1.1 | `.ctx/` scaffold script | `brain init` produces correct dir structure + templates |
| 1.2 | `brain scan` wrapper | Reuses agentctx scan, outputs `.ctx/modules/` with source-hash |
| 1.3 | `brain diff` | Returns changed vs. unchanged modules by hash comparison |
| 1.4 | `brain status` | Shows: module count, fresh/stale/unenriched, last sync |
| 1.5 | Wikilink parser | Resolves `[[type:name]]` → `.ctx/type/name.md`, returns false if missing |
| 1.6 | Page templates (5 types) | YAML frontmatter, wikilinks, kebab-case, ISO dates |
| 1.7 | `CLAUDE.md` for brain projects | Routing protocol <500 tokens, references `protocol.md` |
| 1.8 | Brain Generator agent definition | 4-phase pipeline, MAX_ITERATIONS=3, kill criteria |
| 1.9 | Brain Verifier agent definition | Separate from Generator, reads rubric from references/ |

### Phase 2: Hook-Driven Sync Engine (Days 8-14)

| # | Task | Acceptance Criteria |
|---|---|---|
| 2.1 | 5-hook lifecycle setup | SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd all wired |
| 2.2 | `/brain-sync` slash command | Runs full 4-phase pipeline, reports created/updated/flagged |
| 2.3 | `/brain-lint` slash command | Structured report with severity grouping, rubric from references/ |
| 2.4 | Entity page creation | From scan results with wikilinks, hashes |
| 2.5 | Cross-linking | module↔entity↔concept bidirectional |
| 2.6 | Log consolidation engine | Promotes patterns every 10 syncs, archives old entries |
| 2.7 | Archive system | Move superseded pages to `archive/YYYY-MM/`, mark in index |
| 2.8 | Fix-and-retry on verification failure | Up to 3 retries per gate, then stop and report |

### Phase 3: Intelligence Layer (Days 15-21)

| # | Task | Acceptance Criteria |
|---|---|---|
| 3.1 | `brain ingest` | Creates source page from PRD/spec, with 5 self-clarification questions |
| 3.2 | Pattern auto-distillation | Detects cross-module patterns (3+ modules share pattern) |
| 3.3 | Concept proposal system | PROPOSED only, human review mandatory |
| 3.4 | Token budget enforcement | Lint fails if page > 30K tokens, protocol > 500 |
| 3.5 | Contradiction detection | LLM: compares claims, flags opposites |
| 3.6 | Guardrails setup | Block hooks for concepts deletion, warn hooks for modifications |

### Phase 4: Integration with agentctx (Days 22-28)

| # | Task | Acceptance Criteria |
|---|---|---|
| 4.1 | Merge brain into agentctx CLI | `agentctx brain sync` works as standalone `brain sync` |
| 4.2 | Share AST scanner | No code duplication, brain reuses agentctx scan |
| 4.3 | Brain in multi-tool outputs | CLAUDE.md, .cursorrules include brain routing |
| 4.4 | Dashboard brain tab | Fresh/stale counts, sync controls, verifier report |
| 4.5 | E2E test on experiment-on-trpc | 169 modules → brain enriches → queries work |
| 4.6 | Documentation | README.md covers brain as additional layer |
| 4.7 | Unit tests | Scan, sync, lint, wikilink, verification |

---

## Part 9: Success Criteria

A developer creates auth (login page + backend + DB):

1. **Sync speed**: `/brain-sync` completes in < 2 min for 169 modules
2. **Module coverage**: 100% of non-test dirs have module docs after sync
3. **Cross-link density**: Each new entity has ≥2 inbound wikilinks (module + concept)
4. **Zero broken links**: `/brain-lint` returns 0 errors after sync
5. **Comprehension debt reduction**: Query "how does auth work here?" → synthesized answer citing pages in < 3 seconds
6. **Human-in-the-loop**: 0 concept pages auto-created without PROPOSED status
7. **Token budgets**: No page > 30K tokens, protocol < 500
8. **Generator-Verifier agreement**: Verifier produces structured pass/fail, no human review required for Layer 1 checks
9. **Memory consolidation**: After 10 syncs, `log.md` top section has promoted patterns, old entries not needed for comprehension
10. **Lifecycle hooks active**: SessionStart loads minimal context, SessionEnd persists observations, PostToolUse marks stale modules

---

## Part 10: What We're NOT Building (Honor the Research, Updated)

1. **No fully-auto concept pages** — ETH Zurich: AI context hurts. PROPOSED by AI, REVIEWED by human.
2. **No agent swarms for sync** — 3-5 agent ceiling, cognitive load. Brain makes each agent better, not more numerous.
3. **No monolithic dump** — Progressive disclosure: routing.md (400t) → index.md → page. If protocol > 500, lint errors.
4. **No CLAUDE.md-as-security** — $30K incident. Block hooks for critical, not instructions.
5. **No replacement for agentctx** — Brain is layer ON TOP. agentctx does scanning, output, skills, dashboard, agents.
6. **No vibe coding** — Brain documents what exists, doesn't generate code.
7. **No self-verification** — Generator and Verifier are separate agents (Anthropic/DeepMind/Meta convergence).
8. **No combined investigation+implementation** — Same cognitive ops conflict. Sync separates them into phases.
9. **No CLAUDE.md-only guardrails** — Guardrails at input, execution, and output layers.
