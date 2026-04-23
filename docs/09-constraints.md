# Constraints — What We're NOT Building

## Anti-Patterns

1. **No fully-auto concept pages** — ETH Zurich: AI-generated context hurts (3% less success, 20% more cost). Concepts are PROPOSED by AI, REVIEWED by human.

2. **No agent swarms for sync** — 3-5 agent ceiling, ambient anxiety tax, comprehension debt. The brain makes each agent better, not more numerous.

3. **No monolithic context dump** — Progressive disclosure: routing.md (400t) → index.md (cluster) → page. If protocol > 500 tokens, lint errors.

4. **No CLAUDE.md-as-security** — $30K API key incident proved CLAUDE.md is a suggestion, not enforcement. Only block hooks enforce constraints unconditionally.

5. **No replacement for agentctx** — The brain is a layer ON TOP. agentctx handles scanning, multi-tool output, skills, dashboard, 156 agents.

6. **No vibe coding enabler** — The brain documents what exists; it doesn't generate code. It bridges the 70% gap by preserving engineering knowledge.

7. **No self-verification** — Generator and Verifier are separate agents. Anthropic/DeepMind/Meta research convergence: "verification is easier than generation" — splitting roles eliminates self-review bias.

8. **No combined investigation+implementation** — Task Explosion Pattern: these are fundamentally different cognitive operations. Sync separates them into phases.

9. **No CLAUDE.md-only guardrails** — Guardrails at input, execution, and output layers. CLAUDE.md alone is insufficient (model-interpreted, can be overridden).

## Cross-References

- [[05-guardrails]] — multi-layer enforcement that constraint #4 and #9 drive
- [[04-agents]] — Generator-Verifier split that constraint #7 enforces
- [[07-cognitive-limits]] — cognitive constraints that #2 and #3 address
- [[01-decisions]] — distributed model rationale for #1 and #7
- [[03-memory]] — anti-bloat mechanisms that #3 operationalizes
