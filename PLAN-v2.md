# Code Brain — Self-Maintaining Context Wiki for Code

## Context

The `agentctx-idea` wiki proves that a structured, queryable knowledge base works for research. The `agentctx` CLI proves that AST-scanned + AI-enriched module docs work for code. The `experiment-on-trpc` project shows that 169 auto-generated modules, pattern tracking, and sync status give a developer a full picture of a codebase.

**The gap**: agentctx generates module docs but doesn't give them wiki properties — no cross-references, no contradiction tracking, no concept pages that synthesize across modules, no routing table. The wiki has wikilinks and interlinking but no code scanning.

**The combined idea**: A "brain" that is both wiki AND code scanner. You write auth login page + backend + DB — the system auto-records it as a module (with code signatures, file paths, behavior), links it to the "Authentication" concept page, updates the entity index, and maintains the routing table. Like a wiki that writes itself from your commits.

---

## Architecture: Wiki + Scanner Combined

The brain merges the wiki's interlinking with agentctx's auto-generation:

```
Brain (per project)
├── .ctx/
│   ├── protocol.md              ← Entry point (what to read, when)
│   ├── index.md                 ← Content catalog with one-line summaries
│   ├── routing.md               ← Keyword-based query routing
│   ├── overview.md              ← Current state + recent activity
│   ├── log.md                   ← Chronological activity log
│   │
│   ├── concepts/                ← Wiki-style concept pages (THE BRAIN)
│   │   ├── authentication.md    ← What auth means in THIS project
│   │   ├── caching.md
│   │   └── error-handling.md
│   │
│   ├── entities/                ← Code entities (APIs, services, components)
│   │   ├── AuthService.md       ← Generated from scan + manually enriched
│   │   └── User.md              ← Model/entity definition
│   │
│   ├── modules/                 ← Auto-scanned module docs (from agentctx)
│   │   ├── auth.md              ← Scanned: functions, files, behavior notes
│   │   └── user-service.md
│   │
│   ├── sources/                 ← PRDs, specs, requirements (ingested)
│   │   └── user-auth-spec.md
│   │
│   ├── conventions/             ← Conventions from skills/init
│   │   ├── nextjs/
│   │   └── typescript/
│   │
│   └── patterns.md              ← Cross-cutting patterns (distilled from modules)
```

### What each layer does

| Layer | Source | Maintained By | Example |
|---|---|---|---|
| **Concepts** | Human + AI synthesis | Wiki agent on commit | "Authentication" — explains the whole auth strategy |
| **Entities** | Code scan + manual edits | Maintenance agent | `AuthService.md` — single service, its deps and interface |
| **Modules** | AST scan + AI enrich | `agentctx scan` + sync | `auth.md` — all files in auth dir, signatures, behavior |
| **Conventions** | Skills / init | `agentctx add` | Next.js routing conventions |
| **Sources** | User provides | Ingest agent | PRD, spec, requirements doc |
| **Patterns** | Distilled from modules | Evolve on commit | "Provider switching pattern" appears in Auth, Email, SMS |

### How it solves your scenario

When you create auth (login page + backend + DB):

1. **You commit** the changes
2. **Maintenance agent reads the diff** and identifies:
   - New module: `src/auth/` directory → creates `.ctx/modules/auth.md` (via scan)
   - New entity: `AuthService`, `User` model → creates `.ctx/entities/auth-service.md`, `.ctx/entities/user-model.md`
   - New concept: "Authentication" → creates `.ctx/concepts/authentication.md` with wikilinks to the entity and module
3. **Cross-links auto-created**:
   - `concepts/authentication.md` links to `modules/auth.md` and `entities/auth-service.md`
   - `modules/auth.md` frontmatter links back to `concepts/authentication.md`
   - `index.md` gets new entries
   - `routing.md` gets "auth, login, jwt, password" keywords
4. **Status.md** updated: "2026-04-16: Auth module created, 3 entities, 1 concept"
5. **Log.md** appended with structured entry

---

## Phase 1: The Scaffold — Directory + Page Templates

Creates the `.ctx/` brain skeleton with templates that follow the wiki conventions.

### Files to create:

```
.ctx/
  protocol.md                    ← Entry: "Read routing.md first, index.md next, then specific page"
  index.md                       ← Catalog template (concepts, entities, modules, conventions)
  routing.md                     ← Keyword routing table template
  overview.md                    ← State summary template
  log.md                         ← Append-only activity log
  patterns.md                    ← Cross-cutting patterns (empty)
  status.md                      ← Sync state: fresh/stale/unenriched counts
  concepts/
    _template.md                 ← Concept page template (wiki format)
  entities/
    _template.md                 ← Entity page template (wiki format)
  modules/
    _template.md                 ← Module doc template (agentctx format + wiki fields)
  sources/
  conventions/
```

### Template: Concept page (wiki format + code awareness)

```markdown
---
title: "Authentication"
category: methodology | pattern | domain
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags: [auth, security]
---

# Authentication

**Category**: <category>
**Introduced in**: commit abc1234 — "add auth with login page"

## Definition
What this concept means in THIS project (not generic definition).

## Implementation in This Project
- Uses [[entity:auth-service]] for JWT + refresh token rotation
- [[module:auth]] contains controller, service, guards, strategies
- Database: `[[entity:user]]` model with `passwordHash` and `refreshToken` fields
- Login page: `[[module:login-page]]` in web app

## Module Dependencies
```
auth → db/repositories/auth, db/repositories/users
users → db/repositories/users
```

## Key Decisions
- Decision 1 (date) — Why we chose JWT over sessions

## Related Concepts
- [[concept:authorization]]
- [[concept:rate-limiting]]

---
Updated: YYYY-MM-DD | Synced from commit abc1234
```

### Template: Entity page (wiki format + code data)

```markdown
---
title: "AuthService"
type: service | model | component | api | controller
source-file: apps/backend/src/auth/auth.service.ts
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# AuthService

**Type**: <type>
**Location**: `path/to/file.ts`
**Belongs to**: [[module:auth]]

## Purpose
What this entity does in the project.

## Public API
```typescript
login(dto: LoginDto): Promise<TokenResponse>
register(dto: RegisterDto): Promise<TokenResponse>
refreshTokens(refreshToken: string): Promise<TokenResponse>
```

## Dependencies
- Uses: `[[entity:HashingService]]`, `[[entity:TokenService]]`, `[[entity:AuthRepository]]`
- Used by: `[[entity:AuthController]]`, `[[entity:JwtAuthGuard]]`

## Change History
- **YYYY-MM-DD**: Created from scan
- **YYYY-MM-DD**: Added refreshTokens method

---
Updated: YYYY-MM-DD | Synced from commit abc1234
```

### Template: Module doc (agentctx scan format + wiki links)

```markdown
---
generated-by: agentctx-scan
generated-at: YYYY-MM-DD
source-files: [list]
source-hash: abc123
enriched-at: YYYY-MM-DD
enriched-hash: xyz789
concept: "[[concept:authentication]]"
---

# Auth

## Key Files
- `apps/backend/src/auth/auth.controller.ts`
- `apps/backend/src/auth/auth.service.ts`

## Functions
- `register(dto: RegisterDto): Promise<TokenResponse>` — creates user, returns JWT

## Entities
- [[entity:auth-service]], [[entity:auth-controller]], [[entity:jwt-auth-guard]]

## Behavior Notes
- Rate limited: 5-10 req/min

---
Updated: YYYY-MM-DD | Synced from commit abc1234
```

---

## Phase 2: CLI Commands — Scan, Ingest, Lint

Build the commands that operate on the `.ctx/` brain.

### Commands

| Command | What it does |
|---|---|
| `brain init` | Scaffold `.ctx/` directory structure from templates |
| `brain scan` | AST scan → generates module docs in `.ctx/modules/` |
| `brain sync` | Full enrichment: scan + AI analysis (patterns, entities, concepts) |
| `brain ingest <file>` | Ingest a spec/PRD → creates concept page in `.ctx/sources/` |
| `brain lint` | Health check: contradictions, orphan pages, stale modules, broken wikilinks |
| `brain status` | Show: module count, fresh/stale, recent activity, recommendations |
| `brain diff` | Compare `.ctx/` state vs source code — what changed since last scan |
| `brain ls` | List all pages by category with link stats |

### Key logic: `brain sync` workflow

```
1. Run `brain scan` → generate/update .ctx/modules/*.md (AST scan)
2. Read git diff since last sync → identify:
   - New files/directories → new entities
   - Deleted files → mark entities as orphaned
   - Changed functions → update entity pages, detect pattern changes
3. Create/update entity pages in .ctx/entities/
4. If new concept discovered (files grouped by domain) → create concept page
5. Update cross-links: module → entity, entity → concept, concept → module
6. Update routing.md with new keywords
7. Update index.md catalog
8. Append to log.md
9. Update status.md
10. Re-distill patterns.md if new patterns detected
```

---

## Phase 3: Auto-Sync Agent — The Self-Maintaining Part

### The maintenance agent (`.claude/agents/ctx-maintenance.md`)

Triggers: Git hook on commit (or slash command `/brain-sync`).

**Steps:**
1. Read `git diff HEAD~1 HEAD`
2. Parse the diff:
   - New files → new entities/concepts
   - Changed files → update existing entities
   - Deleted files → mark orphaned, don't delete (track history)
3. Run `brain scan` (or reuse last scan results)
4. Create/update entity pages with wikilinks to related modules
5. Update concept pages if implementation strategy changed
6. Update module docs
7. Cross-link: "auth module uses [[entity:user-model]], which is part of [[concept:data-access]]"
8. Append structured log entry to `log.md`
9. Update `status.md` and `index.md`

### The health check (`.claude/agents/ctx-linter.md`)

Triggered by `/brain-lint`:

**Checks:**
- **Broken wikilinks**: `[[concept:foo]]` but `concepts/foo.md` doesn't exist
- **Stale modules**: `source-hash` changed since `enriched-at` timestamp
- **Orphan entities**: entity page with no inbound wikilinks from any concept/module
- **Missing modules**: source directory exists at `src/auth/` but no `.ctx/modules/auth.md`
- **Pattern drift**: a pattern described in `patterns.md` no longer exists in code
- **Concept contradictions**: two concepts claim opposite things about the same detail

Output: structured health report with severity (error, warning, info).

---

## How This Is Different From agentctx + Wiki

| Feature | agentctx (current) | agentctx-idea (wiki) | **This combined system** |
|---|---|---|---|
| Module docs | Auto-generated (AST scan) | Manual curation | Auto-generated + manually enriched |
| Cross-references | None | Wikilinks everywhere | Wikilinks: module ↔ entity ↔ concept |
| Concept pages | N/A | Human-written | Human + AI synthesis from code |
| Progressive disclosure | Router + convention files | routing.md → index.md → page | Same, but across modules too |
| Change tracking | `source-hash` in frontmatter | `log.md` entries | Both: hash + structured log |
| Auto-update | `agentctx scan` (manual) | Manual ingest | On-commit trigger (git hook) |
| Contradiction detection | None | Manual lint | Lint agent + hash mismatch |
| Pattern tracking | `patterns.md` (manual) | N/A | Auto-distilled from module changes |
| Multi-tool output | Generate 10 formats | N/A | Inherits from agentctx |
| Dashboard | Web UI served locally | Obsidian vault | Inherits from agentctx |
| Skills/composable context | Yes | N/A | Inherits from agentctx |

### What agentctx does today (and we keep):
- AST module scanning
- AI enrichment (parallel agents)
- Multi-tool output generation
- Skills system (conventions, commands, references)
- Dashboard (spec board, modules, health)
- `learn` + `evolve` (extract patterns from sessions)
- 156 bundled agents
- Monorepo inheritance
- Token budgets + CI lint

### What we add (the brain layer):
- Wiki-style interlinking (modules ↔ entities ↔ concepts)
- Concept pages that synthesize across modules
- Progressive disclosure routing (routing.md → index.md → page)
- On-commit auto-sync maintenance
- Contradiction detection between concept pages
- Structured activity log (parseable, chronological)
- Pattern auto-distillation (cross-cutting patterns from module changes)
- `brain` command namespace that operates on the wiki layer

### Where to implement:
- **In agentctx CLI**: `brain` commands (`brain init`, `brain sync`, `brain lint`, `brain ingest`)
- **In CLAUDE.md / .claude/ agents**: The maintenance and linter agents
- **The `.ctx/` directory**: The brain itself, created inside the target project

---

## Design Rationale (from Research)

| Decision | Research Source | Rationale |
|---|---|---|
| 3-layer hierarchy | [[agents-md-hierarchy]] | Monolithic context fails at scale |
| Wikilinks + interlinking | [[memory-persistence]] | Four channels of memory: semantic linking |
| Progressive disclosure | [[progressive-disclosure-memory]] | ~10x token savings |
| Auto-sync on commit | [[guardrails-hierarchy]] | Context drifts immediately after change |
| Hash tracking per module | [[token-economics]] | Enrichment cost — only re-sync what changed |
| Pattern auto-distillation | [[compound-learning]] | Each improvement makes future easier |
| Contradiction detection | wiki CLAUDE.md | `[Superseded YYYY-MM-DD]` annotation |
| Size-limited articles | [[context-window-management]] | 30-40% context utilization target |
| Thin protocol | [[curse-of-instructions]] | Under 500 token entry point |

---

## Implementation Plan

### Step 1: Create `.ctx/` scaffold with templates
- Scaffold script creates full directory structure
- Templates for concept, entity, module pages
- `CLAUDE.md` for the brain framework

### Step 2: Implement `brain` CLI commands in agentctx
- `brain init` — runs the scaffold
- `brain scan` — wrappers around existing `agentctx scan` with wiki output
- `brain sync` — the full enrichment pipeline (scan + entity + concept generation)
- `brain lint` — health checks
- `brain status` — show brain health
- `brain ingest` — ingest PRD/spec as source

### Step 3: Auto-sync agent for Claude Code
- `.claude/agents/brain-maintenance.md` — the maintenance agent definition
- Git hook integration (via settings.json)
- Slash command: `/brain-sync`

### Step 4: Progressive disclosure router
- `routing.md` keyword table
- Index-based routing in CLAUDE.md
- Token budget enforcement

---

## Verification

1. `brain init` → correct directory structure created
2. `brain scan` → module docs generated with hashes, signatures
3. `brain sync` → entities created, concepts synthesized, wikilinks established
4. Make a code change → commit → `/brain-sync` → entity page updated, log entry added
5. `brain lint` → health report with broken link detection
6. `brain status` → shows fresh/stale counts, recent activity
7. Query about auth → agent reads routing.md → finds auth cluster → reads concept page → reads module
8. No context rot: every session starts fresh with protocol.md → routing.md as entry

---

## Open Questions

1. Should `.ctx/` merge with `.agentctx/` (same directory) or remain separate? Since `.agentctx/` already has `context/`, the brain could be `.agentctx/brain/` — a wiki layer on top of existing context.
2. What happens when a project already has agentctx set up — does `brain init` detect it and extend, or create standalone?
3. How does the concept page AI synthesis work without hallucination — should it only reference facts verifiable in code/module docs?
4. Should the brain be versioned independently from agentctx versions?
