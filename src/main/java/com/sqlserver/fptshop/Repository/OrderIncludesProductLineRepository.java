package com.sqlserver.fptshop.Repository;

import com.sqlserver.fptshop.Entity.OrderIncludesProductLine;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLineId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface OrderIncludesProductLineRepository
    extends JpaRepository<OrderIncludesProductLine, OrderIncludesProductLineId> {

  @Procedure(procedureName = "spAddProductToOrder")
  public String addProductToOrder(
      @Param("orderId") Integer orderId,
      @Param("productLineId") Integer productLineId,
      @Param("price") Double price,
      @Param("quantity") Integer quantity);

  @Procedure(procedureName = "spRemoveProductFromOrder")
  public String removeProductFromOrder(
      @Param("orderId") Integer orderId,
      @Param("productLineId") Integer productLineId);

}
