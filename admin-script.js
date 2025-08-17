class AdminPanel {
    constructor() {
        this.currentSection = 'categories';
        this.categories = JSON.parse(localStorage.getItem('customCategories')) || this.getDefaultCategories();
        this.users = JSON.parse(localStorage.getItem('users')) || this.getDefaultUsers();
        this.settings = JSON.parse(localStorage.getItem('adminSettings')) || this.getDefaultSettings();
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.loadCategories();
        this.loadUsers();
        this.loadSettings();
        this.loadAnalytics();
        this.setupNavigation();
    }

    setupEventListeners() {
        // Category form
        document.getElementById('categoryForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addCategory();
        });

        // User form
        document.getElementById('userForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addUser();
        });

        // Settings save
        document.getElementById('saveSettings').addEventListener('click', () => {
            this.saveSettings();
        });

        // Export/Import
        document.getElementById('exportData').addEventListener('click', () => {
            this.exportAllData();
        });

        document.getElementById('importData').addEventListener('click', () => {
            document.getElementById('importFile').click();
        });

        document.getElementById('importFile').addEventListener('change', (e) => {
            this.importData(e.target.files[0]);
        });

        // Backup operations
        document.getElementById('exportAllData').addEventListener('click', () => {
            this.exportAllData();
        });

        document.getElementById('importAllData').addEventListener('click', () => {
            document.getElementById('importFile').click();
        });

        document.getElementById('clearAllData').addEventListener('click', () => {
            this.clearAllData();
        });
    }

    setupNavigation() {
        const sidebarLinks = document.querySelectorAll('.sidebar-link');
        const sections = document.querySelectorAll('.admin-section');

        sidebarLinks.forEach(link => {
            link.addEventListener('click', (e) => {
                e.preventDefault();
                const targetId = link.getAttribute('href').substring(1);
                this.showSection(targetId);
                
                // Update active states
                sidebarLinks.forEach(l => l.classList.remove('active'));
                link.classList.add('active');
            });
        });
    }

    showSection(sectionId) {
        // Hide all sections
        document.querySelectorAll('.admin-section').forEach(section => {
            section.classList.remove('active');
        });

        // Show target section
        document.getElementById(sectionId).classList.add('active');
        this.currentSection = sectionId;

        // Load section-specific data
        if (sectionId === 'analytics') {
            this.loadAnalytics();
        }
    }

    // Category Management
    getDefaultCategories() {
        return [
            { id: 'salary', name: 'Gaji', type: 'income', color: '#4CAF50', icon: '💰' },
            { id: 'freelance', name: 'Freelance', type: 'income', color: '#2196F3', icon: '💼' },
            { id: 'investment', name: 'Investasi', type: 'income', color: '#FF9800', icon: '📈' },
            { id: 'food', name: 'Makanan', type: 'expense', color: '#f44336', icon: '🍔' },
            { id: 'transport', name: 'Transport', type: 'expense', color: '#9C27B0', icon: '🚗' },
            { id: 'entertainment', name: 'Hiburan', type: 'expense', color: '#E91E63', icon: '🎬' },
            { id: 'shopping', name: 'Belanja', type: 'expense', color: '#FF5722', icon: '🛒' },
            { id: 'bills', name: 'Tagihan', type: 'expense', color: '#795548', icon: '📋' },
            { id: 'other', name: 'Lainnya', type: 'expense', color: '#607D8B', icon: '📦' }
        ];
    }

    addCategory() {
        const name = document.getElementById('categoryName').value;
        const type = document.getElementById('categoryType').value;
        const color = document.getElementById('categoryColor').value;
        const icon = document.getElementById('categoryIcon').value;

        if (!name) {
            alert('Nama kategori harus diisi!');
            return;
        }

        const category = {
            id: name.toLowerCase().replace(/\s+/g, '-'),
            name: name,
            type: type,
            color: color,
            icon: icon
        };

        this.categories.push(category);
        this.saveCategories();
        this.loadCategories();
        document.getElementById('categoryForm').reset();
        
        alert('Kategori berhasil ditambahkan!');
    }

    deleteCategory(id) {
        if (confirm('Yakin ingin menghapus kategori ini?')) {
            this.categories = this.categories.filter(cat => cat.id !== id);
            this.saveCategories();
            this.loadCategories();
        }
    }

    saveCategories() {
        localStorage.setItem('customCategories', JSON.stringify(this.categories));
    }

    loadCategories() {
        const grid = document.getElementById('categoryGrid');
        grid.innerHTML = '';

        this.categories.forEach(category => {
            const categoryElement = document.createElement('div');
            categoryElement.className = 'category-item';
            categoryElement.style.borderColor = category.color;
            
            categoryElement.innerHTML = `
                <div class="category-icon">${category.icon}</div>
                <div class="category-name">${category.name}</div>
                <div class="category-type">${category.type === 'income' ? 'Pemasukan' : 'Pengeluaran'}</div>
                <div class="category-actions">
                    <button onclick="adminPanel.editCategory('${category.id}')" class="admin-btn">✏️ Edit</button>
                    <button onclick="adminPanel.deleteCategory('${category.id}')" class="admin-btn danger">🗑️ Hapus</button>
                </div>
            `;
            
            grid.appendChild(categoryElement);
        });
    }

    editCategory(id) {
        const category = this.categories.find(cat => cat.id === id);
        if (category) {
            document.getElementById('categoryName').value = category.name;
            document.getElementById('categoryType').value = category.type;
            document.getElementById('categoryColor').value = category.color;
            document.getElementById('categoryIcon').value = category.icon;
            
            // Change form to edit mode
            const form = document.getElementById('categoryForm');
            const submitBtn = form.querySelector('button[type="submit"]');
            submitBtn.textContent = '✏️ Update Kategori';
            submitBtn.onclick = (e) => {
                e.preventDefault();
                this.updateCategory(id);
            };
        }
    }

    updateCategory(id) {
        const name = document.getElementById('categoryName').value;
        const type = document.getElementById('categoryType').value;
        const color = document.getElementById('categoryColor').value;
        const icon = document.getElementById('categoryIcon').value;

        const categoryIndex = this.categories.findIndex(cat => cat.id === id);
        if (categoryIndex !== -1) {
            this.categories[categoryIndex] = {
                id: id,
                name: name,
                type: type,
                color: color,
                icon: icon
            };

            this.saveCategories();
            this.loadCategories();
            this.resetCategoryForm();
            alert('Kategori berhasil diupdate!');
        }
    }

    resetCategoryForm() {
        document.getElementById('categoryForm').reset();
        const submitBtn = document.querySelector('#categoryForm button[type="submit"]');
        submitBtn.textContent = '➕ Tambah Kategori';
        submitBtn.onclick = (e) => {
            e.preventDefault();
            this.addCategory();
        };
    }

    // User Management
    getDefaultUsers() {
        return [
            { id: 1, name: 'Admin', email: 'admin@expensetracker.com', role: 'admin', status: 'active' },
            { id: 2, name: 'User Demo', email: 'user@expensetracker.com', role: 'user', status: 'active' }
        ];
    }

    addUser() {
        const name = document.getElementById('userName').value;
        const email = document.getElementById('userEmail').value;
        const role = document.getElementById('userRole').value;

        if (!name || !email) {
            alert('Semua field harus diisi!');
            return;
        }

        const user = {
            id: Date.now(),
            name: name,
            email: email,
            role: role,
            status: 'active'
        };

        this.users.push(user);
        this.saveUsers();
        this.loadUsers();
        document.getElementById('userForm').reset();
        
        alert('User berhasil ditambahkan!');
    }

    saveUsers() {
        localStorage.setItem('users', JSON.stringify(this.users));
    }

    loadUsers() {
        const tbody = document.getElementById('userTableBody');
        tbody.innerHTML = '';

        this.users.forEach(user => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${user.name}</td>
                <td>${user.email}</td>
                <td><span class="badge ${user.role === 'admin' ? 'admin' : 'user'}">${user.role}</span></td>
                <td><span class="badge ${user.status === 'active' ? 'active' : 'inactive'}">${user.status}</span></td>
                <td>
                    <button onclick="adminPanel.editUser(${user.id})" class="admin-btn">✏️</button>
                    <button onclick="adminPanel.deleteUser(${user.id})" class="admin-btn danger">🗑️</button>
                </td>
            `;
            tbody.appendChild(row);
        });
    }

    deleteUser(id) {
        if (confirm('Yakin ingin menghapus user ini?')) {
            this.users = this.users.filter(user => user.id !== id);
            this.saveUsers();
            this.loadUsers();
        }
    }

    editUser(id) {
        // Implementation for editing user
        alert('Fitur edit user akan segera hadir!');
    }

    // Settings Management
    getDefaultSettings() {
        return {
            primaryColor: '#667eea',
            secondaryColor: '#764ba2',
            themeMode: 'light',
            chartType: 'pie',
            chartAnimation: true,
            enableNotifications: true,
            budgetAlerts: true,
            autoBackup: false,
            dataRetention: 365
        };
    }

    loadSettings() {
        Object.keys(this.settings).forEach(key => {
            const element = document.getElementById(key);
            if (element) {
                if (element.type === 'checkbox') {
                    element.checked = this.settings[key];
                } else {
                    element.value = this.settings[key];
                }
            }
        });
    }

    saveSettings() {
        Object.keys(this.settings).forEach(key => {
            const element = document.getElementById(key);
            if (element) {
                if (element.type === 'checkbox') {
                    this.settings[key] = element.checked;
                } else {
                    this.settings[key] = element.value;
                }
            }
        });

        localStorage.setItem('adminSettings', JSON.stringify(this.settings));
        alert('Pengaturan berhasil disimpan!');
    }

    // Analytics
    loadAnalytics() {
        const transactions = JSON.parse(localStorage.getItem('transactions')) || [];
        
        // Update stats
        document.getElementById('totalUsers').textContent = this.users.length;
        document.getElementById('totalTransactions').textContent = transactions.length;
        
        const avgAmount = transactions.length > 0 
            ? transactions.reduce((sum, t) => sum + t.amount, 0) / transactions.length 
            : 0;
        
        // Improved currency formatting - more compact and readable
        let formattedAmount;
        if (avgAmount > 0) {
            if (avgAmount >= 1000000) {
                // For millions, use compact format
                formattedAmount = `Rp${(avgAmount / 1000000).toFixed(1)}M`;
            } else if (avgAmount >= 1000) {
                // For thousands, use compact format
                formattedAmount = `Rp${(avgAmount / 1000).toFixed(0)}K`;
            } else {
                // For small amounts, use full format
                formattedAmount = `Rp${avgAmount.toLocaleString('id-ID')}`;
            }
        } else {
            formattedAmount = 'Rp 0';
        }
        
        document.getElementById('avgTransaction').textContent = formattedAmount;

        // Load top categories
        this.loadTopCategories(transactions);
    }

    loadTopCategories(transactions) {
        const categoryStats = {};
        
        transactions.forEach(transaction => {
            if (transaction.type === 'expense') {
                categoryStats[transaction.category] = (categoryStats[transaction.category] || 0) + transaction.amount;
            }
        });

        const topCategories = Object.entries(categoryStats)
            .sort(([,a], [,b]) => b - a)
            .slice(0, 5);

        const container = document.getElementById('topCategories');
        container.innerHTML = '';

        topCategories.forEach(([category, amount]) => {
            // Improved currency formatting for categories
            let formattedAmount;
            if (amount >= 1000000) {
                formattedAmount = `Rp${(amount / 1000000).toFixed(1)}M`;
            } else if (amount >= 1000) {
                formattedAmount = `Rp${(amount / 1000).toFixed(0)}K`;
            } else {
                formattedAmount = `Rp${amount.toLocaleString('id-ID')}`;
            }
            
            const categoryElement = document.createElement('div');
            categoryElement.style.cssText = `
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 15px;
                margin: 10px 0;
                background: white;
                border-radius: 8px;
                border-left: 4px solid #667eea;
            `;
            
            categoryElement.innerHTML = `
                <span style="font-weight: 600;">${this.getCategoryLabel(category)}</span>
                <span style="color: #667eea; font-weight: bold;">${formattedAmount}</span>
            `;
            
            container.appendChild(categoryElement);
        });
    }

    getCategoryLabel(category) {
        const categoryObj = this.categories.find(cat => cat.id === category);
        return categoryObj ? categoryObj.name : category;
    }

    // Data Export/Import
    exportAllData() {
        const data = {
            categories: this.categories,
            users: this.users,
            settings: this.settings,
            transactions: JSON.parse(localStorage.getItem('transactions')) || [],
            exportDate: new Date().toISOString()
        };

        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `expense-tracker-backup-${new Date().toISOString().split('T')[0]}.json`;
        a.click();
        URL.revokeObjectURL(url);
    }

    importData(file) {
        const reader = new FileReader();
        reader.onload = (e) => {
            try {
                const data = JSON.parse(e.target.result);
                
                if (data.categories) this.categories = data.categories;
                if (data.users) this.users = data.users;
                if (data.settings) this.settings = data.settings;
                if (data.transactions) localStorage.setItem('transactions', JSON.stringify(data.transactions));

                this.saveCategories();
                this.saveUsers();
                this.saveSettings();
                
                this.loadCategories();
                this.loadUsers();
                this.loadSettings();
                this.loadAnalytics();
                
                alert('Data berhasil diimport!');
            } catch (error) {
                alert('Error: File tidak valid!');
            }
        };
        reader.readAsText(file);
    }

    clearAllData() {
        if (confirm('⚠️ PERINGATAN: Semua data akan dihapus permanen! Lanjutkan?')) {
            if (confirm('Apakah Anda yakin 100%? Tindakan ini tidak dapat dibatalkan!')) {
                localStorage.clear();
                this.categories = this.getDefaultCategories();
                this.users = this.getDefaultUsers();
                this.settings = this.getDefaultSettings();
                
                this.loadCategories();
                this.loadUsers();
                this.loadSettings();
                this.loadAnalytics();
                
                alert('Semua data telah dihapus!');
            }
        }
    }
}

// Initialize admin panel
const adminPanel = new AdminPanel();

// Add some additional CSS for badges
const adminStyle = document.createElement('style');
adminStyle.textContent = `
    .badge {
        padding: 5px 10px;
        border-radius: 15px;
        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
    }
    .badge.admin {
        background: #667eea;
        color: white;
    }
    .badge.user {
        background: #4CAF50;
        color: white;
    }
    .badge.active {
        background: #4CAF50;
        color: white;
    }
    .badge.inactive {
        background: #f44336;
        color: white;
    }
`;
document.head.appendChild(adminStyle);
