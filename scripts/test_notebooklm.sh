#!/usr/bin/env bash
# test_notebooklm.sh — Test notebooklm-mcp-cli (nlm) operations
# Prerequisites: pip/uv install notebooklm-mcp-cli && nlm login
set -euo pipefail

RESULTS_DIR="$(dirname "$0")/../results"
mkdir -p "$RESULTS_DIR"

echo "============================================"
echo "  NotebookLM CLI (nlm) Test Suite"
echo "============================================"

# Check if nlm is installed
if ! command -v nlm &>/dev/null; then
    echo "❌ 'nlm' not found. Install with:"
    echo "   uv tool install notebooklm-mcp-cli"
    echo "   # or"
    echo "   pipx install notebooklm-mcp-cli"
    echo ""
    echo "Then authenticate:"
    echo "   nlm login"
    exit 1
fi

echo "nlm version: $(nlm --version 2>/dev/null || echo 'unknown')"
echo ""

# Test 1: List notebooks
echo "--- Test 1: List notebooks ---"
START=$(python3 -c "import time; print(time.time())")
if nlm notebook list 2>&1 | tee "$RESULTS_DIR/nlm_list.txt"; then
    echo "✅ Success"
else
    echo "⚠️  Failed (may need 'nlm login' first)"
fi
END=$(python3 -c "import time; print(time.time())")
ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
echo "⏱  Time: ${ELAPSED}s"
echo ""

# Test 2: Create a test notebook
echo "--- Test 2: Create test notebook ---"
START=$(python3 -c "import time; print(time.time())")
if nlm notebook create --title "God Mode Test $(date +%s)" 2>&1 | tee "$RESULTS_DIR/nlm_create.txt"; then
    echo "✅ Success"
else
    echo "⚠️  Failed"
fi
END=$(python3 -c "import time; print(time.time())")
ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
echo "⏱  Time: ${ELAPSED}s"
echo ""

# Test 3: Show available commands
echo "--- Test 3: Available commands ---"
nlm --help 2>&1 | tee "$RESULTS_DIR/nlm_help.txt"
echo ""

echo "============================================"
echo "  Results saved to: $RESULTS_DIR/"
echo "============================================"
