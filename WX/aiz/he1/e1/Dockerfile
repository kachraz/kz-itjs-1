# HexStrike AI MCP Agents - Complete Installation
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

# System update and basic dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    wget \
    gnupg \
    lsb-release \
    software-properties-common \
    git \
    unzip \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Install Python 3.11 and build tools
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3.11-distutils \
    python3-pip \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    pkg-config \
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

# Set python3.11 as default
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1
RUN python3 -m pip install --upgrade pip setuptools wheel

# Install Go for Go-based tools
RUN apt-get update && apt-get install -y golang-go && rm -rf /var/lib/apt/lists/*

# Install Ruby for Ruby-based tools
RUN apt-get update && apt-get install -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*

# Install available network tools from Ubuntu repos
RUN apt-get update && apt-get install -y \
    nmap \
    masscan \
    dnsutils \
    netcat-traditional \
    socat \
    tcpdump \
    wireshark-common \
    && rm -rf /var/lib/apt/lists/*

# Install network tools from source/GitHub
RUN git clone https://github.com/lgandx/Responder.git /opt/responder && \
    chmod +x /opt/responder/Responder.py && \
    ln -s /opt/responder/Responder.py /usr/local/bin/responder

RUN git clone https://github.com/cddmp/enum4linux-ng.git /opt/enum4linux-ng && \
    chmod +x /opt/enum4linux-ng/enum4linux-ng.py && \
    ln -s /opt/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng

# Install Go-based network tools
RUN go install -v github.com/owasp-amass/amass/v4/cmd/amass@latest && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    cp /root/go/bin/* /usr/local/bin/

# Install rustscan
RUN wget https://github.com/RustScan/RustScan/releases/download/2.1.1/rustscan_2.1.1_amd64.deb && \
    dpkg -i rustscan_2.1.1_amd64.deb || apt-get install -f -y && \
    rm rustscan_2.1.1_amd64.deb

# Install Python network tools
RUN python3 -m pip install autorecon netexec theharvester dnspython

# Install available web tools from Ubuntu repos
RUN apt-get update && apt-get install -y \
    dirb \
    nikto \
    sqlmap \
    && rm -rf /var/lib/apt/lists/*

# Install Go-based web tools
RUN go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest && \
    go install -v github.com/ffuf/ffuf@latest && \
    go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install -v github.com/projectdiscovery/katana/cmd/katana@latest && \
    go install -v github.com/hakluke/hakrawler@latest && \
    go install -v github.com/lc/gau/v2/cmd/gau@latest && \
    go install -v github.com/tomnomnom/waybackurls@latest && \
    go install -v github.com/OJ/gobuster/v3@latest && \
    cp /root/go/bin/* /usr/local/bin/

# Install feroxbuster
RUN wget https://github.com/epi052/feroxbuster/releases/latest/download/x86_64-linux-feroxbuster.tar.gz && \
    tar -xzf x86_64-linux-feroxbuster.tar.gz && \
    mv feroxbuster /usr/local/bin/ && \
    rm x86_64-linux-feroxbuster.tar.gz

# Install web tools from GitHub
RUN git clone https://github.com/maurosoria/dirsearch.git /opt/dirsearch && \
    ln -s /opt/dirsearch/dirsearch.py /usr/local/bin/dirsearch

RUN git clone https://github.com/enablesecurity/wafw00f.git /opt/wafw00f && \
    ln -s /opt/wafw00f/bin/wafw00f /usr/local/bin/wafw00f

# Install Python web tools
RUN python3 -m pip install wpscan-cli arjun paramspider

# Install password tools from Ubuntu repos
RUN apt-get update && apt-get install -y \
    hydra \
    john \
    hashcat \
    medusa \
    ophcrack \
    && rm -rf /var/lib/apt/lists/*

# Install evil-winrm
RUN gem install evil-winrm

# Install Python password tools
RUN python3 -m pip install patator

# Install binary analysis tools from Ubuntu repos
RUN apt-get update && apt-get install -y \
    gdb \
    gdb-multiarch \
    radare2 \
    binwalk \
    binutils \
    strace \
    ltrace \
    foremost \
    steghide \
    exiftool \
    openjdk-17-jdk \
    && rm -rf /var/lib/apt/lists/*

# Install Ghidra
RUN wget https://github.com/NationalSecurityAgency/ghidra/releases/download/Ghidra_10.4_build/ghidra_10.4_PUBLIC_20230928.zip && \
    unzip ghidra_10.4_PUBLIC_20230928.zip -d /opt/ && \
    mv /opt/ghidra_10.4_PUBLIC /opt/ghidra && \
    ln -s /opt/ghidra/ghidraRun /usr/local/bin/ghidra && \
    rm ghidra_10.4_PUBLIC_20230928.zip

# Install checksec
RUN wget https://raw.githubusercontent.com/slimm609/checksec.sh/main/checksec && \
    chmod +x checksec && \
    mv checksec /usr/local/bin/

# Install Python binary tools
RUN python3 -m pip install volatility3 ropgadget

# Install cloud security tools
RUN python3 -m pip install prowler scout-suite checkov terrascan

# Install Docker
RUN apt-get update && apt-get install -y docker.io && rm -rf /var/lib/apt/lists/*

# Install Trivy
RUN wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | gpg --dearmor | tee /usr/share/keyrings/trivy.gpg > /dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/trivy.gpg] https://aquasecurity.github.io/trivy-repo/deb jammy main" | tee -a /etc/apt/sources.list.d/trivy.list && \
    apt-get update && apt-get install -y trivy && rm -rf /var/lib/apt/lists/*

# Install kube-hunter and kube-bench
RUN wget https://github.com/aquasecurity/kube-hunter/releases/download/v0.6.8/kube-hunter_0.6.8_linux_amd64.tar.gz && \
    tar -xzf kube-hunter_0.6.8_linux_amd64.tar.gz && \
    mv kube-hunter /usr/local/bin/ && \
    rm kube-hunter_0.6.8_linux_amd64.tar.gz

RUN wget https://github.com/aquasecurity/kube-bench/releases/download/v0.7.1/kube-bench_0.7.1_linux_amd64.tar.gz && \
    tar -xzf kube-bench_0.7.1_linux_amd64.tar.gz && \
    mv kube-bench /usr/local/bin/ && \
    rm kube-bench_0.7.1_linux_amd64.tar.gz

# Install docker-bench-security
RUN git clone https://github.com/docker/docker-bench-security.git /opt/docker-bench-security && \
    ln -s /opt/docker-bench-security/docker-bench-security.sh /usr/local/bin/docker-bench-security

# Install forensics tools from Ubuntu repos
RUN apt-get update && apt-get install -y \
    sleuthkit \
    testdisk \
    scalpel \
    bulk-extractor \
    outguess \
    && rm -rf /var/lib/apt/lists/*

# Install zsteg
RUN gem install zsteg

# Install OSINT tools
RUN python3 -m pip install sherlock-project social-analyzer recon-ng shodan censys

RUN apt-get update && apt-get install -y spiderfoot && rm -rf /var/lib/apt/lists/*

# Install Google Chrome and ChromeDriver
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
RUN CHROME_DRIVER_VERSION=$(curl -sS https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget "https://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip && \
    mv chromedriver /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Install X11 for headless browser
RUN apt-get update && apt-get install -y \
    xvfb \
    x11vnc \
    fluxbox \
    wmctrl \
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

# Set working directory
WORKDIR /app

# Copy and install Python requirements
COPY requirements.txt ./
RUN python3 -m pip install -r requirements.txt

# Copy application
COPY . /app

# Set environment variables
ENV HEXSTRIKE_PORT=8888 \
    HEXSTRIKE_HOST=0.0.0.0 \
    CHROME_BIN=/usr/bin/google-chrome \
    CHROMEDRIVER=/usr/local/bin/chromedriver \
    DISPLAY=:99 \
    PATH="/usr/local/bin:${PATH}"

# Create non-root user
RUN useradd -m -u 1000 hexstrike && chown -R hexstrike:hexstrike /app

# Expose port
EXPOSE 8888

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -f http://127.0.0.1:8888/health || exit 1

# Switch to non-root user
USER hexstrike

# Start command
CMD ["sh", "-c", "Xvfb :99 -screen 0 1024x768x24 & python3 hexstrike_server.py"]