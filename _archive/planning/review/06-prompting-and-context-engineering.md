# Review: Prompting & Context Engineering Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| context-engineering.md | **COVERED** | Referenced in context section; progressive disclosure architecture |
| prompt-engineering-patterns.md | **COVERED** | Implicit in SKILL.md structure: When to Use → Instructions → Pipeline → Templates → References |
| skill-pattern-inversion.md | **COVERED** | Phase 1: Requirements uses Inversion (self-clarification before output) |
| discuss-mode-options.md | **COVERED** | Phase 1: Requirements Inversion is essentially discuss-mode |
| few-shot-prompting.md | **COVERED** | Covered via templates/ mechanism — templates serve as few-shot examples of correct output |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| prompt-anti-patterns.md | **PARTIAL** | Our plan shows what to DO but doesn't explicitly call out what NOT to do in prompts/skills | Add to protocol.md: "Prompt anti-patterns to avoid: vague acceptance criteria, over-specification, context stuffing, conflicting instructions" |
| xml-prompt-engineering.md | **PARTIAL** | Our protocol.md and pipeline files use markdown headers, not XML. GSD repo uses XML (`<task>`, `<acceptance_criteria>`) for structured parsing | Add to `pipelines/` files: use XML structure for machine-parseable pipeline definitions (task lists, acceptance criteria, verification steps) |
| prompt-precision-vs-model-size.md | **PARTIAL** | Not explicitly referenced in our plan | Add to wiki/concepts/ — see cognitive constraints batch |
