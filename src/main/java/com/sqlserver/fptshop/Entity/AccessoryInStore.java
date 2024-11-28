package com.sqlserver.fptshop.Entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "AccessoryInStore")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AccessoryInStore {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne
  @JoinColumn(name = "AccessoryID", referencedColumnName = "ID", nullable = false)
  private Accessory accessory;

  @ManyToOne
  @JoinColumn(name = "StoreID", referencedColumnName = "StoreID", nullable = false)
  private Store store;

  @Column(name = "StockQuantity", nullable = false)
  private Integer stockQuantity;
}
