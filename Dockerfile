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
    git \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# -------------------------------------------
# 2. Install uv (fast Python package manager)
# -------------------------------------------
RUN pip install --no-cache-dir uv

# -------------------------------------------
# 3. Clone mPAPA source from GitHub
# -------------------------------------------
WORKDIR /tmp
RUN git clone --depth 1 https://github.com/hapi-ds/mPAPA.git mPAPA-src

# -------------------------------------------
# 4. Set working directory and copy source
# -------------------------------------------
WORKDIR /app
RUN cp /tmp/mPAPA-src/pyproject.toml . && \
    cp /tmp/mPAPA-src/uv.lock . && \
    cp /tmp/mPAPA-src/README.md . && \
    cp -r /tmp/mPAPA-src/src . && \
    cp -r /tmp/mPAPA-src/domain_profiles . && \
    rm -rf /tmp/mPAPA-src

# -------------------------------------------
# 5. Apply patches
# -------------------------------------------
COPY patch_openrouter.py /app/
RUN python3 patch_openrouter.py && rm patch_openrouter.py

# -------------------------------------------
# 6. Install dependencies (no dev deps)
# -------------------------------------------
RUN uv sync --frozen --no-dev --no-install-project

# -------------------------------------------
# 6. Install the project itself
# -------------------------------------------
RUN uv sync --frozen --no-dev

# -------------------------------------------
# 7. Create runtime directories
# -------------------------------------------
RUN mkdir -p /app/data /app/data/pdfs /app/logs

# -------------------------------------------
# 8. Copy entrypoint script
# -------------------------------------------
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# -------------------------------------------
# 9. Expose NiceGUI port
# -------------------------------------------
EXPOSE 8080

# -------------------------------------------
# 10. Health check
# -------------------------------------------
HEALTHCHECK --interval=30s --timeout=5s --start-period=15s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# -------------------------------------------
# 11. Entrypoint
# -------------------------------------------
ENTRYPOINT ["/entrypoint.sh"]
