# ===========================================
# mPAPA — Dockerfile for Coolify deployment
# ===========================================
# mPAPA: my Personal Artificial Patent Attorney
# AI-powered patent drafting with prior art search
# ===========================================

FROM python:3.13-slim AS base

LABEL maintainer="Coralyx"
LABEL description="mPAPA — AI Patent Drafting System"

# -------------------------------------------
# 1. Install system dependencies
# -------------------------------------------
RUN apt-get update && apt-get install --yes --no-install-recommends \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------------
# 2. Install uv (fast Python package manager)
# -------------------------------------------
RUN pip install --no-cache-dir uv

# -------------------------------------------
# 3. Set working directory
# -------------------------------------------
WORKDIR /app

# -------------------------------------------
# 4. Copy dependency files first (for caching)
# -------------------------------------------
COPY pyproject.toml uv.lock ./

# -------------------------------------------
# 5. Install dependencies (no dev deps)
# -------------------------------------------
RUN uv sync --frozen --no-dev --no-install-project

# -------------------------------------------
# 6. Copy source code and data
# -------------------------------------------
COPY src/ src/
COPY domain_profiles/ domain_profiles/

# -------------------------------------------
# 7. Install the project itself
# -------------------------------------------
RUN uv sync --frozen --no-dev

# -------------------------------------------
# 8. Create runtime directories
# -------------------------------------------
RUN mkdir -p /app/data /app/data/pdfs /app/logs

# -------------------------------------------
# 9. Copy entrypoint script
# -------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# -------------------------------------------
# 10. Expose NiceGUI port
# -------------------------------------------
EXPOSE 8080

# -------------------------------------------
# 11. Health check
# -------------------------------------------
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# -------------------------------------------
# 12. Entrypoint
# -------------------------------------------
ENTRYPOINT ["/entrypoint.sh"]
