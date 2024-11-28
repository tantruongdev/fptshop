package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;



@Entity
@Table(name = "Store")
public class Store {
    @Id
    private String storeID;

    @Column(name = "NumberOfEmployees", nullable = false)
    private Integer numberOfEmployees;

    @Column(name = "Area")
    private Double area;

    @Column(name = "StoreName")
    private String storeName;

    @Column(name = "Address", unique = true, nullable = false)
    private String address;

    // Getters and Setters

    public String getStoreID() {
        return storeID;
    }

    public void setStoreID(String storeID) {
        this.storeID = storeID;
    }

    public Integer getNumberOfEmployees() {
        return numberOfEmployees;
    }

    public void setNumberOfEmployees(Integer numberOfEmployees) {
        this.numberOfEmployees = numberOfEmployees;
    }

    public Double getArea() {
        return area;
    }

    public void setArea(Double area) {
        this.area = area;
    }

    public String getStoreName() {
        return storeName;
    }

    public void setStoreName(String storeName) {
        this.storeName = storeName;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}