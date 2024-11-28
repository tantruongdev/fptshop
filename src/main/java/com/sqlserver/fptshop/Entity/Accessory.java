package com.sqlserver.fptshop.Entity;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonManagedReference;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Accessory")
@Data // Tự động tạo getter, setter, toString, equals, hashCode
@NoArgsConstructor
@AllArgsConstructor
public class Accessory {

  @Id
  @Column(name = "ID", length = 8)
  private String id;

  @Column(name = "BatteryCapacity", length = 30)
  private String batteryCapacity;

  // @OneToOne
  // @JoinColumn(name = "ID", referencedColumnName = "ID")
  // private ProductLine productLine;

  @OneToMany(mappedBy = "accessory", cascade = CascadeType.ALL)
  private List<Connection> connections;

  // @OneToMany(mappedBy = "accessory", cascade = CascadeType.ALL)
  // private List<AccessoryInStore> accessoryInStores;

}
