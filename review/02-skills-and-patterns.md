# Review: Skills Pattern Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| agent-skills-pattern.md | **COVERED** | SKILL.md schema section, extends agentskills.io spec |
| agent-skills-injection.md | **COVERED** | Skill trigger_phrases in YAML, progressive disclosure in SKILL.md body |
| agent-skill-ecosystem.md | **COVERED** | related_skills field in YAML, wikilink connections between skills |
| skill-as-code-behavior.md | **COVERED** | Stated explicitly: "Skills are NOT documentation — they are code that shapes agent behavior" |
| skill-pattern-tool-wrapper.md | **COVERED** | Used as Scan brain service pattern, references/ loading model |
| skill-pattern-generator.md | **COVERED** | Every SKILL.md is a Generator by default |
| skill-pattern-reviewer.md | **COVERED** | Every SKILL-verifier.md is a Reviewer |
| skill-pattern-inversion.md | **COVERED** | Phase 1: Requirements uses Inversion (self-clarification) |
| skill-pattern-pipeline.md | **COVERED** | Phase 5: Deployment uses Pipeline-only pattern |
| brainstorming-skill.md | **COVERED** | Referenced via Inversion pattern — self-clarification is essentially brainstorming without user |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| skill-atrophy.md | **PARTIAL** | Our plan updates SKILL.md but doesn't explicitly track when skills become stale as code evolves | Add verifier check: "Skill accuracy degrades if code patterns no longer match skill references" — run as part of wiki lint |
| compound-config-pattern.md | **PARTIAL** | Our plan has per-phase configs but doesn't discuss how configs compound across phases (e.g., impl phase learns from design phase feedback) | Add to pipelines/ — describe config inheritance between phases |
| anti-slop-rigor.md | **PARTIAL** | Mentioned via verification but not explicitly as a design principle | Add to protocol.md: "Skills must include anti-slop rules — no vague criteria, no 'looks right' judgments" |
| mandatory-agent-workflows.md | **PARTIAL** | Our plan describes workflows but doesn't mark any as MANDATORY vs. advisory | Add to SKILL.md → Instructions section: mark critical rules as "MUST" (enforced by verifier) vs. "SHOULD" (advisory) |
| gsd-workflow.md | **PARTIAL** | Our discuss→plan→execute→verify→ship loop is similar but not explicitly named | Reference in protocol.md: "This framework follows a discuss→plan→execute→verify→ship loop inspired by [[gsd-workflow]]" |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
| human-partner-language.md | **GAP** | Superpowers repo uses "your human partner" terminology for deliberate psychological framing | Add to protocol.md as a style convention — it affects how agents perceive their role |
