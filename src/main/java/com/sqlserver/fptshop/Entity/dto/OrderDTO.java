package com.sqlserver.fptshop.Entity.dto;

import java.util.Date;

import lombok.Data;

@Data
public class OrderDTO {

  private Integer orderId;

  private Date orderDate;

  private Double totalAmount;

  private String orderStatus;

  private Integer customerId;

  private Integer employeeId;

  private Integer deliveryId;

}
