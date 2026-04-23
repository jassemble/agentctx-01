# Architecture — Three Layers + Code Brain

## Layer 1: Schema Layer (Entry Point)

```
agentctx-sdlc/                          # The Framework
├── protocol.md                         # Routing: personas, skill index, core principles (<500t)
├── CLAUDE.md                           # <500 tokens: "Read protocol.md first"
├── README.md                           # Human overview
├── llms.txt                            # Machine-readable framework catalog for any agent
├── SKILLS-INDEX.md                     # {trigger phrase → skill path} mapping
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
│   ├── protocol.md                  # <500t: "Read routing.md first, load persona"
│   ├── routing.md                   # Keyword → cluster → page (<400t)
│   ├── index.md                     # Content catalog with token counts
│   ├── overview.md                  # State summary + codebase patterns
│   ├── decisions.md                 # All decisions + consolidated summary (agent reads this on session start)
│   ├── decisions/                   # Individual ADRs (detailed, rarely read by default)
│   │   ├── 001-auth-strategy.md     # Why JWT over sessions, tradeoffs, date, links
│   │   └── _template.md             # ADR template
│   ├── log.md                       # Append-only: episodic + semantic sections
│   ├── status.md                    # Fresh/stale/unenriched/verified per module
│   ├── patterns.md                  # Cross-cutting patterns (auto-distilled)
│   ├── references/                  # Swappable rubrics
│   │   └── lint-checklist.md        # Lint rubric (replaceable without code change)
│   ├── concepts/                    # Wiki-style (PROPOSED → REVIEWED → CONFIRMED)
│   │   ├── authentication.md        # Human-enriched or human-reviewed
│   │   └── _template.md             # Template
│   ├── entities/                    # Auto-generated with hash tracking
│   │   ├── auth-service.md          # Service docs
│   │   └── _template.md             # Template
│   ├── modules/                     # Auto-scanned (agentctx scan format + wikilinks)
│   │   ├── auth.md                  # Directory-level docs
│   │   └── _template.md             # Template
│   ├── sources/                     # Ingested specs/PRDs
│   │   └── auth-spec.md             # Auth requirements
│   ├── conventions/                 # From agentctx skills (read-only)
│   │   └── nextjs/                  # Next.js patterns
```

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

## Integration: SDLC Agent + Code Brain

| Code Brain (.ctx/) | SDLC Framework |
|---|---|
| Project-specific context | Phase-specific expertise |
| Auto-scanned from code | Template-driven documents |
| Self-maintaining via hooks | Trigger-activated skills |
| Records what the code does | Guides how agents work |
| log.md = episodic memory | Wiki log.md = wiki evolution |
| patterns.md = distilled code patterns | Wiki concepts/ = distilled methodology |

When an SDLC agent runs on a project with a brain:
1. SessionStart hook loads minimal context (protocol.md, recent logs)
2. Agent loads relevant SDLC skill (trigger-matched)
3. Skill loads its templates + references
4. Agent produces artifact (PRD, architecture, code, etc.)
5. Brain SessionEnd hook persists observation, updates status
6. Brain Verifier checks artifact quality against rubrics

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

See also: [[03-agents]] for agent roles, [[04-memory-and-lifecycle]] for memory model and hooks, [[06-implementation]] for the task breakdown.
