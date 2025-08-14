# HexStrike AI MCP Agents v6.0 - Docker Container
FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV API_PORT=8000
ENV DEBUG_MODE=False

# Create working directory
WORKDIR /app

# Update system and install base dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    python3-venv \
    git \
    wget \
    curl \
    unzip \
    build-essential \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Install security tools and dependencies
RUN apt-get update && apt-get install -y \
    # Network tools
    nmap \
    masscan \
    netcat \
    socat \
    tcpdump \
    wireshark-common \
    tshark \
    # Web tools
    gobuster \
    dirb \
    nikto \
    sqlmap \
    # DNS tools
    dnsutils \
    dnsrecon \
    fierce \
    # Forensics tools
    binwalk \
    foremost \
    # Crypto tools
    hashcat \
    hashcat-data \
    john \
    john-data \
    # System tools
    strace \
    ltrace \
    gdb \
    # Additional utilities
    jq \
    xmlstarlet \
    && rm -rf /var/lib/apt/lists/*

# Install Go (for some security tools)
RUN wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz && \
    rm go1.21.0.linux-amd64.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# Install additional security tools from source
RUN git clone https://github.com/OWASP/Amass.git /tmp/amass && \
    cd /tmp/amass && \
    go build -o /usr/local/bin/amass ./cmd/amass && \
    rm -rf /tmp/amass

RUN git clone https://github.com/projectdiscovery/subfinder.git /tmp/subfinder && \
    cd /tmp/subfinder/v2/cmd/subfinder && \
    go build -o /usr/local/bin/subfinder && \
    rm -rf /tmp/subfinder

RUN git clone https://github.com/projectdiscovery/httpx.git /tmp/httpx && \
    cd /tmp/httpx/cmd/httpx && \
    go build -o /usr/local/bin/httpx && \
    rm -rf /tmp/httpx

RUN git clone https://github.com/projectdiscovery/nuclei.git /tmp/nuclei && \
    cd /tmp/nuclei/v2/cmd/nuclei && \
    go build -o /usr/local/bin/nuclei && \
    rm -rf /tmp/nuclei

# Install Node.js and npm (for some web tools)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Chrome for browser automation
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN CHROME_VERSION=$(google-chrome --version | grep -oP '\d+\.\d+\.\d+') && \
    DRIVER_VERSION=$(curl -s "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_${CHROME_VERSION%%.*}") && \
    wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${DRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /tmp && \
    mv /tmp/chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

# Copy application files
COPY requirements.txt .
COPY hexstrike_server.py .
COPY hexstrike_mcp.py .
COPY hexstrike-ai-mcp.json .

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Install additional Python security libraries
RUN pip3 install --no-cache-dir \
    scapy \
    pycryptodome \
    volatility3 \
    yara-python \
    python-magic \
    pefile \
    capstone \
    keystone-engine \
    unicorn \
    ropper \
    angr

# Create necessary directories
RUN mkdir -p /app/logs /app/data /app/wordlists /app/payloads

# Download common wordlists
RUN wget -O /app/wordlists/common.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt && \
    wget -O /app/wordlists/directory-list-2.3-medium.txt https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/directory-list-2.3-medium.txt

# Set permissions
RUN chmod +x hexstrike_server.py hexstrike_mcp.py

# Create non-root user for security
RUN useradd -m -s /bin/bash hexstrike && \
    chown -R hexstrike:hexstrike /app
USER hexstrike

# Expose the API port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# Start the server
CMD ["python3", "hexstrike_server.py"]