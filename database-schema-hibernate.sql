-- ========================================
-- EXPENSE TRACKER DATABASE SCHEMA - HIBERNATE COMPATIBLE
-- SQLite Database Creation Script
-- ========================================

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- ========================================
-- 1. USERS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(255) NOT NULL CHECK (role IN ('ADMIN', 'USER')),
    status VARCHAR(255) NOT NULL CHECK (status IN ('ACTIVE', 'INACTIVE')),
    updated_at TIMESTAMP
);

-- ========================================
-- 2. CATEGORIES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS categories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    color VARCHAR(7),
    created_at TIMESTAMP NOT NULL,
    icon VARCHAR(10),
    is_default BOOLEAN,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(255) NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    updated_at TIMESTAMP,
    user_id BIGINT,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 3. TRANSACTIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS transactions (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    amount NUMERIC(15,2) NOT NULL,
    created_at TIMESTAMP NOT NULL,
    description TEXT,
    transaction_date DATE NOT NULL,
    type VARCHAR(255) NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    updated_at TIMESTAMP,
    category_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 4. BUDGETS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS budgets (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    amount FLOAT NOT NULL,
    created_at TIMESTAMP NOT NULL,
    end_date DATE,
    is_active BOOLEAN NOT NULL,
    period VARCHAR(255) NOT NULL CHECK (period IN ('DAILY','WEEKLY','MONTHLY','YEARLY')),
    start_date DATE NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    category_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 5. SETTINGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS settings (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at TIMESTAMP NOT NULL,
    setting_key VARCHAR(255) NOT NULL,
    setting_value VARCHAR(255),
    updated_at TIMESTAMP NOT NULL,
    user_id BIGINT NOT NULL,
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
(1, 'Admin', 'admin@expensetracker.com', 'admin123', 'ADMIN', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert default user (password: user123)
INSERT OR IGNORE INTO users (id, name, email, password_hash, role, status, created_at, updated_at) VALUES 
(2, 'User Demo', 'user@expensetracker.com', 'user123', 'USER', 'ACTIVE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert default categories
INSERT OR IGNORE INTO categories (id, name, type, color, icon, is_default, user_id, created_at, updated_at) VALUES 
(1, 'Gaji', 'INCOME', '#4CAF50', '💰', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 'Freelance', 'INCOME', '#2196F3', '💼', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 'Investasi', 'INCOME', '#FF9800', '📈', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 'Makanan', 'EXPENSE', '#f44336', '🍔', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 'Transport', 'EXPENSE', '#9C27B0', '🚗', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(6, 'Hiburan', 'EXPENSE', '#E91E63', '🎬', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(7, 'Belanja', 'EXPENSE', '#FF5722', '🛒', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(8, 'Tagihan', 'EXPENSE', '#795548', '📋', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(9, 'Lainnya', 'EXPENSE', '#607D8B', '📦', 1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert sample transactions
INSERT OR IGNORE INTO transactions (id, user_id, type, amount, category_id, description, transaction_date, created_at, updated_at) VALUES 
(1, 1, 'INCOME', 5000000.00, 1, 'Gaji bulanan Januari 2024', '2024-01-15', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 1, 'EXPENSE', 150000.00, 4, 'Makan siang di restoran', '2024-01-16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 1, 'EXPENSE', 50000.00, 5, 'Bensin motor', '2024-01-16', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(4, 1, 'INCOME', 500000.00, 2, 'Project freelance website', '2024-01-17', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(5, 1, 'EXPENSE', 200000.00, 6, 'Nonton film di bioskop', '2024-01-18', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert sample budgets
INSERT OR IGNORE INTO budgets (id, user_id, category_id, amount, period, start_date, end_date, is_active, created_at, updated_at) VALUES 
(1, 1, 4, 500000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(2, 1, 5, 200000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(3, 1, 6, 300000.00, 'MONTHLY', '2024-01-01', '2024-01-31', 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- Insert default settings
INSERT OR IGNORE INTO settings (user_id, setting_key, setting_value, created_at, updated_at) VALUES 
(1, 'primaryColor', '#667eea', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'secondaryColor', '#764ba2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'themeMode', 'light', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'chartType', 'pie', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'chartAnimation', 'true', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'enableNotifications', 'true', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'budgetAlerts', 'true', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'autoBackup', 'false', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP),
(1, 'dataRetention', '365', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

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
