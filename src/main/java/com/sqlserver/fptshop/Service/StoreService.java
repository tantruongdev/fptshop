package com.sqlserver.fptshop.Service;

import com.sqlserver.fptshop.Entity.Store;
import com.sqlserver.fptshop.Repository.StoreRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class StoreService {
  @Autowired
  private StoreRepository storeRepository;

  // Create or Update Store
  public Store saveStore(Store store) {
    return storeRepository.save(store);
  }

  public Store updateStore(Integer storeId, Store store) {
    Optional<Store> existingStore = storeRepository.findById(storeId);
    if (existingStore.isPresent()) {
      Store updatedStore = existingStore.get();
      updatedStore.setStoreName(store.getStoreName());
      updatedStore.setAddress(store.getAddress());
      updatedStore.setNumberOfEmployees(store.getNumberOfEmployees());
      updatedStore.setArea(store.getArea());
      return storeRepository.save(updatedStore);
    }
    return null;
  }

  // Read All Stores
  public List<Store> getAllStores() {
    return storeRepository.findAll();
  }

  // Read Store by ID
  public Optional<Store> getStoreById(Integer storeID) {
    return storeRepository.findById(storeID);
  }

  // Delete Store
  public void deleteStore(Integer storeID) {
    storeRepository.deleteById(storeID);
  }
}
