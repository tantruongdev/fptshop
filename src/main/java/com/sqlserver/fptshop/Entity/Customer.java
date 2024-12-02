package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDate;
import java.util.Date;

@Entity
@Table(name = "customer")
@Data
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer customerId;

    @Column(unique = true, nullable = false, length = 10)
    private String phoneNumber;

    @Column(unique = true, length = 50)
    private String email;

    @Column(nullable = false)
    private LocalDate registrationDate;

    private String shippingAddress;

    @Column(nullable = false, length = 40)
    private String lname;

    @Column(nullable = false, length = 15)
    private String fname;

    @Column(nullable = false)
    private Integer totalPoints;

    @ManyToOne
    @JoinColumn(name = "membership_class_id", nullable = false)
    private MembershipClass membershipClass;

    @Column(nullable = false)
    private Boolean isDeleted = false;
}
