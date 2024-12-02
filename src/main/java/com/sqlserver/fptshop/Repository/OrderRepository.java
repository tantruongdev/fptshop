package com.sqlserver.fptshop.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sqlserver.fptshop.Entity.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {
  // Bạn có thể thêm các phương thức truy vấn tùy chỉnh ở đây nếu cần
}
