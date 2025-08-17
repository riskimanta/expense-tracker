package com.expensetracker.service;

import com.expensetracker.entity.User;
import com.expensetracker.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

    public Optional<User> getUserById(Integer id) {
        return userRepository.findById(id);
    }

    public Optional<User> getUserByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    public User createUser(User user) {
        if (userRepository.existsByEmail(user.getEmail())) {
            throw new RuntimeException("Email sudah terdaftar");
        }
        
        // Encode password
        user.setPasswordHash(passwordEncoder.encode(user.getPasswordHash()));
        
        // Set default values
        if (user.getRole() == null) {
            user.setRole("USER");
        }
        if (user.getStatus() == null) {
            user.setStatus("ACTIVE");
        }
        
        return userRepository.save(user);
    }

    public User updateUser(Integer id, User userDetails) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User tidak ditemukan"));
        
        user.setName(userDetails.getName());
        user.setEmail(userDetails.getEmail());
        user.setRole(userDetails.getRole());
        user.setStatus(userDetails.getStatus());
        
        // Update password if provided
        if (userDetails.getPasswordHash() != null && !userDetails.getPasswordHash().isEmpty()) {
            user.setPasswordHash(passwordEncoder.encode(userDetails.getPasswordHash()));
        }
        
        return userRepository.save(user);
    }

    public void deleteUser(Integer id) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("User tidak ditemukan"));
        userRepository.delete(user);
    }

    public List<User> getUsersByRole(String role) {
        return userRepository.findByRole(role);
    }

    public List<User> getUsersByStatus(String status) {
        return userRepository.findByStatus(status);
    }

    public long countUsersByRole(String role) {
        return userRepository.countByRole(role);
    }

    public List<User> searchUsers(String name, String email) {
        return userRepository.searchUsers(name, email);
    }

    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }
}
