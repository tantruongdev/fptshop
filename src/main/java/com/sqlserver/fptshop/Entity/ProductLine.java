package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "product_line")
@Data
public class ProductLine {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 50)
    private String brand;

    @Column(nullable = false)
    private Boolean isUsed;

    @Column(nullable = false)
    private Boolean stockStatus;

    @Column(nullable = false)
    private Double price;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(nullable = false, length = 15)
    private String category;

    @Column(length = 15)
    private String color;

    @ManyToOne
    @JoinColumn(name = "promotion_id")
    private Promotion promotion;

    @Column(nullable = false)
    private Short discountPercentage;

    @ManyToOne
    @JoinColumn(name = "category_type_id", nullable = false)
    private CategoryType categoryType;
}
