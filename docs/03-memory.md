# Memory — Episodic vs Semantic, Consolidation & Fingerprinting

The Brain implements all four memory channels to ensure high-fidelity context without token bloat.

## The 4 Memory Channels

| Channel | Implementation | Read When |
|---|---|---|
| **Git history** | `source-hash` in every module frontmatter $\to$ diff against HEAD | Sync phase |
| **Progress log** | `.ctx/log.md` — chronological, parseable entries | Every session start (recent 5) |
| **Task state** | `.ctx/status.md` — fresh/stale/unenriched per module | Sync phase entry criteria |
| **Semantic memory**| `.ctx/concepts/` + `.ctx/entities/` + `.ctx/patterns.md` | When agent reads relevant page |

## Episodic vs Semantic Memory

| Memory Type | File | What It Contains | Read When |
|---|---|---|---|
| **Episodic** | `log.md` entries | Chronological sync history & observations | Debugging "why" a change happened |
| **Semantic** | `patterns.md` | Reusable patterns distilled from repeated observations | Every new agent session start |

**Consolidation rule**: Every 10 syncs, promote recurring patterns from `log.md` to `patterns.md`. Archive old entries to `archive/YYYY-MM/`.

## Fingerprinting & Weighted Edges
To prevent hallucination, all semantic connections must be typed and scored.

| Edge Type | Description | Confidence Score |
|---|---|---|
| **EXTRACTED** | Found directly in source (e.g., via AST/Tree-sitter). | `1.0` |
| **INFERRED** | Logical connection derived via LLM reasoning. | `0.0 - 0.9` |
| **AMBIGUOUS** | Flagged for human review due to low certainty. | `0.0` |

## Anti-Bloat & Token Economics
*   **Fingerprinting**: Every entry in `index.md` must include a `fingerprint` (metadata summary) so agents can decide whether to read the full file.
*   **Token Budgeting**: Strictly enforce limits via `protocol.md`.
*   **Archival**: Superseded pages move to `archive/`, never deleted.

## Cross-References
- [[02-architecture]] — The 3-Layer Stack
- [[04-agents]] — Sync and Enrichment agents
- [[05-guardrails]] — Token budgets and Truth-checks
