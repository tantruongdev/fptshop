package com.sqlserver.fptshop.Repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import com.sqlserver.fptshop.Entity.Order;

public interface OrderRepository extends JpaRepository<Order, Integer> {

  @Procedure(procedureName = "spCreateOrder")
  public String createOrder(
      @Param("customerId") Integer customerId,
      @Param("employeeId") Integer employeeId,
      @Param("deliveryId") Integer deliveryId,
      @Param("orderStatus") String orderStatus);

  @Procedure(procedureName = "spUpdateOrderStatus")
  public String updateOrderStatus(
      @Param("orderId") Integer orderId,
      @Param("orderStatus") String orderStatus);

  @Procedure(procedureName = "spDeleteOrder")
  public String deleteOrder(
      @Param("orderId") Integer orderId);
}
