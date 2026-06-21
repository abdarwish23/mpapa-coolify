#!/bin/bash
# ===========================================
# mPAPA Entrypoint — Coolify deployment
# ===========================================
set -e

echo "==========================================="
echo "  mPAPA — Patent Analysis & Drafting System"
echo "==========================================="

# -------------------------------------------
# Detect LLM backend
# -------------------------------------------
if [ -n "$PATENT_LM_STUDIO_BASE_URL" ]; then
    echo "[✓] LLM Backend: $PATENT_LM_STUDIO_BASE_URL"
else
    # Default to Ollama if running in compose stack
    export PATENT_LM_STUDIO_BASE_URL="http://ollama:11434/v1"
    echo "[✓] LLM Backend: $PATENT_LM_STUDIO_BASE_URL (default Ollama)"
fi

echo "[✓] NiceGUI Port: ${PATENT_NICEGUI_PORT:-8080}"
echo "[✓] Database: ${PATENT_DATABASE_PATH:-data/patent_system.db}"
echo ""

# -------------------------------------------
# Ensure runtime directories
# -------------------------------------------
mkdir -p /app/data /app/data/pdfs /app/logs

# -------------------------------------------
# Start mPAPA
# -------------------------------------------
echo "Starting mPAPA on port ${PATENT_NICEGUI_PORT:-8080}..."
echo "Access at: http://localhost:${PATENT_NICEGUI_PORT:-8080}/"
echo "==========================================="

exec uv run python -m patent_system.main
