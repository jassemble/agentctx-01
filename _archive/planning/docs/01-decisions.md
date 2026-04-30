# Decisions — How Agents "Take Decisions"

## Context

Agents don't decide. The architecture decides across six phases (from the Factory Model). The brain is not an agent — it is the **context layer** consulted by every agent at each phase.

Derived from: factory-model, compound-pipeline, task-explosion-pattern.

## The Distributed Decision Model

```
Spec → Analysis → Planning → Execution → Verification → Retro
```

| Phase | Agent Pattern | Brain Consults | Brain Records |
|---|---|---|---|
| Spec | Inversion | existing concepts/sources | the spec as a source page |
| Analysis | Tool Wrapper | architecture.md + patterns.md | nothing (read-only) |
| Planning | Generator | module-index + entities | new concept proposals |
| Execution | Pipeline | relevant concept + entity pages | module doc updates |
| Verification | Reviewer | patterns.md + conventions + prior status | verification status per module |
| Retro | Generator | nothing | updates modules, entities, concepts, patterns, log |

**Key principle**: The brain's decision model is reactive, not proactive. It observes what was built, records it, links it, and flags discrepancies. It proposes concept pages but never auto-creates them (ETH Zurich: AI-generated context hurts 3%, costs 20% more).

## Generator-Verifier Split

The brain should be split into:
- **Generator**: writes pages from facts (AST scan results, function signatures, imports)
- **Verifier**: reads pages back against code to check accuracy

This mirrors the Anthropic/DeepMind/Meta research convergence: "verification is easier than generation" — splitting these roles eliminates self-review bias.

## Cross-References

- [[06-verification]] — layered verification model
- [[04-agents]] — the 4 agent definitions
- [[09-constraints]] — no self-verification, no fully-auto concepts
