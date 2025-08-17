package com.expensetracker.repository;

import com.expensetracker.entity.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Integer> {

    List<Transaction> findByUserId(Integer userId);
    
    List<Transaction> findByType(String type);
    
    List<Transaction> findByCategoryId(Integer categoryId);
    
    List<Transaction> findByUserIdAndType(Integer userId, String type);
    
    @Query("SELECT t FROM Transaction t WHERE t.transactionDate BETWEEN :startDate AND :endDate")
    List<Transaction> findByTransactionDateBetween(@Param("startDate") String startDate, @Param("endDate") String endDate);
    
    @Query("SELECT t FROM Transaction t WHERE t.userId = :userId AND t.transactionDate BETWEEN :startDate AND :endDate")
    List<Transaction> findByUserIdAndTransactionDateBetween(@Param("userId") Integer userId, @Param("startDate") String startDate, @Param("endDate") String endDate);
}
