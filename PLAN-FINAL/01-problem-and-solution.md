# The Problem — Why the Code Brain Exists

## Four Foundations Converge

1. **agentctx CLI** — AST scanning + AI enrichment + module docs + multi-tool output + 156 agents. But modules are isolated: no cross-references, no concept synthesis, no self-maintenance.
2. **agentctx-idea wiki** — 73 concepts from 17 Osmani sources: interlinked concepts, entities, contradictions, progressive disclosure. But has no code scanning (manually curated).
3. **experiment-on-trpc** — 169 auto-generated modules with pattern tracking and sync status. But `module-index.md` is flat: 0 relationships.
4. **brain** — Transforms any folder into a persistent, queryable knowledge graph. AST extraction (25 languages via tree-sitter), Leiden community detection, confidence-scored edges (EXTRACTED/INFERRED/AMBIGUOUS), interactive visualization (graph.html), MCP query server, 71.5x token reduction. But has no governance (no concept approval workflow, no decision tracking, no SDLC phases).

## The Gap

| What exists | Does | Does not |
|---|---|---|
| agentctx scan | Generates module docs per directory | No relationships, no concept synthesis, no wiki properties |
| agentctx-idea wiki | Interlinked concept pages with cross-references | No code scanning — manually curated |
| experiment-on-trpc | 169 modules with status tracking | No wiki properties — flat list |
| brain | Builds knowledge graph with clustering, confidence, visualization, MCP queries | No governance, no decision tracking, no SDLC skills, no human-in-the-loop |

**What we need**: A brain that scans your code AND synthesizes it AND governs it. When you write auth login + backend + DB, brain extracts the knowledge graph (entities, edges, communities), generates governed wiki pages (modules, entities, concept proposals), and agents can traverse the result both visually (graph.html) and programmatically (MCP server). On `brain init`, the system detects your stack (React? Go? Prisma?) and installs only the skills your project actually needs — not 58 skills, just the ones that match.

The result: a **self-maintaining wiki powered by brain's knowledge graph**, with smart skill selection based on project structure, governed by human-in-the-loop concept approval, with dual readability for both humans and AI agents.

## Distributed Decision Model

**Core insight from Osmani's research**: Agents don't decide. Architecture decides across 6 phases:

```
Spec → Analysis → Planning → Execution → Verification → Retro
```

The brain is **not** an agent. It is the **context layer** consulted by every agent at each phase. See [[02-architecture]] for the full breakdown.

See also: [[08-anti-patterns]] for what we're NOT building, [[03-agents]] for agent roles.
