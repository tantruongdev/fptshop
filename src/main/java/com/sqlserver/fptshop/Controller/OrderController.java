package com.sqlserver.fptshop.Controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.dto.OrderDTO;
import com.sqlserver.fptshop.Entity.dto.ProductLineDTO;
import com.sqlserver.fptshop.Service.OrderService;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

  @Autowired
  private OrderService orderService;

  @PostMapping
  public String createOrder(@RequestBody OrderDTO orderdDto) {
    return orderService.createOrder(orderdDto);
  }

  @GetMapping
  public List<Order> getAllOrders() {
    return orderService.getAllOrders();
  }

  @GetMapping("/{id}")
  public Order getOrderById(@PathVariable Integer id) {
    return orderService.getOrderById(id);
  }

  @PatchMapping("/{id}")
  public String updateOrderStatus(@PathVariable Integer id, @RequestBody OrderDTO orderDto) {
    return orderService.updateOrderStatus(id, orderDto);
  }

  @PutMapping("/{id}")
  public Order updateOrder(@PathVariable Integer id, @RequestBody Order order) {
    return orderService.updateOrder(id, order);
  }

  @DeleteMapping("/{id}")
  public String deleteOrder(@PathVariable Integer id) {

    return orderService.deleteOrder(id);
  }

  @PostMapping("/{orderId}/productlines")
  public String addProductLineToOrder(@PathVariable Integer orderId, @RequestBody ProductLineDTO productLineDTO) {
    return orderService.addProductLineToOrder(productLineDTO);
  }

  @DeleteMapping("/{orderId}/productlines")
  public String removeProductLineFromOrder(@PathVariable Integer orderId,
      @RequestBody ProductLineDTO productLineDTO) {
    return orderService.removeProductLineFromOrder(productLineDTO);

  }

}