package com.sqlserver.fptshop.Repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;

import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.dto.CustomerOrderDTO;

import jakarta.persistence.Tuple;

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

    @Query(value = "SELECT dbo.CalculateTotalSales(:p_ProductLineID, :p_StartDate, :p_EndDate)", nativeQuery = true)
    Integer calculateTotalSales(@Param("p_ProductLineID") Integer productLineId,
            @Param("p_StartDate") LocalDate startDate,
            @Param("p_EndDate") LocalDate endDate);

    @Query(value = "SELECT * from dbo.HighestOrderAmount(:p_number, :p_StartDate, :p_EndDate)", nativeQuery = true)
    List<Tuple> getHighestOrderAmount(@Param("p_number") Integer number,
            @Param("p_StartDate") LocalDate startDate,
            @Param("p_EndDate") LocalDate endDate);
}
