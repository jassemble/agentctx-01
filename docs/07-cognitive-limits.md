# Cognitive Limits — The Human Dimension

## What the Brain Must NOT Do to Humans

From: parallel-agent-limit, cognitive-load-of-parallel-agents, comprehension-debt, ambient-anxiety-tax, productivity-paradox-evidence.

1. **The 3-4 agent ceiling**: The brain must not create more supervision work than a human can handle. Each sync produces a single report, not multiple parallel outputs.

2. **Comprehension debt reduction**: The brain's job is to REDUCE comprehension debt, not add to it. If reading the brain is harder than reading the code, the system failed.
   - Summaries before details (progressive disclosure)
   - One-line token counts in index.md (budget awareness)
   - `log.md` top section has reusable patterns, not per-sync noise

3. **Ambient anxiety tax eliminated**: The brain gives a single definitive answer, not multiple possibilities requiring human judgment. The Verifier produces pass/fail, not "here are 4 possible issues."

4. **The METR RCT finding**: Experienced developers were 19% slower with AI while believing they were 20% faster. The brain tracks **actual verification time**, not just "sync completed."

   Success = code changed AND verified correct, not just code changed.

## Why This Matters

METR RCT (2025): 16 experienced developers, 246 tasks. AI tools made developers 19% slower.

Faros AI (2025): 10,000+ developers, zero measurable DORA improvement despite 75% AI adoption.

Vila's interpretation: these failure modes are structurally worse in multi-agent systems because mistakes compound across tool calls and agent boundaries. Better architecture doesn't eliminate these problems, but it makes them **visible, testable, and fixable**.

The brain's role is the "visible, testable, fixable" part.

## Cross-References

- [[03-memory]] — anti-bloat mechanisms
- [[09-constraints]] — no agent swarms, no monolithic dump
