package com.sqlserver.fptshop.Entity;

import com.fasterxml.jackson.annotation.JsonBackReference;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "Connections")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Connection {

  @Id
  @Column(name = "AccessoryID", insertable = false, updatable = false)
  private String accessoryID;

  @ManyToOne
  @JoinColumn(name = "AccessoryID", referencedColumnName = "ID", nullable = false)
  private Accessory accessory;

  @Column(name = "Connection", length = 30, nullable = false)
  private String connectionType;
}
