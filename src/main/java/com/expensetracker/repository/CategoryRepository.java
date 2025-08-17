package com.expensetracker.repository;

import com.expensetracker.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    List<Category> findByType(String type);
    
    List<Category> findByUserId(Integer userId);
    
    List<Category> findByTypeAndUserId(String type, Integer userId);
    
    @Query("SELECT c FROM Category c WHERE c.name LIKE %:name%")
    List<Category> findByNameContaining(@Param("name") String name);
    
    @Query("SELECT c FROM Category c WHERE c.isDefault = 1")
    List<Category> findDefaultCategories();
}
