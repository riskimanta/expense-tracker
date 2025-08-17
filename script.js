class ExpenseTracker {
    constructor() {
        this.transactions = JSON.parse(localStorage.getItem('transactions')) || [];
        this.chart = null;
        this.isUpdating = false;
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.renderAll();
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

    addTransaction() {
        if (this.isUpdating) return;
        
        const type = document.getElementById('type')?.value;
        const amount = parseFloat(document.getElementById('amount')?.value);
        const category = document.getElementById('category')?.value;
        const description = document.getElementById('description')?.value;

        if (!amount || !category || !description) {
            alert('Mohon lengkapi semua field!');
            return;
        }

        const transaction = {
            id: Date.now(),
            type: type,
            amount: amount,
            category: category,
            description: description,
            date: new Date().toLocaleDateString('id-ID')
        };

        this.transactions.push(transaction);
        this.saveToLocalStorage();
        this.renderAll();
        this.resetForm();
    }

    deleteTransaction(id) {
        if (this.isUpdating) return;
        
        if (confirm('Yakin ingin menghapus transaksi ini?')) {
            this.transactions = this.transactions.filter(t => t.id !== id);
            this.saveToLocalStorage();
            this.renderAll();
        }
    }

    resetForm() {
        const form = document.getElementById('transactionForm');
        if (form) {
            form.reset();
        }
    }

    saveToLocalStorage() {
        try {
            localStorage.setItem('transactions', JSON.stringify(this.transactions));
        } catch (e) {
            console.error('Error saving to localStorage:', e);
        }
    }

    getFilteredTransactions() {
        const categoryFilter = document.getElementById('filterCategory')?.value || '';
        const typeFilter = document.getElementById('filterType')?.value || '';

        return this.transactions.filter(transaction => {
            const categoryMatch = !categoryFilter || transaction.category === categoryFilter;
            const typeMatch = !typeFilter || transaction.type === typeFilter;
            return categoryMatch && typeMatch;
        });
    }

    renderAll() {
        if (this.isUpdating) return;
        this.isUpdating = true;

        try {
            this.updateSummary();
            this.updateTransactionsTable();
            this.updateChart();
        } finally {
            this.isUpdating = false;
        }
    }

    updateSummary() {
        const totalIncome = this.transactions
            .filter(t => t.type === 'income')
            .reduce((sum, t) => sum + t.amount, 0);

        const totalExpense = this.transactions
            .filter(t => t.type === 'expense')
            .reduce((sum, t) => sum + t.amount, 0);

        const balance = totalIncome - totalExpense;

        const incomeEl = document.getElementById('totalIncome');
        const expenseEl = document.getElementById('totalExpense');
        const balanceEl = document.getElementById('balance');

        if (incomeEl) incomeEl.textContent = `Rp ${totalIncome.toLocaleString('id-ID')}`;
        if (expenseEl) expenseEl.textContent = `Rp ${totalExpense.toLocaleString('id-ID')}`;
        if (balanceEl) balanceEl.textContent = `Rp ${balance.toLocaleString('id-ID')}`;
    }

    updateTransactionsTable() {
        const tbody = document.getElementById('transactionsBody');
        if (!tbody) return;

        const filteredTransactions = this.getFilteredTransactions();
        
        // Clear existing content
        tbody.innerHTML = '';

        if (filteredTransactions.length === 0) {
            const row = document.createElement('tr');
            row.innerHTML = '<td colspan="6" style="text-align: center;">Tidak ada transaksi</td>';
            tbody.appendChild(row);
            return;
        }

        // Create fragment for better performance
        const fragment = document.createDocumentFragment();

        filteredTransactions.forEach(transaction => {
            const row = document.createElement('tr');
            row.innerHTML = `
                <td>${transaction.date}</td>
                <td>
                    <span class="badge ${transaction.type === 'income' ? 'income' : 'expense'}">
                        ${transaction.type === 'income' ? '💰 Pemasukan' : '💸 Pengeluaran'}
                    </span>
                </td>
                <td>${this.getCategoryLabel(transaction.category)}</td>
                <td>${transaction.description}</td>
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

        tbody.appendChild(fragment);
    }

    getCategoryLabel(category) {
        const labels = {
            'salary': 'Gaji',
            'freelance': 'Freelance',
            'investment': 'Investasi',
            'food': 'Makanan',
            'transport': 'Transport',
            'entertainment': 'Hiburan',
            'shopping': 'Belanja',
            'bills': 'Tagihan',
            'other': 'Lainnya'
        };
        return labels[category] || category;
    }

    updateChart() {
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
            .filter(t => t.type === 'expense')
            .forEach(t => {
                expenseData[t.category] = (expenseData[t.category] || 0) + t.amount;
            });

        const labels = Object.keys(expenseData).map(cat => this.getCategoryLabel(cat));
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
                        labels: {
                            padding: 20,
                            usePointStyle: true
                        }
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
