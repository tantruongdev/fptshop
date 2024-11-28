package com.sqlserver.fptshop.Service;

import com.sqlserver.fptshop.Entity.Device;
import com.sqlserver.fptshop.Repository.DeviceRepository;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class DeviceService {

    private final DeviceRepository deviceRepository;

    public DeviceService(DeviceRepository deviceRepository){
        this.deviceRepository = deviceRepository;
    }

    public List<Device> getAll(){
        return this.deviceRepository.findAll();
    }
}
