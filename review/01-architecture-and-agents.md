# Review: Architecture & Agent Patterns Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| factory-model.md | **COVERED** | Mentioned in Context → "Factory Model" as existing architecture; Pipeline composition in pipelines/ |
| compound-pipeline.md | **COVERED** | pipelines/ directory maps to compound pipeline concept; Phase 3: Implementation pipeline section |
| continuous-coding-loop.md | **COVERED** | Phase 3: Implementation → "Generator + Pipeline + Continuous Coding Loop" |
| generator-verifier-architecture.md | **COVERED** | Core to entire plan — every phase has SKILL.md + SKILL-verifier.md |
| planner-worker-model.md | **COVERED** | Covered via Generator-Verifier split; pipeline orchestration handles planning aspect |
| spec-driven-development.md | **COVERED** | Phase 1: Requirements (Inversion + self-clarification + task explosion pipeline) |
| self-clarification-pattern.md | **COVERED** | Phase 1: "Agent self-clarifies (5 questions) before generating PRD" |
| task-explosion-pattern.md | **COVERED** | Phase 1: "Explode into 8-15 tasks (task explosion)" |
| autonomous-vs-oversight.md | **COVERED** | Covered via Three-Tier Boundaries (Always/Ask/Never) and human-in-the-loop for concept approvals |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| agent-teams.md | **PARTIAL** | Mentions 3-4 agent ceiling but doesn't design multi-agent team workflows across phases | Add `agents/` section to wiki/ describing when parallel vs sequential phase execution is appropriate |
| agentic-engineering.md | **PARTIAL** | Referenced generally as methodology but not explicitly mapped to SDLC phases | Add explicit mapping: "Agentic Engineering → this framework IS the operationalization" |
| conductor-to-orchestrator-shift.md | **PARTIAL** | Implied via skill architecture but not explicitly discussed | Add to wiki/concepts/ as a bridge between human dev and agent-executor model |
| monolithic-vs-multi-agent-architecture.md | **PARTIAL** | Our plan uses Generator-Verifier split (2 agents per phase = 12 total) but doesn't discuss when to combine or separate | Add guidance in protocol.md on per-phase agent count vs. monolithic agent |
| orchestration-tiers.md | **PARTIAL** | Covered implicitly in pipeline gating but not explicitly | Add to pipelines/ — explain orchestration as tiered: spec→design (human-heavy), impl→test (agent-heavy), deploy (human-gate) |
| subagent-driven-development.md | **PARTIAL** | Our plan has per-phase agents but not intra-phase subagent delegation | Add to Phase 3 (Implementation) → "Agent delegates lint/typecheck to subagents, focuses on logic" |
| subagent-pattern.md | **PARTIAL** | Not explicitly discussed as a design pattern within skills | Add to references/ section of any skill that delegates work (e.g., implementation skill delegates typecheck) |
| agentic-coding-patterns.md | **PARTIAL** | Referenced as existing research but not synthesized into skill instructions | Create wiki/concepts/agentic-coding-patterns.md summarizing the patterns our skills implement |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
| pr-contract.md | **GAP** | PR Contract (review standards with evidence requirement) should be a Deployment/Maintenance phase template or verifier rubric item. Add "pr-contract.md" to deployment templates OR add to code verifier: "Require proof (tests, screenshots) not just claims" |

## IMPROVEMENTS

| Concept | Current | Enhancement |
|---------|---------|-------------|
| wave-based-execution.md | Implicitly in pipeline parallel testing | Make explicit in pipelines/ → explain that Phase 4 testing can run in waves (unit → integration → E2E) rather than all at once |
