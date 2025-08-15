# HexStrike AI MCP Agents - Container Image
# Base: Python slim with Debian packages for headless Chromium and build deps
FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System dependencies:
# - build tools and headers for packages like angr/pwntools
# - Chromium and chromedriver for BrowserAgent
# - minimal GUI libs for headless chromium stability
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    gcc g++ make \
    python3-dev \
    libffi-dev libssl-dev \
    libxml2-dev libxslt1-dev \
    zlib1g-dev libbz2-dev liblzma-dev \
    pkg-config \
    ca-certificates \
    git curl wget unzip \
    chromium chromium-driver \
    fonts-liberation \
    libglib2.0-0 libnss3 \
    libgdk-pixbuf-2.0-0 libgtk-3-0 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Workdir
WORKDIR /app

# Install Python dependencies first for better caching
COPY requirements.txt ./
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application source
COPY . /app

# Environment for server
ENV HEXSTRIKE_PORT=8888 \
    HEXSTRIKE_HOST=0.0.0.0

# Expose API port
EXPOSE 8888

# Optional container healthcheck hitting /health
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
  CMD curl -fsS http://127.0.0.1:8888/health || exit 1

# Default command runs the API server
CMD ["python3", "hexstrike_server.py"]
