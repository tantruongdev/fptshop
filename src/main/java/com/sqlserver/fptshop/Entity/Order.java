package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;
import lombok.Data;

import java.util.Date;
import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Data
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

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<OrderIncludesProductLine> orderIncludesProductLines;

    // @ManyToOne
    // @JoinColumn(name = "DeliveryID")
    // private Delivery delivery;

    // Getters and Setters
}