# 🚀 GitHub Deployment Commands

This document provides step-by-step instructions for deploying your Expense Tracker application to GitHub.

## 📋 Prerequisites

- Git installed on your system
- GitHub account
- Repository created on GitHub
- SSH key or Personal Access Token configured

## 🔧 Setup Commands

### 1. Initialize Git Repository (First Time Only)

```bash
# Navigate to your project directory
cd /path/to/your/project

# Initialize Git repository
git init

# Add remote origin (replace with your GitHub repo URL)
git remote add origin https://github.com/yourusername/expense-tracker.git

# Or if using SSH
git remote add origin git@github.com:yourusername/expense-tracker.git
```

### 2. Configure Git (First Time Only)

```bash
# Set your name and email
git config user.name "Your Name"
git config user.email "your.email@example.com"

# Set default branch to main
git branch -M main
```

## 🚀 Deployment Commands

### Option 1: Manual Commands

```bash
# Check current status
git status

# Add all files
git add .

# Commit changes
git commit -m "Update expense tracker application"

# Push to GitHub
git push origin main
```

### Option 2: Using Scripts (Recommended)

#### For Linux/Mac:
```bash
# Make script executable
chmod +x deploy-to-github.sh

# Run deployment script
./deploy-to-github.sh
```

#### For Windows:
```cmd
# Run deployment script
deploy-to-github.bat
```

## 📁 Files to Include in Git

### ✅ Include These Files:
- `index.html`
- `style.css`
- `script.js`
- `admin.html`
- `admin-style.css`
- `admin-script.js`
- `src/` (Java backend code)
- `pom.xml`
- `application.properties`
- `database-schema.sql`
- `sample-data.sql`
- `README.md`
- `README-BACKEND.md`
- `GITHUB-PUSH-COMMANDS.md`

### ❌ Don't Include These Files:
- `expense_tracker.db` (database file)
- `target/` (compiled Java classes)
- `.DS_Store` (macOS system files)
- `*.log` (log files)
- IDE-specific files

## 🔒 .gitignore Configuration

Make sure your `.gitignore` file includes:

```gitignore
# Database
*.db
*.sqlite
*.sqlite3

# Java
target/
*.class
*.jar

# IDE
.vscode/
.idea/
*.iml

# System
.DS_Store
Thumbs.db

# Logs
*.log

# Environment
.env
application-local.properties
```

## 🚨 Troubleshooting

### Error: "fatal: remote origin already exists"
```bash
# Remove existing remote
git remote remove origin

# Add new remote
git remote add origin https://github.com/yourusername/expense-tracker.git
```

### Error: "fatal: refusing to merge unrelated histories"
```bash
# Force merge (use with caution)
git pull origin main --allow-unrelated-histories
```

### Error: "Permission denied (publickey)"
```bash
# Check SSH key
ssh -T git@github.com

# Generate new SSH key if needed
ssh-keygen -t ed25519 -C "your.email@example.com"
```

## 📚 Additional Resources

- [GitHub SSH Setup](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [GitHub Personal Access Tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)

## 🎯 Best Practices

1. **Commit Frequently**: Make small, focused commits
2. **Use Descriptive Messages**: Write clear commit messages
3. **Test Before Pushing**: Ensure your code works locally
4. **Review Changes**: Use `git diff` to review before committing
5. **Keep Branches Clean**: Delete feature branches after merging

## 🆘 Need Help?

If you encounter issues:

1. Check the error message carefully
2. Search for solutions on Stack Overflow
3. Check GitHub's documentation
4. Ask for help in the project's Issues section

---

**Happy Coding! 🚀**
