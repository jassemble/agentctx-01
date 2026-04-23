# Guardrails & Constraints — Always/Ask/Never, Security, Verification

## Three-Tier Boundaries (Always/Ask/Never)

| Action | Tier | Mechanism |
|---|---|---|
| Auto-sync module docs (hash changed) | Always | Auto |
| Auto-update entity signatures | Always | Auto |
| Auto-update routing.md keywords | Always | Auto |
| Auto-append to log.md | Always | Auto |
| Auto-update status.md counts | Always | Auto |
| Create new concept page | Ask First | PROPOSED status, human review required |
| Change concept description | Ask First | [Proposed change] appended, human approves |
| Archive a page | Ask First | Move to archive/ with date stamp |
| Modify patterns.md | Ask First | Propose pattern change, human reviews |
| Delete entity page | Ask First | Only if no inbound links, human confirms |
| Delete concept page | Never | Concepts archival only (move to archive/) |
| Overwrite human-enriched content | Never | Always append with `[Superseded]` |
| Sync without verification passing | Never | Block phase — fix or report stuck |

---

## Guardrails Hierarchy

From the guardrails hierarchy research, guardrails sit at multiple points:

| Layer | What | Mechanism |
|---|---|---|
| **Pre-input** | Validate spec/PRD being ingested | Block hooks: reject if contains `<private>` markers, PII patterns |
| **Pre-execution** | Block destructive ops on brain | Block hooks: no deletion of concepts, no overwriting CONFIRMED pages |
| **Post-output** | Validate brain pages are correct | Generator-Verifier split: separate agent checks accuracy |
| **Lifecycle** | Prevent context rot within sessions | SessionStart hook loads minimal context, SessionEnd compresses and persists |

The `CLAUDE.md` is **model-interpreted** (can be overridden). Warn hooks give non-blocking alerts. Block hooks enforce unconditionally (exit code 2). This matches the `$30K API key incident` lesson: CLAUDE.md instructions don't stop leaks — only block hooks do.

---

## MCP Security Rules

| Attack | Mechanism |
|---|---|
| **Tool Poisoning** | Before loading any MCP tool, grep its description for hidden instruction patterns (`<IMPORTANT>`, `SYSTEM`, `ignore previous`). If found, reject the tool. |
| **Rug-pull Prevention** | Verify MCP tool definitions haven't changed since last session. If hash differs, re-audit before use. |
| **Input Sanitization** | User-submitted requirements/specs validated against known prompt injection patterns before embedding in SKILL.md context. |
| **No Secrets in Templates** | Token paths, API keys, credentials — never in templates, references, or SKILL.md content. Use environment variables or MCP secret management. |

---

## Autonomy Risk Management

| Safeguard | Mechanism |
|---|---|
| Branch Isolation | Autonomous execution only on feature branch — never main directly |
| Read-only Commands | Safe commands (read, grep, scan) auto-approved |
| Sandbox Execution | Destructive commands run in Docker/VM where possible |
| Emergency Kill | Human can always stop agent immediately |
| Multi-model Cross-check | Planning done with Opus, coding with Sonnet — different models for different phases |
| Context Summarization | Long runs require periodic refocusing (pause, re-plan, verify no drift) |

The human partner can always override any boundary — they own the codebase. When they say "proceed despite warning," the agent logs the override and continues.

---

## 3-Tier Verification

From layered verification research (deterministic → heuristic → human):

### Layer 1 — Deterministic (fast, runs every sync)
- Hash comparisons (`source-hash` vs. current git hash)
- Wikilink resolution (file exists?)
- Token budget checks (under limits?)
- Directory completeness (all source dirs have modules?)

### Layer 2 — Heuristic/ML (runs with separate Verifier agent)
- Pattern drift detection (does code still match patterns.md claims?)
- Contradiction detection (do two pages claim opposite things?)
- Comprehension debt check (has the brain produced code the human hasn't reviewed?)

The Verifier agent is **separate** from the Generator (Anthropic dual-agent research). The Verifier:
- Runs **after** the Generator completes
- Has read-only access to brain pages + source code
- Produces a structured report the Generator cannot edit

### Layer 3 — Human (runs on review)
- Concept page approval (PROPOSED → REVIEWED → CONFIRMED)
- Pattern additions/removals
- Archive decisions

---

## Status Lifecycle (per module)

```
UNENRICHED → FRESH → STALE (code changed) → RESYNCED → FRESH → VERIFIED (after human review)
```

---

## Cognitive Constraints (Human Dimension)

From the cognitive limits research:

1. **3-4 agent ceiling**: The brain must not create more supervision work than a human can handle. Each sync = a single report, not multiple parallel agent outputs.

2. **Comprehension debt reduction**: The brain's job is to REDUCE comprehension debt. If reading the brain is harder than reading the code, the system failed.
   - Summaries before details (progressive disclosure)
   - One-line token counts in index.md
   - `log.md` top section has reusable patterns

3. **Ambient anxiety tax eliminated**: The brain must give a single definitive answer. The Verifier produces pass/fail, not "here are 4 possible issues."

4. **Productivity paradox** (METR RCT: 19% slower): The brain must track **actual verification time**, not just "sync completed." Success = code changed AND verified correct.

5. **Terminology convention**: The agent refers to the user as "human partner" — deliberate psychological framing that affects agent behavior and collaborative quality.

See also: [[08-anti-patterns]] for what we're NOT building, [[07-skill-verifier-rubrics]] for the concrete rubric items.
