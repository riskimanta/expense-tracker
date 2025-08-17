# 🗄️ Database Commands - Expense Tracker

Panduan lengkap untuk membuat dan mengelola database SQLite.

## 🚀 Cara Membuat Database

### **Method 1: Script Otomatis (Recommended)**

#### **Windows:**
```cmd
# Double click file
create-database-fixed.bat
```

#### **Linux/Mac:**
```bash
chmod +x create-database-fixed.sh
./create-database-fixed.sh
```

### **Method 2: Command Manual**

```bash
# Buat database baru
sqlite3 expense_tracker.db < database-schema-fixed.sql

# Verifikasi database
sqlite3 expense_tracker.db ".tables"
sqlite3 expense_tracker.db "SELECT COUNT(*) FROM users;"
```

## 🔧 Troubleshooting Database

### **Error: "no such table: budgets"**
**Solusi**: Gunakan file `database-schema-fixed.sql` yang sudah diperbaiki

### **Error: "no such table: settings"**
**Solusi**: Pastikan semua tabel dibuat dengan benar

### **Error: "foreign key constraint failed"**
**Solusi**: Hapus database lama dan buat ulang

```bash
# Hapus database lama
rm expense_tracker.db  # Linux/Mac
del expense_tracker.db # Windows

# Buat database baru
sqlite3 expense_tracker.db < database-schema-fixed.sql
```

## 📊 Verifikasi Database

### **1. Buka Database**
```bash
sqlite3 expense_tracker.db
```

### **2. Lihat Semua Tabel**
```sql
.tables
```

### **3. Lihat Struktur Tabel**
```sql
.schema users
.schema categories
.schema transactions
.schema settings
```

### **4. Cek Jumlah Record**
```sql
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'settings', COUNT(*) FROM settings;
```

### **5. Lihat Sample Data**
```sql
-- Users
SELECT * FROM users;

-- Categories
SELECT * FROM categories;

-- Transactions
SELECT * FROM transactions;

-- Settings
SELECT * FROM settings;
```

## 🎯 Database yang Akan Dibuat

### **4 Tabel Utama:**
1. **`users`** - 2 records (admin + demo user)
2. **`categories`** - 9 records (3 income + 6 expense)
3. **`transactions`** - 5 sample records
4. **`settings`** - 9 default settings

### **Data Sample:**
- **Admin**: `admin@expensetracker.com` / `admin123`
- **User**: `user@expensetracker.com` / `user123`
- **Kategori**: Gaji, Freelance, Investasi, Makanan, Transport, dll
- **Transaksi**: Sample income dan expense
- **Pengaturan**: Theme, chart type, notifications

## 🔍 Test Database

### **1. Test Foreign Key Constraints**
```sql
-- Test insert transaction dengan user dan category yang valid
INSERT INTO transactions (user_id, type, amount, category_id, description, transaction_date)
VALUES (1, 'EXPENSE', 100000, 4, 'Test transaction', date('now'));

-- Test insert dengan user_id yang tidak valid (harus error)
INSERT INTO transactions (user_id, type, amount, category_id, description, transaction_date)
VALUES (999, 'EXPENSE', 100000, 4, 'Invalid user', date('now'));
```

### **2. Test Unique Constraints**
```sql
-- Test insert user dengan email yang sudah ada (harus error)
INSERT INTO users (name, email, password_hash) 
VALUES ('Test User', 'admin@expensetracker.com', 'password123');
```

### **3. Test Check Constraints**
```sql
-- Test insert transaction dengan amount negatif (harus error)
INSERT INTO transactions (user_id, type, amount, category_id, description, transaction_date)
VALUES (1, 'EXPENSE', -100000, 4, 'Negative amount', date('now'));
```

## 🛠️ Maintenance Database

### **1. Backup Database**
```bash
sqlite3 expense_tracker.db ".backup backup_$(date +%Y%m%d_%H%M%S).db"
```

### **2. Restore Database**
```bash
sqlite3 expense_tracker.db ".restore backup_file.db"
```

### **3. Optimize Database**
```sql
VACUUM;
ANALYZE;
```

### **4. Check Integrity**
```sql
PRAGMA integrity_check;
```

## 📝 Sample Queries

### **1. User dengan Transaksi Terbanyak**
```sql
SELECT u.name, COUNT(t.id) as transaction_count
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.name
ORDER BY transaction_count DESC;
```

### **2. Kategori dengan Pengeluaran Terbesar**
```sql
SELECT c.name, SUM(t.amount) as total_expense
FROM categories c
JOIN transactions t ON c.id = t.category_id
WHERE t.type = 'EXPENSE'
GROUP BY c.id, c.name
ORDER BY total_expense DESC;
```

### **3. Transaksi Bulan Ini**
```sql
SELECT t.*, c.name as category_name
FROM transactions t
JOIN categories c ON t.category_id = c.id
WHERE strftime('%Y-%m', t.transaction_date) = strftime('%Y-%m', 'now');
```

### **4. Total Income vs Expense**
```sql
SELECT 
    SUM(CASE WHEN type = 'INCOME' THEN amount ELSE 0 END) as total_income,
    SUM(CASE WHEN type = 'EXPENSE' THEN amount ELSE 0 END) as total_expense,
    SUM(CASE WHEN type = 'INCOME' THEN amount ELSE -amount END) as net_amount
FROM transactions;
```

## ⚠️ Common Issues & Solutions

### **Issue 1: Database Locked**
```bash
# Tutup semua koneksi
# Restart aplikasi jika menggunakan Spring Boot
```

### **Issue 2: Permission Denied**
```bash
# Pastikan folder memiliki permission write
# Gunakan path absolut jika diperlukan
```

### **Issue 3: Foreign Key Error**
```sql
-- Pastikan foreign key constraints enabled
PRAGMA foreign_keys = ON;
```

### **Issue 4: Table Already Exists**
```sql
-- Drop table jika perlu
DROP TABLE IF EXISTS table_name;
```

## 🎉 Setelah Database Berhasil Dibuat

1. **Verifikasi semua tabel ada**
2. **Cek jumlah record di setiap tabel**
3. **Test beberapa query sample**
4. **Jalankan backend Java Spring Boot**
5. **Test API endpoints**

---

**Database siap digunakan! 🎯**
