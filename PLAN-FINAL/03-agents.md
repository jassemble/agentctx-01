# Agents — Roles, Pipelines, and Handoffs

## Core Principle: Generator-Verifier Split

The Generator and Verifier are **separate** agents. Self-review is less reliable than separate-agent review. See [[05-guardrails-and-constraints]] for why this matters.

## The 4 Brain Agents

### Agent 1: Brain Generator Agent

**Role**: Writes/maintains brain pages from facts.

**Pattern**: Generator + Pipeline

**Generates**:
- Module docs from AST scan results
- Entity pages from function signatures, imports, and code structure
- Concept proposals (marked PROPOSED) from cross-module patterns
- Routing table entries from newly detected keywords
- Cross-links between modules, entities, and concepts

**Does NOT**:
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

**Output Format**: `brain-lint-report.md` — structured report with: Summary → Findings (grouped by severity) → Score → Top 3 Recommendations

**Swappable rubric**: The checklist lives in `.ctx/references/lint-checklist.md` so it can be changed without modifying the agent definition itself. The Reviewer pattern separates **what to check** from **how to check**.

---

### Agent 3: Brain Synthesis Agent

**Role**: Distills patterns across modules, proposes new concept pages. **Human-initiated** — never automatic.

**Pattern**: Inversion + Generator (follows the Inversion pattern)

**How it works**:
1. Read all entity and module pages
2. Identify cross-cutting themes (e.g., "5 modules use provider-switching pattern")
3. **DO NOT** create concept pages — instead, propose them:
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

**Role**: Orchestrates the full 4-phase sync pipeline on commit.

**Pattern**: Pipeline (coordinates Generator + Verifier)

**Trigger**: Git commit (via settings.json hook) or `/brain-sync` slash command.

## The 4-Phase Sync Pipeline

The sync pipeline separates investigation from implementation (task explosion pattern) and Generator from Verifier:

```
Phase 1: INVESTIGATE (Tool Wrapper)
  - Run AST scan on changed directories only (context isolation)
  - Run git diff against last known state (hash comparison from status.md)
  - Parse diff -> classify: new files, changed functions, deleted directories
  - Cross-reference against existing modules/entities -> identify what needs changes
  - Exit criteria: structured change map complete
  Gate: if no changes -> skip to update phase (lightweight sync only)

Phase 2: UPDATE (Generator)
  - For each change in the map:
    - Create/update module docs (hash changed -> full regeneration)
    - Create/update entity pages with wikilinks to related modules
    - Flag concepts whose description no longer matches code (hash mismatch)
    - Propose new concept pages if new domain detected (marked PROPOSED)
  - Exit criteria: all changed pages touched, unchanged pages verified stable
  Gate: if concept proposed -> mark "PROPOSED" for human review
  Gate: if entity created -> add to status.md tracking

Phase 3: VERIFY (Reviewer — separate from Generator!)
  - Deterministic checks: wikilink resolution, hash comparison, token budgets
  - Heuristic checks: pattern drift, contradiction detection (separate agent)
  - If any ERROR found: fix-and-retry (MAX 3 retries)
  - If still failing after 3 retries: stop, report "sync blocked: [reason]"
  - Exit criteria: all checks pass or flagged for manual review
  Gate: no errors -> proceed to commit; errors -> fix-and-retry

Phase 4: COMMIT (Pipeline)
  - Update routing.md with new keywords from changed modules/entities
  - Update index.md catalog (add new pages, update token counts)
  - Append structured entry to log.md:
    ## [YYYY-MM-DD] sync
    Status: complete | blocked
    Changed modules: X
    New entities: Y
    Updated entities: Z
    Concept proposals: N
  - Update status.md (fresh/stale/unenriched/verified counts)
  - Distill patterns.md if cross-module patterns detected
  - Exit criteria: all metadata updated, log entry persisted
```

**Kill criteria**: If sync stuck after 3 retries, stop and report "sync blocked: [reason]" rather than silently burning tokens.

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
