package com.sqlserver.fptshop.Controller;

import com.sqlserver.fptshop.Entity.Store;
import com.sqlserver.fptshop.Service.StoreService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/stores")
public class StoreController {
  @Autowired
  private StoreService storeService;

  // Create or Update Store
  @PostMapping
  public ResponseEntity<Store> saveStore(@RequestBody Store store) {
    Store savedStore = storeService.saveStore(store);
    return ResponseEntity.ok(savedStore);
  }

  // Read All Stores
  @GetMapping
  public ResponseEntity<List<Store>> getAllStores() {
    List<Store> stores = storeService.getAllStores();
    return ResponseEntity.ok(stores);
  }

  // Read Store by ID
  @GetMapping("/{id}")
  public ResponseEntity<Store> getStoreById(@PathVariable("id") Integer storeID) {
    return storeService.getStoreById(storeID)
        .map(ResponseEntity::ok)
        .orElse(ResponseEntity.notFound().build());
  }

  // Delete Store
  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteStore(@PathVariable("id") Integer storeID) {
    storeService.deleteStore(storeID);
    return ResponseEntity.noContent().build();
  }
}
