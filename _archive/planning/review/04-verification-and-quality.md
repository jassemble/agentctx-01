# Review: Verification & Quality Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| verification-driven-development.md | **COVERED** | Core to all phases — every phase has Verifier handoff before proceeding |
| layered-verification.md | **COVERED** | Code Brain Integration: "3-tier verification" — deterministic → heuristic → human |
| verification-bottleneck.md | **COVERED** | Every phase has its own verifier, which addresses the bottleneck by distributing verification |
| quality-gates.md | **COVERED** | Section: "SKILL.md body structure → Gate Conditions → PRE/POST what must be true" |
| machine-verifiable-criteria.md | **COVERED** | Phase 1: "task list with boolean acceptance criteria"; verifier rubrics use boolean pass/fail |
| qa-validation-loops.md | **COVERED** | Phase 3: "validates, commits"; Phase 4: "Coverage threshold, tests pass, edge cases covered" |
| periodic-refocusing.md | **COVERED** | Covered via MAX_ITERATIONS=3 kill criteria and log consolidation every 10 entries |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| test-driven-development-ai.md | **PARTIAL** | Referenced via QA loops but RED-GREEN-REFACTOR cycle not explicitly called out in implementation/testing phases | Add to Phase 3 (Implementation): "Use RED-GREEN-REFACTOR: write failing test first, implement, refactor while passing" |
| proof-over-vibes.md | **PARTIAL** | Implied by verification but not stated as a design principle | Add to protocol.md as a core principle: "Proof over vibes — every artifact must be accompanied by evidence it works" |
| demo-quality-trap.md | **PARTIAL** | Not addressed — the risk of agents producing code that works in demo but not real usage | Add to Phase 4 (Testing): "Test against real production-like data, not hand-crafted fixtures. Demo ≠ production." |
| anti-slop-rigor.md | **PARTIAL** | Referenced in skill-as-code-behavior but not as a standalone quality principle | Add to protocol.md: "Anti-slop rigor — all criteria must be machine-verifiable boolean checks, never subjective assessments" |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
| agent-browser-testing.md | **GAP** | Agent-driven headless browser automation (open, snapshot, click, fill, screenshot, console) for UI verification. Structured acceptance criteria follow `"agent-browser: <command> - <expected result>"` pattern. The compound-product repo mandates browser verification as a hard gate — frontend tasks are NOT complete until browser verification passes. | Add to Phase 4 (Testing) references: "browser-automation.md — structured UI verification via headless browser commands (open/snapshot/click/fill/screenshot/console). Frontend tasks require browser-gate: verify UI changes work before marking complete. Machine-verifiable criteria produce boolean pass/fail" |
| pr-contract.md | **GAP** | PR Contract defines what PR reviewers should look for (tests, screenshots, security, performance). Should be a dedicated verifier rubric in Phase 3 (Implementation) | Add to `skills/implementation/SKILL-verifier.md` Rubric: "PR Contract checks: tests exist and pass, screenshots for UI changes, security review for auth/data changes, no performance regression" |
| inference-speed.md | **GAP** | The framework doesn't discuss when to use faster/cheaper models vs. high-quality ones for different phases | Add to protocol.md or create `profiles.md`: "Phase 1 (Requirements): Sonnet is fine. Phase 5 (Deployment, safety): Opus required. Phase 3 (Implementation): inherit" |
| constitutional-ai.md | **GAP** | Our three-tier boundaries (Always/Ask/Never) are a form of constitution, but it's not framed as such | Add to wiki/concepts/constitutional-ai.md — explain how our guardrails hierarchy IS a constitution for the SDLC agents |

## IMPROVEMENTS

| Concept | Current | Enhancement |
|---------|---------|-------------|
| productivity-paradox-evidence.md | Mentioned generally in context | Add specific finding to protocol.md: "METR RCT: AI made devs 19% slower. Our framework must track actual verification time, not just 'task completed'" |
| vibe-coding.md | Referenced as a contrast | Add to "What Makes This Different" table — explicitly contrast vibe coding (prompt→accept→don't review) with SDLC framework (prompt→follow pipeline→verify→gate) |
| seventy-percent-problem.md | Referenced in context | Add to requirements phase: "The 70% problem — AI gets first 70% right, stalls on last 30%. Our pipeline's 3-tier verification targets exactly this gap" |
