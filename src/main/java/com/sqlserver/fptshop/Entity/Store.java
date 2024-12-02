package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "store")
@Data
public class Store {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer storeId;

    @Column(nullable = false)
    private Integer numberOfEmployees;

    // @Column(precision = 15)
    private Double area;

    @Column(nullable = false, length = 50)
    private String storeName;

    @Column(nullable = false, length = 150, unique = true)
    private String address;
}
