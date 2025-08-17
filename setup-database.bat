@echo off
echo ========================================
echo EXPENSE TRACKER DATABASE SETUP
echo Windows Batch Script
echo ========================================

echo.
echo Creating database and tables...
echo.

REM Check if SQLite is available
sqlite3 --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: SQLite3 is not installed or not in PATH
    echo Please install SQLite3 and add it to your PATH
    echo Download from: https://www.sqlite.org/download.html
    pause
    exit /b 1
)

REM Create database and tables
echo Creating database: expense_tracker.db
sqlite3 expense_tracker.db < database-schema.sql

if %errorlevel% neq 0 (
    echo ERROR: Failed to create database schema
    pause
    exit /b 1
)

echo.
echo Inserting sample data...
sqlite3 expense_tracker.db < sample-data.sql

if %errorlevel% neq 0 (
    echo ERROR: Failed to insert sample data
    pause
    exit /b 1
)

echo.
echo ========================================
echo DATABASE SETUP COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Database file: expense_tracker.db
echo Schema file: database-schema.sql
echo Sample data: sample-data.sql
echo.
echo You can now start the Spring Boot application
echo.
pause
