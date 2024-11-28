package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "Employee")
public class Employee {
    @Id
    private String employeeID;

    @Column(name = "IdentityCard", unique = true, nullable = false)
    private String identityCard;

    @Column(name = "Lname", nullable = false)
    private String lname;

    @Column(name = "Fname", nullable = false)
    private String fname;

    @Column(name = "PhoneNumber", unique = true)
    private String phoneNumber;

    @Column(name = "DOB", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date dob;

    @Column(name = "HireDate", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date hireDate;

    @Column(name = "Email")
    private String email;

    @ManyToOne
    @JoinColumn(name = "SupervisorID")
    private Employee supervisor;

    @Column(name = "SuperviseDate")
    @Temporal(TemporalType.DATE)
    private Date superviseDate;

    @Column(name = "IsDeleted", nullable = true)
    private Boolean isDeleted = false;

    @ManyToOne
    @JoinColumn(name = "StoreID", nullable = false)
    private Store store;

    // Getters and Setters
    public String getEmployeeID() {
        return employeeID;
    }

    public void setEmployeeID(String employeeID) {
        this.employeeID = employeeID;
    }

    public String getIdentityCard() {
        return identityCard;
    }

    public void setIdentityCard(String identityCard) {
        this.identityCard = identityCard;
    }

    public String getLname() {
        return lname;
    }

    public void setLname(String lname) {
        this.lname = lname;
    }

    public String getFname() {
        return fname;
    }

    public void setFname(String fname) {
        this.fname = fname;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Employee getSupervisor() {
        return supervisor;
    }

    public void setSupervisor(Employee supervisor) {
        this.supervisor = supervisor;
    }

    public Date getSuperviseDate() {
        return superviseDate;
    }

    public void setSuperviseDate(Date superviseDate) {
        this.superviseDate = superviseDate;
    }

    public Boolean getIsDeleted() {
        return isDeleted != null ? isDeleted : false;
    }

    public void setIsDeleted(Boolean isDeleted) {
        this.isDeleted = isDeleted != null ? isDeleted : false;
    }

    public Store getStore() {
        return store;
    }

    public void setStore(Store store) {
        this.store = store;
    }
}
