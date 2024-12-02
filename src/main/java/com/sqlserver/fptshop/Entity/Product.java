package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "product")
@Data
public class Product {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Integer serial;

  @ManyToOne
  @JoinColumn(name = "store_id", nullable = false)
  private Store store;

  @ManyToOne
  @JoinColumn(name = "device_id", nullable = false)
  private Device device;

  // @ManyToOne
  // @JoinColumn(name = "note_id")
  // private GoodsDeliveryNote note;
}
