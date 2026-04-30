# agentctx — Code Brain for AI Agents

A project-level knowledge brain that gives AI agents persistent, structured context about your codebase.

## What It Does

- Extracts a knowledge graph from your codebase (AST + semantic analysis)
- Generates governed wiki pages (modules, entities, concepts, decisions)
- Routes agents to relevant context automatically via lifecycle hooks
- Tracks decisions, patterns, and project evolution over time

## Quick Start

```bash
# 1. Initialize the brain
bash brain-init.sh

# 2. Run extraction (requires brain CLI)
brain .

# 3. Sync: generate pages from graph
bash scripts/sync/run-sync.sh

# 4. Verify brain health
bash scripts/sync/phase3-verify.sh
```

## Slash Commands

- `/brain-sync` — Full sync pipeline (extract, update, verify, commit)
- `/brain-lint` — Read-only verification audit

## Architecture

```
.ctx/                          # The Brain (per-project)
  protocol.md                  # Entry point (<500 tokens)
  routing.md                   # Keyword -> page (<400 tokens)
  index.md                     # Page catalog with fingerprints
  graph/                       # brain extraction output
  concepts/                    # Methodology pages (PROPOSED -> CONFIRMED)
  entities/                    # Code entities with confidence-scored edges
  modules/                     # Directory-level documentation
  decisions/                   # Architecture Decision Records
  skills/                      # Auto-detected skill packages
  references/                  # Swappable lint rubrics
```

## Progressive Adoption

1. **Start**: `bash brain-init.sh` — scaffold `.ctx/`, zero hooks
2. **Add hooks**: Enable SessionStart first, then PostToolUse, then UserPromptSubmit
3. **Enable skills**: Routing engine activates implicitly from hooks
4. **Full automation**: Enable SessionEnd persistence + `/brain-sync`

## Skill Detection

On init, the brain detects your project stack and installs matching skills:

| Signal | Skills Activated |
|--------|-----------------|
| `package.json` with `react` | react, typescript |
| `tsconfig.json` | typescript |
| `go.mod` | go |
| `requirements.txt` | python |
| `prisma/schema.prisma` | data-modeling |
| `.env` | security |

Core SDLC skills (requirements, design, implementation, testing, deployment, maintenance) are always installed.

## MCP Server

```bash
brain serve .ctx/graph/graph.json
```

Exposes: `query_graph`, `get_node`, `get_neighbors`, `get_community`, `god_nodes`, `graph_stats`, `shortest_path`. Token budget: < 2000 tokens per query.

## Coexistence

- Existing `.agentctx/` directories are untouched
- Existing `CLAUDE.md` gets a single pointer line appended
- Existing `.cursorrules` are never modified
- `.ctx/` can be added to `.gitignore` during evaluation
