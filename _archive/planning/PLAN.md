# Context Engineering & Auto-Sync Framework for Claude Code

## Context

Context rot — as conversations accumulate, Claude's context window fills with noise, stale instructions, and forgotten details. The "curse of instructions" shows LLM adherence drops as instruction count grows. Research from the `agentctx-idea` wiki (73 concepts, 17 sources) proves that **external, structured context + progressive disclosure** is the solution.

This system builds a reusable framework: `agentctx-01` becomes the open-source brain that any project can adopt to give Claude a persistent, self-maintaining memory.

---

## Architecture: 3-Layer AGENTS.md Hierarchy

From wiki research ([agents-md-hierarchy](../agentctx-idea/wiki/concepts/agents-md-hierarchy.md)), a monolithic AGENTS.md fails. Instead:

- **Layer 1 — Protocol** (`.ctx/protocol.md`): What personas/skills exist, when to load them, minimum essential repo facts. Under 500 tokens.
- **Layer 2 — Personas** (`.ctx/personas/`): Focused context per task type (frontend, backend, testing, docs). Only relevant persona loaded per task.
- **Layer 3 — Maintenance** (auto-sync agent): Runs on commit, keeps Layer 1 accurate.

---

## Directory Structure

```
agentctx-01/
├── .claude/                          ← Claude Code primitives
│   ├── settings.local.json           ← hooks: postCommit triggers sync
│   ├── skills/
│   │   ├── sync-context.md           ← /sync-context: manual maintenance
│   │   └── lint-context.md           ← /lint-context: health check
│   └── agents/
│       ├── ctx-maintenance.md        ← Scans diffs, updates wiki
│       └── ctx-linter.md             ← Finds contradictions, orphans, stale claims
│
├── .ctx/                             ← The context brain (auto-generated per project)
│   ├── protocol.md                   ← Layer 1: routing document
│   ├── personas/
│   │   ├── frontend.md               ← Loaded when doing UI work
│   │   ├── backend.md                ← Loaded when doing API work
│   │   └── testing.md                ← Loaded when writing tests
│   ├── index.md                      ← Content catalog (organized by cluster)
│   ├── sources/                      ← Ingested specs, PRDs, requirements
│   ├── concepts/                     ← Domain concepts (auth, caching, etc.)
│   ├── entities/                     ← APIs, services, components, models
│   ├── routing.md                    ← Keyword → cluster → page lookup
│   ├── overview.md                   ← Current state summary
│   └── log.md                        ← Chronological activity log
│
└── PLAN.md                           ← This file
```

---

## Design Rationale (from Research)

| Decision | Research Source | Rationale |
|---|---|---|
| 3-layer hierarchy | [agents-md-hierarchy](../agentctx-idea/wiki/concepts/agents-md-hierarchy.md) | Monolithic context fails at scale |
| Progressive disclosure | [progressive-disclosure-memory](../agentctx-idea/wiki/concepts/progressive-disclosure-memory.md) | ~10x token savings: routing → index → page |
| Auto-sync on commit | [guardrails-hierarchy](../agentctx-idea/wiki/concepts/guardrails-govern-hooks.md) | Context drifts immediately after change |
| Page format templates | [wiki/CLAUDE.md](../agentctx-idea/CLAUDE.md) | Proven wiki structure: YAML frontmatter, wikilinks, kebab-case |
| Memory consolidation | [memory-persistence](../agentctx-idea/wiki/concepts/memory-persistence.md) | Episodic (log) + semantic (patterns) separation |
| Contradiction tracking | [wiki/CLAUDE.md](../agentctx-idea/CLAUDE.md) | `[Superseded YYYY-MM-DD]` annotation, never silent overwrite |
| Size-limited artifacts | [context-window-management](../agentctx-idea/wiki/concepts/context-window-management.md) | 30-40% context utilization target |
| Protocol under 500 tokens | [token-economics](../agentctx-idea/wiki/concepts/token-economics.md) | Layer 1 must be small enough to always load |

---

## Phase 1: Foundation — Scaffold + Bootstrap

### Deliverables

1. **`.ctx/` scaffold** — Initialize full directory structure
   - Creates all directories: `sources/`, `concepts/`, `entities/`, `personas/`
   - Seeds: `protocol.md`, `index.md`, `routing.md`, `overview.md`, `log.md`
   - Uses page format conventions from wiki (YAML frontmatter, wikilinks, kebab-case, ISO dates)

2. **`protocol.md` template** — Layer 1 routing document
   - Lists available personas and when to invoke them
   - Lists available skills (slash commands) and what they do
   - Progressive disclosure instructions: "Read `index.md` TOC first, then only load relevant persona"
   - Stays under 500 tokens

3. **`CLAUDE.md`** — Root operating document for projects using the framework
   - Defines the 3-layer architecture
   - Specifies progressive disclosure: "always read routing.md first, then index.md cluster, then specific page"
   - References `protocol.md` as the entry point
   - Defines the memory model: `.ctx/` = long-term semantic memory

4. **`.claude/settings.local.json` with hooks**
   - Post-commit hook triggers ctx-maintenance agent
   - Size-limited artifact enforcement

### Page Formats (from wiki templates)

**Concept page** (`.ctx/concepts/<slug>.md`):
```markdown
---
title: "Concept Name"
category: methodology | theory | tool | phenomenon | debate
introduced_in: <source>
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [tags]
---

# Concept Name

**Category**: <category>
**Introduced in**: [[source]]

## Definition
Clear, sourced definition.

## Current Understanding
Evolving synthesis, updated as changes are detected.

## Related Code Paths
- `src/auth/login.ts` — primary implementation
- `src/auth/middleware.ts` — middleware wrapping

## Related Concepts
- [[related-concept-1]]
- [[related-concept-2]]

---
Updated: YYYY-MM-DD | Synced from commit abc1234
```

**Entity page** (`.ctx/entities/<slug>.md`):
```markdown
---
title: "Entity Name"
entity_type: api | service | component | model | library
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Entity Name

**Type**: <entity_type>
**Location**: `path/to/file`

## Purpose
What this entity does.

## Dependencies
- Imports: `...`
- Used by: `...`

## Change History
- **YYYY-MM-DD**: Created from scan
- **YYYY-MM-DD**: Updated — what changed, why

---
Updated: YYYY-MM-DD | Synced from commit abc1234
```

---

## Phase 2: Auto-Sync Maintenance Agent

### Deliverables

1. **`ctx-maintenance` agent** (`.claude/agents/ctx-maintenance.md`)
   - Reads `git diff` of the commit
   - Identifies: new functions, changed patterns, deprecated code, new dependencies
   - Creates/updates concept pages in `.ctx/concepts/`
   - Creates/updates entity pages in `.ctx/entities/`
   - Updates `log.md` with parseable entry (matches wiki log format)
   - Updates `index.md` with new/modified page references
   - Appends consolidated "Codebase Patterns" section to `.ctx/overview.md`

2. **`/sync-context` skill**
   - Manual trigger for full maintenance run
   - Scans entire codebase, not just last commit
   - Reports: what changed, what was synced, what needs review

3. **`/lint-context` skill**
   - Health check: contradictions, stale claims, orphan pages, missing pages
   - Matches wiki "Lint" operation from `CLAUDE.md` template

---

## Phase 3: Progressive Disclosure Integration

### Deliverables

1. **Context budget enforcement** — Auto-verify `.ctx/` pages stay under size limits
2. **Index-based routing proven** — agent reads `routing.md` first (~400 tokens), then `index.md`, then specific pages
3. **Summarization agent** — Compresses old log entries, archives stale concept pages
4. **Spec-driven workflow** — Integrate with spec artifacts in `.ctx/sources/`

---

## What Problems This Solves

| Problem | How We Solve It |
|---|---|
| Context rot (forgotten details) | Fresh subagent reads `.ctx/` pages on-demand — current source of truth |
| Context bloat (too much loaded) | Progressive disclosure: routing → index → specific page. Only load what's relevant |
| Instruction degradation | Modular context pages replace monolithic prompt lists |
| Stale AGENTS.md | Auto-sync on every commit — Layer 3 maintenance agent keeps Layer 1 accurate |
| Cross-session amnesia | `.ctx/` directory persists across sessions — agent loads it on start |
| Lost project context | Structured wiki with wikilinks, contradiction tracking, chronological log |

---

## Verification Checklist

- [ ] Scaffold creation produces correct directory structure
- [ ] Claude Code reads `.ctx/protocol.md` on session start
- [ ] Code change + commit → `.ctx/log.md` gets new entry automatically
- [ ] Concept page created for new function/pattern
- [ ] `/sync-context` runs full scan successfully
- [ ] `/lint-context` produces health report
- [ ] Pages stay under token budget limits
- [ ] Contradiction detection works (old vs new claim about same concept)
- [ ] Progressive disclosure: agent loads only relevant context, not everything

---

## Research Sources (from agentctx-idea Wiki)

**Core concepts driving this design:**
- [context-engineering](../agentctx-idea/wiki/concepts/context-engineering.md) — Modular prompts, dynamic loading
- [context-window-management](../agentctx-idea/wiki/concepts/context-window-management.md) — 30-40% utilization target
- [context-bloat](../agentctx-idea/wiki/concepts/context-bloat.md) — Problem of accumulated context
- [curse-of-instructions](../agentctx-idea/wiki/concepts/curse-of-instructions.md) — Instruction adherence drops with count
- [agents-md-pattern](../agentctx-idea/wiki/concepts/agents-md-pattern.md) — Persistent semantic memory
- [agents-md-hierarchy](../agentctx-idea/wiki/concepts/agents-md-hierarchy.md) — 3-layer architecture
- [progressive-disclosure-memory](../agentctx-idea/wiki/concepts/progressive-disclosure-memory.md) — Layered retrieval, ~10x token savings
- [memory-persistence](../agentctx-idea/wiki/concepts/memory-persistence.md) — 4 channels of memory
- [spec-driven-development](../agentctx-idea/wiki/concepts/spec-driven-development.md) — Gated workflow
- [compound-learning](../agentctx-idea/wiki/concepts/compound-learning.md) — Each improvement makes future easier
- [token-economics](../agentctx-idea/wiki/concepts/token-economics.md) — Token count as constraint
- [pink-elephant-problem](../agentctx-idea/wiki/concepts/pink-elephant-problem.md) — Anchoring bias from irrelevant context
- [guardrails-hierarchy](../agentctx-idea/wiki/concepts/guardrails-hierarchy.md) — Three-tier defense layers
- [llms-txt](../agentctx-idea/wiki/concepts/llms-txt.md) — Sitemap for AI agents

**Total Wiki State:**
- 73 concepts
- 24 entities
- 17 sources
- 10 topic clusters

---

## Open Questions

1. Should `.ctx/` be at the repo root or in `.claude/ctx/`? (Convention vs. separation)
2. Should the maintenance agent be a Claude Code skill or a settings.json hook?
3. How to handle very large codebases — scan full diff or targeted analysis?
4. Should we support projects that already have AGENTS.md / CLAUDE.md / MEMORY.md — how to integrate without conflict?
