# Decision Tracking & Self-Learning Loop

## The Core Loop

Every agent that works on the project should **get smarter over time** from past decisions, not repeat the same mistakes or rehash the same tradeoffs. This is the compound learning loop:

```
┌─────────────────────────────────────────────────────────────┐
│  CAPTURE → CONSOLIDATE → FEED FORWARD → SELF-IMPROVE        │
│                                                             │
│  CAPTURE:                                                   │
│    Every significant decision gets recorded as a decision.  │
│    (what, why, alternatives considered, outcome)             │
│    Triggered at SessionEnd, commit hook, or explicit flag   │
│                                                             │
│    ↓                                                        │
│  CONSOLIDATE:                                               │
│    Every 10 decisions (or every N syncs), raw decisions     │
│    are summarized. Recurring themes become patterns.         │
│    Contradicted old decisions get flagged.                    │
│    The consolidated summary grows; raw ADRs shrink in use.  │
│                                                             │
│    ↓                                                        │
│  FEED FORWARD:                                              │
│    New agent starts → reads decisions.md (consolidated).    │
│    Agent sees: "We chose X because Y. Alternatives Z failed │
│    because..." Agent consults this before making similar    │
│    decisions in new work.                                    │
│                                                             │
│    ↓                                                        │
│  SELF-IMPROVE:                                              │
│    Agent compares its approach against past lessons.         │
│    If it repeats a past mistake → Verifier flags it.        │
│    If it finds a better approach → new decision captured,   │
│    consolidated summary updated with the improvement.       │
│    The loop compounds.                                       │
└─────────────────────────────────────────────────────────────┘
```

---

## What Gets Recorded (Decision Structure)

Every decision follows this format:

```yaml
---
id: 001
title: "JWT over Sessions for Auth"
date: YYYY-MM-DD
decider: Agent name + context
status: active | superseded | deprecated
related:
  - concepts/authentication
  - entities/auth-service
  - sources/auth-spec
---
```

```markdown
# 001 — JWT over Sessions for Auth

## Context
User auth needed for the app. Sessions vs JWT debate surfaced during requirements.

## Decision
Using JWT with refresh token rotation.

## Why
- Stateless on the server side → simpler horizontal scaling
- Refresh token rotation → compromised tokens have limited blast radius
- Frontend SPA has no cookie concern

## Alternatives Considered
- **Sessions** — would require sticky sessions, more ops complexity
- **API keys** — not suitable for user auth (long-lived by design)

## Outcome
Implemented successfully. No issues in production.

## Lessons Learned
(Updated when agent encounters this decision again)
```

---

## Where Decisions Live

### Raw Decisions → `.ctx/decisions/`

Individual ADR files. These exist for auditability — you can dig into the full rationale for any decision. But **agents don't read these by default** (too many, too detailed).

### Consolidated Summary → `.ctx/decisions.md`

This is what agents actually read on session start. It's a single file with one-line summaries of every decision, grouped by theme, with the lessons-learned surfaced:

```markdown
# Decisions — Consolidated Summary

## Auth & Security (3 decisions)
- **JWT over sessions** (001) — Stateless scales better. Refresh rotation protects against compromise.
  - Lesson: Avoid sticky sessions, they broke horizontal scaling in a previous project
- **Rate limiting at the gateway** (014) — Centralized, not per-service. 100 req/min default.
  - Lesson: Per-service rate limiting led to inconsistent throttling

## Architecture (5 decisions)
- **Monolith over microservices** (002) — Single deploy until >5 services needed.
  - Lesson: Don't premature-optimize for scale. Monolith is fine at our size.
- **Provider-switching pattern** (008) — Auth, Email, SMS all use abstract providers.
  - Lesson: This pattern emerged organically — codify it early in new domains

## Data (2 decisions)
- **Postgres over Mongo** (011) — Strong typing, migrations tooling, team familiarity.
  - Lesson: Mongo schema drift cost 2x engineering time on previous project

## [Superseded decisions]
- ~~Caching strategy (006)~~ — Superseded by 021: moved from Redis to Varnish
```

---

## The Self-Improve Mechanism (How Agent Learns)

### At Session Start (Feed Forward)
1. Agent reads `protocol.md` + `decisions.md` consolidated summary
2. Based on what it's about to work on, it loads relevant ADR files (e.g., building auth → loads decision 001)
3. Agent checks: "Am I about to repeat a past mistake? Am I ignoring a documented lesson?"

### During Work (Self-Correct)
1. Agent encounters a decision point: "Should I use sessions or tokens?"
2. Agent checks `decisions.md`: "We decided JWT in 001, here's why."
3. Agent follows the documented decision path instead of rehashing

### At SessionEnd (Capture New Decisions)
1. Agent records any NEW decisions made during the session
2. Verifier checks: "Did the agent's new decision contradict any existing decision?"
3. If yes: flag it, mark old decision as superseded, create new ADR

### Periodically (Consolidate)
1. Every 10 new decisions (or every 10 syncs), the Synthesis agent:
   - Reads raw `decisions/` files
   - Identifies themes, contradictions, outdated decisions
   - Updates `decisions.md` consolidated summary
   - Archives superseded decisions
   - Promotes lessons learned to the top of the summary

---

## Decision Status Lifecycle

```
DRAFT → DECIDED → ACTIVE
                 ↓
            [new evidence or changed context]
                 ↓
            SUPERSEDED (new decision created)
                 OR
            DEPRECATED (decision no longer applies)
```

---

## How This Prevents Common Agent Failures

| Agent Failure | How Self-Learning Prevents It |
|---|---|
| Re-debating settled decisions | Agent reads decisions.md → sees "We decided X, here's why" → doesn't rehash |
| Repeating past mistakes | Lessons Learned surface in consolidated summary → agent avoids same pitfall |
| Contradicting prior work | Verifier checks decisions → flags contradictions → forces resolution |
| Forgetting project context | decisions.md is read at SessionStart → agent inherits project knowledge |
| Context bloat from too many ADRs | Consolidated summary is ~2K tokens, not 20 ADR files |
| Stale decisions persisting | Periodic consolidation flags superseded decisions, marks them |

---

## Integration with Sync Pipeline

The sync pipeline's Phase 3 (Commit) also updates `decisions.md` if any new decisions emerged during the investigation/update phases. This happens automatically — no separate agent needed:

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

---

## Integration with SDLC Phases

Each SDLC phase naturally produces decisions:

| Phase | Decisions Produced |
|---|---|
| Requirements | What to build vs not (scope decisions) |
| Design | Architecture choices (patterns, tradeoffs, ADRs) |
| Implementation | Implementation choices (framework, library, structure) |
| Testing | Test strategy choices (what to test, what to mock) |
| Deployment | Rollout strategy choices (canary, blue-green, feature flags) |
| Maintenance | Fix strategy choices (refactor vs rewrite, deprecation) |

All decisions flow into `.ctx/decisions/` + `decisions.md` through the same capture mechanism.

See also: [[04-memory-and-lifecycle]] for the episodic/semantic memory split (decisions.md is semantic memory), [[03-agents]] for how agents interact with this loop, [[06-implementation]] for where decision capture happens in the pipeline.
