package com.sqlserver.fptshop.Entity;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "CategoryType")
public class CategoryType {
    @Id
    private String categoryTypeID;

    @Column(name = "Name", nullable = false, unique = true)
    private String name;

    // Getters and Setters


    public String getCategoryTypeID() {
        return categoryTypeID;
    }

    public void setCategoryTypeID(String categoryTypeID) {
        this.categoryTypeID = categoryTypeID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}