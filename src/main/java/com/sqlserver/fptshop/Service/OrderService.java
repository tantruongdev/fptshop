package com.sqlserver.fptshop.Service;

import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLine;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLineId;
import com.sqlserver.fptshop.Entity.dto.OrderDTO;
import com.sqlserver.fptshop.Entity.dto.ProductLineDTO;
import com.sqlserver.fptshop.Repository.OrderIncludesProductLineRepository;
import com.sqlserver.fptshop.Repository.OrderRepository;

import org.springframework.transaction.annotation.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}