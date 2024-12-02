package com.sqlserver.fptshop.Entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.MapsId;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "accessory")
@Data
public class Accessory {
  @Id
  private Integer id;

  private String batteryCapacity;

  @OneToOne
  @MapsId
  @JoinColumn(name = "id")
  private ProductLine productLine;
}
