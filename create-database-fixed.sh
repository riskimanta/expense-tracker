#!/bin/bash

echo "========================================"
echo "EXPENSE TRACKER DATABASE CREATOR - FIXED"
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

# Remove old database if exists
if [ -f "expense_tracker.db" ]; then
    echo "Menghapus database lama..."
    rm expense_tracker.db
fi

# Create database with fixed schema
echo "Membuat database dengan schema yang diperbaiki..."
sqlite3 expense_tracker.db < database-schema-fixed.sql

if [ $? -eq 0 ]; then
    echo
    echo "========================================"
    echo "Database berhasil dibuat!"
    echo "File: expense_tracker.db"
    echo "========================================"
    echo
    echo "Verifikasi database..."
    echo
    
    # Verify database
    sqlite3 expense_tracker.db "SELECT 'Database verification:' as info; SELECT 'users' as table_name, COUNT(*) as record_count FROM users UNION ALL SELECT 'categories', COUNT(*) FROM categories UNION ALL SELECT 'transactions', COUNT(*) FROM transactions UNION ALL SELECT 'budgets', COUNT(*) FROM budgets UNION ALL SELECT 'settings', COUNT(*) FROM settings;"
    
    echo
    echo "========================================"
    echo "Database siap digunakan!"
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
    echo "SELECT * FROM budgets;"
    echo
else
    echo
    echo "ERROR: Gagal membuat database!"
    echo "Periksa file SQL dan coba lagi"
    exit 1
fi
