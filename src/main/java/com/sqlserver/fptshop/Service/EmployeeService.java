package com.sqlserver.fptshop.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sqlserver.fptshop.Entity.Employee;
import com.sqlserver.fptshop.Entity.Order;
import com.sqlserver.fptshop.Entity.dto.EmployeeDTO;
import com.sqlserver.fptshop.Repository.EmployeeRepository;

@Service
public class EmployeeService {

    private final EmployeeRepository employeeRepository;

    public EmployeeService(EmployeeRepository employeeRepository) {
        this.employeeRepository = employeeRepository;
    }

    @Transactional(readOnly = true)
    public List<Employee> getAll() {

        return employeeRepository.getAllEmployees();
    }

    @Transactional(readOnly = true)
    public Employee getEmployeeById(Integer employeeId) {
        return employeeRepository.getEmployeeById(employeeId);
    }

    @Transactional
    public String insertEmployee(EmployeeDTO employeeDTO) {
        return employeeRepository.insertEmployee(
                employeeDTO.getIdentityCard(),
                employeeDTO.getLname(),
                employeeDTO.getFname(),
                employeeDTO.getPhoneNumber(),
                employeeDTO.getDob(),
                employeeDTO.getHireDate(),
                employeeDTO.getEmail(),
                employeeDTO.getSupervisorId(),
                employeeDTO.getSuperviseDate(),
                employeeDTO.getStoreId());
    }

    @Transactional
    public String updateEmployee(Integer employeeId, EmployeeDTO employeeDTO) {
        return employeeRepository.updateEmployee(
                employeeId,
                employeeDTO.getIdentityCard(),
                employeeDTO.getLname(),
                employeeDTO.getFname(),
                employeeDTO.getPhoneNumber(),
                employeeDTO.getDob(),
                employeeDTO.getHireDate(),
                employeeDTO.getEmail(),
                employeeDTO.getSupervisorId(),
                employeeDTO.getSuperviseDate(),
                employeeDTO.getStoreId(),
                employeeDTO.getIsDeleted());
    }

    @Transactional
    public String deleteEmployee(Integer employeeId) {
        return employeeRepository.deleteEmployee(employeeId);
    }

    @Transactional
    public String reactiveEmployee(Integer employeeId) {
        return employeeRepository.reactiveEmployee(employeeId);
    }

    @Transactional
    public List<Employee> searchEmployeesForStore(String storeName, String employeeName, String phone,
            String email, Integer sortOption) {
        return employeeRepository.searchEmployeesForStore(storeName, employeeName, phone, email, sortOption);
    }

    @Transactional
    public List<Map<String, Object>> getTopSellingProducts(Integer minQuantitySold, String date) {
        return employeeRepository.getTopSellingProducts(minQuantitySold, date);
    }

    @Transactional
    public List<Map<String, Object>> getCustomerOrders(String startDate, String endDate) {
        return employeeRepository.getCustomerOrders(startDate, endDate);
    }

}
