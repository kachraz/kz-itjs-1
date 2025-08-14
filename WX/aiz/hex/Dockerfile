# HexStrike AI MCP Agents v6.0 - Dockerfile
# Containerizes the API server and optional browser/agent dependencies without modifying source logic.

# Use a Python base image with Debian for broad binary wheels compatibility
FROM python:3.10-slim AS runtime

# Avoid interactive prompts during apt operations
ARG DEBIAN_FRONTEND=noninteractive

# Build arguments to optionally include heavy optional tools
# Set to "true" to install extra browser tooling via Playwright (not required for Selenium)
ARG INSTALL_PLAYWRIGHT_DEPS=false
# Set to "true" (default) to install Chromium + Chromedriver for the Browser Agent
ARG INSTALL_BROWSER_DEPS=true

# System packages required for building some Python wheels and runtime libs
# - build-essential, gcc, etc. for packages with native extensions (cryptography, etc.)
# - libmagic1 for python-magic
# - Optional Chromium + Chromedriver for Browser Agent (Selenium)
# - Common Chromium runtime libraries (when browser deps enabled)
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      curl \
      wget \
      git \
      build-essential \
      gcc \
      g++ \
      make \
      pkg-config \
      python3-dev \
      libffi-dev \
      libssl-dev \
      libmagic1 \
      libmagic-dev; \
    if [ "$INSTALL_BROWSER_DEPS" = "true" ]; then \
      apt-get install -y --no-install-recommends \
        chromium \
        chromium-driver \
        libasound2 \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libdrm2 \
        libexpat1 \
        libfontconfig1 \
        libgcc1 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libnss3 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libgbm1 \
        xdg-utils \
        fonts-liberation; \
    fi; \
    rm -rf /var/lib/apt/lists/*

# Environment configuration
ENV PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    # Explicitly set Chromium path for Selenium if needed
    CHROME_BIN=/usr/bin/chromium \
    CHROMEDRIVER_PATH=/usr/bin/chromedriver \
    HEXSTRIKE_PORT=8888 \
    DEBUG_MODE=0

WORKDIR /app

# Copy dependency list first to leverage Docker layer caching
COPY requirements.txt /app/

# Upgrade pip/setuptools/wheel to improve wheels resolution
RUN python -m pip install --upgrade pip setuptools wheel

# Optional: install Playwright browser and deps if requested
# HexStrike primarily uses Selenium; this is off by default to keep the image leaner
RUN if [ "$INSTALL_PLAYWRIGHT_DEPS" = "true" ]; then \
      python -m pip install playwright && \
      python -m playwright install --with-deps chromium; \
    fi

# Install Python dependencies. Some optional packages are very heavy and may take time.
# If you prefer a hard-fail build on any dependency error, remove the trailing '|| true'.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt || true

# Copy the rest of the repository
COPY . /app

# Create an unprivileged user to run the service
RUN useradd -m -u 10001 hexstrike \
 && chown -R hexstrike:hexstrike /app
USER hexstrike

# Expose service port
EXPOSE 8888

# Healthcheck against /health endpoint once the server is up
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=10 \
  CMD wget -qO- http://127.0.0.1:${HEXSTRIKE_PORT:-8888}/health || exit 1

# Default command: start the API server
CMD ["python", "hexstrike_server.py"]
