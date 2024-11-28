package com.sqlserver.fptshop.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sqlserver.fptshop.Entity.Accessory;

public interface AccessoryRepository extends JpaRepository<Accessory, String> {
}
