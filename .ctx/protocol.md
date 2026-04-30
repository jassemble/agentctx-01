# Code Brain Protocol

## Core Principles

1. **Pointer-first**: satisfy queries from metadata before loading full pages
2. **Evidence over claims**: link assertions to source code or graph edges
3. **Additive only**: never delete confirmed knowledge -- archive instead
4. **Human partner**: the developer is "human partner", not "user"

## Navigation

- **Routing**: see routing.md for keyword-to-page mappings
- **Decisions**: see decisions.md for project decision log
- **Index**: see index.md for full page catalog with token counts

## Graph Queries

Query the knowledge graph via brain MCP server:
- query_graph -- BFS/DFS traversal with token budget
- god_nodes -- highest-degree abstractions
- get_neighbors -- immediate connections for an entity
- shortest_path -- trace relationship between two nodes

Budget: queries return < 2000 tokens by default.

## Loading Tiers

1. **Metadata** -- index.md fingerprint (name, summary, tokens)
2. **Snippet** -- routing.md keyword match, relevant section
3. **Full File** -- only when Tier 1-2 insufficient
