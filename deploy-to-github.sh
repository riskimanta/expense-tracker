#!/bin/bash

echo "========================================"
echo "EXPENSE TRACKER - GITHUB DEPLOYMENT"
echo "========================================"

echo
echo "Checking Git status..."
git status

echo
echo "Adding all files..."
git add .

echo
echo "Enter commit message:"
read commit_message

if [ -z "$commit_message" ]; then
    commit_message="Update expense tracker application"
fi

echo
echo "Committing changes: $commit_message"
git commit -m "$commit_message"

echo
echo "Pushing to GitHub..."
git push origin main

echo
echo "========================================"
echo "DEPLOYMENT COMPLETED SUCCESSFULLY!"
echo "========================================"
echo
echo "Your changes have been pushed to GitHub"
echo "Repository: $(git remote get-url origin)"
echo
