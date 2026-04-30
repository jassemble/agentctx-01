# Review: Cognitive Constraints Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| cognitive-load-of-parallel-agents.md | **COVERED** | Referenced in context: "3-4 agent ceiling" in Code Brain constraints |
| comprehension-debt.md | **COVERED** | Referenced: "comprehension debt" in cognitive constraints |
| ambient-anxiety-tax.md | **COVERED** | Referenced: "ambient anxiety" in cognitive constraints |
| productivity-paradox-evidence.md | **COVERED** | Referenced in context section |
| curse-of-instructions.md | **COVERED** | Referenced via context-engineering research in context section |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| pink-elephant-problem.md | **PARTIAL** | Referenced in Code Brain plan (anchoring bias from irrelevant AGENTS.md content) but no mitigation strategy in SDLC plan | Add to protocol.md: "Avoid irrelevant context injection — only load skills matching current phase and task type" |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
| knowledge-paradox.md | **GAP** | Counterintuitive: AI helps experienced developers MORE, not less. Seniors use AI to accelerate known work; juniors accept AI suggestions blindly producing "house of cards code". METR RCT found "high developer familiarity" actually slowed devs down — experts under-specify prompts assuming shared context. Our framework should acknowledge this in the Human Partner Convention | Add to protocol.md: "Knowledge paradox: framework assumes experienced human partner. For junior users, add more verifier checks and require evidence over trust. SKILL.md should not skip steps — assume the human needs to see each gate's proof" |
| prompt-precision-vs-model-size.md | **GAP** | Our plan doesn't discuss how structured prompts and skill files perform across different model sizes | Add to wiki/concepts/prompt-precision-vs-model-size.md — "XML/structured prompts raise output quality floor regardless of model. Our SKILL.md body sections use structured headers (## Instructions, ## Pipeline) following this principle" |
