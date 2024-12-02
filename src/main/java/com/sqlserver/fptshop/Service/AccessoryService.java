package com.sqlserver.fptshop.Service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sqlserver.fptshop.Entity.Accessory;
import com.sqlserver.fptshop.Repository.AccessoryRepository;

import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;
import java.util.Optional;

@Service
public class AccessoryService {

  @Autowired
  private AccessoryRepository accessoryRepository;

  public List<Accessory> getAllAccessories() {
    return accessoryRepository.findAll();
  }

  @Transactional
  public Optional<Accessory> getAccessoryDetails(Integer id) {
    return accessoryRepository.findById(id);
  }

  public Accessory saveAccessory(Accessory accessory) {
    return accessoryRepository.save(accessory);
  }

  public void deleteAccessory(Integer id) {
    accessoryRepository.deleteById(id);
  }
}
