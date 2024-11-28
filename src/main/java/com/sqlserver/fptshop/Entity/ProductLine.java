package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;

@Entity
@Table(name = "ProductLine")
public class ProductLine {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "Name", nullable = false)
    private String name;

    @Column(name = "Brand", nullable = false)
    private String brand;

    @Column(name = "IsUsed", nullable = false)
    private Boolean isUsed;

    @Column(name = "StockStatus", nullable = false)
    private Boolean stockStatus;

    @Column(name = "Price", nullable = false)
    private Double price;

    @Column(name = "Description")
    private String description;

    @Column(name = "Category")
    private String category;

    @Column(name = "Color")
    private String color;

    @ManyToOne
    @JoinColumn(name = "PromotionID")
    private Promotion promotion;

    @Column(name = "DiscountPercentage")
    private Short discountPercentage;

    @ManyToOne
    @JoinColumn(name = "CategoryTypeID", nullable = false)
    private CategoryType categoryType;

    // Getters and Setters
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public Boolean getUsed() {
        return isUsed;
    }

    public void setUsed(Boolean used) {
        isUsed = used;
    }

    public Boolean getStockStatus() {
        return stockStatus;
    }

    public void setStockStatus(Boolean stockStatus) {
        this.stockStatus = stockStatus;
    }

    public Double getPrice() {
        return price;
    }

    public void setPrice(Double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Promotion getPromotion() {
        return promotion;
    }

    public void setPromotion(Promotion promotion) {
        this.promotion = promotion;
    }

    public Short getDiscountPercentage() {
        return discountPercentage;
    }

    public void setDiscountPercentage(Short discountPercentage) {
        this.discountPercentage = discountPercentage;
    }

    public CategoryType getCategoryType() {
        return categoryType;
    }

    public void setCategoryType(CategoryType categoryType) {
        this.categoryType = categoryType;
    }
}
