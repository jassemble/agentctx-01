# Architecture — The Three-Layer Cognitive Stack

The Brain is not just a collection of files; it is a tiered cognitive stack designed to balance **Truth**, **Efficiency**, and **Usability**.

## 1. The Intelligence Engine (Layer: Truth)
*Goal: Build a high-fidelity, topologically-aware knowledge graph.*

This layer is responsible for the deterministic and semantic extraction of data. It ensures the Brain knows not just "what" exists, but "how" it is connected.

| Component | Responsibility | Implementation |
|---|---|---|
| **Structural Scan** | Deterministic AST extraction (classes, functions, call-graphs). | Tree-sitter (No LLM) |
| **Semantic Enrich** | Concept, rationale, and relationship extraction. | Claude/LLM |
| **Topological Engine**| Community detection and clustering. | Leiden Algorithm |

**Key Output:** A weighted graph where edges are tagged as `EXTRACTED` (1.0 confidence) or `INFERRED` (0.0-1.0 confidence).

## 2. The Context Router (Layer: Efficiency)
*Goal: Maximize reasoning density while minimizing token expenditure.*

This layer prevents "Context Bloat" by acting as a gatekeeper. It ensures the agent never reads raw files unless absolutely necessary.

| Component | Responsibility | Mechanism |
|---|---|---|
| **Fingerprinting** | Creating lightweight metadata for every entity/module. | `index.md` entry per file |
| **Tiered Loading** | Managing the "Depth of Sight" for the agent. | Pointer $\to$ Snippet $\to$ Full File |
| **Token Budgeting** | Enforcing strict limits on context injection. | `protocol.md` guardrails |

**Core Principle: Pointer-First.** The agent must always attempt to satisfy a query using the lowest-cost tier (Metadata $\to$ Snippet) before requesting the high-cost tier (Full File).

## 3. The Navigation Interface (Layer: Ergonomics)
*Goal: Make the Brain feel like a natural extension of the IDE.*

This layer provides the "human-in-the-loop" and "agent-in-the-loop" ways to traverse the knowledge.

| Component | Responsibility | Implementation |
|---|---|---|
| **Breadcrumbs** | Providing local context during active file editing. | `PostToolUse` hook injection |
| **Community Maps** | High-level views of logical responsibility clusters. | `community_map.md` |
| **Semantic Wiki** | Human-readable, agent-crawlable knowledge articles. | `.ctx/concepts/` & `.ctx/entities/` |

## Directory Structure (Updated)

```
your-project/
├── .agentctx/                       ← Existing agentctx (unchanged)
├── .ctx/                            ← The Brain
│    ├── protocol.md                 ← Tiered loading rules & Token budgets
│    ├── routing.md                  ← Keyword $\to$ Cluster $\to$ Page
│    ├── index.md                    ← Content catalog + Fingerprints (Metadata)
│    ├── community_map.md            ← High-level responsibility clusters
│    ├── overview.md                 ← ## Codebase Patterns + Active State
│    ├── log.md                      ← Episodic memory (Recent Syncs)
│    ├── status.md                   ← Fresh/Stale/Unenriched status
│    ├── patterns.md                 ← Semantic memory (Distilled patterns)
│    ├── references/                 ← Swappable rubrics & checklists
│    ├── concepts/                   ← Wiki-style (PROPOSED $\to$ CONFIRMED)
│    ├── entities/                   ← Auto-generated with hash tracking
│    ├── modules/                    ← Auto-scanned with wikilinks
│    └── archive/                    ← Superseded pages
```

## Cross-References

- [[03-memory]] — Semantic vs Episodic & Fingerprinting
- [[04-agents]] — The Engine, Router, and Interface agents
- [[05-guardrails]] — Token budgets and Truth-checks
