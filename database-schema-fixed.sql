-- ========================================
-- EXPENSE TRACKER DATABASE SCHEMA - FIXED VERSION
-- SQLite Database Creation Script
-- ========================================

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- ========================================
-- 1. USERS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT DEFAULT 'USER',
    status TEXT DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- 2. CATEGORIES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    type TEXT NOT NULL,
    color TEXT DEFAULT '#667eea',
    icon TEXT DEFAULT '💰',
    is_default INTEGER DEFAULT 0,
    user_id INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 3. TRANSACTIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    type TEXT NOT NULL,
    amount REAL NOT NULL,
    category_id INTEGER NOT NULL,
    description TEXT,
    transaction_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- ========================================
-- 4. BUDGETS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS budgets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount REAL NOT NULL,
    period TEXT DEFAULT 'MONTHLY',
    start_date DATE NOT NULL,
    end_date DATE,
    is_active INTEGER DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE
);

-- ========================================
-- 5. SETTINGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    setting_key TEXT NOT NULL,
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, setting_key)
);

-- ========================================
-- INDEXES FOR PERFORMANCE
-- ========================================

-- Users indexes
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_role ON users(role);
CREATE INDEX IF NOT EXISTS idx_users_status ON users(status);

-- Categories indexes
CREATE INDEX IF NOT EXISTS idx_categories_user_type ON categories(user_id, type);
CREATE INDEX IF NOT EXISTS idx_categories_name ON categories(name);

-- Transactions indexes
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);

-- Budgets indexes
CREATE INDEX IF NOT EXISTS idx_budgets_user ON budgets(user_id);
CREATE INDEX IF NOT EXISTS idx_budgets_category ON budgets(category_id);
CREATE INDEX IF NOT EXISTS idx_budgets_active ON budgets(is_active);

-- Settings indexes
CREATE INDEX IF NOT EXISTS idx_settings_user_key ON settings(user_id, setting_key);

-- ========================================
-- INSERT DEFAULT DATA
-- ========================================

-- Insert default admin user (password: admin123)
INSERT OR IGNORE INTO users (id, name, email, password_hash, role, status) VALUES 
(1, 'Admin', 'admin@expensetracker.com', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iAt6Z5EHsM8lE9lBOsl7iKTVEFDa', 'ADMIN', 'ACTIVE');

-- Insert default user (password: user123)
INSERT OR IGNORE INTO users (id, name, email, password_hash, role, status) VALUES 
(2, 'User Demo', 'user@expensetracker.com', '$2a$10$8.UnVuG9HHgffUDAlk8qfOuVGkqRzgVymGe07xd00DMxs.AQubh4a', 'USER', 'ACTIVE');

-- Insert default categories
INSERT OR IGNORE INTO categories (id, name, type, color, icon, is_default, user_id) VALUES 
(1, 'Gaji', 'INCOME', '#4CAF50', '💰', 1, 1),
(2, 'Freelance', 'INCOME', '#2196F3', '💼', 1, 1),
(3, 'Investasi', 'INCOME', '#FF9800', '📈', 1, 1),
(4, 'Makanan', 'EXPENSE', '#f44336', '🍔', 1, 1),
(5, 'Transport', 'EXPENSE', '#9C27B0', '🚗', 1, 1),
(6, 'Hiburan', 'EXPENSE', '#E91E63', '🎬', 1, 1),
(7, 'Belanja', 'EXPENSE', '#FF5722', '🛒', 1, 1),
(8, 'Tagihan', 'EXPENSE', '#795548', '📋', 1, 1),
(9, 'Lainnya', 'EXPENSE', '#607D8B', '📦', 1, 1);

-- Insert sample transactions
INSERT OR IGNORE INTO transactions (id, user_id, type, amount, category_id, description, transaction_date) VALUES 
(1, 1, 'INCOME', 5000000.00, 1, 'Gaji bulanan Januari 2024', '2024-01-15'),
(2, 1, 'EXPENSE', 150000.00, 4, 'Makan siang di restoran', '2024-01-16'),
(3, 1, 'EXPENSE', 50000.00, 5, 'Bensin motor', '2024-01-16'),
(4, 1, 'INCOME', 500000.00, 2, 'Project freelance website', '2024-01-17'),
(5, 1, 'EXPENSE', 200000.00, 6, 'Nonton film di bioskop', '2024-01-18');

-- Insert sample budgets
INSERT OR IGNORE INTO budgets (id, user_id, category_id, amount, period, start_date, end_date, is_active) VALUES 
(1, 1, 4, 500000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1),
(2, 1, 5, 200000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1),
(3, 1, 6, 300000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1);

-- Insert default settings
INSERT OR IGNORE INTO settings (user_id, setting_key, setting_value) VALUES 
(1, 'primaryColor', '#667eea'),
(1, 'secondaryColor', '#764ba2'),
(1, 'themeMode', 'light'),
(1, 'chartType', 'pie'),
(1, 'chartAnimation', 'true'),
(1, 'enableNotifications', 'true'),
(1, 'budgetAlerts', 'true'),
(1, 'autoBackup', 'false'),
(1, 'dataRetention', '365');

-- ========================================
-- VERIFICATION QUERIES
-- ========================================

-- Check if tables were created successfully
SELECT 'Tables created successfully' as status;

-- Show table information
SELECT name, sql FROM sqlite_master WHERE type='table' ORDER BY name;

-- Count records in each table
SELECT 'users' as table_name, COUNT(*) as record_count FROM users
UNION ALL
SELECT 'categories', COUNT(*) FROM categories
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'budgets', COUNT(*) FROM budgets
UNION ALL
SELECT 'settings', COUNT(*) FROM settings;

-- Show sample data
SELECT 'Sample Users:' as info;
SELECT id, name, email, role, status FROM users;

SELECT 'Sample Categories:' as info;
SELECT id, name, type, color, icon FROM categories;

SELECT 'Sample Transactions:' as info;
SELECT id, type, amount, description, transaction_date FROM transactions;

SELECT 'Sample Budgets:' as info;
SELECT id, amount, period, start_date, end_date FROM budgets;
