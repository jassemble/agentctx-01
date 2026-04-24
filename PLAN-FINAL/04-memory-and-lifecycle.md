# Memory & Lifecycle — Episodic vs. Semantic, 5 Hooks, Decision Tracking

## Memory Model

The brain implements all **4 channels of memory** from the Ralph Wiggum (compound-product) research:

| Channel | Implementation | Read When |
|---|---|---|
| **Git history** | `source-hash` in every module frontmatter → diff against HEAD | Sync phase |
| **Progress log** | `.ctx/log.md` — chronological, parseable entries | Every session (recent 5 entries) |
| **Task state** | `.ctx/status.md` — fresh/stale/unenriched/verified per module | Sync phase entry criteria |
| **Semantic memory** | `.ctx/concepts/` + `.ctx/entities/` + `.ctx/patterns.md` + `decisions.md` | When agent reads relevant brain page |

### Episodic vs. Semantic Separation

| Memory Type | File | What It Contains | Read When |
|---|---|---|---|
| **Episodic** | `log.md` bottom entries | What happened in sync N: changed files, created pages, flagged concepts | Debugging "why did this page change?" |
| **Semantic** | `decisions.md` (consolidated) + `patterns.md` | Reusable patterns and past decisions distilled from repeated observations | Every new agent session start — agent learns from history |

**Why this matters for self-learning**: When a new agent starts working, it reads `decisions.md` at the top and sees: "We chose JWT over sessions because sticky sessions broke horizontal scaling in a previous project." The agent doesn't rehash that debate. It inherits the lesson. That's self-improvement at the architecture level.

---

## Decision Tracking — The Self-Learning Loop

> **Note**: This section summarizes the decision tracking system. For the full detailed specification (decision structure, consolidation agent, SDLC integration, self-improve mechanism), see [[09-decision-tracking-and-learning]].

### The Core Loop

```
┌─────────────────────────────────────────────────────────────┐
│  CAPTURE → CONSOLIDATE → FEED FORWARD → SELF-IMPROVE        │
│                                                             │
│  CAPTURE (at SessionEnd / commit / explicit flag):          │
│    Every significant decision gets an ADR in .ctx/decisions/│
│    (what, why, alternatives considered, outcome, lessons)   │
│                                                             │
│  CONSOLIDATE (every 10 decisions or syncs):                 │
│    Consolidation agent reads raw ADRs → distills lessons.  │
│    Recurring themes become higher-level decisions.          │
│    Contradicted old decisions get marked [Superseded].      │
│    Updates decisions.md — the summary agents actually read. │
│                                                             │
│  FEED FORWARD (at SessionStart):                            │
│    New agent reads decisions.md consolidated summary.       │
│    Agent sees past decisions + lessons before starting work.│
│    If it's building auth → loads decision 001 (JWT choice). │
│    Agent checks: "Am I about to repeat a past mistake?"     │
│                                                             │
│  SELF-IMPROVE (during + after work):                        │
│    Agent follows documented decisions instead of rehashing. │
│    If it finds a better approach → new decision captured.   │
│    Verifier flags if new decision contradicts existing one. │
│    The loop compounds over time.                            │
└─────────────────────────────────────────────────────────────┘
```

### How Decisions Are Structured

```yaml
---
id: 001
title: "JWT over Sessions for Auth"
date: YYYY-MM-DD
decider: ctx-maintenance-agent v2.3 — commit abc1234
status: active | superseded | deprecated
related:
  - concepts/authentication
  - entities/auth-service
---
```

### Where Decisions Live

**`.ctx/decisions.md`** — Consolidated summary. This is what agents read on session start. One file, ~2K tokens, every decision as a one-liner with lessons surfaced:

```markdown
# Decisions — Consolidated Summary

## Auth & Security (3 decisions)
- **JWT over sessions** [001, active] — Stateless scales better. Refresh rotation for compromise protection. Lessons: avoid sticky sessions, they break horizontal scaling.
- **Rate limiting at gateway** [014, active] — 100 req/min default. Lessons: per-service rate limiting led to inconsistent throttling.

## Architecture (5 decisions)
- **Monolith over microservices** [002, active] — Single deploy until >5 services needed. Lessons: don't premature-optimize for scale.
- **Provider-switching pattern** [008, active] — Auth, Email, SMS all use abstract providers. Lessons: codify this early in new domains.

## [Superseded decisions]
- ~~Caching strategy via Redis [006]~~ → superseded by [021]: moved to Varnish
- ~~Session auth [001-variant]~~ → superseded by [001]: JWT wins
```

**`.ctx/decisions/`** — Individual ADR files. Detailed, auditable, but agents don't read these by default (too many, too detailed). Each follows the template: Context → Decision → Why → Alternatives → Outcome → Lessons Learned.

### Decision Status Lifecycle

```
DRAFT → DECIDED → ACTIVE
                 ↓
            [new evidence or changed context]
                 ↓
            SUPERSEDED (new decision created, old one kept for audit)
                 OR
            DEPRECATED (decision no longer applies to current code)
```

### How This Prevents Agent Failures

| Agent Failure | How Self-Learning Prevents It |
|---|---|
| Re-debating settled decisions | Agent reads decisions.md → "We decided X, here's why" → moves on |
| Repeating past mistakes | Lessons Learned in consolidated summary → agent avoids same pitfall |
| Contradicting prior work | Verifier cross-references decisions → flags contradictions → forces resolution |
| Forgetting project context | decisions.md read at SessionStart → agent inherits project knowledge |
| Context bloat from too many ADRs | Consolidated summary ~2K tokens, not 20 individual ADR files |
| Stale decisions persisting | Periodic consolidation flags superseded decisions, marks them |

### Decision Capture During Sync Pipeline

Phase 4 (Commit) of the sync pipeline also updates decisions:

```
Phase 4 (Commit) includes:
  - If new ADR was created during this sync:
    → Add one-line entry to decisions.md
    → Update theme count in consolidated section
    → Log entry: "New decision: 012 — caching strategy"
  - If existing decision superseded:
    → Mark old decision [Superseded] in decisions.md
    → Create superseded note in the ADR file
```

### How the Consolidation Agent Works

Every 10 decisions (or every 10 syncs), the Synthesis agent:

1. Reads all raw `decisions/*.md` files
2. Identifies themes, contradictions, outdated decisions
3. Updates `decisions.md` consolidated summary
4. Archives superseded decisions
5. Promotes lessons learned to the top of the summary
6. Appends consolidation timestamp: "Last consolidated: YYYY-MM-DD"

The `decisions.md` file is **always** the source of truth — agents read it at SessionStart, write to it at SessionEnd, and the consolidation cycle keeps it from growing beyond token budgets.

**Consolidation rule**: Raw ADR files are never deleted. They're kept for auditability. The consolidated summary is what matters for the self-learning loop.

---

## 5 Lifecycle Hooks

From the lifecycle hooks architecture research, the brain is made **session-aware**, not just commit-aware:

| Hook | Trigger | What the Brain Does |
|---|---|---|
| **SessionStart** | Agent starts new session | Load protocol.md + `decisions.md` (consolidated) + 5 most recent log.md entries + relevant brain pages based on task type. **Skill routing**: read `.ctx/skills/manifest.json` detected_stack → pre-load relevant skill references into session context (stack context signal) |
| **UserPromptSubmit** | User sends a prompt | Store the query for future context matching. **Skill routing**: match prompt against installed skills' `trigger_phrases` → set active skill for this interaction (intent match signal). No explicit invocation needed — if the user says "write tests for auth", the testing skill activates automatically |
| **PostToolUse** | Agent modifies a file | If file is in `.ctx/`, validate the change (no accidental deletion, human-approved content protected). If file is in source code, mark related modules as potentially stale AND inject **breadcrumbs** — local context hints showing the module, related entities, and relevant concept links for the file being edited (Navigation Interface layer). **Skill routing**: match edited/read file path against installed skills' `paths` globs → inject matched skill's conventions as breadcrumb context (file context signal — highest priority) |
| **Stop** | Agent pauses | Checkpoint current task progress to status.md |
| **SessionEnd** | Agent finishes session | Persist any ephemeral observations to log.md, record any new decisions made this session, update status.md, trigger lightweight sync if source files changed |

**Why this matters**: Currently, if an agent works on code between commits, the brain doesn't know. Hooks close this gap. An agent that creates 5 files + makes 2 architecture decisions in a session but doesn't commit — the SessionEnd hook triggers a lightweight sync + decision capture so the brain stays current.

### Hook Configuration

Hooks are defined in `.claude/settings.local.json`:

```json
{
  "hooks": {
    "SessionStart": "brain load-context",
    "PostToolUse": "brain validate-changed-file",
    "SessionEnd": "brain persist-observations"
  }
}
```

The `brain` command resolves to the CLI that operates on `.ctx/`.

---

## Anti-Bloat Mechanisms

From context bloat + pink elephant problem research:

1. **Progress log consolidation**: See episodic/semantic separation above. Log entries promoted every 10 syncs. Decision consolidation every 10 decisions.

2. **Token budgets per page** (with overflow handling):
   - routing.md < 400 tokens
   - protocol.md < 500 tokens
   - decisions.md summary < 3K tokens (consolidate when it grows beyond)
   - Individual pages < 30K tokens
   - Lint enforces these (see [[07-skill-verifier-rubrics]])

   **When a page exceeds its budget** (the overflow strategy — not just "lint errors"):
   1. **Split by responsibility cluster**: If an entity page grows beyond 30K (e.g., a god node with 50+ edges), split into sub-pages by community cluster. The original page becomes a summary with links: `[[entity:auth-service-core]]`, `[[entity:auth-service-integrations]]`
   2. **Summarize-and-link**: Replace verbose sections with one-line summaries pointing to detail pages. The Cisco 193K-token API doc lesson: chunk by resource/endpoint, not by product
   3. **Archive older sections**: Move historical content (old log entries, superseded patterns) to `archive/` — keep only the active state in the main page
   4. **Progressive disclosure enforcement**: If a page still exceeds budget after splitting, the lint report flags it as ERROR with a suggested split point (the largest section)

3. **Token surfacing in index.md**: Each entry shows token count so agents can make context-budget decisions:
   ```
   - [[authentication]] — 2.3K tokens — How auth works (JWT + refresh rotation)
   - [[caching]] — 1.8K tokens — Redis caching strategy
   ```

4. **Archival strategy**: Superseded concept pages and decisions move to `archive/YYYY-MM/` instead of deletion. Original remains. Index entry marked `[Superseded YYYY-MM-DD]`.

5. **System observability** (brain health metrics):

   The productivity paradox (METR RCT: 19% slower while believing 20% faster) means we cannot trust subjective impressions of whether the brain is helping. `log.md` structured entries track measurable system health:

   | Metric | Where Tracked | Why |
   |---|---|---|
   | Sync duration (ms) | `log.md` per-sync entry | Trending up = pages growing too large or graph too complex |
   | Sync pass/fail rate | `log.md` per-sync entry | Failing syncs = verifier catching real issues or system is brittle |
   | Skill routing hit rate | `log.md` per-session | Did the right skill activate? Track user corrections (explicit slash command after implicit miss) |
   | Token cost per sync | `log.md` per-sync entry | Trending up = context bloat or extraction scope creep |
   | Pages over budget | `status.md` overflow count | Any non-zero = overflow strategy not keeping up |
   | Verification time (human) | `log.md` per-session | Time from "sync complete" to human marking VERIFIED — the real productivity metric |

   These metrics feed the self-learning loop: if sync duration trends up, the consolidation agent investigates why. If skill routing hit rate drops, trigger phrases need updating (skill atrophy).

See also: [[02-architecture]] for the directory structure, [[05-guardrails-and-constraints]] for token budget enforcement, [[09-decision-tracking-and-self-learning]] for the detailed decision capture flow.
