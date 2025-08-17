-- ========================================
-- EXPENSE TRACKER DATABASE SCHEMA
-- SQLite Database Creation Script
-- ========================================

-- Enable foreign key constraints
PRAGMA foreign_keys = ON;

-- ========================================
-- 1. USERS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL CHECK (length(name) >= 2 AND length(name) <= 100),
    email TEXT UNIQUE NOT NULL CHECK (email LIKE '%_@_%'),
    password_hash TEXT NOT NULL CHECK (length(password_hash) >= 6),
    role TEXT NOT NULL DEFAULT 'USER' CHECK (role IN ('ADMIN', 'USER')),
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ========================================
-- 2. CATEGORIES TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL CHECK (length(name) >= 2 AND length(name) <= 100),
    type TEXT NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    color TEXT DEFAULT '#667eea' CHECK (color LIKE '#%' AND length(color) = 7),
    icon TEXT DEFAULT '💰' CHECK (length(icon) <= 10),
    is_default BOOLEAN DEFAULT 0 CHECK (is_default IN (0, 1)),
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
    type TEXT NOT NULL CHECK (type IN ('INCOME', 'EXPENSE')),
    amount REAL NOT NULL CHECK (amount > 0),
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
    amount REAL NOT NULL CHECK (amount > 0),
    period TEXT DEFAULT 'MONTHLY' CHECK (period IN ('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')),
    start_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT 1 CHECK (is_active IN (0, 1)),
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
    setting_key TEXT NOT NULL CHECK (length(setting_key) <= 100),
    setting_value TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE(user_id, setting_key)
);

-- ========================================
-- 6. AUDIT LOGS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS audit_logs (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER,
    action TEXT NOT NULL CHECK (length(action) <= 100),
    table_name TEXT CHECK (length(table_name) <= 50),
    record_id INTEGER,
    old_values TEXT,
    new_values TEXT,
    ip_address TEXT CHECK (length(ip_address) <= 45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
);

-- ========================================
-- 7. NOTIFICATIONS TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS notifications (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL CHECK (length(title) <= 200),
    message TEXT NOT NULL,
    type TEXT DEFAULT 'INFO' CHECK (type IN ('INFO', 'WARNING', 'ERROR', 'SUCCESS')),
    is_read BOOLEAN DEFAULT 0 CHECK (is_read IN (0, 1)),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 8. EXPORT_HISTORY TABLE
-- ========================================
CREATE TABLE IF NOT EXISTS export_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    export_type TEXT NOT NULL CHECK (export_type IN ('TRANSACTIONS', 'CATEGORIES', 'ALL_DATA')),
    file_name TEXT NOT NULL,
    file_size INTEGER,
    export_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
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
CREATE INDEX IF NOT EXISTS idx_categories_is_default ON categories(is_default);

-- Transactions indexes
CREATE INDEX IF NOT EXISTS idx_transactions_user_date ON transactions(user_id, transaction_date);
CREATE INDEX IF NOT EXISTS idx_transactions_category ON transactions(category_id);
CREATE INDEX IF NOT EXISTS idx_transactions_type ON transactions(type);
CREATE INDEX IF NOT EXISTS idx_transactions_amount ON transactions(amount);

-- Budgets indexes
CREATE INDEX IF NOT EXISTS idx_budgets_user_active ON budgets(user_id, is_active);
CREATE INDEX IF NOT EXISTS idx_budgets_period ON budgets(period);
CREATE INDEX IF NOT EXISTS idx_budgets_date_range ON budgets(start_date, end_date);

-- Settings indexes
CREATE INDEX IF NOT EXISTS idx_settings_user_key ON settings(user_id, setting_key);

-- Audit logs indexes
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_date ON audit_logs(user_id, created_at);
CREATE INDEX IF NOT EXISTS idx_audit_logs_action ON audit_logs(action);
CREATE INDEX IF NOT EXISTS idx_audit_logs_table ON audit_logs(table_name);

-- Notifications indexes
CREATE INDEX IF NOT EXISTS idx_notifications_user_read ON notifications(user_id, is_read);
CREATE INDEX IF NOT EXISTS idx_notifications_created ON notifications(created_at);

-- Export history indexes
CREATE INDEX IF NOT EXISTS idx_export_history_user_date ON export_history(user_id, export_date);

-- ========================================
-- TRIGGERS FOR UPDATED_AT TIMESTAMP
-- ========================================

-- Users trigger
CREATE TRIGGER IF NOT EXISTS update_users_timestamp 
    AFTER UPDATE ON users
    BEGIN
        UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- Categories trigger
CREATE TRIGGER IF NOT EXISTS update_categories_timestamp 
    AFTER UPDATE ON categories
    BEGIN
        UPDATE categories SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- Transactions trigger
CREATE TRIGGER IF NOT EXISTS update_transactions_timestamp 
    AFTER UPDATE ON transactions
    BEGIN
        UPDATE transactions SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- Budgets trigger
CREATE TRIGGER IF NOT EXISTS update_budgets_timestamp 
    AFTER UPDATE ON budgets
    BEGIN
        UPDATE budgets SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- Settings trigger
CREATE TRIGGER IF NOT EXISTS update_settings_timestamp 
    AFTER UPDATE ON settings
    BEGIN
        UPDATE settings SET updated_at = CURRENT_TIMESTAMP WHERE id = NEW.id;
    END;

-- ========================================
-- TRIGGERS FOR AUDIT LOGGING
-- ========================================

-- Users audit trigger
CREATE TRIGGER IF NOT EXISTS audit_users_changes
    AFTER UPDATE ON users
    BEGIN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (
            NEW.id,
            'UPDATE',
            'users',
            NEW.id,
            json_object('name', OLD.name, 'email', OLD.email, 'role', OLD.role, 'status', OLD.status),
            json_object('name', NEW.name, 'email', NEW.email, 'role', NEW.role, 'status', NEW.status)
        );
    END;

-- Categories audit trigger
CREATE TRIGGER IF NOT EXISTS audit_categories_changes
    AFTER UPDATE ON categories
    BEGIN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (
            NEW.user_id,
            'UPDATE',
            'categories',
            NEW.id,
            json_object('name', OLD.name, 'type', OLD.type, 'color', OLD.color, 'icon', OLD.icon),
            json_object('name', NEW.name, 'type', NEW.type, 'color', NEW.color, 'icon', NEW.icon)
        );
    END;

-- Transactions audit trigger
CREATE TRIGGER IF NOT EXISTS audit_transactions_changes
    AFTER UPDATE ON transactions
    BEGIN
        INSERT INTO audit_logs (user_id, action, table_name, record_id, old_values, new_values)
        VALUES (
            NEW.user_id,
            'UPDATE',
            'transactions',
            NEW.id,
            json_object('amount', OLD.amount, 'type', OLD.type, 'description', OLD.description),
            json_object('amount', NEW.amount, 'type', NEW.type, 'description', NEW.description)
        );
    END;

-- ========================================
-- VIEWS FOR COMMON QUERIES
-- ========================================

-- View for transaction summary
CREATE VIEW IF NOT EXISTS transaction_summary AS
SELECT 
    t.user_id,
    t.type,
    COUNT(*) as transaction_count,
    SUM(t.amount) as total_amount,
    AVG(t.amount) as average_amount,
    MIN(t.amount) as min_amount,
    MAX(t.amount) as max_amount
FROM transactions t
GROUP BY t.user_id, t.type;

-- View for category summary
CREATE VIEW IF NOT EXISTS category_summary AS
SELECT 
    c.id,
    c.name,
    c.type,
    c.color,
    c.icon,
    c.user_id,
    COUNT(t.id) as transaction_count,
    SUM(CASE WHEN t.type = 'EXPENSE' THEN t.amount ELSE 0 END) as total_expense,
    SUM(CASE WHEN t.type = 'INCOME' THEN t.amount ELSE 0 END) as total_income,
    (SUM(CASE WHEN t.type = 'INCOME' THEN t.amount ELSE 0 END) - SUM(CASE WHEN t.type = 'EXPENSE' THEN t.amount ELSE 0 END)) as net_amount
FROM categories c
LEFT JOIN transactions t ON c.id = t.category_id
GROUP BY c.id, c.name, c.type, c.color, c.icon, c.user_id;

-- View for monthly summary
CREATE VIEW IF NOT EXISTS monthly_summary AS
SELECT 
    t.user_id,
    strftime('%Y-%m', t.transaction_date) as month,
    t.type,
    COUNT(*) as transaction_count,
    SUM(t.amount) as total_amount,
    AVG(t.amount) as average_amount
FROM transactions t
GROUP BY t.user_id, strftime('%Y-%m', t.transaction_date), t.type;

-- View for budget vs actual
CREATE VIEW IF NOT EXISTS budget_vs_actual AS
SELECT 
    b.user_id,
    b.category_id,
    c.name as category_name,
    b.amount as budget_amount,
    b.period,
    b.start_date,
    b.end_date,
    COALESCE(SUM(t.amount), 0) as actual_amount,
    (b.amount - COALESCE(SUM(t.amount), 0)) as remaining_amount,
    CASE 
        WHEN COALESCE(SUM(t.amount), 0) > b.amount THEN 'OVER_BUDGET'
        WHEN COALESCE(SUM(t.amount), 0) = b.amount THEN 'ON_BUDGET'
        ELSE 'UNDER_BUDGET'
    END as budget_status
FROM budgets b
JOIN categories c ON b.category_id = c.id
LEFT JOIN transactions t ON b.category_id = t.category_id 
    AND t.user_id = b.user_id 
    AND t.transaction_date BETWEEN b.start_date AND COALESCE(b.end_date, date('now'))
WHERE b.is_active = 1
GROUP BY b.id, b.user_id, b.category_id, c.name, b.amount, b.period, b.start_date, b.end_date;

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
SELECT 'settings', COUNT(*) FROM settings;

-- Show sample data
SELECT 'Sample Users:' as info;
SELECT id, name, email, role, status FROM users;

SELECT 'Sample Categories:' as info;
SELECT id, name, type, color, icon FROM categories;

SELECT 'Sample Transactions:' as info;
SELECT id, type, amount, description, transaction_date FROM transactions;
