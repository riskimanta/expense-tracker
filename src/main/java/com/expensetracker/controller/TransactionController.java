package com.expensetracker.controller;

import com.expensetracker.entity.Transaction;
import com.expensetracker.service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/transactions")
@CrossOrigin(origins = "*")
public class TransactionController {

    @Autowired
    private TransactionService transactionService;

    @GetMapping
    public ResponseEntity<List<Transaction>> getAllTransactions() {
        List<Transaction> transactions = transactionService.getAllTransactions();
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Transaction> getTransactionById(@PathVariable Integer id) {
        Transaction transaction = transactionService.getTransactionById(id);
        if (transaction != null) {
            return ResponseEntity.ok(transaction);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<Transaction>> getTransactionsByUser(@PathVariable Integer userId) {
        List<Transaction> transactions = transactionService.getTransactionsByUser(userId);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/type/{type}")
    public ResponseEntity<List<Transaction>> getTransactionsByType(@PathVariable String type) {
        List<Transaction> transactions = transactionService.getTransactionsByType(type);
        return ResponseEntity.ok(transactions);
    }

    @GetMapping("/category/{categoryId}")
    public ResponseEntity<List<Transaction>> getTransactionsByCategory(@PathVariable Integer categoryId) {
        List<Transaction> transactions = transactionService.getTransactionsByCategory(categoryId);
        return ResponseEntity.ok(transactions);
    }

    @PostMapping
    public ResponseEntity<?> createTransaction(@RequestBody Transaction transaction) {
        try {
            System.out.println("=== CREATE TRANSACTION REQUEST ===");
            System.out.println("Received transaction: " + transaction);
            System.out.println("Transaction type: " + (transaction.getType() != null ? transaction.getType() : "NULL"));
            System.out.println("Transaction amount: " + (transaction.getAmount() != null ? transaction.getAmount() : "NULL"));
            System.out.println("Transaction categoryId: " + (transaction.getCategoryId() != null ? transaction.getCategoryId() : "NULL"));
            System.out.println("Transaction userId: " + (transaction.getUserId() != null ? transaction.getUserId() : "NULL"));
            System.out.println("Transaction description: " + (transaction.getDescription() != null ? transaction.getDescription() : "NULL"));
            System.out.println("Transaction date: " + (transaction.getTransactionDate() != null ? transaction.getTransactionDate() : "NULL"));
            System.out.println("=================================");
            
            // Validate required fields
            if (transaction.getType() == null || transaction.getType().trim().isEmpty()) {
                System.err.println("ERROR: Transaction type is required");
                return ResponseEntity.badRequest().body("Transaction type is required");
            }
            if (transaction.getAmount() == null || transaction.getAmount() <= 0) {
                System.err.println("ERROR: Transaction amount must be positive");
                return ResponseEntity.badRequest().body("Transaction amount must be positive");
            }
            if (transaction.getCategoryId() == null) {
                System.err.println("ERROR: Category ID is required");
                return ResponseEntity.badRequest().body("Category ID is required");
            }
            if (transaction.getUserId() == null) {
                System.err.println("ERROR: User ID is required");
                return ResponseEntity.badRequest().body("User ID is required");
            }
            if (transaction.getDescription() == null || transaction.getDescription().trim().isEmpty()) {
                System.err.println("ERROR: Description is required");
                return ResponseEntity.badRequest().body("Description is required");
            }
            if (transaction.getTransactionDate() == null || transaction.getTransactionDate().trim().isEmpty()) {
                System.err.println("ERROR: Transaction date is required");
                return ResponseEntity.badRequest().body("Transaction date is required");
            }
            
            System.out.println("All validations passed, calling service...");
            Transaction createdTransaction = transactionService.createTransaction(transaction);
            System.out.println("Transaction created successfully: " + createdTransaction.getId());
            return ResponseEntity.ok(createdTransaction);
        } catch (RuntimeException e) {
            System.err.println("RuntimeException in createTransaction: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.badRequest().body("Error: " + e.getMessage());
        } catch (Exception e) {
            System.err.println("Unexpected error in createTransaction: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Unexpected error: " + e.getMessage());
        }
    }

    @PutMapping("/{id}")
    public ResponseEntity<Transaction> updateTransaction(@PathVariable Integer id, @RequestBody Transaction transactionDetails) {
        try {
            Transaction updatedTransaction = transactionService.updateTransaction(id, transactionDetails);
            return ResponseEntity.ok(updatedTransaction);
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteTransaction(@PathVariable Integer id) {
        try {
            transactionService.deleteTransaction(id);
            return ResponseEntity.ok().build();
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
