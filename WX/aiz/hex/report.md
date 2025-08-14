# HexStrike AI MCP Agents v6.0 – Containerization Report

This report documents the containerization of the HexStrike AI repository. It provides an overview of the Docker image, installed dependencies, configuration options, and a smoke test flow to validate the container. No existing source files or logic were modified.

## What was added

- `Dockerfile` – A production-ready container for the HexStrike API server with optional browser tooling.
- `test_docker.sh` – A convenience script to build, run, smoke-test, and clean up a test container.

## Goals and design choices

- Preserve the project’s startup flow: `python hexstrike_server.py` (Flask server on port 8888 by default).
- Support the Browser Agent by including Chromium and Chromedriver (configurable).
- Keep the build resilient even when optional heavy Python dependencies cannot build in a slim environment.
- Avoid changing any app logic, environment variable names, or runtime behavior.

## Dockerfile overview

Base image:
- `python:3.10-slim` – Debian-based, compact, and compatible with most prebuilt wheels.

Key layers:
- System packages: build toolchain and libraries used by common Python packages, plus optional Chromium/Chromedriver and libs used by Selenium in headless mode.
- Core Python deps: a minimal subset that guarantees the server can start: Flask, requests, psutil, aiohttp, bs4, lxml, selenium, mitmproxy, websockets, fastmcp.
- Full requirements: installs the complete `requirements.txt`. To avoid breaking builds due to optional heavy packages, failures are tolerated (remove `|| true` for strict installs).
- Optional Playwright: can be enabled via `--build-arg INSTALL_PLAYWRIGHT_DEPS=true` but is off by default.

Important environment variables:
- `HEXSTRIKE_PORT` (default 8888) – Consumed by the server; mapped with `EXPOSE 8888`.
- `DEBUG_MODE` (default 0) – Respecting the existing code which reads this env var.
- `CHROME_BIN` and `CHROMEDRIVER_PATH` – Paths exposed for Selenium; Chromium + Chromedriver are installed when `INSTALL_BROWSER_DEPS=true`.

Healthcheck:
- Pings `GET /health` after the server is up.

Default command:
- `CMD ["python", "hexstrike_server.py"]`

## Browser Agent support

The project’s Browser Agent uses Selenium with Chrome. The Dockerfile installs Chromium and Chromedriver by default (controlled by `INSTALL_BROWSER_DEPS=true`). Headless Chrome flags (`--no-sandbox`, `--disable-dev-shm-usage`, etc.) are already set in the application code. If you want to slim the image and don’t need browser features, pass `--build-arg INSTALL_BROWSER_DEPS=false`.

## Notes on large/optional dependencies

`requirements.txt` lists numerous heavy or platform-specific packages (e.g., binary analysis, ML/AI, cloud SDKs). Some of these may require additional native dependencies or may not be necessary for basic API/server functionality. The server is designed to operate even if some optional tools are missing; APIs may gracefully degrade. For this reason, the Dockerfile:
- Installs a minimal subset first so the server can boot.
- Attempts to install the full requirements but does not fail the build if some packages fail.

For a strict CI build (fail on any dependency error), remove the `|| true` from the `pip install -r requirements.txt` command.

## Building and testing (Docker and Compose)

Manual steps:
- Build the image (default includes browser tooling):
  - `docker build -t hexstrike-ai:dev .`
- Or slim build without Chromium/Chromedriver:
  - `docker build --build-arg INSTALL_BROWSER_DEPS=false -t hexstrike-ai:dev .`

Run:
- `docker run -d --name hexstrike-ai -p 8888:8888 -e HEXSTRIKE_PORT=8888 hexstrike-ai:dev`
- Wait for the server to come up, then test:
  - `curl http://127.0.0.1:8888/health`

Smoke-test script:
- `chmod +x ./test_docker.sh && ./test_docker.sh`
- Actions performed:
  1. Build with optional browser deps enabled (default).
  2. Run the container publishing port 8888.
  3. Poll `/health` until it responds.
  4. Run a couple of basic HTTP checks.
  5. Stop and remove the container.

### Compose
- Build and run:
  - `docker compose up --build -d`
- Logs:
  - `docker compose logs -f`
- Stop:
  - `docker compose down`

## Configuration matrix

Build arguments:
- `INSTALL_BROWSER_DEPS` (default `true`) – Install Chromium + Chromedriver and runtime libs for headless Selenium.
- `INSTALL_PLAYWRIGHT_DEPS` (default `false`) – Install Playwright and Chromium for it (not required by current code).

Environment variables:
- `HEXSTRIKE_PORT` – Port the Flask server binds to (default: 8888). Also exposed by the image.
- `DEBUG_MODE` – Set to `1`/`true` to enable debug mode.
- `CHROME_BIN`, `CHROMEDRIVER_PATH` – Override paths if you provide custom browser builds.

## Known limitations and future improvements

- Some tools listed in `requirements.txt` and the README require extensive OS packages or GPUs (e.g., PyTorch), which are out of scope for a minimal portable image. If you need full capability, consider a larger base image (e.g., `nvidia/cuda` for GPU) and/or additional apt packages.
- External CLI tools (nmap, nuclei, gobuster, etc.) are not installed in this image. The app gracefully handles missing executables. For a bespoke “batteries-included” image, you can extend from this image and add specific CLI tools you need.
- If you require Google Chrome Stable instead of Chromium, customize the Dockerfile to install Google’s repository and package.

## Quick reference

- Build: `docker build -t hexstrike-ai:dev .`
- Run: `docker run -d --name hexstrike-ai -p 8888:8888 -e HEXSTRIKE_PORT=8888 hexstrike-ai:dev`
- Check: `curl http://127.0.0.1:8888/health`
- Clean: `docker rm -f hexstrike-ai` (to stop and remove)

---

Prepared by Rovo Dev
