# Integration Gap Summary — agentctx-idea vs. Our SDLC Framework

## Sources Coverage (22 sources in agentctx-idea wiki)

| Source | Referenced in Our Plan? |
|--------|----------------------|
| 5-agent-skill-design-patterns | YES — 5 skill patterns used throughout |
| best-practices-ai-agents-subagents-skills-mcp | INDIRECT — MCP security gap identified |
| code-agent-orchestra | YES — Factory Model |
| compound-product-repo | YES — Compound Pipeline, Task Explosion, Self-Clarification |
| get-shit-done-repo | INDIRECT — GSD workflow referenced but not explicitly named |
| self-improving-coding-agents | YES — Ralph Wiggum technique, AGENTS.md, QA loops |
| spec-writing-for-ai-agents | YES — Self-clarification, context engineering |
| stop-using-init-for-agents-md | YES — AGENTS.md hierarchy, pink elephant problem |
| superpowers-repo | NO — TDD, anti-slop rigor, skill-as-code philosophy |
| verify-before-work | YES — VDD, layered verification |
| verify-before-work-web-research | INDIRECT — Constitutional AI, academic VDD evidence |
| verify-before-work | YES — VDD |

**Sources not explicitly referenced**: superpowers-repo (TDD/anti-slop), code-review-in-the-age-of-ai (proof over vibes), ui-ux-pro-max-skill-repo, claude-code-swarms, claude-mem-repo, parallel-agent-limit, prompt-engineering-playbook-for-programmers, awesome-claude-code-repo

---

## Overall Counts Across All 10 Review Batches

| Rating | Count | % |
|--------|-------|---|
| COVERED | ~48 | 44% |
| PARTIALLY | ~32 | 30% |
| GAPS | ~21 (18 + 3 late-found) | ~19% |
| IMPROVEMENTS | ~10 | 9% |

---

## Top 10 Actionable Gaps (Prioritized — fill these into our PLAN-sdlc-framework.md)

### 1. **TDD / RED-GREEN-REFACTOR** (from superpowers-repo)
**Missing from**: Phase 3 (Implementation), Phase 4 (Testing)
**Add**: "RED-GREEN-REFACTOR cycle: write failing test first (RED), implement to pass (GREEN), refactor while keeping tests green"
**Location**: SKILL.md body for implementation and testing phases
**Priority**: HIGH — TDD is the most reliable way to get agents to produce correct code

### 2. **Proof Over Vibes** (concept + pr-contract)
**Missing from**: protocol.md, verifier rubrics
**Add**: "Every artifact must be accompanied by evidence that it works — tests passed, screenshots for UI, logs for backend. Code claims without proof are rejected."
**Location**: protocol.md (core principle), verifier rubrics (check for evidence)
**Priority**: HIGH — addresses the quality trap directly

### 3. **MCP Security** (tool-poisoning, rug-pull, prompt-injection)
**Missing from**: protocol.md, security section
**Add**: Security section to protocol.md auditing tool descriptions, verifying MCP definitions unchanged, sanitizing user input
**Location**: protocol.md, wiki/concepts/mcp-security.md
**Priority**: HIGH — security vulnerabilities in production

### 4. **XML Structured Prompts** (xml-prompt-engineering)
**Missing from**: pipelines/ definition format
**Add**: Use XML tags (`<task>`, `<acceptance_criteria>`, `<verification>`) in pipeline files for machine-parseable structure
**Location**: All 5 pipeline files in pipelines/
**Priority**: MEDIUM — improves reliability of subagent instruction parsing

### 5. **Model Profiles** (inference-speed, multi-provider-llm-fallback)
**Missing from**: Entire plan
**Add**: `profiles.md` with phase-appropriate model recommendations
**Location**: protocol.md or profiles.md
**Priority**: MEDIUM — cost vs. quality tradeoff per phase

### 6. **Human Partner Language** (terminology convention)
**Missing from**: protocol.md
**Add**: Style convention — "human partner" vs "user" phrasing for deliberate psychological framing
**Location**: protocol.md
**Priority**: LOW — affects agent psychology/perception

### 7. **Behavioral Developer Profiling** (behavioral-developer-profiling)
**Missing from**: wiki/
**Add**: `entities/agent-profile.md` — stored developer preferences for agent behavior customization
**Location**: wiki/entities/ or per-project .agentctx/
**Priority**: MEDIUM — personalization improves output alignment

### 8. **Anti-Slop Rigor** (standalone principle)
**Missing from**: protocol.md
**Add**: Explicit anti-slop rules in all verifier rubrics — boolean checks only, no "looks right" judgments
**Location**: protocol.md, all SKILL-verifier.md files
**Priority**: HIGH — prevents subjective quality degradation

### 9. **Skill Atrophy Detection** (skill-atrophy)
**Missing from**: wiki lint operation
**Add**: Wiki lint should check: "Do SKILL.md references/ still match current code patterns? Has skill content drifted from actual project?"
**Location**: scripts/wiki-lint.sh
**Priority**: MEDIUM — skills become inaccurate over time

### 10. **PR Contract** (pr-contract)
**Missing from**: Phase 3 (Implementation), Phase 5 (Deployment)
**Add**: PR contract verifier rubric — tests pass, screenshots for UI, security review for auth changes, no perf regression
**Location**: skills/implementation/SKILL-verifier.md, skills/deployment/SKILL-verifier.md
**Priority**: HIGH — code review standards for agent output

### 11. **LLMs.txt** (for agent ecosystem)
**Missing from**: Repo structure
**Add**: llms.txt describing the entire framework, all 12 skills, installation
**Location**: repo root
**Priority**: LOW — discoverability for other agents

---

## Late-Found Concepts (3 additional concepts missed in initial review)

| Concept | Status | Added To | Relevance |
|---------|--------|----------|-----------|
| agent-browser-testing.md | **GAP** → review/04-verification-and-quality.md | Testing — headless browser automation for UI verification with machine-verifiable acceptance criteria |
| knowledge-paradox.md | **GAP** → review/05-cognitive-constraints.md | Cognitive — AI helps experienced devs more; framework should account for senior vs. junior user differences |
| risk-management.md | **GAP** → review/07-security-and-guardrails.md | Security — branch isolation, sandboxing, emergency kill for autonomous agents |

---

## Concepts NOT Applicable to SDLC Framework

These concepts from agentctx-idea wiki are domain-specific or not relevant to our SDLC framework:

| Concept | Reason |
|---------|--------|
| design-system-generation.md | Frontend-specific — covered by patterns.dev-skills |
| core-web-vitals.md | Domain-specific — covered by patterns.dev-skills |
| seo-optimization.md | Domain-specific — covered by patterns.dev-skills |
| web-accessibility.md | Domain-specific — covered by patterns.dev-skills |
| ui-style-catalog.md | Frontend-specific — covered by patterns.dev-skills |
| pre-delivery-checklist-ui.md | Frontend-specific — could be Phase 4 edge case |
| industry-specific-reasoning.md | Domain-specific — not core to SDLC |
| rubber-duck-debugging-ai.md | Technique, not SDLC phase methodology |
| lsp-for-agents.md | IDE-specific — not required for framework |
| constitutional-ai.md | Covered by our guardrails hierarchy |
| master-overrides-pattern.md | Niche — human override is implied |
| privacy-tags.md | Optional feature |

## New Recommendations Based on This Review

1. **Create `profiles.md`** — model recommendations per phase (Sonnet/Opus/Haiku)
2. **Add TDD explicitly** to Phase 3 and Phase 4 SKILL.md files
3. **Add `security/` section** to protocol.md (MCP, tool poisoning, prompt injection)
4. **Add "Proof over vibes"** core principle to protocol.md
5. **Add anti-slop rules** to all verifier rubrics
6. **Use XML structure** in pipeline files for machine parseability
7. **Create `llms.txt`** in repo root for agent discoverability
8. **Add skill-atrophy detection** to wiki lint script
9. **Reference superpowers-repo** as a source for TDD philosophy
10. **Create `human-partner-language.md`** in wiki/concepts/ — define terminology conventions
