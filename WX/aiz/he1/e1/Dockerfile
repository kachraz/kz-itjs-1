# HexStrike AI MCP Agents - Complete Installation
# Multi-stage build for comprehensive cybersecurity tool suite
FROM ubuntu:22.04 AS base

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System update and basic dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# STAGE 1: Python and Build Environment
# =============================================================================
FROM base AS python-build

# Install Python 3.11 and build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    python3-pip \
    build-essential \
    gcc g++ make \
    cmake \
    pkg-config \
    git \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libsqlite3-dev \
    libreadline-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    && rm -rf /var/lib/apt/lists/*

# Set python3.11 as default python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
RUN python3 -m pip install --upgrade pip setuptools wheel

# =============================================================================
# STAGE 2: Network & Reconnaissance Tools
# =============================================================================
FROM python-build AS network-tools

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Core network scanning
    nmap \
    masscan \
    # Domain enumeration
    amass \
    subfinder \
    fierce \
    dnsenum \
    theharvester \
    # Network utilities
    responder \
    netexec \
    enum4linux-ng \
    # Additional network tools
    dnsutils \
    netcat-traditional \
    socat \
    tcpdump \
    wireshark-common \
    && rm -rf /var/lib/apt/lists/*

# Install rustscan (needs manual installation)
RUN wget -q https://github.com/RustScan/RustScan/releases/download/2.1.1/rustscan_2.1.1_amd64.deb \
    && dpkg -i rustscan_2.1.1_amd64.deb || true \
    && apt-get update && apt-get install -f -y \
    && rm rustscan_2.1.1_amd64.deb

# Install autorecon
RUN python3 -m pip install autorecon

# =============================================================================
# STAGE 3: Web Application Security Tools
# =============================================================================
FROM network-tools AS web-tools

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Directory/file enumeration
    gobuster \
    feroxbuster \
    dirsearch \
    dirb \
    # Web fuzzing
    ffuf \
    # Web scanners
    nikto \
    sqlmap \
    wpscan \
    # HTTP utilities
    httpx \
    katana \
    # Web security tools
    wafw00f \
    && rm -rf /var/lib/apt/lists/*

# Install nuclei
RUN wget -q https://github.com/projectdiscovery/nuclei/releases/download/v3.1.0/nuclei_3.1.0_linux_amd64.zip \
    && unzip nuclei_3.1.0_linux_amd64.zip \
    && mv nuclei /usr/local/bin/ \
    && chmod +x /usr/local/bin/nuclei \
    && rm nuclei_3.1.0_linux_amd64.zip

# Install additional web tools via pip
RUN python3 -m pip install \
    arjun \
    paramspider \
    dalfox

# Install hakrawler, gau, waybackurls (Go tools)
RUN apt-get update && apt-get install -y golang-go \
    && go install github.com/hakluke/hakrawler@latest \
    && go install github.com/lc/gau/v2/cmd/gau@latest \
    && go install github.com/tomnomnom/waybackurls@latest \
    && mv /root/go/bin/* /usr/local/bin/ \
    && apt-get remove -y golang-go \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /root/go

# =============================================================================
# STAGE 4: Authentication & Password Tools
# =============================================================================
FROM web-tools AS auth-tools

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Password attacks
    hydra \
    john \
    hashcat \
    medusa \
    patator \
    # Windows tools
    evil-winrm \
    # Hash utilities
    hash-identifier \
    ophcrack \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# STAGE 5: Binary Analysis & Reverse Engineering
# =============================================================================
FROM auth-tools AS binary-tools

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Debugging and analysis
    gdb \
    gdb-multiarch \
    radare2 \
    binwalk \
    checksec \
    # System utilities
    strings \
    objdump \
    strace \
    ltrace \
    # Forensics
    volatility3 \
    foremost \
    steghide \
    exiftool \
    && rm -rf /var/lib/apt/lists/*

# Install Ghidra
RUN apt-get update && apt-get install -y openjdk-17-jdk \
    && wget -q https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip \
    && unzip ghidra_10.4_PUBLIC_20230928.zip -d /opt/ \
    && mv /opt/ghidra_10.4_PUBLIC /opt/ghidra \
    && ln -s /opt/ghidra/ghidraRun /usr/local/bin/ghidra \
    && rm ghidra_10.4_PUBLIC_20230928.zip \
    && rm -rf /var/lib/apt/lists/*

# Install ropgadget
RUN python3 -m pip install ropgadget

# =============================================================================
# STAGE 6: Cloud & Container Security
# =============================================================================
FROM binary-tools AS cloud-tools

# Install cloud security tools
RUN python3 -m pip install \
    prowler \
    scout-suite \
    checkov \
    terrascan

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Container security
    docker.io \
    # Kubernetes tools
    && rm -rf /var/lib/apt/lists/*

# Install trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | apt-key add - \
    && echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | tee -a /etc/apt/sources.list.d/trivy.list \
    && apt-get update && apt-get install -y trivy \
    && rm -rf /var/lib/apt/lists/*

# Install kube-hunter, kube-bench
RUN wget -q https://github.com/aquasecurity/kube-hunter/releases/download/v0.6.8/kube-hunter_0.6.8_linux_amd64.tar.gz \
    && tar -xzf kube-hunter_0.6.8_linux_amd64.tar.gz \
    && mv kube-hunter /usr/local/bin/ \
    && rm kube-hunter_0.6.8_linux_amd64.tar.gz

RUN wget -q https://github.com/aquasecurity/kube-bench/releases/download/v0.7.1/kube-bench_0.7.1_linux_amd64.tar.gz \
    && tar -xzf kube-bench_0.7.1_linux_amd64.tar.gz \
    && mv kube-bench /usr/local/bin/ \
    && rm kube-bench_0.7.1_linux_amd64.tar.gz

# Install docker-bench-security
RUN git clone https://github.com/docker/docker-bench-security.git /opt/docker-bench-security \
    && ln -s /opt/docker-bench-security/docker-bench-security.sh /usr/local/bin/docker-bench-security

# =============================================================================
# STAGE 7: CTF & Forensics Tools
# =============================================================================
FROM cloud-tools AS ctf-tools

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Forensics tools
    autopsy \
    sleuthkit \
    photorec \
    testdisk \
    scalpel \
    bulk-extractor \
    # Steganography
    zsteg \
    outguess \
    && rm -rf /var/lib/apt/lists/*

# Install stegsolve (Java tool)
RUN wget -q http://www.caesum.com/handbook/Stegsolve.jar -O /opt/stegsolve.jar \
    && echo '#!/bin/bash\njava -jar /opt/stegsolve.jar "$@"' > /usr/local/bin/stegsolve \
    && chmod +x /usr/local/bin/stegsolve

# =============================================================================
# STAGE 8: OSINT & Intelligence Tools
# =============================================================================
FROM ctf-tools AS osint-tools

# Install OSINT tools
RUN python3 -m pip install \
    sherlock-project \
    social-analyzer \
    recon-ng \
    shodan \
    censys

RUN apt-get update && apt-get install -y --no-install-recommends \
    spiderfoot \
    && rm -rf /var/lib/apt/lists/*

# Install maltego (Community Edition)
RUN wget -q https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.5.0.deb \
    && dpkg -i Maltego.v4.5.0.deb || true \
    && apt-get update && apt-get install -f -y \
    && rm Maltego.v4.5.0.deb \
    && rm -rf /var/lib/apt/lists/*

# =============================================================================
# STAGE 9: Browser Agent Setup
# =============================================================================
FROM osint-tools AS browser-setup

# Install Chrome and ChromeDriver
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y --no-install-recommends \
    google-chrome-stable \
    # X11 libraries for headless operation
    xvfb \
    x11vnc \
    fluxbox \
    wmctrl \
    # Additional browser dependencies
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libdrm2 \
    libgtk-3-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    libxss1 \
    libxtst6 \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) \
    && wget -q "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" \
    && unzip chromedriver_linux64.zip \
    && mv chromedriver /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm chromedriver_linux64.zip

# =============================================================================
# STAGE 10: Application Setup
# =============================================================================
FROM browser-setup AS final

# Set working directory
WORKDIR /app

# Copy requirements and install Python dependencies
COPY requirements.txt ./
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Install additional Python packages for web scraping and automation
RUN python3 -m pip install \
    selenium \
    beautifulsoup4 \
    mitmproxy \
    webdriver-manager

# Copy application code
COPY . /app

# Set environment variables
ENV HEXSTRIKE_PORT=8888 \
    HEXSTRIKE_HOST=0.0.0.0 \
    CHROME_BIN=/usr/bin/google-chrome \
    CHROMEDRIVER=/usr/local/bin/chromedriver \
    DISPLAY=:99 \
    PATH="/usr/local/bin:${PATH}"

# Create non-root user for security
RUN useradd -m -u 1000 hexstrike \
    && chown -R hexstrike:hexstrike /app

# Expose API port
EXPOSE 8888

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -f http://127.0.0.1:8888/health || exit 1

# Switch to non-root user
USER hexstrike

# Start X virtual framebuffer for headless browser
CMD ["sh", "-c", "Xvfb :99 -screen 0 1024x768x24 & python3 hexstrike_server.py"]