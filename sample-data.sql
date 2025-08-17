-- ========================================
-- SAMPLE DATA FOR EXPENSE TRACKER
-- Matches clean database schema
-- ========================================

-- Sample Users
INSERT OR IGNORE INTO users (name, email, password_hash, role, status) VALUES
('Administrator', 'admin@example.com', '$2a$10$rQZ8K8K8K8K8K8K8K8K8O', 'ADMIN', 'ACTIVE'),
('John Doe', 'user1@example.com', '$2a$10$rQZ8K8K8K8K8K8K8K8K8O', 'USER', 'ACTIVE');

-- Sample Categories
INSERT OR IGNORE INTO categories (name, type, color, icon, is_default, user_id) VALUES
('Makanan & Minuman', 'EXPENSE', '#FF6384', '🍔', 1, NULL),
('Transportasi', 'EXPENSE', '#36A2EB', '🚗', 1, NULL),
('Belanja', 'EXPENSE', '#FFCE56', '🛍️', 1, NULL),
('Hiburan', 'EXPENSE', '#4BC0C0', '🎬', 1, NULL),
('Gaji', 'INCOME', '#9966FF', '💰', 1, NULL),
('Bonus', 'INCOME', '#FF9F40', '🎁', 1, NULL);

-- Sample Transactions (format: YYYY-MM-DD)
INSERT OR IGNORE INTO transactions (user_id, type, amount, category_id, description, transaction_date) VALUES
(1, 'EXPENSE', 50000.0, 1, 'Makan siang', '2025-08-17'),
(1, 'EXPENSE', 25000.0, 2, 'Bensin motor', '2025-08-17'),
(1, 'INCOME', 5000000.0, 5, 'Gaji bulanan', '2025-08-01');

-- Sample Budgets
INSERT OR IGNORE INTO budgets (user_id, category_id, amount, period, start_date, end_date, is_active) VALUES
(1, 1, 1000000.0, 'MONTHLY', '2025-08-01', '2025-08-31', 1),
(1, 2, 500000.0, 'MONTHLY', '2025-08-01', '2025-08-31', 1);

-- Sample Settings
INSERT OR IGNORE INTO settings (user_id, setting_key, setting_value) VALUES
(1, 'currency', 'IDR'),
(1, 'language', 'id'),
(1, 'theme', 'light');
