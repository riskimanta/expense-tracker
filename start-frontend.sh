#!/bin/bash

echo "========================================"
echo "EXPENSE TRACKER - FRONTEND START"
echo "========================================"

echo
echo "Starting frontend application..."
echo

# Check if Python is available for simple HTTP server
if command -v python3 &> /dev/null; then
    echo "Starting Python HTTP server..."
    echo "Frontend will be available at: http://localhost:8000"
    echo "Press Ctrl+C to stop the server"
    echo
    python3 -m http.server 8000
elif command -v python &> /dev/null; then
    echo "Starting Python HTTP server..."
    echo "Frontend will be available at: http://localhost:8000"
    echo "Press Ctrl+C to stop the server"
    echo
    python -m SimpleHTTPServer 8000
elif command -v php &> /dev/null; then
    echo "Starting PHP HTTP server..."
    echo "Frontend will be available at: http://localhost:8000"
    echo "Press Ctrl+C to stop the server"
    echo
    php -S localhost:8000
else
    echo "No HTTP server found. Please open index.html directly in your browser:"
    echo "  - Double-click on index.html"
    echo "  - Or drag index.html to your browser"
    echo
    echo "Alternatively, install a simple HTTP server:"
    echo "  - Python: brew install python (macOS) or sudo apt-get install python3 (Linux)"
    echo "  - PHP: brew install php (macOS) or sudo apt-get install php (Linux)"
    echo
    read -p "Press Enter to continue..."
fi
