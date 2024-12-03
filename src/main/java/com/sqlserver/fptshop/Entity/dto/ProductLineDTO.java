package com.sqlserver.fptshop.Entity.dto;

import lombok.Data;

@Data
public class ProductLineDTO {

  private Integer productLineId;

  private Integer orderId;

  private Double price;

  private Integer quantity;
}
