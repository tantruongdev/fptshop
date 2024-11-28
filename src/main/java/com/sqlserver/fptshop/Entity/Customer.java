package com.sqlserver.fptshop.Entity;

import jakarta.persistence.*;

import java.util.Date;

@Entity
@Table(name = "Customer")
public class Customer {
    @Id
    private String customerID;

    @Column(name = "PhoneNumber", unique = true, nullable = false)
    private String phoneNumber;

    @Column(name = "Email", unique = true)
    private String email;

    @Column(name = "RegistrationDate", nullable = false)
    private Date registrationDate;

    @Column(name = "ShippingAddress")
    private String shippingAddress;

    @Column(name = "Lname", nullable = false)
    private String lname;

    @Column(name = "Fname", nullable = false)
    private String fname;

    @Column(name = "TotalPoints", nullable = false)
    private Integer totalPoints;

    @ManyToOne
    @JoinColumn(name = "MembershipClass", nullable = false)
    private MembershipClass membershipClass;

    // Getters and Setters

    public String getCustomerID() {
        return customerID;
    }

    public void setCustomerID(String customerID) {
        this.customerID = customerID;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Date getRegistrationDate() {
        return registrationDate;
    }

    public void setRegistrationDate(Date registrationDate) {
        this.registrationDate = registrationDate;
    }

    public String getShippingAddress() {
        return shippingAddress;
    }

    public void setShippingAddress(String shippingAddress) {
        this.shippingAddress = shippingAddress;
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

    public Integer getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }

    public MembershipClass getMembershipClass() {
        return membershipClass;
    }

    public void setMembershipClass(MembershipClass membershipClass) {
        this.membershipClass = membershipClass;
    }
}