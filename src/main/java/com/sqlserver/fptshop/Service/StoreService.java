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
