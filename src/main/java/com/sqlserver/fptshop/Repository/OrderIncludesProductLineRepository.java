package com.sqlserver.fptshop.Repository;

import com.sqlserver.fptshop.Entity.OrderIncludesProductLine;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLineId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderIncludesProductLineRepository
    extends JpaRepository<OrderIncludesProductLine, OrderIncludesProductLineId> {
  // Bạn có thể thêm các phương thức truy vấn tùy chỉnh tại đây nếu cần
}
