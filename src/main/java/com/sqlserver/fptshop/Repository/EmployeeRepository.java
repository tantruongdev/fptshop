package com.sqlserver.fptshop.Repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.sqlserver.fptshop.Entity.Employee;

@Repository
public interface EmployeeRepository extends JpaRepository<Employee, String> {

  @Procedure(procedureName = "GetAllEmployees")
  List<Employee> getAllEmployees();

  @Procedure(procedureName = "GetEmployeeByID")
  Employee getEmployeeById(@Param("EmployeeID") String employeeId);

  @Procedure(name = "InsertEmployee")
  String insertEmployee(
      @Param("EmployeeID") String employeeId,
      @Param("IdentityCard") String identityCard,
      @Param("Lname") String lname,
      @Param("Fname") String fname,
      @Param("PhoneNumber") String phoneNumber,
      @Param("DOB") Date dob,
      @Param("HireDate") Date hireDate,
      @Param("Email") String email,
      @Param("SupervisorID") String supervisorId,
      @Param("SuperviseDate") Date superviseDate,
      @Param("StoreID") String storeId);

  @Procedure(name = "UpdateEmployee")
  String updateEmployee(
      @Param("EmployeeID") String employeeId,
      @Param("IdentityCard") String identityCard,
      @Param("Lname") String lname,
      @Param("Fname") String fname,
      @Param("PhoneNumber") String phoneNumber,
      @Param("DOB") Date dob,
      @Param("HireDate") Date hireDate,
      @Param("Email") String email,
      @Param("SupervisorID") String supervisorId,
      @Param("SuperviseDate") Date superviseDate,
      @Param("StoreID") String storeId);

  @Procedure(name = "DeleteEmployee")
  String deleteEmployee(@Param("EmployeeID") String employeeId);

  @Procedure(name = "ReactiveEmployee")
  String reactiveEmployee(@Param("EmployeeID") String employeeId);

}
