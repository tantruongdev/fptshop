package com.sqlserver.fptshop.Entity;


import jakarta.persistence.*;


@Entity
@Table(name = "Device")
public class Device {
    @Id
    @Column(name = "ID")
    private String id;

    @Column(name = "RAM")
    private Short ram;

    @Column(name = "OperatorSystem")
    private String operatorSystem;

    @Column(name = "BatteryCapacity")
    private String batteryCapacity;

    @Column(name = "Weight")
    private String weight;

    @Column(name = "Camera")
    private String camera;

    @Column(name = "Storage")
    private String storage;

    @Column(name = "ScreenSize")
    private String screenSize;

    @Column(name = "DisplayResolution")
    private String displayResolution;

    @OneToOne
    @JoinColumn(name = "ID", referencedColumnName = "ID")
    private ProductLine productLine;

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Short getRam() {
        return ram;
    }

    public void setRam(Short ram) {
        this.ram = ram;
    }

    public String getOperatorSystem() {
        return operatorSystem;
    }

    public void setOperatorSystem(String operatorSystem) {
        this.operatorSystem = operatorSystem;
    }

    public String getBatteryCapacity() {
        return batteryCapacity;
    }

    public void setBatteryCapacity(String batteryCapacity) {
        this.batteryCapacity = batteryCapacity;
    }

    public String getWeight() {
        return weight;
    }

    public void setWeight(String weight) {
        this.weight = weight;
    }

    public String getCamera() {
        return camera;
    }

    public void setCamera(String camera) {
        this.camera = camera;
    }

    public String getStorage() {
        return storage;
    }

    public void setStorage(String storage) {
        this.storage = storage;
    }

    public String getScreenSize() {
        return screenSize;
    }

    public void setScreenSize(String screenSize) {
        this.screenSize = screenSize;
    }

    public String getDisplayResolution() {
        return displayResolution;
    }

    public void setDisplayResolution(String displayResolution) {
        this.displayResolution = displayResolution;
    }

    public ProductLine getProductLine() {
        return productLine;
    }

    public void setProductLine(ProductLine productLine) {
        this.productLine = productLine;
    }
}
