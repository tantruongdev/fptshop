package com.sqlserver.fptshop.Entity;

import com.fasterxml.jackson.annotation.JsonIgnore;

import jakarta.persistence.Column;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "OrderIncludesProductLine")
public class OrderIncludesProductLine {

  @EmbeddedId
  private OrderIncludesProductLineId id;

  @Column(name = "Price")
  private Double Price;

  @Column(name = "Quantity")
  private Integer Quantity;

  @ManyToOne
  @JoinColumn(name = "OrderID", insertable = false, updatable = false)
  @JsonIgnore // Ngăn không cho serialize
  private Order order;

}
