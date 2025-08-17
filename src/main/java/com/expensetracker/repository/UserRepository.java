package com.expensetracker.repository;

import com.expensetracker.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {

    Optional<User> findByEmail(String email);
    
    boolean existsByEmail(String email);
    
    List<User> findByRole(String role);
    
    List<User> findByStatus(String status);
    
    @Query("SELECT u FROM User u WHERE u.email = :email AND u.status = 'ACTIVE'")
    Optional<User> findActiveUserByEmail(@Param("email") String email);
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.role = :role")
    long countByRole(@Param("role") String role);
    
    @Query("SELECT u FROM User u WHERE u.name LIKE %:name% OR u.email LIKE %:email%")
    List<User> searchUsers(@Param("name") String name, @Param("email") String email);
}
