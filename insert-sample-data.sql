-- ========================================
-- INSERT SAMPLE DATA WITH CORRECT TIMESTAMPS
-- ========================================

PRAGMA foreign_keys = ON;

-- Insert users
INSERT OR IGNORE INTO users (id, name, email, password_hash, role, status, created_at, updated_at) VALUES 
(1, 'Admin', 'admin@expensetracker.com', 'admin123', 'ADMIN', 'ACTIVE', datetime('now'), datetime('now')),
(2, 'User Demo', 'user@expensetracker.com', 'user123', 'USER', 'ACTIVE', datetime('now'), datetime('now'));

-- Insert categories
INSERT OR IGNORE INTO categories (id, name, type, color, icon, is_default, user_id, created_at, updated_at) VALUES 
(1, 'Gaji', 'INCOME', '#4CAF50', '💰', 1, 1, datetime('now'), datetime('now')),
(2, 'Freelance', 'INCOME', '#2196F3', '💼', 1, 1, datetime('now'), datetime('now')),
(3, 'Investasi', 'INCOME', '#FF9800', '📈', 1, 1, datetime('now'), datetime('now')),
(4, 'Makanan', 'EXPENSE', '#f44336', '🍔', 1, 1, datetime('now'), datetime('now')),
(5, 'Transport', 'EXPENSE', '#9C27B0', '🚗', 1, 1, datetime('now'), datetime('now')),
(6, 'Hiburan', 'EXPENSE', '#E91E63', '🎬', 1, 1, datetime('now'), datetime('now')),
(7, 'Belanja', 'EXPENSE', '#FF5722', '🛒', 1, 1, datetime('now'), datetime('now')),
(8, 'Tagihan', 'EXPENSE', '#795548', '📋', 1, 1, datetime('now'), datetime('now')),
(9, 'Lainnya', 'EXPENSE', '#607D8B', '📦', 1, 1, datetime('now'), datetime('now'));

-- Insert sample transactions
INSERT OR IGNORE INTO transactions (id, user_id, type, amount, category_id, description, transaction_date, created_at, updated_at) VALUES 
(1, 1, 'INCOME', 5000000.00, 1, 'Gaji bulanan Januari 2024', '2024-01-15', datetime('now'), datetime('now')),
(2, 1, 'EXPENSE', 150000.00, 4, 'Makan siang di restoran', '2024-01-16', datetime('now'), datetime('now')),
(3, 1, 'EXPENSE', 50000.00, 5, 'Bensin motor', '2024-01-16', datetime('now'), datetime('now')),
(4, 1, 'INCOME', 500000.00, 2, 'Project freelance website', '2024-01-17', datetime('now'), datetime('now')),
(5, 1, 'EXPENSE', 200000.00, 6, 'Nonton film di bioskop', '2024-01-18', datetime('now'), datetime('now'));

-- Insert sample budgets
INSERT OR IGNORE INTO budgets (id, user_id, category_id, amount, period, start_date, end_date, is_active, created_at, updated_at) VALUES 
(1, 1, 4, 500000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1, datetime('now'), datetime('now')),
(2, 1, 5, 200000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1, datetime('now'), datetime('now')),
(3, 1, 6, 300000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1, datetime('now'), datetime('now'));

-- Insert default settings
INSERT OR IGNORE INTO settings (user_id, setting_key, setting_value, created_at, updated_at) VALUES 
(1, 'primaryColor', '#667eea', datetime('now'), datetime('now')),
(1, 'secondaryColor', '#764ba2', datetime('now'), datetime('now')),
(1, 'themeMode', 'light', datetime('now'), datetime('now')),
(1, 'chartType', 'pie', datetime('now'), datetime('now')),
(1, 'chartAnimation', 'true', datetime('now'), datetime('now')),
(1, 'enableNotifications', 'true', datetime('now'), datetime('now')),
(1, 'budgetAlerts', 'true', datetime('now'), datetime('now')),
(1, 'autoBackup', 'false', datetime('now'), datetime('now')),
(1, 'dataRetention', '365', datetime('now'), datetime('now'));

-- Verification
SELECT 'Data inserted successfully!' as status;
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL
SELECT 'settings', COUNT(*) FROM settings;
