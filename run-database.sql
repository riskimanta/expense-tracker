-- ========================================
-- EXPENSE TRACKER DATABASE RUNNER
-- Jalankan script ini untuk membuat database
-- ========================================

-- Baca dan jalankan schema utama
.read database-schema.sql

-- Tampilkan status database
SELECT 'Database berhasil dibuat!' as status;
SELECT datetime('now') as created_at;

-- Tampilkan semua tabel yang dibuat
SELECT name as table_name, 'TABLE' as type FROM sqlite_master WHERE type='table'
UNION ALL
SELECT name as table_name, 'VIEW' as type FROM sqlite_master WHERE type='view'
ORDER BY type, name;

-- Tampilkan jumlah record di setiap tabel
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'settings', COUNT(*) FROM settings
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL
SELECT 'audit_logs', COUNT(*) FROM audit_logs
UNION ALL
SELECT 'notifications', COUNT(*) FROM notifications
UNION ALL
SELECT 'export_history', COUNT(*) FROM export_history;
