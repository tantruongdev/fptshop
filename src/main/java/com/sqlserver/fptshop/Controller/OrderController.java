package com.sqlserver.fptshop.Controller;

import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLine;
import com.sqlserver.fptshop.Entity.OrderIncludesProductLineId;
import com.sqlserver.fptshop.Service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/orders")
public class OrderController {

  @Autowired
  private OrderService orderService;

  @PostMapping
  public Order createOrder(@RequestBody Order order) {
    return orderService.createOrder(order);
  }

  @GetMapping
  public List<Order> getAllOrders() {
    return orderService.getAllOrders();
  }

  @GetMapping("/{id}")
  public Order getOrderById(@PathVariable String id) {
    return orderService.getOrderById(id);
  }

  @PatchMapping("/{id}")
  public Order updateOrderPatch(@PathVariable String id, @RequestBody Order order) {
    return orderService.updateOrderStatus(id, order);
  }

  @PutMapping("/{id}")
  public Order updateOrder(@PathVariable String id, @RequestBody Order order) {
    return orderService.updateOrder(id, order);
  }

  @DeleteMapping("/{id}")
  public ResponseEntity<Void> deleteOrder(@PathVariable String id) {
    orderService.deleteOrder(id);
    return ResponseEntity.noContent().build();
  }

  @PostMapping("/{orderId}/productlines")
  public Order addProductLineToOrder(@PathVariable String orderId, @RequestBody OrderIncludesProductLine productLine) {
    return orderService.addProductLineToOrder(orderId, productLine);
  }

  @DeleteMapping("/{orderId}/productlines")
  public void removeProductLineFromOrder(@PathVariable String orderId,
      @RequestBody OrderIncludesProductLineId productLineId) {
    orderService.deleteProductLine(productLineId);
    return;
  }

}