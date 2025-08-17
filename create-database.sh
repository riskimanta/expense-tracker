#!/bin/bash

echo "========================================"
echo "EXPENSE TRACKER DATABASE CREATOR"
echo "========================================"
echo

# Check if SQLite is installed
if ! command -v sqlite3 &> /dev/null; then
    echo "ERROR: SQLite3 tidak ditemukan!"
    echo "Silakan install SQLite3 terlebih dahulu"
    echo "Ubuntu/Debian: sudo apt-get install sqlite3"
    echo "CentOS/RHEL: sudo yum install sqlite3"
    echo "macOS: brew install sqlite3"
    exit 1
fi

echo "SQLite3 ditemukan, membuat database..."
echo

# Create database
sqlite3 expense_tracker.db < run-database.sql

if [ $? -eq 0 ]; then
    echo
    echo "========================================"
    echo "Database berhasil dibuat!"
    echo "File: expense_tracker.db"
    echo "========================================"
    echo
    echo "Untuk membuka database:"
    echo "sqlite3 expense_tracker.db"
    echo
    echo "Untuk melihat struktur tabel:"
    echo ".schema"
    echo
    echo "Untuk melihat data:"
    echo "SELECT * FROM users;"
    echo "SELECT * FROM categories;"
    echo "SELECT * FROM transactions;"
    echo
else
    echo
    echo "ERROR: Gagal membuat database!"
    echo "Periksa file SQL dan coba lagi"
    exit 1
fi
