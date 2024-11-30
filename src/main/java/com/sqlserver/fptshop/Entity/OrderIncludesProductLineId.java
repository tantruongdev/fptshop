package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class OrderIncludesProductLineId implements Serializable {

  @Column(name = "ProductLineID")
  private String productLineID;

  @Column(name = "OrderID")
  private String orderID;

  // Getters, Setters, equals, and hashCode
  // Tương tự như ở trên
}