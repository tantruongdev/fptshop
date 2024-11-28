package com.sqlserver.fptshop.Entity.dto;

import java.util.Date;

import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;

public class EmployeeDTO {
  private String employeeID;
  private String identityCard;
  private String lname;
  private String fname;
  private String phoneNumber;

  @Temporal(TemporalType.DATE)
  private Date dob;

  @Temporal(TemporalType.DATE)
  private Date hireDate;
  private String email;
  private String supervisorID;
  @Temporal(TemporalType.DATE)
  private Date superviseDate;
  private String storeID;

  public String getEmployeeID() {
    return employeeID;
  }

  public void setEmployeeId(String employeeID) {
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

  public String getSupervisorID() {
    return supervisorID;
  }

  public void setSupervisorID(String supervisorID) {
    this.supervisorID = supervisorID;
  }

  public Date getSuperviseDate() {
    return superviseDate;
  }

  public void setSuperviseDate(Date superviseDate) {
    this.superviseDate = superviseDate;
  }

  public String getStoreID() {
    return storeID;
  }

  public void setStoreID(String storeID) {
    this.storeID = storeID;
  }

}
