package com.sqlserver.fptshop.Entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "order_includes_product_line")
public class OrderIncludesProductLine {

  @EmbeddedId
  private OrderIncludesProductLineId id;

  private Double Price;

  private Integer Quantity;

  @ManyToOne
  @JoinColumn(name = "orderId", insertable = false, updatable = false)
  @JsonIgnore // Ngăn không cho serialize
  private Order order;

}
