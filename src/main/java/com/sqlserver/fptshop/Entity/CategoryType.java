package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "category_type")
@Data
public class CategoryType {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer categoryTypeId;

    @Column(nullable = false, length = 30, unique = true)
    private String name;
}
