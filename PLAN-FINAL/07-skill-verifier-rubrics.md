# Skill Verifier Rubrics — Boolean Pass/Fail Checks

## Lint Checklist (for Brain Verifier)

This checklist lives in `.ctx/references/lint-checklist.md` (swappable rubric). Every item has a clear criterion, machine-verifiable check, and severity.

| Check | Criterion | Severity | Machine-verifiable? |
|---|---|---|---|
| Broken wikilinks | Every `[[type:name]]` resolves to a file at the expected path | ERROR | Yes — file exists check |
| Stale modules | `source-hash` in module frontmatter matches current git hash of source files | WARNING | Yes — hash comparison |
| Orphan entities | Entity page has >=1 inbound wikilink from another page | WARNING | Yes — backlink grep |
| Missing modules | Every non-test source directory has a corresponding module page | ERROR | Yes — directory scan vs module catalog |
| Pattern drift | Each claim in patterns.md matches actual code patterns | WARNING | Partial — needs LLM confirm |
| Token overflow | No page exceeds 30K tokens | WARNING | Yes — word count * 0.75 estimate |
| Protocol bloat | protocol.md is under 500 tokens | ERROR | Yes |
| Contradiction | No two pages claim opposite facts about the same entity/concept | WARNING | Partial — LLM comparison |
| Orphan concepts | Concept page has >=1 inbound wikilink | INFO | Yes — backlink grep |
| Stale log | Log last entry is <=7 days old | INFO | Yes — date comparison |
| Missing verification | status.md has a verification entry for every module | WARNING | Yes — status.md check |
| Low-confidence edges | INFERRED edges with confidence < 0.5 flagged for human review | INFO | Yes — frontmatter confidence field |
| EXTRACTED edge validity | EXTRACTED edges resolve to actual code references (import/call) | WARNING | Yes — AST cross-check |
| Community map staleness | community_map.md clusters match current module relationships | WARNING | Partial — Leiden re-run comparison |

Lint output: structured report grouped by severity (ERROR/WARNING/INFO) with a score and top 3 recommendations.

## Phase-Specific Verifier Rubrics

### Requirements Verifier (PRD Audit)

| Check | Severity |
|---|---|
| PRD has goal, scope, non-goals sections | ERROR |
| Each requirement has boolean acceptance criteria | ERROR |
| Stakeholders identified in PRD | WARNING |
| Self-clarification questions answered or marked N/A | WARNING |
| No ambiguous language ("should", "might", "could") | INFO |

### Design Verifier (Architecture Review)
| Check | Severity |
|---|---|
| All PRD requirements mapped to design decisions | ERROR |
| Tradeoffs documented for each architectural choice | WARNING |
| No premature optimization (performance not spec'd) | WARNING |
| ADRs created for decisions with >=2 viable options | INFO |

### Implementation Verifier (PR Contract)
| Check | Severity |
|---|---|
| Test files exist for all changed logic paths | ERROR |
| All tests pass (RED-GREEN-REFACTOR cycle completed) | ERROR |
| Typecheck clean (no errors) | ERROR |
| Lint clean (no warnings) | WARNING |
| Screenshots for UI changes | WARNING |
| Security review for auth/data changes | WARNING |
| No performance regressions in critical paths | WARNING |
| One commit per task (atomic commits) | INFO |

### Testing Verifier
| Check | Severity |
|---|---|
| Test plan covers unit, integration, and E2E scopes | ERROR |
| Tests use production-like data (not hand-crafted fixtures) | ERROR |
| Edge cases covered (not just happy path) | WARNING |
| No flaky tests (repeated runs pass) | WARNING |
| UI changes have headless browser automation tests (Playwright/Puppeteer) with machine-verifiable acceptance criteria (screenshots, DOM assertions) | WARNING |
| Coverage meets team-defined threshold | INFO |

### Deployment Verifier
| Check | Severity |
|---|---|
| Rollback path exists and is documented | ERROR |
| Secrets not in config (env vars or secret management) | ERROR |
| Monitoring covers new feature | WARNING |
| Pre-deploy checklist completed | WARNING |
| Runbook has pre-check → deploy → verify → rollback steps | INFO |

## Skill Atrophy Detection

The wiki lint also checks for skill accuracy:

| Check | Severity |
|---|---|
| SKILL.md references/ still match current codebase patterns | WARNING |
| Templates/ outputs match what Generator phases actually produce | WARNING |
| Trigger phrases still match common user intents (from query log) | INFO |
| related_skills links still point to relevant skills | INFO |

If any skill fails the atrophy check, the lint report flags it with "SKILL ATROPHY: [skill] — references outdated" and recommends a skill update.

See also: [[05-guardrails-and-constraints]] for the verification philosophy, [[03-agents]] for how verifiers work with generators.
