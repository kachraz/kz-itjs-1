# HexStrike AI Containerization Report (Revised)

This revision aligns the container setup strictly with the repository’s README and code expectations, focusing on:
- Installing only what is necessary to run the HexStrike API server and the Browser Agent (Selenium + Chromium/Chromedriver) as referenced by the README and hexstrike_server.py, without bundling the optional 150+ external security tools.
- Avoiding speculative packages and keeping the image reproducible on Debian Bookworm (official Python base images).

No existing repository files were modified. Only Dockerfile, docker-compose.yml, and this report were added/updated.

## What’s installed and why

From README “Installation Steps” and requirements.txt:
- Python dependencies: installed from `requirements.txt` (flask, requests, psutil, fastmcp, beautifulsoup4, selenium, webdriver-manager, aiohttp, mitmproxy, pwntools, angr). These are the imports used by `hexstrike_server.py` and needed for core runtime.
- Browser Agent requirements (README: Chromium/Chrome + ChromeDriver): we install Debian packages `chromium` and `chromium-driver` along with the minimal runtime libraries needed for headless operation.
- Build toolchain and headers to satisfy Python packages with native extensions (e.g., pwntools/angr when wheels are not available): build-essential, python3-dev, libffi-dev, libssl-dev, libxml2-dev, libxslt1-dev, zlib1g-dev, libbz2-dev, liblzma-dev, pkg-config, etc.

Not included (by design): The optional 150+ external tools (nmap, nuclei, etc.). The README notes the system works with any subset and gracefully skips missing tools. Bundling them would significantly increase the image size and maintenance burden and is not required for the server to run.

## Dockerfile (key points)
- Base: `python:3.11-bookworm` (Debian 12) to ensure clean availability of `chromium` and `chromium-driver` packages.
- Installs Chromium and ChromeDriver and essential runtime libraries for headless mode.
- Installs Python dependencies from `requirements.txt`.
- Sets env vars so Selenium can locate Chromium/Chromedriver: `CHROME_BIN=/usr/bin/chromium`, `CHROMEDRIVER=/usr/bin/chromedriver`.
- Exposes port 8888 and defines a curl-based `HEALTHCHECK` for `/health`.
- Default command runs `python3 hexstrike_server.py`.

## docker-compose.yml (key points)
- Builds the image from Dockerfile.
- Maps host port (default 8888) to container 8888 (configurable via `HEXSTRIKE_PORT`).
- Sets environment variables required by the server and browser agent (`HEXSTRIKE_PORT`, `HEXSTRIKE_HOST`, `DEBUG_MODE`, `CHROME_BIN`, `CHROMEDRIVER`).
- Uses modern Compose format without the obsolete `version:`.
- `restart: unless-stopped` for resilience.

## How to run

- Build and run with Compose:
  - `docker compose up --build -d`
  - Open `http://localhost:8888/health`
- Override port:
  - `HEXSTRIKE_PORT=9999 docker compose up --build -d`
  - Open `http://localhost:9999/health`
- See logs:
  - `docker compose logs -f`
- Tear down:
  - `docker compose down`

## Notes
- The Browser Agent relies on Selenium + Chromium/Chromedriver present in the image. The code references Selenium and Chrome options directly in `hexstrike_server.py` and `requirements.txt` corroborates the usage.
- For a variant image that pre-installs a curated subset of external tools from the README (like nmap, nuclei, httpx) we can add a separate service/profile to keep the default image lean.

If you want, I can add a dev profile (compose override) that mounts the repository as a bind mount for live iteration and hot reload while keeping production image clean.
