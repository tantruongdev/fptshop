package com.sqlserver.fptshop.Repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.sqlserver.fptshop.Entity.MembershipClass;

public interface MembershipClassRepository extends JpaRepository<MembershipClass, Integer> {
  MembershipClass findFirstByOrderByIdAsc();
}
