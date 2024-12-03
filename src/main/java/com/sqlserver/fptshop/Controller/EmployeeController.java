package com.sqlserver.fptshop.Controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.sqlserver.fptshop.Entity.Employee;
import com.sqlserver.fptshop.Entity.dto.EmployeeDTO;
import com.sqlserver.fptshop.Service.EmployeeService;

@RestController
@RequestMapping("/api/employees")
public class EmployeeController {

    private final EmployeeService employeeService;

    public EmployeeController(EmployeeService employeeService) {
        this.employeeService = employeeService;
    }

    @GetMapping
    public List<Employee> getEmployeeList() {
        return employeeService.getAll();
    }

    @GetMapping("/{id}")
    public Employee getEmployeeById(@PathVariable Integer id) {
        return employeeService.getEmployeeById(id);
    }

    @PostMapping
    public String insertEmployee(@RequestBody EmployeeDTO employeeDTO) {
        return employeeService.insertEmployee(employeeDTO);
    }

    @PutMapping("/{id}")
    public String updateEmployee(@PathVariable Integer id, @RequestBody EmployeeDTO employeeDTO) {
        return employeeService.updateEmployee(id, employeeDTO);
    }

    @DeleteMapping("/{id}")
    public String deleteEmployee(@PathVariable Integer id) {
        return employeeService.deleteEmployee(id);
    }

    @PatchMapping("/{id}")
    public String reactiveEmployee(@PathVariable Integer id) {
        return employeeService.reactiveEmployee(id);
    }

    @GetMapping("/search")
    public ResponseEntity<List<Employee>> searchEmployeesForStore(
            @RequestParam String storeName,
            @RequestParam(required = false) String employeeName,
            @RequestParam(required = false) String phone,
            @RequestParam(required = false) String email,
            @RequestParam(required = false) Integer sortOption) {
        List<Employee> employees = employeeService.searchEmployeesForStore(storeName, employeeName, phone,
                email, sortOption);
        return ResponseEntity.ok(employees);
    }

    @GetMapping("/top-selling-products")
    public ResponseEntity<List<Map<String, Object>>> getTopSellingProducts(
            @RequestParam Integer minQuantitySold,
            @RequestParam String date) {
        List<Map<String, Object>> products = employeeService.getTopSellingProducts(minQuantitySold, date);
        return ResponseEntity.ok(products);
    }

    @GetMapping("/customer-orders")
    public ResponseEntity<List<Map<String, Object>>> getCustomerOrders(
            @RequestParam String startDate,
            @RequestParam String endDate) {
        List<Map<String, Object>> orders = employeeService.getCustomerOrders(startDate, endDate);
        return ResponseEntity.ok(orders);
    }

}
