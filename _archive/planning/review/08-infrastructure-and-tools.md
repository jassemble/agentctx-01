# Review: Infrastructure & Tools Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| lifecycle-hooks-architecture.md | **COVERED** | Brain's 5 hooks fully documented: SessionStart, PostToolUse, SessionEnd, Stop, UserPromptSubmit |
| token-economics.md | **COVERED** | Token budget rules everywhere: SKILL.md <500 lines, protocol <500 tokens, routing <400t, wiki pages <30K tokens |
| performance-budget.md | **COVERED** | Implicit in token budgets and SKILL.md size limits |
| compound-learning.md | **COVERED** | Maintenance phase: "Update AGENTS.md with new learnings (compound learning)" |
| compound-config-pattern.md | **COVERED** | Referenced in skills/ — configs build on each other across phases |
| wave-based-execution.md | **COVERED** | Pipeline composition model allows parallel vs sequential phase execution |
| gsd-workflow.md | **COVERED** | Our discuss→plan→execute→verify→ship loop maps to GSD workflow |
| discuss-mode-options.md | **COVERED** | Phase 1: Requirements Inversion = discuss-mode |
| size-limited-artifacts.md | **COVERED** | Token budgets throughout implement this principle |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| multi-provider-llm-fallback.md | **PARTIAL** | Our plan mentions profiles implicitly but doesn't specify provider fallback for different phases | Add to protocol.md: "Provider fallback: Phase 1-4 can use Sonnet. Phase 5-6 (Deployment/Maintenance, safety-critical) require Opus. Budget mode: Haiku for linting/search tasks" |
| cross-platform-agent-support.md | **PARTIAL** | Not discussed — which platforms/agents this framework targets (Claude Code, Cursor, Codex, etc.) | Add to README.md: "This framework works with any agent that supports the agentskills.io specification. Currently tested against: Claude Code, Cursor. Compatible with: any MCP-based agent runtime" |
| behavioral-developer-profiling.md | **PARTIAL** | Not in our plan — profiling developer preferences to customize agent behavior | Add to `entities/agent-profile.md` in wiki — "Agent behavior adapts to developer preferences recorded in profile. Some devs prefer verbose explanations, others want terse diffs. Profile is stored and applied per session" |
| inference-speed.md | **PARTIAL** | No model selection guidance in our plan | See security batch — add profiles.md with phase-appropriate model recommendations |
| dependency-tracking.md | **PARTIAL** | related_skills field provides basic dependency tracking | See context/memory batch — add skill-dependencies script for full dependency visualization |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
