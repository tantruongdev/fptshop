package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "membership_class")
@Data
public class MembershipClass {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(unique = true, nullable = false, length = 30)
    private String name;

    @Column(unique = true, nullable = false)
    private Short discountPercent;

    @Column(unique = true, nullable = false)
    private Integer minimumNoPoint;
}
