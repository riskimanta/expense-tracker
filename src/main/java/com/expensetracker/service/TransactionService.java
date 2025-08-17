package com.expensetracker.service;

import com.expensetracker.entity.Transaction;
import com.expensetracker.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;



import java.util.List;
import java.util.Optional;

@Service
public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepository;

    public List<Transaction> getAllTransactions() {
        return transactionRepository.findAll();
    }

    public Optional<Transaction> getTransactionById(Integer id) {
        return transactionRepository.findById(id);
    }

    public List<Transaction> getTransactionsByUser(Integer userId) {
        return transactionRepository.findByUserId(userId);
    }

    public List<Transaction> getTransactionsByType(String type) {
        return transactionRepository.findByType(type);
    }

    public List<Transaction> getTransactionsByCategory(Integer categoryId) {
        return transactionRepository.findByCategoryId(categoryId);
    }

    public Transaction createTransaction(Transaction transaction) {
        if (transaction.getAmount() == null || transaction.getAmount() <= 0) {
            throw new RuntimeException("Transaction amount must be positive");
        }
        if (transaction.getType() == null) {
            throw new RuntimeException("Transaction type is required");
        }
        if (transaction.getCategoryId() == null) {
            throw new RuntimeException("Category is required");
        }
        if (transaction.getUserId() == null) {
            throw new RuntimeException("User is required");
        }
        return transactionRepository.save(transaction);
    }

    public Transaction updateTransaction(Integer id, Transaction transactionDetails) {
        Transaction transaction = transactionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Transaction not found"));

        if (transactionDetails.getAmount() != null && transactionDetails.getAmount() > 0) {
            transaction.setAmount(transactionDetails.getAmount());
        }
        if (transactionDetails.getType() != null) {
            transaction.setType(transactionDetails.getType());
        }
        if (transactionDetails.getCategoryId() != null) {
            transaction.setCategoryId(transactionDetails.getCategoryId());
        }
        if (transactionDetails.getDescription() != null) {
            transaction.setDescription(transactionDetails.getDescription());
        }
        if (transactionDetails.getTransactionDate() != null) {
            transaction.setTransactionDate(transactionDetails.getTransactionDate());
        }

        return transactionRepository.save(transaction);
    }

    public void deleteTransaction(Integer id) {
        if (!transactionRepository.existsById(id)) {
            throw new RuntimeException("Transaction not found");
        }
        transactionRepository.deleteById(id);
    }
}
