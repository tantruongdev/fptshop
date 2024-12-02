package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "device")
@Data
public class Device {
    @Id
    private Integer id;

    private String ram;

    private String operatorSystem;

    private String batteryCapacity;

    private String weight;

    private String camera;

    private String storage;

    private String screenSize;

    private String displayResolution;

    @OneToOne
    @MapsId
    @JoinColumn(name = "id")
    private ProductLine productLine;
}
