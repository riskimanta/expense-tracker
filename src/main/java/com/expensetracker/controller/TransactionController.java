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
        return transactionService.getTransactionById(id)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
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
    public ResponseEntity<Transaction> createTransaction(@RequestBody Transaction transaction) {
        try {
            Transaction createdTransaction = transactionService.createTransaction(transaction);
            return ResponseEntity.ok(createdTransaction);
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().build();
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
