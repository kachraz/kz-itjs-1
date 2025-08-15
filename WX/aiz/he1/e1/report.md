# HexStrike AI Containerization Report

This report summarizes the changes made to add a containerized workflow and a simple test runner, without modifying any existing project files.

## What was added

- Dockerfile
  - Based on `python:3.11-slim`.
  - Installs system dependencies required to build and run the app, including build tools and libraries used by heavy packages (`angr`, `pwntools`, etc.).
  - Installs Chromium and Chromedriver (`chromium`, `chromium-driver`) plus supporting libraries for the Browser Agent (Selenium headless Chrome).
  - Copies project sources and installs Python dependencies from `requirements.txt`.
  - Exposes port 8888 and configures a container healthcheck targeting `/health`.
  - Default command starts the API server: `python3 hexstrike_server.py`.

- test_docker.sh
  - Bash script that builds the Docker image, runs a container, waits for the `/health` endpoint to become ready, invokes a sample API (`/api/intelligence/analyze-target`), shows tail logs, and then removes the container.
  - Useful for quick validation in environments with Docker installed.

## How to use

1. Build the image
   - `docker build -t hexstrike-ai:local .`

2. Run the server
   - `docker run --rm -p 8888:8888 hexstrike-ai:local`
   - Visit `http://localhost:8888/health`

3. Or run the test script
   - Make the script executable: `chmod +x test_docker.sh`
   - Execute: `./test_docker.sh`

## Notes & assumptions

- The container installs only the Python requirements listed in `requirements.txt`. Many external security tools listed in the README are optional and not required for the server to boot; they are intentionally not bundled in this image to keep size and complexity reasonable. The server gracefully handles missing tools.
- The Browser Agent uses Selenium with headless Chromium. Debian package names used: `chromium` and `chromium-driver`. If your base registry mirrors use different names (e.g., `google-chrome-stable`), you may swap packages accordingly.
- The image includes compilers and headers to support packages with native extensions. If you later optimize image size, consider a multi-stage build to compile wheels in a builder image and copy only needed artifacts.
- No existing repository files were modified, in accordance with the request. Only the following new files were added:
  - `Dockerfile`
  - `test_docker.sh`

## Environment

- Exposed port: 8888 (configurable via `HEXSTRIKE_PORT` at runtime, but the Dockerfile exposes 8888 by default).
- Default command: `python3 hexstrike_server.py`. You can pass `--debug` or `--port` by overriding the command:
  - `docker run --rm -p 9999:9999 hexstrike-ai:local python3 hexstrike_server.py --port 9999 --debug`

## Healthcheck

- Container `HEALTHCHECK` runs a small Python snippet that queries `http://127.0.0.1:8888/health` and expects a 200 with a JSON `status` field.

If you want me to produce a multi-stage build variant, or images that bundle selected external tools (e.g., Nmap, httpx, nuclei), I can add curated variants (with tags) while keeping the default image lean.
