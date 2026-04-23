# The Problem — Why the Code Brain Exists

## Three Foundations Converge

1. **agentctx CLI** — AST scanning + AI enrichment + module docs + multi-tool output + 156 agents. But modules are isolated: no cross-references, no concept synthesis, no self-maintenance.
2. **agentctx-idea wiki** — 73 concepts from 17 Osmani sources: interlinked concepts, entities, contradictions, progressive disclosure. But has no code scanning (manually curated).
3. **experiment-on-trpc** — 169 auto-generated modules with pattern tracking and sync status. But `module-index.md` is flat: 0 relationships.

## The Gap

| What exists | Does | Does not |
|---|---|---|
| agentctx scan | Generates module docs per directory | No relationships, no concept synthesis, no wiki properties |
| agentctx-idea wiki | Interlinked concept pages with cross-references | No code scanning — manually curated |
| experiment-on-trpc | 169 modules with status tracking | No wiki properties — flat list |

**What we need**: A brain that scans your code AND synthesizes it. When you write auth login + backend + DB, the system should auto-create a module doc, entity pages (AuthService, User model), a concept page (Authentication — how auth works HERE), and bidirectional links between them all.

The result: a **self-maintaining wiki that writes itself from your commits**.

## Distributed Decision Model

**Core insight from Osmani's research**: Agents don't decide. Architecture decides across 6 phases:

```
Spec → Analysis → Planning → Execution → Verification → Retro
```

The brain is **not** an agent. It is the **context layer** consulted by every agent at each phase. See [[02-architecture]] for the full breakdown.

See also: [[08-anti-patterns]] for what we're NOT building, [[03-agents]] for agent roles.
