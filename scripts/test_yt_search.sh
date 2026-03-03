#!/usr/bin/env bash
# test_yt_search.sh — Benchmark yt-dlp YouTube search speed & reliability
# Usage: bash scripts/test_yt_search.sh [query]
set -euo pipefail

QUERY="${1:-"best programming tutorials 2025"}"
RESULTS_DIR="$(dirname "$0")/../results"
mkdir -p "$RESULTS_DIR"
OUTFILE="$RESULTS_DIR/yt_dlp_results.txt"

echo "============================================"
echo "  yt-dlp YouTube Search Benchmark"
echo "============================================"
echo "Query: \"$QUERY\""
echo "yt-dlp version: $(yt-dlp --version)"
echo ""

# Test 1: Flat playlist search (fastest — metadata only)
echo "--- Test 1: Flat search, 5 results ---"
START=$(python3 -c "import time; print(time.time())")
yt-dlp "ytsearch5:${QUERY}" --flat-playlist --print url --no-warnings 2>/dev/null | tee "$RESULTS_DIR/flat5.txt"
END=$(python3 -c "import time; print(time.time())")
ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
echo "⏱  Time: ${ELAPSED}s"
echo ""

# Test 2: Flat playlist search, 10 results
echo "--- Test 2: Flat search, 10 results ---"
START=$(python3 -c "import time; print(time.time())")
yt-dlp "ytsearch10:${QUERY}" --flat-playlist --print url --no-warnings 2>/dev/null | tee "$RESULTS_DIR/flat10.txt"
END=$(python3 -c "import time; print(time.time())")
ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
echo "⏱  Time: ${ELAPSED}s"
echo ""

# Test 3: Full metadata (title + URL + duration)
echo "--- Test 3: Full metadata, 5 results ---"
START=$(python3 -c "import time; print(time.time())")
yt-dlp "ytsearch5:${QUERY}" --flat-playlist --print "%(title)s | %(url)s | %(duration_string)s" --no-warnings 2>/dev/null | tee "$RESULTS_DIR/meta5.txt"
END=$(python3 -c "import time; print(time.time())")
ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
echo "⏱  Time: ${ELAPSED}s"
echo ""

# Test 4: JSON output (for programmatic use)
echo "--- Test 4: JSON dump, 3 results ---"
START=$(python3 -c "import time; print(time.time())")
yt-dlp "ytsearch3:${QUERY}" --flat-playlist --dump-json --no-warnings 2>/dev/null | python3 -c "
import sys, json
for line in sys.stdin:
    d = json.loads(line)
    print(json.dumps({'title': d.get('title',''), 'url': d.get('url',''), 'channel': d.get('channel',''), 'duration': d.get('duration_string','')}, indent=2))
" | tee "$RESULTS_DIR/json3.txt"
END=$(python3 -c "import time; print(time.time())")
ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
echo "⏱  Time: ${ELAPSED}s"
echo ""

# Summary
echo "============================================"
echo "  Results saved to: $RESULTS_DIR/"
echo "============================================"
echo "Files:"
ls -la "$RESULTS_DIR"/*.txt 2>/dev/null
