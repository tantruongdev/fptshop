package com.sqlserver.fptshop.Entity.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class CustomerCreateDTO {
  private String phoneNumber;
  private String email;

  private String shippingAddress;
  private String lname;
  private String fname;
  private Integer membershipClassId;
}
