package com.expensetracker.service;

import com.expensetracker.entity.Transaction;
import com.expensetracker.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TransactionService {
    
    @Autowired
    private TransactionRepository transactionRepository;
    
    @Autowired
    private JdbcTemplate jdbcTemplate;
    
    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }
    
    public Transaction getTransactionById(Integer id) {
        return transactionRepository.findById(id).orElse(null);
    }
    
    public List<Transaction> getTransactionsByUser(Integer userId) {
        return transactionRepository.findByUserId(userId);
    }
    
    public List<Transaction> getTransactionsByCategory(Integer categoryId) {
        return transactionRepository.findByCategoryId(categoryId);
    }
    
    public List<Transaction> getTransactionsByType(String type) {
        return transactionRepository.findByType(type);
    }
    
    public List<Transaction> getTransactionsByUserAndType(Integer userId, String type) {
        return transactionRepository.findByUserIdAndType(userId, type);
    }
    
    public List<Transaction> getTransactionsByUserAndDateRange(Integer userId, String startDate, String endDate) {
        return transactionRepository.findByUserIdAndTransactionDateBetween(userId, startDate, endDate);
    }
    
    @Transactional
    public Transaction createTransaction(Transaction transaction) {
        // Validasi input
        if (transaction.getAmount() == null || transaction.getAmount() <= 0) {
            throw new RuntimeException("Transaction amount must be positive");
        }
        if (transaction.getType() == null || transaction.getType().trim().isEmpty()) {
            throw new RuntimeException("Transaction type is required");
        }
        if (transaction.getCategoryId() == null) {
            throw new RuntimeException("Category is required");
        }
        if (transaction.getUserId() == null) {
            throw new RuntimeException("User is required");
        }
        if (transaction.getDescription() == null || transaction.getDescription().trim().isEmpty()) {
            throw new RuntimeException("Description is required");
        }
        if (transaction.getTransactionDate() == null || transaction.getTransactionDate().trim().isEmpty()) {
            throw new RuntimeException("Transaction date is required");
        }
        
        // Pastikan type dalam format yang benar
        String type = transaction.getType().toUpperCase().trim();
        
        // Pastikan description tidak kosong
        String description = transaction.getDescription().trim();
        
        // Pastikan transaction date dalam format YYYY-MM-DD
        if (!transaction.getTransactionDate().matches("\\d{4}-\\d{2}-\\d{2}")) {
            throw new RuntimeException("Transaction date must be in YYYY-MM-DD format");
        }
        
        try {
            // OPSI 1: Gunakan native query untuk INSERT (sudah berhasil)
            transactionRepository.insertTransaction(
                transaction.getUserId(),
                type,
                transaction.getAmount(),
                transaction.getCategoryId(),
                description,
                transaction.getTransactionDate()
            );
            
            // Dapatkan ID yang baru di-insert
            Integer newId = transactionRepository.getLastInsertId();
            
            // Set ID dan return transaction yang lengkap
            transaction.setId(newId);
            transaction.setType(type);
            transaction.setDescription(description);
            
            return transaction;
            
        } catch (Exception e) {
            // OPSI 2: Fallback ke JdbcTemplate jika native query gagal
            try {
                System.out.println("Native query failed, trying JdbcTemplate fallback...");
                return createTransactionWithJdbcTemplate(transaction, type, description);
            } catch (Exception jdbcEx) {
                throw new RuntimeException("Both native query and JdbcTemplate failed: " + e.getMessage() + " | " + jdbcEx.getMessage(), e);
            }
        }
    }
    
    // Method alternatif menggunakan JdbcTemplate
    @Transactional
    private Transaction createTransactionWithJdbcTemplate(Transaction transaction, String type, String description) {
        String sql = "INSERT INTO transactions (user_id, type, amount, category_id, description, transaction_date) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        jdbcTemplate.update(sql,
            transaction.getUserId(),
            type,
            transaction.getAmount(),
            transaction.getCategoryId(),
            description,
            transaction.getTransactionDate()
        );
        
        // Dapatkan ID yang baru di-insert
        Integer newId = jdbcTemplate.queryForObject("SELECT last_insert_rowid()", Integer.class);
        
        // Set ID dan return transaction yang lengkap
        transaction.setId(newId);
        transaction.setType(type);
        transaction.setDescription(description);
        
        return transaction;
    }
    
    @Transactional
    public Transaction updateTransaction(Integer id, Transaction transaction) {
        Transaction existingTransaction = transactionRepository.findById(id).orElse(null);
        if (existingTransaction == null) {
            throw new RuntimeException("Transaction not found");
        }
        
        if (transaction.getAmount() != null && transaction.getAmount() > 0) {
            existingTransaction.setAmount(transaction.getAmount());
        }
        if (transaction.getType() != null && !transaction.getType().trim().isEmpty()) {
            existingTransaction.setType(transaction.getType().toUpperCase().trim());
        }
        if (transaction.getCategoryId() != null) {
            existingTransaction.setCategoryId(transaction.getCategoryId());
        }
        if (transaction.getDescription() != null && !transaction.getDescription().trim().isEmpty()) {
            existingTransaction.setDescription(transaction.getDescription().trim());
        }
        if (transaction.getTransactionDate() != null && !transaction.getTransactionDate().trim().isEmpty()) {
            // Validasi format tanggal
            if (!transaction.getTransactionDate().matches("\\d{4}-\\d{2}-\\d{2}")) {
                throw new RuntimeException("Transaction date must be in YYYY-MM-DD format");
            }
            existingTransaction.setTransactionDate(transaction.getTransactionDate());
        }
        
        // Biarkan database handle updated_at secara otomatis
        // Tidak perlu set manual karena ada DEFAULT CURRENT_TIMESTAMP
        
        return transactionRepository.save(existingTransaction);
    }
    
    public void deleteTransaction(Integer id) {
        transactionRepository.deleteById(id);
    }
}
