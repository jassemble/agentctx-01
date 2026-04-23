# Verification — Three-Tier Model

## Three Tiers

| Tier | Type | Speed | Runs On | What It Checks |
|---|---|---|---|---|
| **Layer 1** | Deterministic | Fast | Every sync | Hash comparisons, wikilink resolution, token budgets, directory completeness |
| **Layer 2** | Heuristic/ML | Slow | `/brain-lint` | Pattern drift, contradiction detection, comprehension debt |
| **Layer 3** | Human | Slowest | On review | Concept approval (PROPOSED → REVIEWED → CONFIRMED), archive decisions |

## Guiding Principle

> Don't send to human what machine can reject; don't trust machine for what requires genuine judgment.

## The Verifier as First-Class Agent

The v4 plan had the sync agent verify its own work. Research shows this is suboptimal. The Verifier agent:
- Runs **after** the Generator completes
- Has read-only access to brain pages + source code
- Produces a structured report the Generator cannot edit
- Is the brain-level implementation of the `@reviewer` teammate pattern

## Status Lifecycle (per module)

```
UNENRICHED → FRESH → STALE (code changed) → RESYNCED → FRESH → VERIFIED (after human review)
```

## Cross-References

- [[04-agents]] — the Verifier agent definition + rubric
- [[01-decisions]] — Generator-Verifier split rationale
- [[09-constraints]] — no self-verification
