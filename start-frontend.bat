@echo off
echo ========================================
echo EXPENSE TRACKER - FRONTEND START
echo ========================================

echo.
echo Starting frontend application...
echo.

REM Check if Python is available
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Starting Python HTTP server...
    echo Frontend will be available at: http://localhost:8000
    echo Press Ctrl+C to stop the server
    echo.
    python -m http.server 8000
    goto :end
)

REM Check if Python3 is available
python3 --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Starting Python3 HTTP server...
    echo Frontend will be available at: http://localhost:8000
    echo Press Ctrl+C to stop the server
    echo.
    python3 -m http.server 8000
    goto :end
)

REM Check if PHP is available
php --version >nul 2>&1
if %errorlevel% equ 0 (
    echo Starting PHP HTTP server...
    echo Frontend will be available at: http://localhost:8000
    echo Press Ctrl+C to stop the server
    echo.
    php -S localhost:8000
    goto :end
)

echo No HTTP server found. Please open index.html directly in your browser:
echo   - Double-click on index.html
echo   - Or drag index.html to your browser
echo.
echo Alternatively, install a simple HTTP server:
echo   - Python: Download from https://www.python.org/downloads/
echo   - PHP: Download from https://windows.php.net/download/
echo.
pause

:end
