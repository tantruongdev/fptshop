package com.sqlserver.fptshop.Entity.dto;

import lombok.Data;

@Data
public class CustomerOrderDTO {

  private Integer rank;
  private Integer customerId;
  private String lname;
  private String fname;
  private Double totalOrderAmount;
  private Integer noPurchases;
  private Integer totalPoints;

  // Getters and setters
}
