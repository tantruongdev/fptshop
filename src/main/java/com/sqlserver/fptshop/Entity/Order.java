package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "[Order]")
public class Order {
    @Id
    private String orderID;

    @Column(name = "OrderDate")
    @Temporal(TemporalType.DATE)
    private Date orderDate;

    @Column(name = "OrderStatus", nullable = false)
    private String orderStatus;

    @Column(name = "TotalAmount", nullable = false)
    private Double totalAmount;

    @ManyToOne
    @JoinColumn(name = "EmployeeID")
    private Employee employee;

    @ManyToOne
    @JoinColumn(name = "CustomerID", nullable = false)
    private Customer customer;

//    @ManyToOne
//    @JoinColumn(name = "DeliveryID")
//    private Delivery delivery;

    // Getters and Setters
}