# 💰 Expense Tracker Application

A comprehensive expense tracking application with frontend and backend components.

## 🚀 Quick Start

### Frontend
1. Open `index.html` in your browser
2. Start tracking your expenses!

### Backend
1. Run database setup: `./setup-database.sh` (Linux/Mac) or `setup-database.bat` (Windows)
2. Start Spring Boot: `mvn spring-boot:run`
3. Backend will be available at `http://localhost:8080`

## 📁 Project Structure

```
project/
├── Frontend Files
│   ├── index.html              # Main application
│   ├── style.css               # Main styles
│   ├── script.js               # Main JavaScript
│   ├── admin.html              # Admin panel
│   ├── admin-style.css         # Admin styles
│   └── admin-script.js         # Admin JavaScript
│
├── Backend Files
│   ├── src/                    # Java source code
│   ├── pom.xml                 # Maven configuration
│   └── application.properties  # Spring Boot config
│
├── Database Files
│   ├── database-schema.sql     # Database schema
│   ├── sample-data.sql         # Sample data
│   └── expense_tracker.db      # SQLite database
│
├── Scripts
│   ├── setup-database.sh       # Database setup (Linux/Mac)
│   ├── setup-database.bat      # Database setup (Windows)
│   ├── deploy-to-github.sh     # GitHub deployment (Linux/Mac)
│   └── deploy-to-github.bat    # GitHub deployment (Windows)
│
└── Documentation
    ├── README.md               # This file
    ├── README-BACKEND.md       # Backend documentation
    └── GITHUB-PUSH-COMMANDS.md # GitHub commands
```

## 🛠️ Features

- **Transaction Management**: Add, edit, delete expenses and income
- **Category Management**: Organize transactions by categories
- **Balance Tracking**: Monitor your current balance
- **Charts & Analytics**: Visual representation of spending patterns
- **Admin Panel**: Manage categories and view statistics
- **Responsive Design**: Works on desktop and mobile
- **Local Storage**: Data persists in your browser
- **Backend API**: Full REST API for data management

## 🔧 Technology Stack

- **Frontend**: HTML5, CSS3, JavaScript (ES6+), Chart.js
- **Backend**: Java 17, Spring Boot 3.2.0, Spring Data JPA
- **Database**: SQLite
- **Build Tool**: Maven

## 📚 Documentation

- [Backend Documentation](README-BACKEND.md)
- [GitHub Commands](GITHUB-PUSH-COMMANDS.md)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Commit and push
5. Create a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
