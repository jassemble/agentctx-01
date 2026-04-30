#!/usr/bin/env bash
# Phase 1: EXTRACT — Run brain incremental extraction
set -euo pipefail

CTX=".ctx"
GRAPH="$CTX/graph/graph.json"
START=$(python3 -c "import time; print(int(time.time()*1000))")

echo "Phase 1: EXTRACT"

if ! command -v brain &>/dev/null; then
  echo "ERROR: brain CLI not found. Install brain first." >&2
  exit 1
fi

# Run incremental extraction
if ! brain . --update 2>&1; then
  echo "ERROR: brain extraction failed" >&2
  exit 1
fi

if [ ! -f "$GRAPH" ]; then
  echo "ERROR: graph.json not produced at $GRAPH" >&2
  exit 1
fi

# Re-detect skills after extraction (task 4.6)
if [ -f "scripts/detect-skills.sh" ]; then
  delta=$(bash scripts/detect-skills.sh --quiet 2>&1) || true
  if [ -n "$delta" ]; then
    echo "$delta"
  fi
fi

END=$(python3 -c "import time; print(int(time.time()*1000))")
DURATION=$((END - START))

# Check if anything changed
python3 -c "
import json, os
graph = '$GRAPH'
manifest = '$CTX/graph/manifest.json'
if os.path.exists(manifest):
    with open(manifest) as f:
        m = json.load(f)
    changed = m.get('changed_files', [])
    if not changed:
        print('NO_CHANGES')
    else:
        print(f'CHANGED:{len(changed)}')
else:
    print('CHANGED:unknown')
" | while read -r line; do
  case "$line" in
    NO_CHANGES)
      echo "Phase 1: no changes detected (exit 10 = skip to lightweight sync)"
      echo "duration_ms=$DURATION"
      exit 10
      ;;
    CHANGED:*)
      count="${line#CHANGED:}"
      echo "Phase 1: complete — $count files processed"
      echo "duration_ms=$DURATION"
      echo "graph=$GRAPH"
      # Output GRAPH_REPORT.md path if it exists
      REPORT="$CTX/graph/GRAPH_REPORT.md"
      [ -f "$REPORT" ] && echo "report=$REPORT"
      ;;
  esac
done

# Log graph stats
python3 -c "
import json, os
graph = '$GRAPH'
if os.path.exists(graph):
    with open(graph) as f:
        data = json.load(f)
    nodes = len(data.get('nodes', []))
    edges = len(data.get('edges', data.get('links', [])))
    comms = len(set(n.get('community', n.get('cluster', '')) for n in data.get('nodes', []) if n.get('community', n.get('cluster', ''))))
    print(f'graph_stats: nodes={nodes} edges={edges} communities={comms}')
" 2>/dev/null || true
