#!/usr/bin/env bash
# Phase 4: COMMIT — Update metadata files + log sync results
set -euo pipefail

CTX=".ctx"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
SYNC_STATUS="${1:-complete}"  # complete or blocked
DURATION="${2:-0}"

echo "Phase 4: COMMIT"

python3 -c "
import os, datetime, re

ctx = '$CTX'
timestamp = '$TIMESTAMP'
sync_status = '$SYNC_STATUS'
duration = '$DURATION'

# Update status.md counts
status_path = os.path.join(ctx, 'status.md')
counts = {'UNENRICHED': 0, 'FRESH': 0, 'STALE': 0, 'RESYNCED': 0, 'VERIFIED': 0}
if os.path.exists(status_path):
    with open(status_path) as f:
        for line in f:
            for s in counts:
                if s in line:
                    counts[s] += 1

# Append structured log entry
log_path = os.path.join(ctx, 'log.md')
if os.path.exists(log_path):
    # Count pages
    module_count = len([f for f in os.listdir(os.path.join(ctx, 'modules')) if f.endswith('.md') and not f.startswith('_')]) if os.path.isdir(os.path.join(ctx, 'modules')) else 0
    entity_count = len([f for f in os.listdir(os.path.join(ctx, 'entities')) if f.endswith('.md') and not f.startswith('_')]) if os.path.isdir(os.path.join(ctx, 'entities')) else 0

    status_str = ', '.join(f'{k}={v}' for k, v in counts.items() if v > 0)
    token_cost = os.environ.get('CLAUDE_TOKEN_COST', 'n/a')
    # Count pages over budget
    over_budget = 0
    for root2, dirs2, files2 in os.walk(ctx):
        for f2 in files2:
            if f2.endswith('.md') and not f2.startswith('_'):
                fp2 = os.path.join(root2, f2)
                try:
                    w = len(open(fp2).read().split())
                    if int(w * 0.75) > 30000:
                        over_budget += 1
                except: pass
    entry = f'- {timestamp} — sync {sync_status} | duration={duration}ms | token_cost={token_cost} | modules={module_count} entities={entity_count} | pages_over_budget={over_budget} | status: {status_str}'

    # Check lint report
    lint_report = os.path.join(ctx, 'graph', 'brain-lint-report.md')
    if os.path.exists(lint_report):
        with open(lint_report) as f:
            rc = f.read()
        errors = re.search(r'Errors:\s*(\d+)', rc)
        if errors:
            entry += f' | lint_errors={errors.group(1)}'

    with open(log_path, 'a') as f:
        f.write(f'\n{entry}\n')

# Update patterns.md from cross-community edges if available
graph_path = os.path.join(ctx, 'graph', 'graph.json')
patterns_path = os.path.join(ctx, 'patterns.md')
if os.path.exists(graph_path) and os.path.exists(patterns_path):
    import json
    with open(graph_path) as f:
        data = json.load(f)
    edges = data.get('edges', data.get('links', []))
    # Find cross-community patterns
    node_comm = {}
    for n in data.get('nodes', []):
        nid = n.get('id', n.get('name', ''))
        node_comm[nid] = n.get('community', n.get('cluster', ''))
    cross = []
    for e in edges:
        sc = node_comm.get(e.get('source', ''), '')
        tc = node_comm.get(e.get('target', ''), '')
        if sc and tc and sc != tc:
            cross.append(e)
    if cross:
        with open(patterns_path) as f:
            existing = f.read()
        if 'Cross-Community' not in existing:
            with open(patterns_path, 'a') as f:
                f.write(f'\n## Cross-Community Patterns (updated {timestamp})\n\n')
                for e in cross[:10]:
                    f.write(f\"\"\"- {e.get('source','')} <-> {e.get('target','')} ({e.get('confidence','INFERRED')})\n\"\"\")

# Check for new decisions during sync
decisions_dir = os.path.join(ctx, 'decisions')
decisions_path = os.path.join(ctx, 'decisions.md')
if os.path.isdir(decisions_dir) and os.path.exists(decisions_path):
    with open(decisions_path) as f:
        existing = f.read()
    for fname in os.listdir(decisions_dir):
        if fname.startswith('_') or not fname.endswith('.md'): continue
        did = fname[:-3]
        if did not in existing:
            adr_path = os.path.join(decisions_dir, fname)
            with open(adr_path) as f:
                c = f.read()
            title_match = re.search(r'title:\s*[\"\'']?(.+?)[\"\'']?\s*$', c, re.MULTILINE)
            title = title_match.group(1) if title_match else did
            entry_line = f'- **{title}** [{did}, active]\n'
            if '## Active Decisions' in existing:
                existing = existing.replace('## Active Decisions\n', f'## Active Decisions\n\n{entry_line}', 1)
            else:
                existing += f'\n{entry_line}'
            with open(decisions_path, 'w') as f:
                f.write(existing)
            print(f'  Decision captured during sync: {title}')

print(f'Phase 4: committed — {sync_status}')
print(f'  Modules: {module_count if \"module_count\" in dir() else \"?\"}, Entities: {entity_count if \"entity_count\" in dir() else \"?\"}')
" 2>/dev/null || echo "Phase 4: committed (minimal)"
