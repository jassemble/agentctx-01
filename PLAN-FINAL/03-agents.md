# Agents — Roles, Pipelines, and Handoffs

## Core Principle: Generator-Verifier Split

The Generator and Verifier are **separate** agents. Self-review is less reliable than separate-agent review. See [[05-guardrails-and-constraints]] for why this matters.

## The 4 Brain Agents

### Agent 1: Brain Generator Agent

**Role**: Writes/maintains brain pages from brain's graph output.

**Pattern**: Generator + Pipeline

**Reads from brain**:
- `graph.json` — nodes (entities, functions, classes), edges (imports, calls, semantic), communities
- `GRAPH_REPORT.md` — god nodes, surprising connections, knowledge gaps, ambiguous edges
- `wiki/` — community articles, god node articles

**Generates**:
- Module docs from brain nodes (file_type=code, grouped by source_file directory)
- Entity pages from brain nodes (classes, services, models) with confidence-scored edges
- Concept proposals (marked PROPOSED) from brain's cross-community patterns and hyperedges
- Routing table entries from brain's god node labels + community labels
- Cross-links between modules, entities, and concepts using brain edge data

**Does NOT**:
- Run AST extraction (brain handles this)
- Run semantic extraction (brain handles this)
- Run community detection (brain handles this)
- Make architecture decisions
- Auto-create concept pages without PROPOSED status
- Verify its own work (separate Verifier handles this)

**MAX_ITERATIONS**: 3 (kill criteria — stop and report blocked after 3 retries)

---

### Agent 2: Brain Verifier Agent

**Role**: Reads pages back against code to check accuracy. **Separate** from Generator.

**Pattern**: Reviewer

**Checks** (all machine-verifiable — boolean pass/fail):

| Check | Criterion | Severity | Machine-verifiable? |
|---|---|---|---|
| Broken wikilinks | Every `[[type:name]]` resolves to a file | ERROR | Yes — file exists |
| Stale modules | `source-hash` in frontmatter matches git hash | WARNING | Yes — hash comparison |
| Orphan entities | Entity has >=1 inbound wikilink from another page | WARNING | Yes — backlink grep |
| Missing modules | Every non-test source directory has a module page | ERROR | Yes — dir scan vs catalog |
| Pattern drift | patterns.md claims exist in referenced code | WARNING | Partial — LLM confirm |
| Token overflow | No page exceeds 30K tokens | WARNING | Yes — word count * 0.75 |
| Protocol bloat | protocol.md under 500 tokens | ERROR | Yes |
| Contradiction | No two pages claim opposite facts about same thing | WARNING | Partial — LLM comparison |
| Orphan concepts | Concept has >=1 inbound link | INFO | Yes — backlink grep |
| Stale log | Log's last entry <=7 days old | INFO | Yes — date comparison |
| Missing verification | Source pages exist without verification status in status.md | WARNING | Yes — status.md check |
| Low-confidence edges | INFERRED edges with confidence < 0.5 flagged for human review | INFO | Yes — frontmatter confidence field |
| EXTRACTED edge validity | EXTRACTED edges resolve to actual code references (import/call) | WARNING | Yes — AST cross-check |
| Community map staleness | community_map.md clusters match current module relationships | WARNING | Partial — Leiden re-run |

**Output Format**: `brain-lint-report.md` — structured report with: Summary → Findings (grouped by severity) → Score → Top 3 Recommendations

**Swappable rubric**: The checklist lives in `.ctx/references/lint-checklist.md` so it can be changed without modifying the agent definition itself. The Reviewer pattern separates **what to check** from **how to check**.

---

### Agent 3: Brain Synthesis Agent

**Role**: Distills patterns across modules, proposes new concept pages. **Human-initiated** — never automatic.

**Pattern**: Inversion + Generator (follows the Inversion pattern)

**How it works**:
1. Read brain's `GRAPH_REPORT.md` — god nodes, surprising connections, hyperedges, knowledge gaps
2. Read brain's community articles (`.ctx/graph/wiki/`) for cross-cluster themes
3. Query brain MCP: `god_nodes`, `get_community`, `shortest_path` for deeper exploration
4. Identify cross-cutting themes (e.g., "5 modules use provider-switching pattern" — visible as a hyperedge in graph.json)
5. **DO NOT** create concept pages — instead, propose them:
   ```
   PROPOSAL: .ctx/concepts/provider-switching.md
   Evidence: modules/auth.md, modules/email.md, modules/sms.md
   Draft content: [proposed draft]
   Status: AWAITING REVIEW
   ```
4. Wait for human review/enrichment/approval
5. Only after human approval: create the page with status = REVIEWED

**Self-clarification** (5 questions before generating concept proposals):
1. What domain does this span? (Which modules?)
2. What's the common pattern? (Shared structure?)
3. What makes this concept specific to THIS project? (Not generic?)
4. What are the success criteria? (How do we know the page is useful?)
5. What are the constraints? (What should this page NOT cover?)

**Why human-initiated**: ETH Zurich study — AI-generated context reduces success 3%, increases cost 20%. Human review is **mandatory** for concept pages.

---

### Agent 4: Brain Maintenance Agent

**Role**: Orchestrates the full 4-phase sync pipeline on commit. Also handles skill re-detection on sync — if new stack signals appear (e.g., a `Dockerfile` was added), it suggests installing the matching skill.

**Pattern**: Pipeline (coordinates Generator + Verifier)

**Trigger**: Git commit (via settings.json hook) or `/brain-sync` slash command.

**Skill detection on sync**: After Phase 1 (EXTRACT), the agent runs `brain detect-skills --quiet` to compare the current project structure against `.ctx/skills/manifest.json`. If new signals are found (new `go.mod`, new `Dockerfile`, etc.), it prints a 1-line suggestion — "Ask First", not auto-install. This same check also runs per-prompt via a `UserPromptSubmit` hook (~5ms, zero API tokens).

## The 4-Phase Sync Pipeline

The sync pipeline separates investigation from implementation (task explosion pattern) and Generator from Verifier. **Phase 1 delegates to brain** for extraction and clustering:

```
Phase 1: EXTRACT (brain — Tool Wrapper)
  - Run `brain . --update` (incremental — only changed files re-extracted)
  - brain handles: AST extraction (25 languages), semantic extraction (LLM),
    Leiden clustering, confidence scoring, god node analysis
  - Outputs: updated graph.json, graph.html, GRAPH_REPORT.md, wiki/
  - brain's cache (SHA256 per-file) ensures unchanged files cost 0 tokens
  - Exit criteria: graph.json updated, GRAPH_REPORT.md regenerated
  Gate: if no files changed (brain manifest check) -> skip to lightweight sync

Phase 2: UPDATE (Brain Generator)
  - Read brain outputs (graph.json nodes/edges, GRAPH_REPORT.md, wiki/)
  - For each new/changed node in graph:
    - Create/update module docs from brain file-level nodes
    - Create/update entity pages from brain class/service/function nodes
    - Populate wikilinks from brain edges (with confidence scores)
    - Flag concepts whose description no longer matches code
    - Propose new concept pages from brain's cross-community patterns,
      hyperedges, and surprising connections (marked PROPOSED)
  - Populate community_map.md from brain cluster output (with cohesion scores)
  - Exit criteria: all changed pages touched, unchanged pages verified stable
  Gate: if concept proposed -> mark "PROPOSED" for human review
  Gate: if entity created -> add to status.md tracking

Phase 3: VERIFY (Brain Verifier — separate from Generator!)
  - Deterministic checks: wikilink resolution, token budgets, edge confidence
  - Cross-reference .ctx/ pages against graph.json:
    - EXTRACTED edges must match actual brain AST data
    - INFERRED edges with confidence < 0.5 flagged for review
    - AMBIGUOUS edges from GRAPH_REPORT.md surfaced
  - Heuristic checks: pattern drift, contradiction detection (separate agent)
  - Check brain GRAPH_REPORT.md for knowledge gaps, ambiguous edges
  - If any ERROR found: fix-and-retry (MAX 3 retries)
  - If still failing after 3 retries: stop, report "sync blocked: [reason]"
  - Exit criteria: all checks pass or flagged for manual review
  Gate: no errors -> proceed to commit; errors -> fix-and-retry

Phase 4: COMMIT (Pipeline)
  - Update routing.md with keywords from brain god nodes + community labels
  - Update index.md catalog (fingerprints from graph.json node attributes)
  - Append structured entry to log.md:
    ## [YYYY-MM-DD] sync
    Status: complete | blocked
    Changed modules: X
    New entities: Y
    Updated entities: Z
    Concept proposals: N
    Graph: N nodes, M edges, K communities
    Confidence: X% EXTRACTED, Y% INFERRED, Z% AMBIGUOUS
  - Update status.md (fresh/stale/unenriched/verified counts)
  - Distill patterns.md from brain's cross-community patterns + hyperedges
  - Exit criteria: all metadata updated, log entry persisted
```

### Error Recovery & Escalation Ladder

The sync pipeline uses a 4-tier escalation strategy — not just "stop and report." Each tier is progressively more expensive and human-involving:

```
Tier 1: FIX-AND-RETRY (automatic)
  - Verifier finds ERROR → Generator fixes → re-verify
  - MAX 3 retries per gate
  - Cost: tokens only, no human time

Tier 2: FORCED REFLECTION (automatic, after 3 retries)
  - Agent pauses and answers: "What failed? What specific change would
    fix it? Am I repeating the same approach?"
  - If reflection produces a new approach → 1 more retry with fresh strategy
  - If same approach → escalate to Tier 3

Tier 3: KILL + REASSIGN (automatic)
  - Kill the stuck agent, spawn fresh agent with clean context
  - Fresh agent reads only: the error report + relevant .ctx/ pages
  - No accumulated confusion from prior attempts
  - If fresh agent also fails → escalate to Tier 4

Tier 4: HUMAN ESCALATION (manual)
  - Report "sync blocked: [reason]" with:
    - What was attempted (all tiers)
    - Which files/pages are affected
    - Suggested manual fix
  - Partial sync results are preserved (completed phases committed)
  - Human can resume from the blocked phase after fixing
```

**Idle detection**: If no new page created/updated in 5 consecutive retries, skip to Tier 3 immediately — the agent is looping without progress.

**Budget pause**: At 85% of per-sync token budget, auto-pause and notify human. Prevents runaway costs from stuck loops.

**Partial sync recovery**: Phases 1-2 results are committed independently. If Phase 3 (VERIFY) blocks, the generated pages still exist — only verification status is incomplete. The next sync can resume from Phase 3 without re-running extraction and generation.

---

## SDLC Phase Agents

Each SDLC phase has a Generator + Verifier pair:

| Phase | Generator Pattern | Verifier Pattern | Trigger Phrases |
|---|---|---|---|
| Requirements | Generator + Inversion | Reviewer | "gather requirements", "write a PRD" |
| Design | Generator + Pipeline | Reviewer | "design architecture", "system design" |
| Implementation | Generator + Pipeline (RED-GREEN-REFACTOR) | Reviewer + PR Contract | "implement feature", "build component" |
| Testing | Generator + Inversion | Reviewer (anti-demo-trap) | "write tests for", "test coverage" |
| Deployment | Pipeline only | Reviewer (readiness checks) | "deploy to production", "CI/CD" |
| Maintenance | Generator + Compound Learning | Reviewer | "fix bug", "improve performance" |

The Generator writes artifacts (PRD, architecture doc, code, test plan, deployment plan, bug fix). The Verifier checks them against a rubric (boolean pass/fail per item). The Verifier produces a structured report that the Generator cannot edit.

See also: [[02-architecture]] for the layer structure, [[04-memory-and-lifecycle]] for how agents interact with memory, [[06-implementation]] for task breakdown.
