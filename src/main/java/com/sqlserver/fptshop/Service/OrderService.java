package com.sqlserver.fptshop.Service;

import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLine;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLineId;
import com.sqlserver.fptshop.Entity.dto.CustomerOrderDTO;
import com.sqlserver.fptshop.Entity.dto.OrderDTO;
import com.sqlserver.fptshop.Entity.dto.ProductLineDTO;
import com.sqlserver.fptshop.Repository.OrderIncludesProductLineRepository;
import com.sqlserver.fptshop.Repository.OrderRepository;

import jakarta.persistence.Tuple;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class OrderService {

  @Autowired
  private OrderRepository orderRepository;

  @Autowired
  private OrderIncludesProductLineRepository orderIncludesProductLineRepository;

  @Transactional
  public String createOrder(OrderDTO orderDto) {
    return orderRepository.createOrder(
        orderDto.getCustomerId(),
        orderDto.getEmployeeId(),
        orderDto.getDeliveryId(),
        orderDto.getOrderStatus());
  }

  public List<Order> getAllOrders() {
    return orderRepository.findAll();
  }

  public Order getOrderById(Integer orderId) {
    return orderRepository.findById(orderId).orElseThrow(() -> new RuntimeException("Order not found"));
  }

  public String updateOrderStatus(Integer orderId, OrderDTO orderDto) {

    return orderRepository.updateOrderStatus(orderDto.getOrderId(), orderDto.getOrderStatus());
  }

  public Order updateOrder(Integer orderId, Order orderDetails) {
    Order order = getOrderById(orderId);
    order.setOrderDate(orderDetails.getOrderDate());
    order.setOrderStatus(orderDetails.getOrderStatus());
    order.setTotalAmount(orderDetails.getTotalAmount());
    order.setEmployee(orderDetails.getEmployee());
    order.setCustomer(orderDetails.getCustomer());
    // Cập nhật các trường khác nếu có
    return orderRepository.save(order);
  }

  public String deleteOrder(Integer orderId) {
    return orderRepository.deleteOrder(orderId);

  }

  public String addProductLineToOrder(ProductLineDTO productLineDTO) {

    return orderIncludesProductLineRepository.addProductToOrder(
        productLineDTO.getOrderId(),
        productLineDTO.getProductLineId(),
        productLineDTO.getPrice(),
        productLineDTO.getQuantity());
  }

  public String removeProductLineFromOrder(ProductLineDTO productLineDTO) {
    return orderIncludesProductLineRepository.removeProductFromOrder(
        productLineDTO.getOrderId(),
        productLineDTO.getProductLineId());
  }

  public Integer calculateTotalSales(Integer productLineId, LocalDate startDate, LocalDate endDate) {
    return orderRepository.calculateTotalSales(productLineId, startDate, endDate);
  }

  public List<CustomerOrderDTO> getHighestOrderAmount(Integer number, LocalDate startDate, LocalDate endDate) {
    List<Tuple> tuples = orderRepository.getHighestOrderAmount(number, startDate, endDate);
    List<CustomerOrderDTO> result = new ArrayList<>();

    for (Tuple tuple : tuples) {
      CustomerOrderDTO customerOrderDTO = new CustomerOrderDTO();

      // Ánh xạ các giá trị từ Tuple vào DTO
      customerOrderDTO.setRank((Integer) tuple.get(0)); // Rank
      customerOrderDTO.setCustomerId((Integer) tuple.get(1)); // Customer ID
      customerOrderDTO.setLname((String) tuple.get(2)); // Last Name
      customerOrderDTO.setFname((String) tuple.get(3)); // First Name

      // Chuyển đổi BigDecimal thành Double cho trường totalOrderAmount
      BigDecimal totalAmount = (BigDecimal) tuple.get(4);
      customerOrderDTO.setTotalOrderAmount(totalAmount.doubleValue()); // Chuyển đổi BigDecimal thành Double

      customerOrderDTO.setNoPurchases((Integer) tuple.get(5)); // Number of Purchases
      customerOrderDTO.setTotalPoints((Integer) tuple.get(6)); // Total Points

      result.add(customerOrderDTO);
    }

    return result;
  }

}