package com.expensetracker.service;

import com.expensetracker.entity.Category;
import com.expensetracker.repository.CategoryRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class CategoryService {

    @Autowired
    private CategoryRepository categoryRepository;

    public List<Category> getAllCategories() {
        return categoryRepository.findAll();
    }

    public Optional<Category> getCategoryById(Integer id) {
        return categoryRepository.findById(id);
    }

    public List<Category> getCategoriesByType(String type) {
        return categoryRepository.findByType(type);
    }

    public List<Category> getCategoriesByUser(Integer userId) {
        return categoryRepository.findByUserId(userId);
    }

    public Category createCategory(Category category) {
        if (category.getName() == null || category.getName().trim().isEmpty()) {
            throw new RuntimeException("Category name is required");
        }
        if (category.getType() == null) {
            throw new RuntimeException("Category type is required");
        }
        return categoryRepository.save(category);
    }

    public Category updateCategory(Integer id, Category categoryDetails) {
        Category category = categoryRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Category not found"));

        if (categoryDetails.getName() != null) {
            category.setName(categoryDetails.getName());
        }
        if (categoryDetails.getType() != null) {
            category.setType(categoryDetails.getType());
        }
        if (categoryDetails.getColor() != null) {
            category.setColor(categoryDetails.getColor());
        }
        if (categoryDetails.getIcon() != null) {
            category.setIcon(categoryDetails.getIcon());
        }

        return categoryRepository.save(category);
    }

    public void deleteCategory(Integer id) {
        if (!categoryRepository.existsById(id)) {
            throw new RuntimeException("Category not found");
        }
        categoryRepository.deleteById(id);
    }
}
