# Implementation Tasks — Atomic, Sequential, Claude-Executable

Each task is designed to be completable in a single Claude session. Tasks have explicit inputs, outputs, dependencies, and boolean acceptance criteria.

**How to use this file**: Work through tasks sequentially within each phase. Tasks within a phase are ordered by dependency — do not skip ahead. Cross-phase dependencies are noted where they exist.

**Task format**:
- **Reads**: Files Claude must read before starting
- **Creates/Modifies**: Files produced or changed
- **AC**: Boolean acceptance criteria — all must be true to mark complete
- **Depends on**: Prior tasks that must be complete

---

## Phase 0: Project Scaffold

Pure file/directory creation. No logic, no extraction, no hooks. The goal is to have the `.ctx/` skeleton that all later phases build on.

---

### 0.1 — Create `.ctx/` directory structure

**Reads**: `PLAN-FINAL/02-architecture.md` (Layer 4: Code Brain section)
**Creates**:
- `brain-init.sh` — Shell script that creates the full `.ctx/` directory tree
- Directories: `.ctx/graph/`, `.ctx/graph/cache/`, `.ctx/graph/wiki/`, `.ctx/skills/`, `.ctx/references/`, `.ctx/concepts/`, `.ctx/entities/`, `.ctx/modules/`, `.ctx/sources/`, `.ctx/decisions/`, `.ctx/archive/`

**AC**:
- [ ] Running `bash brain-init.sh` in any project directory creates the full `.ctx/` tree
- [ ] Script is idempotent — running twice doesn't error or duplicate
- [ ] Script checks for existing `.ctx/` and skips if present (prints "already initialized")
- [ ] Script never modifies existing `.agentctx/`, `CLAUDE.md`, or `.cursorrules`

**Depends on**: Nothing

---

### 0.2 — Create page templates (5 types)

**Reads**: `PLAN-FINAL/02-architecture.md` (wiki page frontmatter schema, lines 72-97)
**Creates**:
- `.ctx/concepts/_template.md`
- `.ctx/entities/_template.md`
- `.ctx/modules/_template.md`
- `.ctx/sources/_template.md`
- `.ctx/decisions/_template.md`

**AC**:
- [ ] Each template has valid YAML frontmatter with: title, category, created, updated, tags, related_skills, related_templates
- [ ] Entity template includes edge confidence fields (`related_entities` with `edge` and `confidence` keys)
- [ ] Module template includes `source-hash` field in frontmatter
- [ ] Each template body follows the structure: Definition → Current Understanding → Phase Mapping → Related Concepts → Sources
- [ ] All templates are under 50 lines

**Depends on**: 0.1

---

### 0.3 — Create `protocol.md` (< 500 tokens)

**Reads**: `PLAN-FINAL/02-architecture.md` (protocol.md description, line 22)
**Creates**: `.ctx/protocol.md`

**AC**:
- [ ] File is under 500 tokens (count with `wc -w`, multiply by 0.75)
- [ ] Contains: core principles, pointer to `routing.md`, pointer to `decisions.md`, brain MCP query instructions, "human partner" naming convention
- [ ] Does NOT contain project-specific content — this is a template that `brain init` places

**Depends on**: 0.1

---

### 0.4 — Create `routing.md` template (< 400 tokens)

**Reads**: `PLAN-FINAL/02-architecture.md` (routing.md description)
**Creates**: `.ctx/routing.md`

**AC**:
- [ ] File is under 400 tokens
- [ ] Contains keyword → cluster → page routing structure (placeholder sections)
- [ ] Format: `keyword: → [[type:name]] — one-line summary`

**Depends on**: 0.1

---

### 0.5 — Create empty metadata files

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (memory model), `PLAN-FINAL/02-architecture.md` (.ctx/ structure)
**Creates**:
- `.ctx/index.md` — empty catalog with header and format example
- `.ctx/status.md` — empty status tracker with column headers (module, status, last_sync, source_hash)
- `.ctx/log.md` — empty log with section headers (Recent Patterns, Activity History)
- `.ctx/decisions.md` — empty consolidated summary with section headers
- `.ctx/patterns.md` — empty patterns file with header
- `.ctx/community_map.md` — empty community map with header
- `.ctx/overview.md` — empty overview with sections (Codebase Patterns, Active State, Recent Activity)

**AC**:
- [ ] All 7 files exist with correct headers
- [ ] `log.md` has both "Recent Patterns" and "Activity History" sections
- [ ] `status.md` has column headers matching the status lifecycle (UNENRICHED → FRESH → STALE → RESYNCED → VERIFIED)
- [ ] `index.md` has a format example: `- [[type:name]] — Xt — summary — cluster:X`

**Depends on**: 0.1

---

### 0.6 — Create lint checklist reference

**Reads**: `PLAN-FINAL/07-skill-verifier-rubrics.md` (full lint checklist table)
**Creates**: `.ctx/references/lint-checklist.md`

**AC**:
- [ ] Contains all 14 checks from `07-skill-verifier-rubrics.md` lint checklist
- [ ] Each check has: name, criterion, severity (ERROR/WARNING/INFO), machine-verifiable flag
- [ ] File is the swappable rubric the Verifier reads — changing this file changes what gets checked

**Depends on**: 0.1

---

### 0.7 — Update `brain-init.sh` for additive CLAUDE.md integration

**Reads**: `PLAN-FINAL/02-architecture.md` (Migration & Adoption Path section)
**Modifies**: `brain-init.sh` (from 0.1)

**AC**:
- [ ] If `CLAUDE.md` exists: appends one line `# Read .ctx/protocol.md for project brain context` (only if line doesn't already exist)
- [ ] If `CLAUDE.md` doesn't exist: creates minimal CLAUDE.md with pointer to `.ctx/protocol.md`
- [ ] Never overwrites existing CLAUDE.md content
- [ ] If `.agentctx/` exists: prints "Existing .agentctx/ detected — .ctx/ will coexist alongside it" and continues
- [ ] If `.cursorrules` exists: does not touch it

**Depends on**: 0.1, 0.3

---

## Phase 1: Graph Integration + Page Generation

Connect brain's extraction output to `.ctx/` page generation. After this phase, `brain . --wiki` output can be translated into governed `.ctx/` pages.

---

### 1.1 — Graph-to-modules translator

**Reads**: A sample `graph.json` from brain output (run `brain .` on a test project first), `.ctx/modules/_template.md`
**Creates**: `scripts/graph-to-modules.py` (or `.sh`)

**AC**:
- [ ] Reads `graph.json` nodes where `file_type=code`
- [ ] Groups nodes by source directory
- [ ] Generates one `.ctx/modules/<dir-name>.md` per directory
- [ ] Each module page has: frontmatter with `source-hash` (from graph.json), body listing entities in that directory, wikilinks to entity pages
- [ ] Skips directories that already have a module page with matching `source-hash` (incremental)

**Depends on**: 0.2, 0.5

---

### 1.2 — Graph-to-entities translator

**Reads**: Sample `graph.json`, `.ctx/entities/_template.md`
**Creates**: `scripts/graph-to-entities.py` (or `.sh`)

**AC**:
- [ ] Reads `graph.json` nodes where type is class, service, function, or model
- [ ] Generates one `.ctx/entities/<name>.md` per entity node
- [ ] Frontmatter includes `related_entities` with edge type (EXTRACTED/INFERRED/AMBIGUOUS) and `confidence_score`
- [ ] Body includes: community membership, degree (number of edges), inbound/outbound connections as wikilinks
- [ ] Skips entities that already exist with matching data (incremental)

**Depends on**: 0.2, 0.5

---

### 1.3 — Wikilink parser + validator

**Reads**: `.ctx/` directory structure
**Creates**: `scripts/wikilink-check.sh` (or `.py`)

**AC**:
- [ ] Finds all `[[type:name]]` patterns across all `.ctx/*.md` and `.ctx/**/*.md` files
- [ ] Resolves each to `.ctx/<type>/<name>.md`
- [ ] Returns list of broken links (target file doesn't exist)
- [ ] Exit code 0 = all links valid, exit code 1 = broken links found
- [ ] Output format: `BROKEN: [[entity:auth-service]] in modules/auth.md:15`

**Depends on**: 0.1

---

### 1.4 — Index.md fingerprint generator

**Reads**: `graph.json`, all `.ctx/modules/*.md` and `.ctx/entities/*.md`
**Creates**: `scripts/generate-index.py` (or `.sh`)
**Modifies**: `.ctx/index.md`

**AC**:
- [ ] Each catalog entry has format: `- [[type:name]] — Xt — summary — cluster:X — degree:N`
- [ ] Token count estimated from file size (word count * 0.75)
- [ ] Cluster and degree pulled from `graph.json` node attributes
- [ ] Sorted by type (concepts, entities, modules, sources), then alphabetically
- [ ] Running twice produces identical output (idempotent)

**Depends on**: 1.1, 1.2

---

### 1.5 — Community map generator

**Reads**: `graph.json` (cluster output from brain's Leiden algorithm)
**Modifies**: `.ctx/community_map.md`

**AC**:
- [ ] Each community listed with: module count, entity count, cohesion score
- [ ] God nodes (highest degree) called out per community
- [ ] Cross-community edges listed as "Surprising connections" with confidence scores
- [ ] Format matches the example in `02-architecture.md` (Auth Cluster section)

**Depends on**: 1.1, 1.2

---

### 1.6 — Routing.md keyword populator

**Reads**: `graph.json` (god node labels, community labels), `.ctx/routing.md`
**Modifies**: `.ctx/routing.md`

**AC**:
- [ ] Populates keyword → page mappings from god node names and community labels
- [ ] Stays under 400 tokens
- [ ] Format: `auth → [[module:auth]], [[entity:auth-service]], [[concept:authentication]]`
- [ ] If routing.md would exceed 400 tokens, keep only the top entries by node degree

**Depends on**: 1.1, 1.2, 0.4

---

## Phase 2: Lifecycle Hooks

Wire up the 5 lifecycle hooks one at a time. Each hook is independently testable.

---

### 2.1 — SessionStart hook

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (hook table)
**Creates**: `scripts/hooks/session-start.sh`
**Modifies**: Documentation for `.claude/settings.local.json` hook config

**AC**:
- [ ] Hook loads: `.ctx/protocol.md` + `.ctx/decisions.md` + last 5 entries from `.ctx/log.md`
- [ ] Outputs loaded context to stdout (for injection into agent context)
- [ ] If `.ctx/` doesn't exist, prints nothing and exits 0 (graceful degradation)
- [ ] Execution time < 100ms on a project with 50+ modules

**Depends on**: 0.3, 0.5

---

### 2.2 — SessionStart skill pre-loading (stack context signal)

**Reads**: `PLAN-FINAL/02-architecture.md` (Skill Routing Engine section)
**Modifies**: `scripts/hooks/session-start.sh` (from 2.1)

**AC**:
- [ ] Reads `.ctx/skills/manifest.json` → extracts `detected_stack` array
- [ ] For each detected stack entry, loads the corresponding skill's `SKILL.md` frontmatter (not full body)
- [ ] Builds in-memory routing table: `{trigger_phrase → skill_path}` and `{glob_pattern → skill_path}` from all installed skills
- [ ] Outputs routing table as structured data (JSON) for downstream hooks to consume
- [ ] If no skills installed, outputs empty routing table and continues

**Depends on**: 2.1

---

### 2.3 — PostToolUse hook (breadcrumbs + file context signal)

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (PostToolUse description)
**Creates**: `scripts/hooks/post-tool-use.sh`

**AC**:
- [ ] Receives the file path that was edited/read as argument
- [ ] If file is in `.ctx/`: validate the change (check no concept deletion, no overwrite of CONFIRMED content) — exit code 2 to block if violated
- [ ] If file is in source code: (a) mark related module as potentially stale in `.ctx/status.md`, (b) inject breadcrumb — module name, related entities, concept links for the edited file
- [ ] Matches file path against installed skills' `paths` globs → if match found, append skill's `references/conventions.md` summary to breadcrumb output
- [ ] Execution time < 50ms per invocation (this fires on every file edit)

**Depends on**: 2.2 (needs routing table)

---

### 2.4 — UserPromptSubmit hook (intent match signal + skill re-detection)

**Reads**: `PLAN-FINAL/02-architecture.md` (Skill Routing Engine), `PLAN-FINAL/03-agents.md` (skill re-detection)
**Creates**: `scripts/hooks/user-prompt-submit.sh`

**AC**:
- [ ] Receives the user prompt as argument
- [ ] Case-insensitive substring scan against routing table's trigger_phrases
- [ ] If match found: outputs activated skill path and loads its `SKILL.md` instructions
- [ ] If multiple matches within same tier: loads all matched skills' references (progressive disclosure — bounded cost)
- [ ] Runs `brain detect-skills --quiet` filesystem check (~5ms): compares project files against `.ctx/skills/manifest.json`, prints 1-line suggestion if new signal found, silent otherwise
- [ ] Execution time < 20ms (excluding detect-skills which is ~5ms)

**Depends on**: 2.2 (needs routing table)

---

### 2.5 — Stop hook

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (Stop hook)
**Creates**: `scripts/hooks/stop.sh`

**AC**:
- [ ] Checkpoints current task progress to `.ctx/status.md`
- [ ] Appends "session paused" entry to `.ctx/log.md` with timestamp
- [ ] Execution time < 50ms

**Depends on**: 0.5

---

### 2.6 — SessionEnd hook

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (SessionEnd hook)
**Creates**: `scripts/hooks/session-end.sh`

**AC**:
- [ ] Persists any ephemeral observations to `.ctx/log.md` (structured entry with timestamp, changed files, decisions)
- [ ] Updates `.ctx/status.md` with current fresh/stale/unenriched counts
- [ ] If source files changed during session: triggers lightweight sync (just `brain . --update`, no full pipeline)
- [ ] Logs session metrics: duration, token cost (if available), skill routing activations vs. user corrections
- [ ] If no `.ctx/` exists, exits silently

**Depends on**: 0.5, 2.3

---

### 2.7 — Hook wiring in settings.local.json

**Reads**: All hook scripts from 2.1-2.6
**Creates**: `.claude/settings.local.json` (or modifies existing)

**AC**:
- [ ] All 5 hooks wired: SessionStart, UserPromptSubmit, PostToolUse, Stop, SessionEnd
- [ ] Each hook points to the correct script path
- [ ] Hooks are independently disable-able (each can be commented out)
- [ ] Documentation comment explains progressive adoption: "Enable hooks one at a time, starting with SessionStart"

**Depends on**: 2.1-2.6

---

## Phase 3: Sync Pipeline

The 4-phase sync pipeline with error recovery. This is the core automation loop.

---

### 3.1 — Phase 1 (EXTRACT) — brain wrapper

**Reads**: `PLAN-FINAL/03-agents.md` (Phase 1: EXTRACT)
**Creates**: `scripts/sync/phase1-extract.sh`

**AC**:
- [ ] Runs `brain . --update` (incremental extraction)
- [ ] Checks brain's manifest for changed files — if none, outputs "no changes" and exits with special code (skip to lightweight sync)
- [ ] On success: outputs path to updated `graph.json`, `GRAPH_REPORT.md`
- [ ] On failure: outputs error and exits non-zero
- [ ] Logs: extraction duration, files processed count, nodes/edges/communities count

**Depends on**: 0.1 (brain must be installed separately)

---

### 3.2 — Phase 2 (UPDATE) — page generation orchestrator

**Reads**: `PLAN-FINAL/03-agents.md` (Phase 2: UPDATE)
**Creates**: `scripts/sync/phase2-update.sh`

**AC**:
- [ ] Calls graph-to-modules (1.1) and graph-to-entities (1.2) translators
- [ ] Calls community map generator (1.5) and routing populator (1.6)
- [ ] Calls index fingerprint generator (1.4)
- [ ] Flags concepts whose description no longer matches code (compares against `graph.json`)
- [ ] Outputs: count of created/updated/flagged pages
- [ ] Marks new entities in `.ctx/status.md` as UNENRICHED

**Depends on**: 3.1, 1.1, 1.2, 1.4, 1.5, 1.6

---

### 3.3 — Phase 3 (VERIFY) — lint runner

**Reads**: `PLAN-FINAL/03-agents.md` (Phase 3: VERIFY), `.ctx/references/lint-checklist.md`
**Creates**: `scripts/sync/phase3-verify.sh`

**AC**:
- [ ] Runs all 14 checks from lint checklist against current `.ctx/` state
- [ ] Deterministic checks run first (wikilinks, token budgets, hash comparisons)
- [ ] Outputs structured report: `brain-lint-report.md` with Summary → Findings (by severity) → Score → Top 3 Recommendations
- [ ] Exit code 0 = all checks pass, exit code 1 = errors found
- [ ] Calls wikilink-check.sh (1.3) as sub-check

**Depends on**: 3.2, 1.3, 0.6

---

### 3.4 — Phase 4 (COMMIT) — metadata update + logging

**Reads**: `PLAN-FINAL/03-agents.md` (Phase 4: COMMIT)
**Creates**: `scripts/sync/phase4-commit.sh`

**AC**:
- [ ] Updates `.ctx/status.md` with fresh/stale/unenriched/verified counts
- [ ] Appends structured log entry to `.ctx/log.md` with: date, status (complete/blocked), changed modules, new entities, concept proposals, graph stats, confidence breakdown
- [ ] Includes sync duration (ms), token cost, pass/fail from Phase 3
- [ ] Updates `.ctx/patterns.md` from brain's cross-community patterns
- [ ] If new decision was made during sync: adds one-line entry to `.ctx/decisions.md`

**Depends on**: 3.3

---

### 3.5 — Sync pipeline orchestrator with 4-tier error recovery

**Reads**: `PLAN-FINAL/03-agents.md` (Error Recovery & Escalation Ladder)
**Creates**: `scripts/sync/run-sync.sh`

**AC**:
- [ ] Runs Phase 1 → 2 → 3 → 4 sequentially
- [ ] If Phase 1 reports no changes: skip to lightweight sync (just verify + commit)
- [ ] Tier 1: On Phase 3 failure, re-run Phase 2 fix + Phase 3 verify (max 3 retries)
- [ ] Tier 2: After 3 retries, run forced reflection prompt ("What failed? Am I repeating?") → 1 more retry with new approach
- [ ] Tier 3: After reflection fails, report for kill+reassign (fresh agent with only error report + relevant pages)
- [ ] Tier 4: After reassign fails, output structured human escalation report with: what was attempted, affected files, suggested fix
- [ ] Idle detection: if no new page created/updated in 5 retries, skip to Tier 3
- [ ] Budget pause: at 85% of token budget, auto-pause and notify
- [ ] Partial sync recovery: Phase 1-2 results are committed independently — Phase 3 failure doesn't lose generated pages
- [ ] Exit code 0 = sync complete, exit code 1 = blocked (with report)

**Depends on**: 3.1, 3.2, 3.3, 3.4

---

### 3.6 — `/brain-sync` slash command

**Reads**: `scripts/sync/run-sync.sh`
**Creates**: Slash command definition (in CLAUDE.md or skills/)

**AC**:
- [ ] `/brain-sync` triggers the full sync pipeline
- [ ] Outputs: sync report (created/updated/flagged/blocked)
- [ ] If sync blocked: shows the Tier 4 escalation report

**Depends on**: 3.5

---

### 3.7 — `/brain-lint` slash command

**Reads**: `scripts/sync/phase3-verify.sh`
**Creates**: Slash command definition

**AC**:
- [ ] `/brain-lint` runs Phase 3 (VERIFY) standalone
- [ ] Outputs structured lint report
- [ ] Does not modify any files — read-only audit

**Depends on**: 3.3

---

## Phase 4: Skill Registry + Detection

Build the skill package system. After this phase, `brain init` detects project stack and installs matching skills.

---

### 4.1 — Create registry.json schema

**Reads**: `PLAN-FINAL/02-architecture.md` (Skill Registry, Detection Heuristics, registry.json example)
**Creates**: `skills-registry/registry.json`

**AC**:
- [ ] Contains all detection rules from the plan: package.json→react, tsconfig.json→typescript, go.mod→go, etc.
- [ ] Each skill entry has: tier (core/detected/available), detect rules, also_installs
- [ ] Core skills (requirements, design, implementation, testing, deployment, maintenance) have `"detect": "always"`
- [ ] Available skills (kubernetes, graphql, mobile) have `"detect": "manual"`

**Depends on**: Nothing

---

### 4.2 — Create core skill packages (6 SDLC phases)

**Reads**: `PLAN-FINAL/02-architecture.md` (SKILL.md body structure, per-phase design table), `PLAN-FINAL/07-skill-verifier-rubrics.md`
**Creates**: 6 directories under `skills-registry/core/`:
- `requirements/SKILL.md` + `SKILL-verifier.md` + `references/` + `templates/`
- `design/SKILL.md` + `SKILL-verifier.md` + `references/` + `templates/`
- `implementation/SKILL.md` + `SKILL-verifier.md` + `references/` + `templates/`
- `testing/SKILL.md` + `SKILL-verifier.md` + `references/` + `templates/`
- `deployment/SKILL.md` + `SKILL-verifier.md` + `references/` + `templates/`
- `maintenance/SKILL.md` + `SKILL-verifier.md` + `references/` + `templates/`

**AC**:
- [ ] Each SKILL.md has valid YAML frontmatter: name, description, license, metadata (author, version, phase, pattern), paths, trigger_phrases, related_skills
- [ ] Each SKILL.md body follows: When to Use → Instructions → Phase Pipeline → Gate Conditions → Templates → References → Verifier Handoff → Three-Tier Boundaries
- [ ] Each SKILL.md is under 500 lines
- [ ] Each SKILL-verifier.md has: Rubric (from `07-skill-verifier-rubrics.md`) + Output Format
- [ ] Trigger phrases match the table in `03-agents.md` (SDLC Phase Agents)

**Depends on**: 4.1

---

### 4.3 — Create detected skill packages (stack-specific)

**Reads**: `PLAN-FINAL/02-architecture.md` (Skill Registry Structure — detected/ section)
**Creates**: Skill directories under `skills-registry/detected/`:
- `react/SKILL.md` + `references/conventions.md` + `references/patterns.md`
- `typescript/SKILL.md` + `references/conventions.md`
- `python/SKILL.md` + `references/conventions.md`
- `go/SKILL.md` + `references/conventions.md`
- `data-modeling/SKILL.md` + `references/prisma-conventions.md`
- `security/SKILL.md` + `references/env-management.md`

**AC**:
- [ ] Each SKILL.md has frontmatter with `paths` globs matching file extensions (e.g., react: `**/*.tsx`, `**/*.jsx`)
- [ ] Each SKILL.md has `trigger_phrases` with domain jargon, intent-based, and low-jargon entry points
- [ ] Tool Wrapper pattern: SKILL.md registers triggers, references/ has conventions, agent loads conventions when triggered
- [ ] Each SKILL.md under 500 lines

**Depends on**: 4.1

---

### 4.4 — Detection engine

**Reads**: `skills-registry/registry.json`
**Creates**: `scripts/detect-skills.sh` (or `.py`)

**AC**:
- [ ] Reads `registry.json` and evaluates each `detect` rule against the current project filesystem
- [ ] Outputs JSON: `{"detected": ["react", "typescript"], "core": ["requirements", ...], "available": ["kubernetes", ...]}`
- [ ] `--quiet` flag: only outputs if delta found vs. existing manifest (for per-prompt hook use, ~5ms)
- [ ] Handles all detection methods: `file_exists`, `file` + `contains` (JSON parse), `dir_exists`, glob patterns

**Depends on**: 4.1

---

### 4.5 — Skill installer (brain init Phase B)

**Reads**: Detection engine output (4.4), `skills-registry/`
**Modifies**: `brain-init.sh` (from 0.1)
**Creates**: `.ctx/skills/manifest.json` (on init)

**AC**:
- [ ] After scaffold (Phase A), runs detection engine (Phase B)
- [ ] Copies matched skill packages (full directories) into `.ctx/skills/`
- [ ] Writes `.ctx/skills/manifest.json` with: installed date, registry version, detected_stack, per-skill reason
- [ ] Core skills always installed, detected skills auto-installed, available skills listed but not installed
- [ ] `brain add-skill <name>` command: manually installs an available skill, updates manifest

**Depends on**: 4.4, 0.1

---

### 4.6 — Skill re-detection integration

**Reads**: `scripts/detect-skills.sh`
**Modifies**: `scripts/hooks/user-prompt-submit.sh` (from 2.4), `scripts/sync/phase1-extract.sh` (from 3.1)

**AC**:
- [ ] UserPromptSubmit hook calls `detect-skills --quiet` on every prompt
- [ ] Phase 1 (EXTRACT) calls `detect-skills` after extraction
- [ ] If new signal found (e.g., Dockerfile added): prints 1-line suggestion "New stack detected: Docker. Run `brain add-skill deployment-docker` to install"
- [ ] "Ask First" — never auto-installs, only suggests
- [ ] Silent (0 tokens) on 99% of prompts when no delta

**Depends on**: 4.4, 2.4, 3.1

---

## Phase 5: Intelligence + Governance

Concept proposals, consolidation, contradiction detection, guardrails. These are the "brain gets smarter over time" features.

---

### 5.1 — Token budget enforcement with overflow handling

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (token budgets with overflow handling)
**Modifies**: `scripts/sync/phase3-verify.sh` (from 3.3)

**AC**:
- [ ] Token check identifies pages exceeding budget
- [ ] For oversized pages: suggests split points (largest section header)
- [ ] Overflow report includes: page path, current size, budget, suggested action (split/summarize/archive)
- [ ] `protocol.md` > 500t = ERROR, individual pages > 30K = ERROR (with split suggestion), `routing.md` > 400t = WARNING

**Depends on**: 3.3

---

### 5.2 — Page splitting script

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (overflow strategy)
**Creates**: `scripts/split-page.sh` (or `.py`)

**AC**:
- [ ] Takes a page path as input
- [ ] Splits by top-level sections (## headers) into sub-pages
- [ ] Original page becomes summary with wikilinks to sub-pages
- [ ] Sub-pages named: `<original>-<section-slug>.md`
- [ ] All wikilinks from other pages pointing to the original still resolve (original still exists as summary)
- [ ] Updates `.ctx/index.md` with new sub-pages

**Depends on**: 5.1

---

### 5.3 — Log consolidation engine

**Reads**: `PLAN-FINAL/04-memory-and-lifecycle.md` (progress log consolidation)
**Creates**: `scripts/consolidate-log.sh`

**AC**:
- [ ] Counts entries in `.ctx/log.md` Activity History section
- [ ] Every 10 entries: scans for recurring patterns → promotes to "Recent Patterns" section at top
- [ ] Archives old entries beyond the 10-entry window (moves to `archive/logs/YYYY-MM.md`)
- [ ] `decisions.md` consolidation: every 10 decisions, groups by theme, surfaces lessons, marks superseded
- [ ] Idempotent — running twice doesn't double-consolidate

**Depends on**: 0.5

---

### 5.4 — Concept proposal system

**Reads**: `PLAN-FINAL/03-agents.md` (Brain Synthesis Agent)
**Creates**: `scripts/propose-concept.sh`

**AC**:
- [ ] Reads `GRAPH_REPORT.md` for surprising connections, god nodes, hyperedges
- [ ] Proposes concept pages with status = PROPOSED (never CONFIRMED)
- [ ] Proposal format: filename, evidence (which modules/entities), draft content, status: AWAITING REVIEW
- [ ] Runs 5 self-clarification questions before generating proposal
- [ ] Outputs proposals to stdout — does NOT create files (human must approve first)

**Depends on**: 1.1, 1.2

---

### 5.5 — Contradiction detection

**Reads**: `PLAN-FINAL/03-agents.md` (Brain Verifier, contradiction check)
**Creates**: `scripts/detect-contradictions.sh`

**AC**:
- [ ] Cross-references brain AMBIGUOUS edges with claims in `.ctx/` pages
- [ ] Checks if two pages claim opposite facts about the same entity/concept
- [ ] Outputs: contradiction pairs with severity (WARNING) and suggested resolution
- [ ] Integrates into Phase 3 (VERIFY) as one of the 14 lint checks

**Depends on**: 3.3

---

### 5.6 — Guardrails setup (block + warn hooks)

**Reads**: `PLAN-FINAL/05-guardrails-and-constraints.md` (Three-Tier Boundaries, Guardrails Hierarchy)
**Creates**: `scripts/hooks/guardrails.sh`
**Modifies**: `.claude/settings.local.json`

**AC**:
- [ ] Block (exit code 2): concept deletion, overwriting CONFIRMED pages, sync without verification
- [ ] Warn (exit code 0 with message): concept modification, pattern changes, archive actions
- [ ] Pre-input: reject specs containing `<private>` markers or PII patterns
- [ ] Hooks wired in settings.local.json alongside lifecycle hooks

**Depends on**: 2.7

---

### 5.7 — Decision capture at SessionEnd

**Reads**: `PLAN-FINAL/09-decision-tracking-and-learning.md` (decision structure, capture flow)
**Modifies**: `scripts/hooks/session-end.sh` (from 2.6)

**AC**:
- [ ] At SessionEnd, prompts: "Were any significant decisions made this session?"
- [ ] If yes: creates ADR in `.ctx/decisions/` with frontmatter (id, title, date, status: active, related)
- [ ] Adds one-line entry to `.ctx/decisions.md` consolidated summary
- [ ] Verifier checks: does new decision contradict any existing decision?
- [ ] If contradiction: flags it, suggests marking old decision as superseded

**Depends on**: 2.6, 5.3

---

## Phase 6: Integration + Validation

End-to-end testing, documentation, and multi-tool output.

---

### 6.1 — End-to-end test on a real project

**Reads**: All scripts from Phases 0-5
**Creates**: `tests/e2e-test.sh`

**AC**:
- [ ] Runs full pipeline on a test project (ideally experiment-on-trpc or similar):
  1. `brain-init.sh` → `.ctx/` scaffold created
  2. `brain .` → graph.json produced
  3. `run-sync.sh` → pages generated, verified, committed
  4. `brain-lint` → 0 errors
- [ ] All wikilinks resolve (wikilink-check exits 0)
- [ ] No page exceeds 30K tokens
- [ ] `protocol.md` under 500 tokens
- [ ] `index.md` has fingerprints for all modules and entities
- [ ] Skill manifest lists detected skills with reasons

**Depends on**: All prior phases

---

### 6.2 — System observability validation

**Reads**: `.ctx/log.md` after E2E test
**Creates**: Nothing (validation only)

**AC**:
- [ ] `log.md` sync entry contains: sync duration (ms), pass/fail, token cost, pages over budget count
- [ ] `status.md` has entries for all modules with correct status values
- [ ] Metrics are queryable: "How long did the last 5 syncs take?" answerable from log.md

**Depends on**: 6.1

---

### 6.3 — brain MCP server setup

**Reads**: `PLAN-FINAL/02-architecture.md` (brain CLI Integration, MCP server)
**Creates**: MCP server configuration

**AC**:
- [ ] `brain serve .ctx/graph/graph.json` starts MCP server
- [ ] Server exposes: `query_graph`, `get_node`, `get_neighbors`, `get_community`, `god_nodes`, `graph_stats`, `shortest_path`
- [ ] Token budget enforced: queries return < 2000 tokens by default
- [ ] BFS and DFS traversal modes available

**Depends on**: 1.1 (graph.json must exist)

---

### 6.4 — Documentation

**Reads**: All plan files, all scripts
**Creates**:
- `README.md` — human overview of brain + brain architecture
- `llms.txt` — machine-readable framework catalog for non-Claude agents

**AC**:
- [ ] README covers: what the brain is, how to install (`brain init`), how to sync (`/brain-sync`), how to query (MCP), progressive adoption path
- [ ] llms.txt follows the AEO spec: under 5K tokens, describes capabilities, links to skill.md files
- [ ] Migration section explains coexistence with `.agentctx/` and `CLAUDE.md`

**Depends on**: 6.1

---

### 6.5 — Multi-tool output integration

**Reads**: `PLAN-FINAL/06-implementation.md` (task 4.3)
**Creates**: Output templates for `.cursorrules`, `.github/copilot-instructions.md`

**AC**:
- [ ] CLAUDE.md output includes brain routing + MCP instructions
- [ ] .cursorrules output includes pointer to `.ctx/protocol.md`
- [ ] Each output format is independently testable
- [ ] Existing files are never overwritten — additive only

**Depends on**: 6.4

---

## Task Dependency Graph (simplified)

```
Phase 0 (scaffold)
  └─→ Phase 1 (graph integration)
       └─→ Phase 2 (hooks) ←── Phase 4 (skills, can run in parallel with Phase 2-3)
            └─→ Phase 3 (sync pipeline)
                 └─→ Phase 5 (intelligence)
                      └─→ Phase 6 (integration)
```

Phase 4 (Skill Registry) can be built in **parallel** with Phases 2-3, since skills and hooks are independently testable. The connection point is task 4.6 (skill re-detection integration) which wires into hooks from Phase 2.

## Total: 38 tasks across 7 phases

| Phase | Tasks | Focus |
|---|---|---|
| 0 | 7 | Project scaffold — files and directories only |
| 1 | 6 | Graph integration — translators and validators |
| 2 | 7 | Lifecycle hooks — one hook at a time |
| 3 | 7 | Sync pipeline — 4-phase sync with error recovery |
| 4 | 6 | Skill registry — detection, installation, routing |
| 5 | 7 | Intelligence — consolidation, concepts, guardrails |
| 6 | 5 | Integration — E2E test, docs, multi-tool |
