package com.expensetracker.repository;

import com.expensetracker.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {

    List<Transaction> findByUserId(Integer userId);

    List<Transaction> findByCategoryId(Integer categoryId);

    List<Transaction> findByType(String type);

    List<Transaction> findByUserIdAndType(Integer userId, String type);

    List<Transaction> findByUserIdAndTransactionDateBetween(Integer userId, String startDate, String endDate);

    // Native query untuk INSERT - handle SQLite generated-keys issue
    @Modifying
    @Query(value = "INSERT INTO transactions (user_id, type, amount, category_id, description, transaction_date) " +
                   "VALUES (:userId, :type, :amount, :categoryId, :description, :transactionDate)", 
           nativeQuery = true)
    void insertTransaction(@Param("userId") Integer userId,
                         @Param("type") String type,
                         @Param("amount") Double amount,
                         @Param("categoryId") Integer categoryId,
                         @Param("description") String description,
                         @Param("transactionDate") String transactionDate);

    // Query untuk mendapatkan ID terakhir yang di-insert
    @Query(value = "SELECT last_insert_rowid()", nativeQuery = true)
    Integer getLastInsertId();
}
