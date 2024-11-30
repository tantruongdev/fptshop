package com.sqlserver.fptshop.Repository;

import com.sqlserver.fptshop.Entity.Store;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface StoreRepository extends JpaRepository<Store, String> {
  // JpaRepository cung cấp các phương thức CRUD mặc định
}
