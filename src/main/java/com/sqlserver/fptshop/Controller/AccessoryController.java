package com.sqlserver.fptshop.Controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.sqlserver.fptshop.Entity.Accessory;
import com.sqlserver.fptshop.Service.AccessoryService;

import java.util.List;

@RestController
@RequestMapping("/api/accessories")
public class AccessoryController {

  @Autowired
  private AccessoryService accessoryService;

  @GetMapping
  public List<Accessory> getAllAccessories() {
    return accessoryService.getAllAccessories();
  }

  @GetMapping("/{id}")
  public ResponseEntity<Accessory> getAccessoryById(@PathVariable Integer id) {
    return accessoryService.getAccessoryDetails(id)
        .map(ResponseEntity::ok)
        .orElse(ResponseEntity.notFound().build());
  }

  @PostMapping
  public Accessory createAccessory(@RequestBody Accessory accessory) {
    return accessoryService.saveAccessory(accessory);
  }

  @PutMapping("/{id}")
  public ResponseEntity<Accessory> updateAccessory(@PathVariable Integer id, @RequestBody Accessory accessory) {
    if (!accessoryService.getAccessoryDetails(id).isPresent()) {
      return ResponseEntity.notFound().build();
    }
    accessory.setId(id);
    return ResponseEntity.ok(accessoryService.saveAccessory(accessory));
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteAccessory(@PathVariable Integer id) {
    if (!accessoryService.getAccessoryDetails(id).isPresent()) {
      return ResponseEntity.notFound().build();
    }
    accessoryService.deleteAccessory(id);
    return ResponseEntity.noContent().build();
  }
}
