# Review: Context & Memory Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| agents-md-pattern.md | **COVERED** | Referenced in "What exists in agentctx-idea wiki" as existing foundation; AGENTS.md discussed in maintenance pipeline output |
| agents-md-hierarchy.md | **COVERED** | Our Schema Layer = Layer 1 (protocol.md), Skills Layer = Layer 2 (skills/), Wiki = Layer 3 |
| context-engineering.md | **COVERED** | Multiple references: progressive disclosure in SKILL.md trigger_phrases, Schema/Wiki/Skills 3-layer architecture |
| context-isolation.md | **COVERED** | Covered via Brain SessionStart loading minimal context; skills loaded on-demand via triggers |
| context-window-management.md | **COVERED** | SKILL.md <500 lines rule, protocol <500 tokens, routing <400 tokens — all token budgets |
| progressive-disclosure-memory.md | **COVERED** | SKILL.md "Details" section loaded on request; progressive disclosure in references/ |
| persistent-memory-system.md | **COVERED** | Brain episodic/semantic memory section; log.md + patterns.md consolidation |
| memory-persistence.md | **COVERED** | Brain's 4 memory channels (git history, progress log, task state, semantic memory) |

## PARTIALLY COVERED

| Concept | Status | Gap | Recommendation |
|---------|--------|-----|----------------|
| context-bloat.md | **PARTIAL** | Mentioned in anti-bloat section of original Code Brain plan but not explicitly in SDLC plan | Add to wiki/concepts/context-bloat.md — explain how we prevent it (token budgets, progressive disclosure, periodic consolidation) |
| context-rot.md | **PARTIAL** | Our wiki will be maintained by Brain, but there's no explicit mechanism to detect when wiki pages have become stale relative to the skills they reference | Add to wiki lint: "stale claims" check should include cross-referencing wiki claims against current SKILL.md content |
| size-limited-artifacts.md | **PARTIAL** | Token budgets in our plan (SKILL.md <500 lines, protocol <500 tokens) implement this, but we don't cite it as a formal concept | Add to wiki/concepts/ — "All artifacts follow size-limited pattern: protocol <500t, routing <400t, SKILL.md <500 lines, wiki pages <30K tokens" |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
| llms-txt.md | **GAP** | LLMs.txt is a pattern for providing a single file that describes a codebase/package to LLMs. Our protocol.md serves this for the wiki itself, but we should also create an llms.txt for the skill ecosystem | Add `llms.txt` to repo root — describes the entire agentctx SDLC framework, all 12 skills, what it does, installation |
| dependency-tracking.md | **GAP** | Our plan doesn't track what skills depend on what other skills beyond related_skills in YAML — there's no dependency graph visualization or impact analysis when a skill changes | Add `scripts/skill-dependencies.sh` — builds dependency map from related_skills fields, outputs DOT graph for visualization |

## IMPROVEMENTS

| Concept | Current | Enhancement |
|---------|---------|-------------|
| ace-framework.md | Indirectly referenced via context engineering research | Add explicit guidance: Dynamic context (selective skill loading based on task type) outperforms static context by 12.3%. Our trigger_phrases implement ACE — make this explicit in protocol.md |
| bm25-hybrid-search.md | Not in plan | As wiki grows beyond ~100 pages, simple grep is insufficient. Add to wiki Lint operation: "If wiki > 100 pages, consider adding BM25/vector search (qmd, etc.)" |
| vector-based-context-retrieval.md | Not in plan | Similar to BM25 — add to wiki/concepts/ as a "when needed" option: when context search becomes insufficient for wiki querying |
| hybrid-semantic-search.md | Not in plan | For the wiki, hybrid search (keyword + semantic) would improve Query operation quality. Note as future optimization |
