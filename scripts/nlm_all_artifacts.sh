#!/usr/bin/env bash
# nlm_all_artifacts.sh — Generate ALL NotebookLM studio artifact types for a notebook
# Usage: bash scripts/nlm_all_artifacts.sh <notebook-id> [profile]
#
# Generates: audio, video, mind map, report, flashcards, quiz, infographic, slides, data table
set -euo pipefail

NOTEBOOK_ID="${1:?Usage: $0 <notebook-id> [profile]}"
PROFILE="${2:-default}"
RESULTS_DIR="$(dirname "$0")/../results/nlm-artifacts"
mkdir -p "$RESULTS_DIR"

echo "============================================"
echo "  NotebookLM Full Artifact Generation"
echo "============================================"
echo "Notebook: $NOTEBOOK_ID"
echo "Profile:  $PROFILE"
echo "Output:   $RESULTS_DIR/"
echo ""

# Array of artifact types and their commands
declare -a ARTIFACTS=(
    "audio:Audio Overview"
    "video:Video Overview"
    "mindmap:Mind Map"
    "report:Report"
    "flashcards:Flashcards"
    "quiz:Quiz"
    "infographic:Infographic"
    "slides:Slide Deck"
    "data-table:Data Table"
)

PASS=0
FAIL=0

for entry in "${ARTIFACTS[@]}"; do
    CMD="${entry%%:*}"
    LABEL="${entry##*:}"
    
    echo "--- Generating: $LABEL ---"
    START=$(python3 -c "import time; print(time.time())")
    
    if nlm "$CMD" create "$NOTEBOOK_ID" --profile "$PROFILE" 2>&1 | tee "$RESULTS_DIR/${CMD}.txt"; then
        echo "✅ $LABEL — Success"
        ((PASS++))
    else
        echo "❌ $LABEL — Failed"
        ((FAIL++))
    fi
    
    END=$(python3 -c "import time; print(time.time())")
    ELAPSED=$(python3 -c "print(f'{${END} - ${START}:.2f}')")
    echo "⏱  Time: ${ELAPSED}s"
    echo ""
done

echo "============================================"
echo "  Summary: $PASS passed, $FAIL failed"
echo "  Results: $RESULTS_DIR/"
echo "============================================"
ls -la "$RESULTS_DIR/"
