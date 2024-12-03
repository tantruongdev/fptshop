package com.sqlserver.fptshop.Service;

import java.sql.Date;
import java.time.LocalDate;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.sqlserver.fptshop.Entity.Customer;
import com.sqlserver.fptshop.Entity.MembershipClass;
import com.sqlserver.fptshop.Entity.dto.CustomerCreateDTO;
import com.sqlserver.fptshop.Repository.CustomerRepository;
import com.sqlserver.fptshop.Repository.EmployeeRepository;
import com.sqlserver.fptshop.Repository.MembershipClassRepository;

@Service
public class CustomerService {

  @Autowired
  private CustomerRepository customerRepository;

  @Autowired
  private EmployeeRepository employeeRepository;

  @Autowired
  private MembershipClassRepository membershipClassRepository;

  // Lấy tất cả customer
  public List<Customer> getAllCustomers() {
    return customerRepository.findAll();
  }

  // Lấy customer theo id
  public Optional<Customer> getCustomerById(Integer customerId) {
    return customerRepository.findById(customerId);
  }

  // Thêm mới customer
  public Customer createCustomer(CustomerCreateDTO customerCreateDTO) {
    // Tạo đối tượng customer mới từ DTO
    Customer customer = new Customer();
    customer.setPhoneNumber(customerCreateDTO.getPhoneNumber());
    customer.setEmail(customerCreateDTO.getEmail());
    customer.setRegistrationDate(LocalDate.now());
    customer.setShippingAddress(customerCreateDTO.getShippingAddress());
    customer.setLname(customerCreateDTO.getLname());
    customer.setFname(customerCreateDTO.getFname());

    MembershipClass membershipClass = null;

    // Nếu có membershipClassId, tìm theo id đó
    if (customerCreateDTO.getMembershipClassId() != null) {
      membershipClass = membershipClassRepository.findById(customerCreateDTO.getMembershipClassId()).orElse(null);

      // Nếu không tìm thấy membership class theo id thì báo lỗi
      if (membershipClass == null) {
        throw new IllegalArgumentException(
            "Membership Class không tồn tại với ID: " + customerCreateDTO.getMembershipClassId());
      } else {
        customer.setTotalPoints(membershipClass.getMinimumNoPoint());
      }
    }

    // Nếu không có membershipClassId, lấy membershipClass đầu tiên
    if (membershipClass == null) {
      membershipClass = membershipClassRepository.findFirstByOrderByIdAsc();
      if (membershipClass != null) {
        customer.setTotalPoints(membershipClass.getMinimumNoPoint());
      } else {
        throw new IllegalArgumentException("Không tìm thấy Membership Class mặc định.");
      }
    }

    // Gán customer với membershipClass
    customer.setMembershipClass(membershipClass);

    // Lưu customer vào database
    return customerRepository.save(customer);
  }

  // Cập nhật customer
  public Customer updateCustomer(Integer customerId, Customer updatedCustomerData) {
    // Tìm customer theo customerId
    Customer existingCustomer = customerRepository.findById(customerId)
        .orElseThrow(() -> new IllegalArgumentException("Customer not found with id: " + customerId));

    // Chỉ cập nhật các trường cho phép
    if (updatedCustomerData.getPhoneNumber() != null) {
      existingCustomer.setPhoneNumber(updatedCustomerData.getPhoneNumber());
    }
    if (updatedCustomerData.getEmail() != null) {
      existingCustomer.setEmail(updatedCustomerData.getEmail());
    }
    if (updatedCustomerData.getShippingAddress() != null) {
      existingCustomer.setShippingAddress(updatedCustomerData.getShippingAddress());
    }
    if (updatedCustomerData.getLname() != null) {
      existingCustomer.setLname(updatedCustomerData.getLname());
    }
    if (updatedCustomerData.getFname() != null) {
      existingCustomer.setFname(updatedCustomerData.getFname());
    }

    // Lưu lại customer sau khi cập nhật
    return customerRepository.save(existingCustomer);
  }

  // Xóa customer
  public Customer deleteCustomer(Integer customerId) throws Exception {
    // Kiểm tra nếu khách hàng không tồn tại
    Customer customer = customerRepository.findById(customerId)
        .orElseThrow(() -> new Exception("Customer not found"));

    // Kiểm tra nếu khách hàng đã bị xóa (isDeleted = 1)
    if (customer.getIsDeleted() == 1) {
      throw new Exception("Customer has already been deleted.");
    }

    // Đánh dấu khách hàng là đã xóa (isDeleted = 1)
    customer.setIsDeleted(1);

    // Lưu lại sự thay đổi
    return customerRepository.save(customer);
  }

  // Reactive customer
  public Customer reactivateCustomer(Integer customerId) throws Exception {
    // Kiểm tra nếu khách hàng không tồn tại
    Customer customer = customerRepository.findById(customerId)
        .orElseThrow(() -> new Exception("Customer not found"));

    // Kiểm tra nếu khách hàng chưa bị xóa (isDeleted = 0)
    if (customer.getIsDeleted() == 0) {
      throw new Exception("Customer is already active.");
    }

    // Đánh dấu khách hàng là chưa xóa (isDeleted = 0)
    customer.setIsDeleted(0);

    // Lưu lại sự thay đổi
    return customerRepository.save(customer);
  }

}
