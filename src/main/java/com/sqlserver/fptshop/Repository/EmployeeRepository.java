package com.sqlserver.fptshop.Repository;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sqlserver.fptshop.Entity.Employee;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, Integer> {

    // Get all employees
    @Procedure(procedureName = "get_all_employees")
    List<Employee> getAllEmployees();

    // Get employee by ID
    @Procedure(procedureName = "get_employee_by_id")
    Employee getEmployeeById(@Param("employee_id") Integer employeeId);

    // Insert employee
    @Procedure(procedureName = "insert_employee")
    String insertEmployee(
            @Param("identity_card") String identityCard,
            @Param("lname") String lname,
            @Param("fname") String fname,
            @Param("phone_number") String phoneNumber,
            @Param("dob") Date dob,
            @Param("hire_date") Date hireDate,
            @Param("email") String email,
            @Param("supervisor_id") Integer supervisorId,
            @Param("supervise_date") Date superviseDate,
            @Param("store_id") Integer storeId);

    // Update employee
    @Procedure(procedureName = "update_employee")
    String updateEmployee(
            @Param("employee_id") Integer employeeId,
            @Param("identity_card") String identityCard,
            @Param("lname") String lname,
            @Param("fname") String fname,
            @Param("phone_number") String phoneNumber,
            @Param("dob") Date dob,
            @Param("hire_date") Date hireDate,
            @Param("email") String email,
            @Param("supervisor_id") Integer supervisorId,
            @Param("supervise_date") Date superviseDate,
            @Param("store_id") Integer storeId,
            @Param("is_deleted") Boolean isDeleted);

    // Delete employee
    @Procedure(procedureName = "delete_employee")
    String deleteEmployee(@Param("employee_id") Integer employeeId);

    // Reactivate employee
    @Procedure(procedureName = "reactive_employee")
    String reactiveEmployee(@Param("employee_id") Integer employeeId);

    // @Procedure(procedureName = "SearchEmployeesForStore")
    // List<Map<String, Object>> searchEmployeesForStore(
    // String storeName,
    // String employeeName,
    // String phone,
    // String email,
    // Integer sortOption);

    // @Procedure(procedureName = "GetTopSellingProducts")
    // List<Map<String, Object>> getTopSellingProducts(
    // Integer minQuantitySold,
    // String date);

    // @Procedure(procedureName = "GetCustomerOrders")
    // List<Map<String, Object>> getCustomerOrders(
    // String startDate,
    // String endDate);

    @Query(value = "EXEC SearchEmployeesForStore :storeName, :employeeName, :phone, :email, :sortOption", nativeQuery = true)
    List<Employee> searchEmployeesForStore(
            @Param("storeName") String storeName,
            @Param("employeeName") String employeeName,
            @Param("phone") String phone,
            @Param("email") String email,
            @Param("sortOption") Integer sortOption);

    @Query(value = "EXEC GetTopSellingProducts :minQuantitySold, :date", nativeQuery = true)
    List<Map<String, Object>> getTopSellingProducts(
            @Param("minQuantitySold") Integer minQuantitySold,
            @Param("date") String date);

    @Query(value = "EXEC GetCustomerOrders :startDate, :endDate", nativeQuery = true)
    List<Map<String, Object>> getCustomerOrders(
            @Param("startDate") String startDate,
            @Param("endDate") String endDate

    );
}
