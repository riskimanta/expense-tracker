@echo off
echo ========================================
echo EXPENSE TRACKER - GITHUB DEPLOYMENT
echo ========================================

echo.
echo Checking Git status...
git status

echo.
echo Adding all files...
git add .

echo.
set /p commit_message="Enter commit message (or press Enter for default): "

if "%commit_message%"=="" (
    set commit_message=Update expense tracker application
)

echo.
echo Committing changes: %commit_message%
git commit -m "%commit_message%"

echo.
echo Pushing to GitHub...
git push origin main

echo.
echo ========================================
echo DEPLOYMENT COMPLETED SUCCESSFULLY!
echo ========================================
echo.
echo Your changes have been pushed to GitHub
echo.
pause
