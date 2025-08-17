#!/bin/bash

echo "========================================"
echo "EXPENSE TRACKER DATABASE SETUP"
echo "Linux/Mac Shell Script"
echo "========================================"

echo
echo "Creating database and tables..."
echo

# Check if SQLite is available
if ! command -v sqlite3 &> /dev/null; then
    echo "ERROR: SQLite3 is not installed"
    echo "Please install SQLite3:"
    echo "  Ubuntu/Debian: sudo apt-get install sqlite3"
    echo "  CentOS/RHEL: sudo yum install sqlite3"
    echo "  macOS: brew install sqlite3"
    exit 1
fi

# Create database and tables
echo "Creating database: expense_tracker.db"
sqlite3 expense_tracker.db < database-schema.sql

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to create database schema"
    exit 1
fi

echo
echo "Inserting sample data..."
sqlite3 expense_tracker.db < sample-data.sql

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to insert sample data"
    exit 1
fi

echo
echo "========================================"
echo "DATABASE SETUP COMPLETED SUCCESSFULLY!"
echo "========================================"
echo
echo "Database file: expense_tracker.db"
echo "Schema file: database-schema.sql"
echo "Sample data: sample-data.sql"
echo
echo "You can now start the Spring Boot application"
echo
