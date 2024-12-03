package com.sqlserver.fptshop.Controller;

import com.sqlserver.fptshop.Entity.Customer;
import com.sqlserver.fptshop.Entity.dto.CustomerCreateDTO;
import com.sqlserver.fptshop.Service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/customers")
public class CustomerController {

  @Autowired
  private CustomerService customerService;

  @GetMapping
  public List<Customer> getAllCustomers() {
    return customerService.getAllCustomers();
  }

  @GetMapping("/{id}")
  public ResponseEntity<Customer> getCustomerById(@PathVariable("id") Integer customerId) {
    Optional<Customer> customer = customerService.getCustomerById(customerId);
    return customer.map(ResponseEntity::ok)
        .orElseGet(() -> ResponseEntity.status(HttpStatus.NOT_FOUND).build());
  }

  // Endpoint thêm mới customer

  @PostMapping
  public ResponseEntity<Customer> createCustomer(@RequestBody CustomerCreateDTO customerCreateDTO) {
    try {
      // Gọi service để tạo customer
      Customer createdCustomer = customerService.createCustomer(customerCreateDTO);
      return ResponseEntity.status(HttpStatus.CREATED).body(createdCustomer);
    } catch (IllegalArgumentException ex) {
      // Nếu có lỗi về MembershipClass, trả về lỗi 400 với thông báo
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(null);
    }
  }

  // Xử lý lỗi nếu có trong controller
  @ExceptionHandler(IllegalArgumentException.class)
  public ResponseEntity<String> handleIllegalArgumentException(IllegalArgumentException ex) {
    return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(ex.getMessage());
  }

  // Endpoint cập nhật customer
  @PutMapping("/{customerId}")
  public ResponseEntity<Customer> updateCustomer(@PathVariable Integer customerId,
      @RequestBody Customer updatedCustomerData) {
    try {
      Customer updatedCustomer = customerService.updateCustomer(customerId, updatedCustomerData);
      return ResponseEntity.status(HttpStatus.OK).body(updatedCustomer);
    } catch (IllegalArgumentException ex) {
      return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
    }
  }

  @DeleteMapping("/{customerId}")
  public ResponseEntity<String> deleteCustomer(@PathVariable Integer customerId) {
    try {
      Customer deletedCustomer = customerService.deleteCustomer(customerId);
      return ResponseEntity.status(HttpStatus.OK).body("Customer marked as deleted.");
    } catch (Exception e) {
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
    }
  }

  @PutMapping("/{customerId}/reactivate")
  public ResponseEntity<String> reactivateCustomer(@PathVariable Integer customerId) {
    try {
      Customer reactivatedCustomer = customerService.reactivateCustomer(customerId);
      return ResponseEntity.status(HttpStatus.OK).body("Customer reactivated successfully.");
    } catch (Exception e) {
      return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
    }
  }

}
