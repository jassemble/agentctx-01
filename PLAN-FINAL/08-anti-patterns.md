# Anti-Patterns — What We're NOT Building (and Why)

Each constraint is backed by a specific research finding. These are not preferences — they are learned from failures in the wild.

| Anti-Pattern | Why Not | Research Source |
|---|---|---|
| **No fully-auto concept pages** | ETH Zurich study: AI-generated context reduces success 3%, increases cost 20%. Concept pages must be PROPOSED by AI, REVIEWED by human. | ETH Zurich study on human-curated AGENTS.md |
| **No agent swarms for sync** | Osmani: 3-5 agent ceiling. More agents add coordination overhead, not throughput. Ambiant anxiety taxes human reviewers. The brain makes each agent better, not more numerous. | Parallel agent limit research, METR RCT |
| **No monolithic context dump** | Progressive disclosure only: routing.md (400t) → index.md (cluster narrowed) → page. If protocol.md > 500 tokens, lint errors. | Curse of instructions, context bloat research |
| **No CLAUDE.md-as-security** | $30K API key incident proved CLAUDE.md is a suggestion, not enforcement. Security-critical constraints are enforced by block hooks. | Guardrails hierarchy research |
| **No replacement for agentctx** | The brain is a layer ON TOP of agentctx. agentctx handles scanning, multi-tool output, skills, dashboard, 156 agents. The brain handles wikilinks, concepts, auto-sync. | Architecture convergence |
| **No vibe coding** | The brain documents what exists; it doesn't generate code. Proof over vibes: every artifact accompanied by evidence it works. AI-generated code has logic errors at 1.75x the rate and XSS at 2.74x the rate. | Proof over vibes, verification-driven development |
| **No self-verification** | Generator and Verifier are separate agents. Self-review is less reliable than separate-agent review (Anthropic/DeepMind/Meta research convergence on "verification is easier than generation"). | Generator-Verifier architecture, layered verification |
| **No combined investigation + implementation** | Same cognitive operations conflict. Investigation is exploratory; implementation is surgical. Mixing them produces vague acceptance criteria. The sync pipeline separates them (Phase 1: Investigate, Phase 2: Update). | Task explosion pattern research |
| **No CLAUDE.md-only guardrails** | Guardrails at input, execution, and output layers. Neither layer alone is sufficient. | Guardrails hierarchy, three-tier boundaries |

## Design Philosophy

The constraint system mirrors three-tier boundaries: **Always** (auto-sync), **Ask First** (propose concepts, archive pages), **Never** (delete concepts, overwrite human content). The human partner can always override any boundary — they own the codebase.

The brain's job is to REDUCE comprehension debt, not add to it. If reading the brain is harder than reading the code, the system failed.

See also: [[05-guardrails-and-constraints]] for the full constraint details, [[01-problem-and-solution]] for the research foundation.
