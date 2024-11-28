package com.sqlserver.fptshop.Repository;


import com.sqlserver.fptshop.Entity.ProductLine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProductRepository extends JpaRepository<ProductLine, String> {

}
