-- ========================================
-- EXPENSE TRACKER DATABASE SCHEMA - SQLITE COMPATIBLE
-- SQLite Database Creation Script
-- ========================================

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- ========================================
-- 1. USERS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    name TEXT NOT NULL,
    password_hash TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('ADMIN', 'USER')),
    status TEXT NOT NULL CHECK (status IN ('ACTIVE', 'INACTIVE')),
    updated_at TEXT
);

-- ========================================
-- 2. CATEGORIES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    color TEXT,
    created_at TEXT NOT NULL,
    icon TEXT,
    is_default INTEGER DEFAULT 0,
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    updated_at TEXT,
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 3. TRANSACTIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS transactions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    amount REAL NOT NULL,
    created_at TEXT NOT NULL,
    description TEXT,
    transaction_date TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    updated_at TEXT,
    category_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 4. BUDGETS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS budgets (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    amount REAL NOT NULL,
    created_at TEXT NOT NULL,
    end_date TEXT,
    is_active INTEGER NOT NULL DEFAULT 1,
    period TEXT NOT NULL CHECK (period IN ('DAILY','WEEKLY','MONTHLY','YEARLY')),
    start_date TEXT NOT NULL,
    updated_at TEXT NOT NULL,
    category_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 5. SETTINGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS settings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    created_at TEXT NOT NULL,
    setting_key TEXT NOT NULL,
    setting_value TEXT,
    updated_at TEXT NOT NULL,
    user_id INTEGER NOT NULL,
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
INSERT OR IGNORE INTO users (id, name, email, password_hash, role, status, created_at, updated_at) VALUES 
(1, 'Admin', 'admin@expensetracker.com', 'admin123', 'ADMIN', 'ACTIVE', datetime('now'), datetime('now'));

-- Insert default user (password: user123)
INSERT OR IGNORE INTO users (id, name, email, password_hash, role, status, created_at, updated_at) VALUES 
(2, 'User Demo', 'user@expensetracker.com', 'user123', 'USER', 'ACTIVE', datetime('now'), datetime('now'));

-- Insert default categories
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
