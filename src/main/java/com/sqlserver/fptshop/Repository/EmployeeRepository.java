package com.sqlserver.fptshop.Repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
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
  @Procedure(procedureName = "ReactiveEmployee")
  String reactiveEmployee(@Param("employee_id") Integer employeeId);

}
