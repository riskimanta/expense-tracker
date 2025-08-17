# 🗄️ Database Setup - Expense Tracker

Dokumentasi lengkap untuk setup database SQLite untuk aplikasi Expense Tracker.

## 📋 Daftar Tabel

### 1. **users** - Manajemen User
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `name` | TEXT | Nama user (2-100 karakter) |
| `email` | TEXT | Email unik |
| `password_hash` | TEXT | Password terenkripsi |
| `role` | TEXT | ADMIN atau USER |
| `status` | TEXT | ACTIVE atau INACTIVE |
| `created_at` | TIMESTAMP | Waktu pembuatan |
| `updated_at` | TIMESTAMP | Waktu update terakhir |

### 2. **categories** - Kategori Transaksi
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `name` | TEXT | Nama kategori |
| `type` | TEXT | INCOME atau EXPENSE |
| `color` | TEXT | Kode warna hex |
| `icon` | TEXT | Emoji icon |
| `is_default` | BOOLEAN | Kategori default |
| `user_id` | INTEGER | Foreign key ke users |
| `created_at` | TIMESTAMP | Waktu pembuatan |
| `updated_at` | TIMESTAMP | Waktu update terakhir |

### 3. **transactions** - Transaksi Keuangan
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `user_id` | INTEGER | Foreign key ke users |
| `type` | TEXT | INCOME atau EXPENSE |
| `amount` | REAL | Jumlah transaksi |
| `category_id` | INTEGER | Foreign key ke categories |
| `description` | TEXT | Deskripsi transaksi |
| `transaction_date` | DATE | Tanggal transaksi |
| `created_at` | TIMESTAMP | Waktu pembuatan |
| `updated_at` | TIMESTAMP | Waktu update terakhir |

### 4. **budgets** - Budget per Kategori
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `user_id` | INTEGER | Foreign key ke users |
| `category_id` | INTEGER | Foreign key ke categories |
| `amount` | REAL | Jumlah budget |
| `period` | TEXT | Periode (DAILY/WEEKLY/MONTHLY/YEARLY) |
| `start_date` | DATE | Tanggal mulai |
| `end_date` | DATE | Tanggal berakhir |
| `is_active` | BOOLEAN | Status aktif |
| `created_at` | TIMESTAMP | Waktu pembuatan |
| `updated_at` | TIMESTAMP | Waktu update terakhir |

### 5. **settings** - Pengaturan Aplikasi
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `user_id` | INTEGER | Foreign key ke users |
| `setting_key` | TEXT | Kunci pengaturan |
| `setting_value` | TEXT | Nilai pengaturan |
| `created_at` | TIMESTAMP | Waktu pembuatan |
| `updated_at` | TIMESTAMP | Waktu update terakhir |

### 6. **audit_logs** - Log Perubahan Data
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `user_id` | INTEGER | Foreign key ke users |
| `action` | TEXT | Jenis aksi |
| `table_name` | TEXT | Nama tabel yang diubah |
| `record_id` | INTEGER | ID record yang diubah |
| `old_values` | TEXT | Nilai lama (JSON) |
| `new_values` | TEXT | Nilai baru (JSON) |
| `ip_address` | TEXT | IP address user |
| `user_agent` | TEXT | User agent browser |
| `created_at` | TIMESTAMP | Waktu log |

### 7. **notifications** - Notifikasi User
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `user_id` | INTEGER | Foreign key ke users |
| `title` | TEXT | Judul notifikasi |
| `message` | TEXT | Pesan notifikasi |
| `type` | TEXT | Tipe (INFO/WARNING/ERROR/SUCCESS) |
| `is_read` | BOOLEAN | Status dibaca |
| `created_at` | TIMESTAMP | Waktu pembuatan |

### 8. **export_history** - Riwayat Export Data
| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | INTEGER | Primary Key, Auto Increment |
| `user_id` | INTEGER | Foreign key ke users |
| `export_type` | TEXT | Jenis export |
| `file_name` | TEXT | Nama file |
| `file_size` | INTEGER | Ukuran file |
| `export_date` | TIMESTAMP | Waktu export |

## 🔗 Relasi Antar Tabel

```
users (1) ←→ (N) categories
users (1) ←→ (N) transactions
users (1) ←→ (N) budgets
users (1) ←→ (N) settings
users (1) ←→ (N) audit_logs
users (1) ←→ (N) notifications
users (1) ←→ (N) export_history

categories (1) ←→ (N) transactions
categories (1) ←→ (N) budgets
```

## 📊 Views yang Tersedia

### 1. **transaction_summary**
- Ringkasan transaksi per user dan tipe
- Count, total, rata-rata, min, max

### 2. **category_summary**
- Ringkasan kategori dengan total transaksi
- Total income, expense, dan net amount

### 3. **monthly_summary**
- Ringkasan transaksi per bulan
- Statistik bulanan

### 4. **budget_vs_actual**
- Perbandingan budget vs realisasi
- Status budget (OVER/ON/UNDER)

## 🚀 Cara Setup Database

### Prerequisites
- SQLite3 installed
- File `database-schema.sql` tersedia

### Method 1: Command Line
```bash
# Buat database baru
sqlite3 expense_tracker.db < database-schema.sql

# Atau gunakan script runner
sqlite3 expense_tracker.db < run-database.sql
```

### Method 2: Windows Batch File
```cmd
# Double click file
create-database.bat
```

### Method 3: Linux/Mac Shell Script
```bash
# Beri permission execute
chmod +x create-database.sh

# Jalankan script
./create-database.sh
```

## 🔍 Verifikasi Database

### 1. **Buka Database**
```bash
sqlite3 expense_tracker.db
```

### 2. **Lihat Struktur Tabel**
```sql
.schema
```

### 3. **Lihat Semua Tabel**
```sql
.tables
```

### 4. **Lihat Views**
```sql
SELECT name FROM sqlite_master WHERE type='view';
```

### 5. **Cek Data Sample**
```sql
SELECT * FROM users;
SELECT * FROM categories;
SELECT * FROM transactions;
```

### 6. **Test Views**
```sql
SELECT * FROM transaction_summary;
SELECT * FROM category_summary;
SELECT * FROM monthly_summary;
```

## 🛠️ Maintenance Database

### 1. **Backup Database**
```bash
sqlite3 expense_tracker.db ".backup backup_$(date +%Y%m%d_%H%M%S).db"
```

### 2. **Restore Database**
```bash
sqlite3 expense_tracker.db ".restore backup_file.db"
```

### 3. **Optimize Database**
```sql
VACUUM;
ANALYZE;
```

### 4. **Check Database Integrity**
```sql
PRAGMA integrity_check;
```

## 📝 Sample Queries

### 1. **User dengan Transaksi Terbanyak**
```sql
SELECT u.name, COUNT(t.id) as transaction_count
FROM users u
JOIN transactions t ON u.id = t.user_id
GROUP BY u.id, u.name
ORDER BY transaction_count DESC;
```

### 2. **Kategori dengan Pengeluaran Terbesar**
```sql
SELECT c.name, SUM(t.amount) as total_expense
FROM categories c
JOIN transactions t ON c.id = t.category_id
WHERE t.type = 'EXPENSE'
GROUP BY c.id, c.name
ORDER BY total_expense DESC;
```

### 3. **Transaksi Bulan Ini**
```sql
SELECT t.*, c.name as category_name
FROM transactions t
JOIN categories c ON t.category_id = c.id
WHERE strftime('%Y-%m', t.transaction_date) = strftime('%Y-%m', 'now');
```

### 4. **Budget Status**
```sql
SELECT * FROM budget_vs_actual
WHERE budget_status = 'OVER_BUDGET';
```

## ⚠️ Troubleshooting

### 1. **Foreign Key Error**
```sql
PRAGMA foreign_keys = ON;
```

### 2. **Table Already Exists**
```sql
DROP TABLE IF EXISTS table_name;
```

### 3. **Permission Denied**
- Pastikan folder memiliki permission write
- Gunakan path absolut jika diperlukan

### 4. **Database Locked**
- Tutup semua koneksi ke database
- Restart aplikasi jika menggunakan Spring Boot

## 🔐 Security Considerations

1. **Password Hashing**: Semua password di-hash dengan BCrypt
2. **Input Validation**: Check constraints pada semua kolom
3. **SQL Injection**: Gunakan prepared statements
4. **Access Control**: Role-based permissions
5. **Audit Logging**: Semua perubahan di-log

## 📚 Referensi

- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Data Types](https://www.sqlite.org/datatype3.html)
- [SQLite Constraints](https://www.sqlite.org/lang_createtable.html#constraints)
- [SQLite Triggers](https://www.sqlite.org/lang_createtrigger.html)

---

**Database siap digunakan! 🎉**
