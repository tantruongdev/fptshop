package com.sqlserver.fptshop.Service;

import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLine;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLineId;
import com.sqlserver.fptshop.Repository.OrderIncludesProductLineRepository;
import com.sqlserver.fptshop.Repository.OrderRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OrderService {

  @Autowired
  private OrderRepository orderRepository;

  @Autowired
  private OrderIncludesProductLineRepository orderIncludesProductLineRepository;

  public Order createOrder(Order order) {
    return orderRepository.save(order);
  }

  public List<Order> getAllOrders() {
    return orderRepository.findAll();
  }

  public Order getOrderById(Integer orderId) {
    return orderRepository.findById(orderId).orElseThrow(() -> new RuntimeException("Order not found"));
  }

  public Order updateOrderStatus(Integer orderId, Order orderDetails) {
    Order order = getOrderById(orderId);

    order.setOrderStatus(orderDetails.getOrderStatus());

    return orderRepository.save(order);
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

  public void deleteOrder(Integer orderId) {
    orderRepository.deleteById(orderId);
  }

  public Order addProductLineToOrder(Integer orderId, OrderIncludesProductLine productLine) {
    Order order = getOrderById(orderId);
    productLine.setOrder(order); // Gán đơn hàng cho dòng sản phẩm
    order.getOrderIncludesProductLines().add(productLine); // Thêm dòng sản phẩm vào danh sách
    return orderRepository.save(order); // Lưu lại đơn hàng với dòng sản phẩm mới
  }

  // Phương thức để xóa sản phẩm khỏi đơn hàng
  public void deleteProductLine(OrderIncludesProductLineId productLineId) {
    orderIncludesProductLineRepository.deleteById(productLineId);
  }

  // Thêm phương thức để xóa sản phẩm khỏi đơn hàng
  public Order removeProductLineFromOrder(Integer orderId, OrderIncludesProductLineId productLineId) {
    System.out.println("Attempting to remove product line from order: " + orderId);
    System.out.println("Product Line ID: " + productLineId);

    Order order = getOrderById(orderId);
    // Tìm dòng sản phẩm trong danh sách
    OrderIncludesProductLine productLineToRemove = null;
    for (OrderIncludesProductLine productLine : order.getOrderIncludesProductLines()) {

      if (productLine.getId().equals(productLineId)) {
        productLineToRemove = productLine;
        break;
      }
    }
    if (productLineToRemove != null) {
      order.getOrderIncludesProductLines().remove(productLineToRemove);
      System.out.println("Product line found: " + productLineToRemove);
    } else {
      // Xóa dòng sản phẩm
      System.out.println("No matching product line found.");
    }

    return orderRepository.save(order); // Lưu lại đơn hàng
  }
}