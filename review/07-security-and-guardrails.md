# Review: Security & Guardrails Concepts

Reviewed against: PLAN-sdlc-framework.md

---

## COVERED

| Concept | Status | Where in Our Plan |
|---------|--------|-------------------|
| guardrails-hierarchy.md | **COVERED** | Referenced in context: "Guardrails: CLAUDE.md → warn hooks → block hooks" |
| three-tier-boundaries.md | **COVERED** | Every SKILL.md has "Three-Tier Boundaries" section (Always/Ask/Never table) |
| tool-poisoning.md | **PARTIAL** | Not in our plan |
| mcp-security.md | **PARTIAL** | Not in our plan |
| rug-pull-attack.md | **GAP** | Attack pattern not in our plan |
| prompt-injection-detection.md | **GAP** | Not in our plan |
| constitutional-ai.md | **GAP** | Not explicitly covered |
| master-overrides-pattern.md | **GAP** | Not in our plan |

## GAPS

| Concept | Status | Recommendation |
|---------|--------|----------------|
| risk-management.md | **GAP** | Safeguards for autonomous agents: run on feature branch (never main directly), read-only commands auto-approved, sandbox execution (Docker/VM), emergency kill always available. Multi-model cross-check for planning vs coding. Context summarization for long runs. | Add to Phase 3 SKILL.md boundaries: "Autonomous execution only on feature branch. Destructive commands require human approval. Emergency stop always available. Long runs require periodic refocusing (pause, re-plan, verify no drift)." Add to protocol.md safety section. |
| tool-poisoning.md | **GAP** | Attack where malicious MCP tool hides instructions in description field. Our framework will likely use MCP tools. Add security section to protocol.md: "All MCP tool descriptions must be audited. Greb for `<IMPORTANT>`, `SYSTEM`, `ignore previous` patterns before connecting any MCP server." Add to verifier skill: check for tool poisoning indicators |
| mcp-security.md | **GAP** | Broader MCP security issues. Add to wiki/concepts/mcp-security.md — "Our framework's MCP tool usage follows: audit descriptions, verify tool sources, never connect untrusted MCP servers to projects with sensitive data" |
| rug-pull-attack.md | **GAP** | Tool behavior changes AFTER initial approval. Our framework should verify tool definitions remain unchanged between runs. Add to wiki lint: "verify MCP tool definitions haven't changed since last use" |
| prompt-injection-detection.md | **GAP** | User input could contain injection. Add to protocol.md: "When ingesting user requirements for Phase 1, validate input against known injection patterns. If template content comes from external sources, sanitize before embedding in SKILL.md context" |
| master-overrides-pattern.md | **GAP** | When human explicitly overrides agent behavior, the agent should comply. Our Three-Tier Boundaries have "Ask First" but never "Human can override." Add boundary table to protocol.md: "Human partner can always override any boundary — they own the codebase" |
| privacy-tags.md | **GAP** | Not in our plan. Skills could have `privacy: public | restricted | confidential` tags controlling what information they can access. Add to SKILL.md YAML schema |

## IMPROVEMENTS

| Concept | Current | Enhancement |
|---------|---------|-------------|
| guardrails-hierarchy.md | Referenced in context | Expand in protocol.md: "Our guardrails hierarchy: CLAUDE.md (model-interpreted, can be overridden) → warn hooks (non-blocking alerts) → block hooks (unconditional, exit code 2). Never rely solely on CLAUDE.md for security-critical constraints" |
