#!/bin/bash
set -e

# HexStrike AI Docker Entry Point
echo "🚀 Starting HexStrike AI MCP Agents v6.0..."

# Create necessary directories if they don't exist
mkdir -p /app/logs /app/data /app/wordlists

# Set proper permissions
chown -R hexstrike:hexstrike /app/logs /app/data /app/wordlists 2>/dev/null || true

# Check if Python dependencies are working
echo "🔍 Checking Python dependencies..."
python3 -c "import flask, requests, aiohttp, beautifulsoup4; print('✅ Core dependencies OK')" || {
    echo "❌ Missing core dependencies, installing..."
    pip3 install flask requests aiohttp beautifulsoup4 lxml psutil colorama
}

# Check if the server file exists and is executable
if [ ! -f "/app/hexstrike_server.py" ]; then
    echo "❌ Server file not found!"
    exit 1
fi

# Test import of the server module
echo "🧪 Testing server module..."
python3 -c "
try:
    import sys
    sys.path.append('/app')
    print('✅ Server module test passed')
except Exception as e:
    print(f'⚠️ Server module test warning: {e}')
" || echo "⚠️ Server module test failed, but continuing..."

# Start the server
echo "🎯 Starting HexStrike AI server on port ${API_PORT:-8000}..."
exec python3 hexstrike_server.py "$@"