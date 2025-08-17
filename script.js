class ExpenseTracker {
    constructor() {
        this.transactions = JSON.parse(localStorage.getItem('transactions')) || [];
        this.chart = null;
        this.init();
    }

    init() {
        this.setupEventListeners();
        this.updateDisplay();
        this.updateChart();
    }

    setupEventListeners() {
        // Form submission
        document.getElementById('transactionForm').addEventListener('submit', (e) => {
            e.preventDefault();
            this.addTransaction();
        });

        // Filter changes
        document.getElementById('filterCategory').addEventListener('change', () => this.updateDisplay());
        document.getElementById('filterType').addEventListener('change', () => this.updateDisplay());
    }

    addTransaction() {
        const type = document.getElementById('type').value;
        const amount = parseFloat(document.getElementById('amount').value);
        const category = document.getElementById('category').value;
        const description = document.getElementById('description').value;

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
        this.updateDisplay();
        this.updateChart();
        this.resetForm();
    }

    deleteTransaction(id) {
        if (confirm('Yakin ingin menghapus transaksi ini?')) {
            this.transactions = this.transactions.filter(t => t.id !== id);
            this.saveToLocalStorage();
            this.updateDisplay();
            this.updateChart();
        }
    }

    resetForm() {
        document.getElementById('transactionForm').reset();
    }

    saveToLocalStorage() {
        localStorage.setItem('transactions', JSON.stringify(this.transactions));
    }

    getFilteredTransactions() {
        const categoryFilter = document.getElementById('filterCategory').value;
        const typeFilter = document.getElementById('filterType').value;

        return this.transactions.filter(transaction => {
            const categoryMatch = !categoryFilter || transaction.category === categoryFilter;
            const typeMatch = !typeFilter || transaction.type === typeFilter;
            return categoryMatch && typeMatch;
        });
    }

    updateDisplay() {
        const filteredTransactions = this.getFilteredTransactions();
        this.updateSummary();
        this.updateTransactionsTable(filteredTransactions);
    }

    updateSummary() {
        const totalIncome = this.transactions
            .filter(t => t.type === 'income')
            .reduce((sum, t) => sum + t.amount, 0);

        const totalExpense = this.transactions
            .filter(t => t.type === 'expense')
            .reduce((sum, t) => sum + t.amount, 0);

        const balance = totalIncome - totalExpense;

        document.getElementById('totalIncome').textContent = `Rp ${totalIncome.toLocaleString('id-ID')}`;
        document.getElementById('totalExpense').textContent = `Rp ${totalExpense.toLocaleString('id-ID')}`;
        document.getElementById('balance').textContent = `Rp ${balance.toLocaleString('id-ID')}`;
    }

    updateTransactionsTable(transactions) {
        const tbody = document.getElementById('transactionsBody');
        tbody.innerHTML = '';

        if (transactions.length === 0) {
            tbody.innerHTML = '<tr><td colspan="6" style="text-align: center;">Tidak ada transaksi</td></tr>';
            return;
        }

        transactions.forEach(transaction => {
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
            tbody.appendChild(row);
        });
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
        const ctx = document.getElementById('expenseChart').getContext('2d');
        
        // Destroy existing chart if it exists
        if (this.chart) {
            this.chart.destroy();
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
            // Show message if no expense data
            ctx.font = '16px Arial';
            ctx.fillStyle = '#666';
            ctx.textAlign = 'center';
            ctx.fillText('Belum ada data pengeluaran', ctx.canvas.width / 2, ctx.canvas.height / 2);
            return;
        }

        this.chart = new Chart(ctx, {
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

// Initialize the application
const expenseTracker = new ExpenseTracker();

// Add some CSS for badges
const style = document.createElement('style');
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
`;
document.head.appendChild(style);
