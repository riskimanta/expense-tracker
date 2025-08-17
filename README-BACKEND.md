# 🚀 Expense Tracker Backend - Java Spring Boot

Backend API untuk aplikasi Expense Tracker menggunakan Java Spring Boot dengan SQLite database.

## 🛠️ Teknologi yang Digunakan

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Data JPA**
- **Spring Security**
- **SQLite Database**
- **Maven**
- **JWT Authentication**

## 📁 Struktur Project

```
src/main/java/com/expensetracker/
├── ExpenseTrackerApplication.java     # Main class
├── config/
│   └── SecurityConfig.java           # Security configuration
├── controller/
│   └── UserController.java           # REST API endpoints
├── entity/
│   ├── User.java                     # User entity
│   ├── Category.java                 # Category entity
│   └── Transaction.java              # Transaction entity
├── repository/
│   └── UserRepository.java           # Data access layer
└── service/
    └── UserService.java              # Business logic layer

src/main/resources/
├── application.properties            # Application configuration
└── data.sql                         # Initial data
```

## 🚀 Cara Menjalankan

### Prerequisites
- Java 17 atau lebih tinggi
- Maven 3.6+
- IDE (IntelliJ IDEA, Eclipse, atau VS Code)

### Langkah-langkah

1. **Clone project**
   ```bash
   git clone <repository-url>
   cd expense-tracker-backend
   ```

2. **Build project**
   ```bash
   mvn clean install
   ```

3. **Jalankan aplikasi**
   ```bash
   mvn spring-boot:run
   ```

4. **Akses aplikasi**
   - API Base URL: `http://localhost:8080/api`
   - Health Check: `http://localhost:8080/api/actuator/health`
   - Swagger UI: `http://localhost:8080/api/swagger-ui.html`

## 📊 API Endpoints

### Users
- `GET /api/users` - Get all users
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user
- `GET /api/users/role/{role}` - Get users by role
- `GET /api/users/status/{status}` - Get users by status
- `GET /api/users/search?name=&email=` - Search users

### Categories
- `GET /api/categories` - Get all categories
- `GET /api/categories/{id}` - Get category by ID
- `POST /api/categories` - Create new category
- `PUT /api/categories/{id}` - Update category
- `DELETE /api/categories/{id}` - Delete category

### Transactions
- `GET /api/transactions` - Get all transactions
- `GET /api/transactions/{id}` - Get transaction by ID
- `POST /api/transactions` - Create new transaction
- `PUT /api/transactions/{id}` - Update transaction
- `DELETE /api/transactions/{id}` - Delete transaction

## 🗄️ Database Schema

### Users Table
- `id` - Primary key
- `name` - User name
- `email` - Unique email
- `password_hash` - Encrypted password
- `role` - ADMIN or USER
- `status` - ACTIVE or INACTIVE
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

### Categories Table
- `id` - Primary key
- `name` - Category name
- `type` - INCOME or EXPENSE
- `color` - Hex color code
- `icon` - Emoji icon
- `is_default` - Default category flag
- `user_id` - Foreign key to users
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

### Transactions Table
- `id` - Primary key
- `user_id` - Foreign key to users
- `type` - INCOME or EXPENSE
- `amount` - Transaction amount
- `category_id` - Foreign key to categories
- `description` - Transaction description
- `transaction_date` - Transaction date
- `created_at` - Creation timestamp
- `updated_at` - Last update timestamp

## 🔐 Security Features

- **Password Encryption** menggunakan BCrypt
- **CORS Configuration** untuk frontend integration
- **JWT Authentication** (akan diimplementasikan)
- **Role-based Access Control**

## 📝 Sample Data

### Default Users
- **Admin**: `admin@expensetracker.com` / `admin123`
- **User**: `user@expensetracker.com` / `user123`

### Default Categories
- **Income**: Gaji, Freelance, Investasi
- **Expense**: Makanan, Transport, Hiburan, Belanja, Tagihan, Lainnya

## 🔧 Configuration

### Database
- **Type**: SQLite
- **File**: `expense_tracker.db` (auto-generated)
- **DDL**: Auto-create tables

### Server
- **Port**: 8080
- **Context Path**: `/api`
- **CORS**: Enabled for all origins

## 🧪 Testing

```bash
# Run tests
mvn test

# Run with coverage
mvn test jacoco:report
```

## 📦 Build & Deploy

```bash
# Build JAR file
mvn clean package

# Run JAR file
java -jar target/expense-tracker-backend-1.0.0.jar

# Build Docker image
docker build -t expense-tracker-backend .
```

## 🚀 Next Steps

1. **Implement JWT Authentication**
2. **Add Category & Transaction Controllers**
3. **Implement Business Logic Services**
4. **Add Data Validation**
5. **Implement Error Handling**
6. **Add Logging & Monitoring**
7. **Create Unit Tests**
8. **Add API Documentation (Swagger)**

## 📞 Support

Untuk pertanyaan atau bantuan, silakan buat issue di repository atau hubungi tim development.

---

**Happy Coding! 🎉**
