# Code Brain — Final Plan Index

## Documents

| Order | File | What it covers |
|---|---|---|
| 1 | [01-problem-and-solution](01-problem-and-solution.md) | Problem context — three foundations converge, the gap, distributed decision model |
| 2 | [02-architecture](02-architecture.md) | Three-layer architecture (Schema + Wiki + Skills), Code Brain .ctx/ structure, **brain as Intelligence Engine**, per-phase agents, wikilinks, pipeline format |
| 3 | [03-agents](03-agents.md) | Agent roles: Brain Generator (reads brain), Brain Verifier, Brain Synthesis, Brain Maintenance — 4-phase sync pipeline with brain extraction |
| 4 | [04-memory-and-lifecycle](04-memory-and-lifecycle.md) | Memory model (episodic vs semantic), 4 memory channels, **decision capture + self-learning loop**, 5 lifecycle hooks |
| 5 | [05-guardrails-and-constraints](05-guardrails-and-constraints.md) | Always/Ask/Never, CLAUDE.md → warn → block hierarchy, MCP security, 3-tier verification, cognitive limits |
| 6 | [06-implementation](06-implementation.md) | 4-phase task breakdown with brain integration — acceptance criteria mapping to all source plans |
| 7 | [07-skill-verifier-rubrics](07-skill-verifier-rubrics.md) | Lint checklist, skill rubrics, boolean pass/fail, severity grouping |
| 8 | [08-anti-patterns](08-anti-patterns.md) | What we're NOT building and why — research-backed constraints |
| 9 | [09-decision-tracking-and-learning](09-decision-tracking-and-learning.md) | Decision capture → consolidating → feeding forward → agent self-improves over time |
| 10 | [10-implementation-tasks](10-implementation-tasks.md) | **38 atomic tasks across 7 phases** — Claude-executable, sequential, with dependencies and boolean AC |

## Source Documents Consolidated

This plan consolidates:

- **PLAN.md** → Original 3-layer context framework (routing → protocol → personas)
- **PLAN-v2.md** → Brain concept: wiki + scanner combined, page templates
- **PLAN-v3.md** → Osmani architecture, 5 skill patterns, comparison tables
- **PLAN-v4.md** → 5 brain services, gated sync pipeline, guardrails enforcement
- **PLAN-v5.md** → Lifecycle hooks, Generator-Verifier split, investigation/implementation separation
- **PLAN-sdlc-framework.md** → Full SDLC skill framework with 6 phases × Generator + Verifier pairs
- **docs/01-09.md** → Distilled concept summaries
- **review/01-09.md + gap-summary.md** → Audit against 73 agentctx-idea concepts with COVERED/PARTIAL/GAPS ratings
- **brain** (`../brain`) → Intelligence Engine: AST extraction (25 langs), Leiden clustering, confidence scoring, interactive visualization, MCP query server

## How to Read This Plan

- Start with **01** for the problem/context
- **02-05** are the design contract — architecture, agents, memory, guardrails
- **06** is the high-level phase overview (what to build)
- **07-08** are quality gates and constraints (rubrics, anti-patterns)
- **10** is the **executable task list** — start here when building. 38 atomic tasks with dependencies, inputs, outputs, and boolean acceptance criteria
