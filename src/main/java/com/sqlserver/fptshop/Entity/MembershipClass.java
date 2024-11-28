package com.sqlserver.fptshop.Entity;


import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "MembershipClass")
public class MembershipClass {
    @Id
    private String name;

    @Column(name = "DiscountPercent", nullable = false)
    private Short discountPercent;

    @Column(name = "MinimumNoPoint", nullable = false)
    private Integer minimumNoPoint;

    // Getters and Setters

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Short getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(Short discountPercent) {
        this.discountPercent = discountPercent;
    }

    public Integer getMinimumNoPoint() {
        return minimumNoPoint;
    }

    public void setMinimumNoPoint(Integer minimumNoPoint) {
        this.minimumNoPoint = minimumNoPoint;
    }
}