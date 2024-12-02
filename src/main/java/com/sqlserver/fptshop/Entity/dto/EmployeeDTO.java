package com.sqlserver.fptshop.Entity.dto;

import java.util.Date;

import jakarta.persistence.Temporal;
import jakarta.persistence.TemporalType;
import lombok.Data;

@Data
public class EmployeeDTO {
  private Integer employeeId;
  private String identityCard;
  private String lname;
  private String fname;
  private String phoneNumber;

  @Temporal(TemporalType.DATE)
  private Date dob;

  @Temporal(TemporalType.DATE)
  private Date hireDate;
  private String email;
  private Integer supervisorId;
  @Temporal(TemporalType.DATE)
  private Date superviseDate;
  private Integer storeId;

}
