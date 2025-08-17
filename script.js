// API Service Layer
class ApiService {
    constructor() {
        this.baseUrl = 'http://localhost:8080';
    }

    async makeRequest(endpoint, options = {}) {
        try {
            console.log(`API Request: ${options.method || 'GET'} ${this.baseUrl}${endpoint}`);
            if (options.body) {
                console.log('Request Body:', options.body);
            }

            const response = await fetch(`${this.baseUrl}${endpoint}`, {
                headers: {
                    'Content-Type': 'application/json',
                    ...options.headers
                },
                ...options
            });

            console.log(`API Response Status: ${response.status}`);
            console.log(`API Response Headers:`, Object.fromEntries(response.headers.entries()));

            if (!response.ok) {
                const errorText = await response.text();
                console.error('API Error Response:', errorText);
                throw new Error(`HTTP ${response.status}: ${errorText || response.statusText}`);
            }

            const data = await response.json();
            console.log('API Response Data:', data);
            return data;
        } catch (error) {
            console.error('API Error Details:', error);
            throw error;
        }
    }

    // User API calls
    async getUsers() {
        return this.makeRequest('/users');
    }

    async getUserById(id) {
        return this.makeRequest(`/users/${id}`);
    }

    // Category API calls
    async getCategories() {
        return this.makeRequest('/categories');
    }

    async getCategoriesByType(type) {
        return this.makeRequest(`/categories/type/${type}`);
    }

    // Transaction API calls
    async getTransactions() {
        return this.makeRequest('/transactions');
    }

    async createTransaction(transaction) {
        return this.makeRequest('/transactions', {
            method: 'POST',
            body: JSON.stringify(transaction)
        });
    }

    async updateTransaction(id, transaction) {
        return this.makeRequest(`/transactions/${id}`, {
            method: 'PUT',
            body: JSON.stringify(transaction)
        });
    }

    async deleteTransaction(id) {
        return this.makeRequest(`/transactions/${id}`, {
            method: 'DELETE'
        });
    }
}

// Initialize API Service
const apiService = new ApiService();

class ExpenseTracker {
    constructor() {
        this.transactions = [];
        this.categories = [];
        this.users = [];
        this.initialBalance = 0;
        this.chart = null;
        this.isUpdating = false;
        this.init();
    }

    async init() {
        try {
            // Load data from API
            await this.loadDataFromAPI();
            
            // Setup UI
            this.setupEventListeners();
            this.renderAll();
        } catch (error) {
            console.error('Failed to initialize:', error);
            // Fallback to localStorage if API fails
            this.fallbackToLocalStorage();
        }
    }

    async loadDataFromAPI() {
        try {
            // Load categories first (needed for transaction form)
            this.categories = await apiService.getCategories();
            
            // Load transactions
            this.transactions = await apiService.getTransactions();
            
            // Load users
            this.users = await apiService.getUsers();
            
            // Load initial balance from localStorage (fallback)
            this.initialBalance = parseFloat(localStorage.getItem('initialBalance')) || 0;
            
            console.log('Data loaded from API:', {
                categories: this.categories.length,
                transactions: this.transactions.length,
                users: this.users.length
            });
        } catch (error) {
            console.error('Failed to load data from API:', error);
            throw error;
        }
    }

    fallbackToLocalStorage() {
        console.log('Falling back to localStorage...');
        this.transactions = JSON.parse(localStorage.getItem('transactions')) || [];
        this.initialBalance = parseFloat(localStorage.getItem('initialBalance')) || 0;
        this.categories = [
            { id: 1, name: 'Gaji', type: 'INCOME', color: '#4CAF50', icon: '💰' },
            { id: 2, name: 'Freelance', type: 'INCOME', color: '#2196F3', icon: '💼' },
            { id: 3, name: 'Makanan', type: 'EXPENSE', color: '#f44336', icon: '🍔' },
            { id: 4, name: 'Transport', type: 'EXPENSE', color: '#9C27B0', icon: '🚗' },
            { id: 5, name: 'Hiburan', type: 'EXPENSE', color: '#E91E63', icon: '🎬' }
        ];
    }

    setupEventListeners() {
        // Form submission
        const form = document.getElementById('transactionForm');
        if (form) {
            form.addEventListener('submit', (e) => {
                e.preventDefault();
                this.addTransaction();
            });
        }

        // Filter changes with proper debouncing
        const categoryFilter = document.getElementById('filterCategory');
        const typeFilter = document.getElementById('filterType');
        
        if (categoryFilter) {
            categoryFilter.addEventListener('change', () => this.debouncedRender());
        }
        if (typeFilter) {
            typeFilter.addEventListener('change', () => this.debouncedRender());
        }

        // Auto-format amount input field
        const amountInput = document.getElementById('amount');
        if (amountInput) {
            amountInput.addEventListener('input', (e) => this.formatAmountInput(e));
            amountInput.addEventListener('focus', (e) => this.formatAmountOnFocus(e));
            amountInput.addEventListener('blur', (e) => this.formatAmountOnBlur(e));
        }

        // Initial balance functionality
        const setBalanceBtn = document.getElementById('setBalanceBtn');
        const initialBalanceInput = document.getElementById('initialBalance');
        
        if (setBalanceBtn) {
            setBalanceBtn.addEventListener('click', () => this.setInitialBalance());
        }
        
        if (initialBalanceInput) {
            initialBalanceInput.addEventListener('input', (e) => this.formatBalanceInput(e));
            initialBalanceInput.addEventListener('focus', (e) => this.formatBalanceOnFocus(e));
            initialBalanceInput.addEventListener('blur', (e) => this.formatBalanceOnBlur(e));
        }
    }

    // Simple debouncing
    debouncedRender() {
        if (this.renderTimeout) {
            clearTimeout(this.renderTimeout);
        }
        this.renderTimeout = setTimeout(() => {
            this.renderAll();
        }, 200);
    }

    // Auto-format amount input methods
    formatAmountInput(e) {
        const input = e.target;
        let value = input.value.replace(/[^\d]/g, ''); // Remove non-digits
        
        // Format with thousand separators
        if (value.length > 0) {
            value = parseInt(value).toLocaleString('id-ID');
            input.value = value;
        }
    }

    formatAmountOnFocus(e) {
        const input = e.target;
        input.value = input.value.replace(/[^\d]/g, ''); // Remove formatting for editing
    }

    formatAmountOnBlur(e) {
        const input = e.target;
        let value = input.value.replace(/[^\d]/g, ''); // Remove non-digits
        
        if (value.length > 0) {
            // Format with thousand separators
            value = parseInt(value).toLocaleString('id-ID');
            input.value = value;
        }
    }

    // Initial balance methods
    formatBalanceInput(e) {
        const input = e.target;
        let value = input.value.replace(/[^\d]/g, ''); // Remove non-digits
        
        // Format with thousand separators
        if (value.length > 0) {
            value = parseInt(value).toLocaleString('id-ID');
            input.value = value;
        }
    }

    formatBalanceOnFocus(e) {
        const input = e.target;
        input.value = input.value.replace(/[^\d]/g, ''); // Remove formatting for editing
    }

    formatBalanceOnBlur(e) {
        const input = e.target;
        let value = input.value.replace(/[^\d]/g, ''); // Remove non-digits
        
        if (value.length > 0) {
            // Format with thousand separators
            value = parseInt(value).toLocaleString('id-ID');
            input.value = value;
        }
    }

    setInitialBalance() {
        const input = document.getElementById('initialBalance');
        if (!input) return;
        
        let value = input.value.replace(/[^\d]/g, ''); // Remove non-digits
        
        if (value.length === 0) {
            alert('Mohon masukkan saldo awal!');
            return;
        }
        
        const balance = parseFloat(value);
        if (balance < 0) {
            alert('Saldo awal tidak boleh negatif!');
            return;
        }
        
        this.initialBalance = balance;
        localStorage.setItem('initialBalance', balance.toString());
        
        // Update display
        this.renderAll();
        
        // Show success message
        alert(`Saldo awal berhasil diset: Rp ${balance.toLocaleString('id-ID')}`);
        
        // Clear input
        input.value = '';
    }

    getCurrentBalance() {
        const totalIncome = this.transactions
            .filter(t => t.type === 'INCOME')
            .reduce((sum, t) => sum + t.amount, 0);
            
        const totalExpense = this.transactions
            .filter(t => t.type === 'EXPENSE')
            .reduce((sum, t) => sum + t.amount, 0);
            
        return this.initialBalance + totalIncome - totalExpense;
    }

    async addTransaction() {
        if (this.isUpdating) return;
        
        const type = document.getElementById('type')?.value;
        const amountInput = document.getElementById('amount')?.value;
        const category = document.getElementById('category')?.value;
        const description = document.getElementById('description')?.value;

        if (!amountInput || !category || !description) {
            alert('Mohon lengkapi semua field!');
            return;
        }

        // Convert formatted amount back to number
        const amount = parseFloat(amountInput.replace(/[^\d]/g, ''));

        if (!amount || amount <= 0) {
            alert('Jumlah harus lebih dari 0!');
            return;
        }

        try {
            this.isUpdating = true;
            
            // Create transaction object for API - ensure proper data types
            const transactionData = {
                type: type.toUpperCase(), // Ensure uppercase
                amount: amount, // Send as number, not string
                categoryId: parseInt(category), // Ensure integer
                description: description.trim(), // Trim whitespace
                transactionDate: new Date().toISOString().split('T')[0], // YYYY-MM-DD format
                userId: 1 // Default user ID for now
            };

            console.log('Sending transaction data:', transactionData);

            // Send to API
            const newTransaction = await apiService.createTransaction(transactionData);
            
            console.log('Transaction created successfully:', newTransaction);
            
            // Add to local array
            this.transactions.push(newTransaction);
            
            // Update display
            this.renderAll();
            
            // Reset form
            this.resetForm();
            
            // Show success message
            alert('Transaksi berhasil ditambahkan!');
            
        } catch (error) {
            console.error('Failed to add transaction:', error);
            
            // Show more specific error message
            let errorMessage = 'Gagal menambahkan transaksi. ';
            if (error.message.includes('400')) {
                errorMessage += 'Data tidak valid. Silakan periksa input Anda.';
            } else if (error.message.includes('500')) {
                errorMessage += 'Server error. Silakan coba lagi nanti.';
            } else {
                errorMessage += error.message;
            }
            
            alert(errorMessage);
        } finally {
            this.isUpdating = false;
        }
    }

    async deleteTransaction(id) {
        if (this.isUpdating) return;
        
        if (!confirm('Apakah Anda yakin ingin menghapus transaksi ini?')) {
            return;
        }

        try {
            this.isUpdating = true;
            
            // Delete from API
            await apiService.deleteTransaction(id);
            
            // Remove from local array
            this.transactions = this.transactions.filter(t => t.id !== id);
            
            // Update display
            this.renderAll();
            
            // Show success message
            alert('Transaksi berhasil dihapus!');
            
        } catch (error) {
            console.error('Failed to delete transaction:', error);
            alert('Gagal menghapus transaksi. Silakan coba lagi.');
        } finally {
            this.isUpdating = false;
        }
    }

    resetForm() {
        const form = document.getElementById('transactionForm');
        if (form) {
            form.reset();
            // Clear amount input formatting
            const amountInput = document.getElementById('amount');
            if (amountInput) {
                amountInput.value = '';
            }
        }
    }

    getFilteredTransactions() {
        let filtered = [...this.transactions];
        
        const categoryFilter = document.getElementById('filterCategory')?.value;
        const typeFilter = document.getElementById('filterType')?.value;
        
        if (categoryFilter) {
            filtered = filtered.filter(t => t.categoryId === parseInt(categoryFilter));
        }
        
        if (typeFilter) {
            filtered = filtered.filter(t => t.type === typeFilter);
        }
        
        return filtered;
    }

    renderAll() {
        if (this.isUpdating) return;
        this.isUpdating = true;
        
        try {
            // Populate category dropdowns first
            this.populateCategoryDropdowns();
            
            // Update display
            this.updateSummary();
            this.updateTransactionsTable();
            this.updateChart();
            this.displayInitialBalance();
        } catch (error) {
            console.error('Error rendering:', error);
        } finally {
            this.isUpdating = false;
        }
    }

    displayInitialBalance() {
        const initialBalanceInput = document.getElementById('initialBalance');
        if (initialBalanceInput && this.initialBalance > 0) {
            // Show current initial balance as placeholder or info
            initialBalanceInput.placeholder = `Saldo awal saat ini: Rp ${this.initialBalance.toLocaleString('id-ID')}`;
        }
    }

    updateSummary() {
        const totalIncome = this.transactions
            .filter(t => t.type === 'INCOME')
            .reduce((sum, t) => sum + t.amount, 0);
            
        const totalExpense = this.transactions
            .filter(t => t.type === 'EXPENSE')
            .reduce((sum, t) => sum + t.amount, 0);
            
        const currentBalance = this.getCurrentBalance();
        
        // Update summary display
        const balanceElement = document.getElementById('balance');
        const incomeElement = document.getElementById('totalIncome');
        const expenseElement = document.getElementById('totalExpense');
        
        if (balanceElement) {
            balanceElement.textContent = `Rp ${currentBalance.toLocaleString('id-ID')}`;
        }
        
        if (incomeElement) {
            incomeElement.textContent = `Rp ${totalIncome.toLocaleString('id-ID')}`;
        }
        
        if (expenseElement) {
            expenseElement.textContent = `Rp ${totalExpense.toLocaleString('id-ID')}`;
        }
    }

    updateTransactionsTable() {
        const filteredTransactions = this.getFilteredTransactions();
        const tbody = document.getElementById('transactionsBody');
        
        if (!tbody) return;
        
        // Use DocumentFragment for better performance
        const fragment = document.createDocumentFragment();

        if (filteredTransactions.length === 0) {
            const row = document.createElement('tr');
            row.innerHTML = '<td colspan="6" style="text-align: center;">Tidak ada transaksi</td>';
            fragment.appendChild(row);
        } else {
            filteredTransactions.forEach(transaction => {
                const row = document.createElement('tr');
                
                // Get category name from categories array
                const category = this.categories.find(c => c.id === transaction.categoryId);
                const categoryName = category ? category.name : 'Unknown';
                
                // Format date
                const date = transaction.transactionDate ? 
                    new Date(transaction.transactionDate).toLocaleDateString('id-ID') : 
                    'N/A';
                
                row.innerHTML = `
                    <td>${date}</td>
                    <td>
                        <span class="badge ${transaction.type === 'income' ? 'income' : 'expense'}">
                            ${transaction.type === 'income' ? '💰 Pemasukan' : '💸 Pengeluaran'}
                        </span>
                    </td>
                    <td>${categoryName}</td>
                    <td>${transaction.description || 'N/A'}</td>
                    <td class="${transaction.type === 'income' ? 'income-amount' : 'expense-amount'}">
                        Rp ${transaction.amount.toLocaleString('id-ID')}
                    </td>
                    <td>
                        <button class="delete-btn" onclick="expenseTracker.deleteTransaction(${transaction.id})">
                            🗑️ Hapus
                        </button>
                    </td>
                `;
                fragment.appendChild(row);
            });
        }
        
        // Clear and append in one operation
        tbody.innerHTML = '';
        tbody.appendChild(fragment);
    }

    updateChart() {
        if (!this.chart) {
            this.initializeChart();
            return;
        }

        // Get expense data by category
        const expenseData = {};
        this.transactions
            .filter(t => t.type === 'EXPENSE')
            .forEach(t => {
                const category = this.categories.find(c => c.id === t.categoryId);
                const categoryName = category ? category.name : 'Unknown';
                expenseData[categoryName] = (expenseData[categoryName] || 0) + t.amount;
            });

        const labels = Object.keys(expenseData);
        const data = Object.values(expenseData);

        if (data.length === 0) {
            // Update chart with empty data instead of destroying
            this.chart.data.labels = ['Belum ada data'];
            this.chart.data.datasets[0].data = [1];
            this.chart.data.datasets[0].backgroundColor = ['#C9CBCF'];
        } else {
            // Update chart data efficiently
            this.chart.data.labels = labels;
            this.chart.data.datasets[0].data = data;
            this.chart.data.datasets[0].backgroundColor = [
                '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF'
            ];
        }

        // Update chart without destroying
        this.chart.update('none'); // Use 'none' mode for better performance
    }

    initializeChart() {
        const canvas = document.getElementById('expenseChart');
        if (!canvas) return;

        // Destroy existing chart if it exists
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
        }

        // Get expense data by category
        const expenseData = {};
        this.transactions
            .filter(t => t.type === 'EXPENSE')
            .forEach(t => {
                const category = this.categories.find(c => c.id === t.categoryId);
                const categoryName = category ? category.name : 'Unknown';
                expenseData[categoryName] = (expenseData[categoryName] || 0) + t.amount;
            });

        const labels = Object.keys(expenseData);
        const data = Object.values(expenseData);

        if (data.length === 0) {
            // Show empty state
            const ctx = canvas.getContext('2d');
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.font = '16px Arial';
            ctx.fillStyle = '#666';
            ctx.textAlign = 'center';
            ctx.fillText('Belum ada data pengeluaran', canvas.width / 2, canvas.height / 2);
            return;
        }

        // Create new chart
        this.chart = new Chart(canvas, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: data,
                    backgroundColor: [
                        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                        '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF'
                    ],
                    borderWidth: 2,
                    borderColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        padding: 20,
                        usePointStyle: true
                    },
                    tooltip: {
                        callbacks: {
                            label: function(context) {
                                const label = context.label || '';
                                const value = context.parsed;
                                const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                const percentage = ((value / total) * 100).toFixed(1);
                                return `${label}: Rp ${value.toLocaleString('id-ID')} (${percentage}%)`;
                            }
                        }
                    }
                }
            }
        });
    }

    populateCategoryDropdowns() {
        // Populate main form category dropdown
        const categorySelect = document.getElementById('category');
        if (categorySelect) {
            categorySelect.innerHTML = '<option value="">Pilih Kategori</option>';
            
            this.categories.forEach(cat => {
                const option = document.createElement('option');
                option.value = cat.id;
                option.textContent = `${cat.icon} ${cat.name}`;
                categorySelect.appendChild(option);
            });
        }

        // Populate filter category dropdown
        const filterCategorySelect = document.getElementById('filterCategory');
        if (filterCategorySelect) {
            filterCategorySelect.innerHTML = '<option value="">Semua Kategori</option>';
            
            this.categories.forEach(cat => {
                const option = document.createElement('option');
                option.value = cat.id;
                option.textContent = `${cat.icon} ${cat.name}`;
                filterCategorySelect.appendChild(option);
            });
        }
    }
}

// Initialize the application when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.expenseTracker = new ExpenseTracker();
});

// Add CSS styles only once
if (!document.getElementById('expense-tracker-styles')) {
    const style = document.createElement('style');
    style.id = 'expense-tracker-styles';
    style.textContent = `
        .badge {
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge.income {
            background: #4CAF50;
            color: white;
        }
        .badge.expense {
            background: #f44336;
            color: white;
        }
        .income-amount {
            color: #4CAF50;
            font-weight: bold;
        }
        .expense-amount {
            color: #f44336;
            font-weight: bold;
        }
        .delete-btn {
            background: #f44336;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
        }
        .delete-btn:hover {
            background: #d32f2f;
        }
    `;
    document.head.appendChild(style);
}
