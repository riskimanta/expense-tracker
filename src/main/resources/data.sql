-- ========================================
-- EXPENSE TRACKER INITIAL DATA
-- ========================================

-- Insert default admin user (password: admin123)
INSERT INTO users (name, email, password_hash, role, status, created_at, updated_at) VALUES 
('Admin', 'admin@expensetracker.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'ADMIN', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert default user (password: user123)
INSERT INTO users (name, email, password_hash, role, status, created_at, updated_at) VALUES 
('User Demo', 'user@expensetracker.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'USER', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert default categories
INSERT INTO categories (name, type, color, icon, is_default, user_id, created_at, updated_at) VALUES 
('Gaji', 'INCOME', '#4CAF50', '💰', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Freelance', 'INCOME', '#2196F3', '💼', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Investasi', 'INCOME', '#FF9800', '📈', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Makanan', 'EXPENSE', '#f44336', '🍔', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Transport', 'EXPENSE', '#9C27B0', '🚗', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Hiburan', 'EXPENSE', '#E91E63', '🎬', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Belanja', 'EXPENSE', '#FF5722', '🛒', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Tagihan', 'EXPENSE', '#795548', '📋', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
('Lainnya', 'EXPENSE', '#607D8B', '📦', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert sample transactions
INSERT INTO transactions (user_id, type, amount, category_id, description, transaction_date, created_at, updated_at) VALUES 
(1, 'INCOME', 5000000.00, 1, 'Gaji bulanan Januari 2024', '2024-01-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'EXPENSE', 150000.00, 4, 'Makan siang di restoran', '2024-01-16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'EXPENSE', 50000.00, 5, 'Bensin motor', '2024-01-16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'INCOME', 500000.00, 2, 'Project freelance website', '2024-01-17', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'EXPENSE', 200000.00, 6, 'Nonton film di bioskop', '2024-01-18', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert default settings
INSERT INTO settings (user_id, setting_key, setting_value, created_at, updated_at) VALUES 
(1, 'primaryColor', '#667eea', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'secondaryColor', '#764ba2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'themeMode', 'light', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'chartType', 'pie', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'chartAnimation', 'true', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'enableNotifications', 'true', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'budgetAlerts', 'true', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'autoBackup', 'false', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'dataRetention', '365', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
