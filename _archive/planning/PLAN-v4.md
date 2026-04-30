# Code Brain — Self-Maintaining Context Wiki for Code (v4)

## Context

After reading all 10 topic clusters from the agentctx-idea wiki (73 concepts, 17 sources), the plan has been comprehensively revised. The v3 plan was structurally correct but architecturally shallow — it described directories and commands but didn't incorporate the distributed decision-making model, verification layers, skill patterns, guardrails, or cognitive constraints that Osmani's research documents.

This v4 plan is organized as the wiki organizes knowledge: by principle, with concrete implementation derived from established patterns.

---

## Part 1: How Agents "Take Decisions" — The Distributed Model

**Core insight from Osmani's research**: Agents don't decide. The architecture decides across six phases:

```
Spec → Analysis → Planning → Execution → Verification → Retro
```

The brain is not an agent. It is the **context layer** consulted by every agent at each phase:

| Phase | Agent Pattern | Brain Consults | Brain Records |
|---|---|---|---|
| Spec | Inversion | existing concepts/sources | the spec as a source page |
| Analysis | Tool Wrapper | architecture.md + patterns.md | nothing (read-only) |
| Planning | Generator | module-index + entities | new concept proposals |
| Execution | Pipeline | relevant concept + entity pages | module doc updates |
| Verification | Reviewer | patterns.md + conventions + prior status | verification status per module |
| Retro | Generator | nothing | updates modules, entities, concepts, patterns, log |

**The brain's decision model is reactive, not proactive**: it observes what was built, records it, links it, and flags discrepancies. It proposes concept pages but never auto-creates them (ETH Zurich: AI-generated context hurts 3%, costs 20% more).

---

## Part 2: Architecture — The Five Composable Brain Services

Each brain service maps to one of the 5 skill design patterns from the Google ADK article:

| Brain Service | Skill Pattern | What It Does | Trigger |
|---|---|---|---|
| **Scan** | Tool Wrapper | Reads code, injects module context on-demand | `brain scan`, git commit |
| **Enrich** | Generator | Produces structured entity/concept pages from modules | `brain sync` |
| **Verify** | Reviewer | Checks brain accuracy against code (lint) | `brain lint`, post-commit |
| **Sync Pipeline** | Pipeline | scan → classify → update → verify → commit (5 gates) | `brain sync`, git hook |
| **Ingest** | Inversion | Interviews user about a spec/PRD before creating source page | `brain ingest` |

### The Sync Pipeline (replaces the flat "brain sync" from v3)

```
┌─────────────────────────────────────────────────────────┐
│ PHASE 1: SCAN (Tool Wrapper)                           │
│ - Run AST scan on changed directories                   │
│ - Generate/update .ctx/modules/*.md with new hashes    │
│ - Exit criteria: all changed dirs have module docs      │
│ Gate: if scan fails → report, stop                      │
├─────────────────────────────────────────────────────────┤
│ PHASE 2: CLASSIFY (Generator)                          │
│ - Parse git diff → classify: new files, changed, deleted│
│ - Map changes to entities, concepts, patterns, routes   │
│ - Identify investigation candidates (new domain?)       │
│ - Exit criteria: change classification complete          │
│ Gate: no classification → skip to update phase only     │
├─────────────────────────────────────────────────────────┤
│ PHASE 3: UPDATE (Generator + Pipeline)                 │
│ - Create/update entity pages with wikilinks            │
│ - Update module docs with function signatures           │
│ - Flag concepts whose description no longer matches code│
│ - Propose new concept pages if new domain detected      │
│ - Exit criteria: all affected pages touched              │
│ Gate: if concept proposed → mark "PROPOSED" for human   │
├─────────────────────────────────────────────────────────┤
│ PHASE 4: VERIFY (Reviewer)                             │
│ - Check: wikilinks resolve (broken link = error)        │
│ - Check: source-hash matches current code (stale = warn)│
│ - Check: no orphan entities (no inbound links = warn)   │
│ - Check: token budgets per page (over 30K = warn)       │
│ - Cross-ref: patterns.md claims match actual code       │
│ - Exit criteria: all checks pass or flagged              │
│ Gate: if errors found → fix-and-retry (MAX 3 retries)   │
├─────────────────────────────────────────────────────────┤
│ PHASE 5: COMMIT (Pipeline)                             │
│ - Update routing.md with new keywords                   │
│ - Update index.md catalog                                │
│ - Append structured entry to log.md                     │
│ - Update status.md (fresh/stale/unenriched counts)      │
│ - Distill patterns.md if cross-module pattern detected  │
│ - Exit criteria: all metadata updated                    │
└─────────────────────────────────────────────────────────┘
```

**Kill criteria** (from quality gates research): If sync is stuck after 3+ retries, stop and report "sync blocked: [reason]" rather than silently burning tokens. This is the [MAX_ITERATIONS=3] enforcement from the factory model.

---

## Part 3: Directory Structure — With Guardrails

```
your-project/
├── .agentctx/                       ← Existing agentctx (unchanged)
│   ├── context/
│   ├── conventions/
│   └── ...
│
├── .ctx/                            ← The Brain
│   ├── protocol.md                  ← Layer 1: <500 tokens always
│   ├── index.md                     ← Content catalog with token counts
│   ├── routing.md                   ← Keyword → cluster → page (400 tokens)
│   ├── overview.md                  ← State summary + recent activity
│   ├── log.md                       ← Append-only, parseable entries
│   ├── status.md                    ← Fresh/stale/unenriched per module
│   ├── patterns.md                  ← Cross-cutting patterns (auto-distilled)
│   │
│   ├── concepts/                    ← Wiki-style (PROPOSED → REVIEWED → CONFIRMED)
│   │   ├── authentication.md        ← Human-enriched or human-reviewed
│   │   └── _template.md
│   │
│   ├── entities/                    ← Mostly auto-generated with hash tracking
│   │   ├── auth-service.md
│   │   └── _template.md
│   │
│   ├── modules/                     ← Auto-scanned (agentctx scan format + wikilinks)
│   │   ├── auth.md
│   │   └── _template.md
│   │
│   ├── sources/                     ← PRDs, specs, requirements
│   │   └── auth-spec.md
│   │
│   ├── conventions/                 ← From agentctx skills (read-only in brain)
│   │
│   └── archive/                     ← Superseded pages (never deleted)
│       └── 2026-04/old-auth-strategy.md
```

### Three-Tier Boundaries for Brain Auto-Updates

From the Always/Ask/Never constraint system, the brain's own auto-update rules:

**Always (auto)**: Update module docs (hash changed), update entity signatures (new function detected), update routing.md keywords, append to log.md, update status.md counts.

**Ask First (propose, don't apply)**: Create new concept pages (mark as PROPOSED), change existing concept descriptions, archive pages, modify patterns.md, delete any entity.

**Never (block)**: Delete a concept page, overwrite human-enriched content without flagging, auto-merge contradictory claims (flag as `[Contradicted YYYY-MM-DD]` instead), sync without verification phase passing.

### Memory Persistence — All Four Channels

The brain implements all four memory channels from the Ralph Wiggum research:

| Channel | Implementation | Read When |
|---|---|---|
| **Git history** | `source-hash` in every module frontmatter → diff against HEAD | Sync phase |
| **Progress log** | `.ctx/log.md` — chronological, parseable entries | Every session start (recent 5 entries) |
| **Task state** | `.ctx/status.md` — fresh/stale/unenriched per module | Sync phase entry criteria |
| **Semantic memory** | `.ctx/concepts/` + `.ctx/entities/` + `.ctx/patterns.md` | When agent reads relevant brain page |

### Anti-Bloat Mechanisms (Context Bloat + Pink Elephant Problem)

From the wiki research on context degradation:

1. **Progress log consolidation**: `.ctx/log.md` has a `## Recent Patterns` section at the TOP (like progress.txt's Codebase Patterns). Raw per-sync entries go below. Every 10 syncs, consolidate: promote recurring patterns to top, archive old entries to `archive/`.

2. **Token budgets per page**: routing.md (< 400 tokens), protocol.md (< 500 tokens), individual pages (< 30K tokens). Lint enforces these (from token economics research).

3. **Token surfacing in index.md**: Each entry shows token count so agents can make context-budget decisions: `- [[authentication]] — 2.3K tokens — How auth works (JWT + refresh rotation)`

4. **Archival strategy**: Superseded concept pages move to `archive/YYYY-MM/` instead of deletion. Original remains for historical context. Index entry marked `[Superseded YYYY-MM-DD]`.

---

## Part 4: The Brain Agents — Designed from Skill Patterns

### Agent 1: Brain Sync Agent (Pipeline + Generator + Tool Wrapper)

**Triggers**: Git commit (via settings.json hook), `/brain-sync` slash command.

**Personality**: Fact-recording only. No hallucination. No architecture decisions. "I observe what was built, I don't decide what should exist."

MAX_ITERATIONS: 3 (kill criteria from quality gates research).

**Phases**:
1. **Scan** (Tool Wrapper) — Load codebase context for changed directories only (context isolation principle)
2. **Classify** (Generator) — Parse diff into structured changes (investigate first, then classify from the task explosion pattern)
3. **Update** (Generator) — Create/update entities, flag concepts, propose new concepts as PROPOSED
4. **Verify** (Reviewer) — Run the full lint checklist with boolean pass/fail criteria
5. **Commit** (Pipeline) — Update routing, index, log, status, patterns. Only if verification passes.

**Fix-and-retry**: If verification finds broken wikilinks or stale hashes, attempt to fix and re-verify. After 3 retries → stop, report blocked items.

### Agent 2: Brain Linter Agent (Reviewer Pattern)

**Triggers**: `/brain-lint` slash command.

The Reviewer pattern separates "what to check" from "how to check". The brain's review checklist lives in `.ctx/references/lint-checklist.md` (swappable rubric).

**Rubric items** (all machine-verifiable — boolean pass/fail):

| Check | Criterion | Severity | Machine-verifiable? |
|---|---|---|---|
| Broken wikilinks | Every `[[type:name]]` resolves to a file | ERROR | Yes — file exists check |
| Stale modules | `source-hash` in frontmatter matches git hash | WARNING | Yes — hash comparison |
| Orphan entities | Entity has ≥1 inbound wikilink from another page | WARNING | Yes — backlink grep |
| Missing modules | Every non-test source directory has a module page | ERROR | Yes — dir scan vs catalog |
| Pattern drift | Each claims in patterns.md exists in referenced code | WARNING | Partial — needs LLM confirm |
| Token overflow | No page exceeds 30K tokens | WARNING | Yes — word count × 0.75 |
| Protocol bloat | `protocol.md` under 500 tokens | ERROR | Yes |
| Contradiction | No two pages claim opposite facts about same thing | WARNING | Partial — LLM comparison |
| Orphan concepts | Concept has ≥1 inbound link | INFO | Yes — backlink grep |
| Stale log | Log's last entry ≤7 days old | INFO | Yes — date comparison |

Output: `brain-lint-report.md` with findings grouped by severity (error/warning/info), exactly matching the Reviewer pattern output format: Summary → Findings (by severity) → Score → Top 3 Recommendations.

### Agent 3: Brain Synthesis Agent (Inversion + Generator)

**Triggers**: `/brain-synthesize` — human-initiated, never automatic.

**Why never automatic**: ETH Zurich study — AI-generated context reduces success 3%, increases cost 20%. Human review is mandatory.

**How it works (Inversion pattern)**:
1. Read all entity and module pages
2. Identify cross-cutting themes (e.g., "5 modules use provider-switching pattern")
3. **DO NOT create concept pages**. Instead, propose them:
   ```
   PROPOSAL: .ctx/concepts/provider-switching.md
   Evidence: modules/auth.md, modules/email.md, modules/sms.md, modules/media.md, modules/ai.md
   Draft content: [proposed draft]
   Status: AWAITING REVIEW
   ```
4. Wait for human to review/enrich/approve
5. Only after human approval: create the page with status = `REVIEWED`

**Self-clarification** (5 questions before generating):
1. What domain does this span? (Which modules?)
2. What's the common pattern? (Shared structure?)
3. What makes this concept specific to THIS project? (Not generic?)
4. What are the success criteria? (How do we know the page is useful?)
5. What are the constraints? (What should this page NOT cover?)

---

## Part 5: Guardrails Enforcement

From the guardrails hierarchy research (CLAUDE.md → warn hooks → block hooks):

### What Goes Where

**CLAUDE.md** (model-interpreted, can be overridden):
- Brain routing instructions: "Always read protocol.md first, then routing.md, then specific page"
- Tone guidelines: factual, no hallucination
- Page format conventions

**Warn hooks** (non-blocking alerts):
- `PostToolUse`: If agent modifies a concept page with status=CONFIRMED, warn "this page was human-approved"
- `PostToolUse`: If sync creates entity pages, flag for review in status.md

**Block hooks** (unconditional, exit code 2):
- `PreToolUse`: Block deletion of any `.ctx/concepts/*.md` file (concepts are never auto-deleted, only archived)
- `PreToolUse`: Block modification of any file with human-authored marker in frontmatter
- `PreToolUse`: Block any file write that would exceed 30K token limit

This matches the $30K API key incident lesson: "Never hardcode secrets" in CLAUDE.md didn't stop the leak. Only block hooks enforce constraints unconditionally.

### Three-Tier Boundaries for Brain Operations

| Action | Tier | Mechanism |
|---|---|---|
| Sync module docs (hash changed) | Always | Auto |
| Update entity signatures | Always | Auto |
| Update routing.md keywords | Always | Auto |
| Append to log.md | Always | Auto |
| Create new concept page | Ask First | PROPOSED status, human review required |
| Change concept description | Ask First | [Proposed change] vs existing, human approves |
| Archive a page | Ask First | Move to archive/ with date stamp |
| Modify patterns.md | Ask First | Propose pattern change, human reviews |
| Delete entity page | Ask First | Only if no inbound links, human confirms |
| Delete concept page | Never | Concepts are archival only (move to archive/) |
| Overwrite human-enriched content | Never | Always append with `[Superseded]`, never replace |
| Sync without verification passing | Never | Block phase — fix or report stuck |

---

## Part 6: Verification — Three-Tier Model Applied to the Brain

From layered verification research (deterministic → heuristic → human):

**Layer 1 — Deterministic** (fast, runs on every sync):
- Hash comparisons (source-hash vs. current)
- Wikilink resolution (file exists?)
- Token budget checks (under limits?)
- Directory completeness (all source dirs have modules?)

**Layer 2 — Heuristic/ML** (runs on `/brain-lint`):
- Pattern drift detection (does code still match patterns.md claims?)
- Contradiction detection (do two pages claim opposite things?)
- Comprehension debt check (has the brain produced code the human hasn't reviewed?)

**Layer 3 — Human** (runs on review):
- Concept page approval (PROPOSED → REVIEWED → CONFIRMED)
- Pattern additions/removals
- Archive decisions

**Status lifecycle** (per module):
```
UNENRICHED → FRESH → STALE (code changed) → RESYNCED → FRESH
                                                    ↓
                                               VERIFIED (after human review)
```

---

## Part 7: Implementation Plan

### Phase 1: Infrastructure (Days 1-7)

| # | Task | Pattern | Acceptance Criteria |
|---|---|---|---|
| 1.1 | Create `.ctx/` scaffold script | Generator | `brain init` produces correct directory structure with templates |
| 1.2 | Implement `brain scan` wrapper | Tool Wrapper | Reuses agentctx scan, outputs `.ctx/modules/` with source-hash |
| 1.3 | Implement `brain diff` | Tool Wrapper | Returns changed vs. unchanged modules by hash comparison |
| 1.4 | Implement `brain status` | Generator | Shows: module count, fresh/stale/unenriched, last sync date |
| 1.5 | Wikilink parser | Generator | Resolves `[[type:name]]` → `.ctx/type/name.md`, returns false if missing |
| 1.6 | Page templates (5 types) | Generator | All templates use YAML frontmatter, wikilinks, kebab-case |
| 1.7 | `CLAUDE.md` for brain-using projects | Generator | Defines routing protocol (<500 tokens), references `protocol.md` |
| 1.8 | Brain sync agent definition | Pipeline + Generator | Defines 5-phase pipeline, MAX_ITERATIONS=3, kill criteria |
| 1.9 | Brain linter agent definition | Reviewer | Defines rubric in `.ctx/references/lint-checklist.md` |

### Phase 2: Sync Engine (Days 8-14)

| # | Task | Pattern | Acceptance Criteria |
|---|---|---|---|
| 2.1 | Sync pipeline implementation | Pipeline | All 5 phases run sequentially with gate enforcement |
| 2.2 | Git hook integration | Tool Wrapper | settings.json post-commit hook triggers `/brain-sync` |
| 2.3 | `/brain-sync` slash command | Inversion + Pipeline | Runs full sync, reports: created X, updated Y, flagged Z |
| 2.4 | `/brain-lint` slash command | Reviewer | Produces structured report with severity grouping |
| 2.5 | Entity page creation | Generator | Creates from scan results, with wikilinks, hashes |
| 2.6 | Cross-linking engine | Generator | Links module↔entity↔concept bidirectionally |
| 2.7 | Broken wikilink detection | Reviewer | Finds unresolved `[[wikilinks]]`, reports as ERROR |
| 2.8 | Stale module detection | Tool Wrapper | Compares stored hash vs. git hash |
| 2.9 | Orphan entity detection | Reviewer | Finds entities with 0 inbound wikilinks |
| 2.10 | Fix-and-retry on verification failure | Pipeline | Up to 3 retries per gate, then stop and report |

### Phase 3: Intelligence Layer (Days 15-21)

| # | Task | Pattern | Acceptance Criteria |
|---|---|---|---|
| 3.1 | `brain ingest` command | Inversion | Creates source page from PRD/spec, with 5 self-clarification questions |
| 3.2 | Pattern auto-distillation | Generator | Detects cross-module patterns (e.g., "provider-switching" in 3+ modules) |
| 3.3 | Concept proposal system | Inversion + Generator | Proposes concepts as PROPOSED, never auto-creates |
| 3.4 | Token budget enforcement | Reviewer | Lint fails if any page > 30K tokens, protocol > 500 |
| 3.5 | Archival system | Pipeline | Move superseded pages to `archive/YYYY-MM/`, mark in index |
| 3.6 | Log consolidation | Generator | Every 10 syncs, promote patterns to top, archive old entries |
| 3.7 | Token surfacing in index | Generator | Each entry: `[[name]] — 2.3K tokens — summary` |
| 3.8 | Contradiction detection | Reviewer | LLM-level: compares claims across pages, flags opposites |
| 3.9 | Three-tier guardrails setup | Tool Wrapper | Block hooks for sensitive operations, warn hooks for review items |

### Phase 4: Integration with agentctx (Days 22-28)

| # | Task | Pattern | Acceptance Criteria |
|---|---|---|---|
| 4.1 | Merge brain commands into agentctx CLI | Tool Wrapper | `agentctx brain sync` works identically to `brain sync` |
| 4.2 | Share AST scanner | Tool Wrapper | Brain scan reuses agentctx scan, no duplication |
| 4.3 | Brain content in multi-tool outputs | Generator | CLAUDE.md, .cursorrules, etc. include brain routing |
| 4.4 | Dashboard brain tab | Generator | Shows fresh/stale counts, recent activity, sync controls |
| 4.5 | End-to-end test on experiment-on-trpc | Pipeline | 169 modules → brain enriches → concepts link → queries work |
| 4.6 | Documentation | Generator | README.md covers the brain as an additional layer |
| 4.7 | Tests for scan, sync, lint, wikilink | Reviewer | Unit tests for core logic |

---

## Part 8: Success Criteria — Measurable

A developer creates auth (login page + backend + DB):

1. **Sync speed**: `/brain-sync` completes in < 2 min for a project of 169 modules (token budget, not raw iteration count)
2. **Module coverage**: 100% of non-test source directories have module docs after sync
3. **Cross-link density**: Each new entity has ≥2 inbound wikilinks (from module + concept)
4. **No broken links**: `/brain-lint` returns 0 errors after sync
5. **Comprehension debt reduction**: Developer can query "how does auth work here?" and get a synthesized answer citing specific pages in < 3 seconds
6. **Human-in-the-loop preserved**: 0 concept pages auto-created without PROPOSED status; at least 1 concept reviewed and approved by human
7. **Token budgets enforced**: No page exceeds 30K tokens, protocol stays under 500 tokens

---

## Part 9: What We're NOT Building (Honor the Research)

1. **No fully-auto concept pages** — ETH Zurich: AI context hurts (3% less success, 20% more cost). Concepts are PROPOSED by AI, REVIEWED by human.
2. **No agent swarms for sync** — Osmani: 3-5 agent ceiling, ambient anxiety tax, comprehension debt. The brain makes each agent better, not more numerous.
3. **No monolithic context dump** — Progressive disclosure: routing.md (400t) → index.md (cluster) → page. If protocol > 500 tokens, lint errors.
4. **No CLAUDE.md-as-security** — $30K API key incident proved CLAUDE.md is a suggestion, not enforcement. Block hooks for critical operations.
5. **No replacement for agentctx** — The brain is a layer ON TOP. agentctx handles scanning, multi-tool output, skills, dashboard, 156 agents.
6. **No vibe coding enabler** — The brain documents what exists; it doesn't generate code. It bridges the 70% gap by preserving engineering knowledge.
