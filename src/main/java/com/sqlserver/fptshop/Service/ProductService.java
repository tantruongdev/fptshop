package com.sqlserver.fptshop.Service;

import com.sqlserver.fptshop.Entity.ProductLine;
import com.sqlserver.fptshop.Repository.ProductRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ProductService {

    private  final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository){
        this.productRepository = productRepository;
    }

    public List<ProductLine> getAll(){
        return productRepository.findAll();
    }
}
