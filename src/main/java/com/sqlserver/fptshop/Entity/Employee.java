package com.sqlserver.fptshop.Entity;

import java.sql.Date;
import java.time.LocalDate;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "employee")
@Data
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "employee_id")
    private Integer employeeId;

    @Column(unique = true, length = 12)
    private String identityCard;

    @Column(nullable = false, length = 40)
    private String lname;

    @Column(nullable = false, length = 15)
    private String fname;

    @Column(length = 10)
    private String phoneNumber;

    @Column(nullable = false)
    private LocalDate dob;

    @Column(name = "hire_date", nullable = false)
    private Date hireDate;

    private String email;

    @ManyToOne
    @JoinColumn(name = "supervisor_id")
    private Employee supervisor;

    private LocalDate superviseDate;

    @ManyToOne
    @JoinColumn(name = "store_id", nullable = false)
    private Store store;

    @Column(nullable = false)
    private Boolean isDeleted = false;
}
