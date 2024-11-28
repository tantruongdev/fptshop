package com.sqlserver.fptshop.Controller;

import java.util.List;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
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
    public Employee getEmployeeById(@PathVariable String id) {
        return employeeService.getEmployeeById(id);
    }

    @PostMapping
    public String insertEmployee(@RequestBody EmployeeDTO employeeDTO) {
        return employeeService.insertEmployee(employeeDTO);
    }

    @PutMapping("/{id}")
    public String updateEmployee(@PathVariable String id, @RequestBody EmployeeDTO employeeDTO) {
        return employeeService.updateEmployee(id, employeeDTO);
    }

    @DeleteMapping("/{id}")
    public String deleteEmployee(@PathVariable String id) {
        return employeeService.deleteEmployee(id);
    }

    @PatchMapping("/{id}")
    public String reactiveEmployee(@PathVariable String id) {
        return employeeService.reactiveEmployee(id);
    }

}
