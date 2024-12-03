package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.Data;

import java.io.Serializable;

@Embeddable
@Data
public class OrderIncludesProductLineId implements Serializable {

  private String productLineId;

  private String orderId;

  // Getters, Setters, equals, and hashCode
  // Tương tự như ở trên
}