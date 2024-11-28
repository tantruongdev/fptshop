package com.sqlserver.fptshop.Controller;

import java.util.List;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.sqlserver.fptshop.Entity.Device;
import com.sqlserver.fptshop.Entity.ProductLine;
import com.sqlserver.fptshop.Service.DeviceService;
import com.sqlserver.fptshop.Service.ProductService;

@RestController
@RequestMapping("/api")
public class ProductController {

    private final ProductService productService;
    private final DeviceService deviceService;

    public ProductController(ProductService productService,
            DeviceService deviceService) {
        this.productService = productService;
        this.deviceService = deviceService;
    }

    @GetMapping("/test")
    public String test() {
        return "Test Auto restart 1";
    }

    @GetMapping("/products")
    public List<ProductLine> getProductList() {
        return productService.getAll();
    }

    @GetMapping("/devices")
    public List<Device> getDeviceList() {
        return deviceService.getAll();
    }

}
