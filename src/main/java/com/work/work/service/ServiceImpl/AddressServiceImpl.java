package com.work.work.service.ServiceImpl;

import com.work.work.entity.Address;
import com.work.work.mapper.AddressMapper;
import com.work.work.service.AddressService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AddressServiceImpl implements AddressService {

    @Autowired
    private AddressMapper addressMapper;

    @Override
    public List<Address> getAddressByUserId(Integer userId) {
        return addressMapper.findByUserId(userId);
    }

    @Override
    public Address getAddressById(Integer id) {
        return addressMapper.findById(id);
    }

    @Override
    public Address getDefaultAddress(Integer userId) {
        return addressMapper.findDefaultByUserId(userId);
    }

    @Override
    @Transactional
    public boolean saveAddress(Address address) {
        // 如果是默认地址，先清除其他默认
        if (address.getIsDefault()) {
            addressMapper.clearDefaultForUser(address.getUserId());
        }

        // 如果这是用户的第一个地址，设为默认
        List<Address> existingAddresses = addressMapper.findByUserId(address.getUserId());
        if (existingAddresses.isEmpty()) {
            address.setIsDefault(true);
        }

        return addressMapper.insert(address) > 0;
    }

    @Override
    @Transactional
    public boolean updateAddress(Address address) {
        // 如果设为默认地址，清除其他默认
        if (address.getIsDefault()) {
            addressMapper.clearDefaultForUser(address.getUserId());
        }

        return addressMapper.update(address) > 0;
    }

    @Override
    public boolean deleteAddress(Integer id) {
        return addressMapper.deleteById(id) > 0;
    }

    @Override
    @Transactional
    public boolean setDefault(Integer userId, Integer addressId) {
        // 清除该用户的所有默认地址
        addressMapper.clearDefaultForUser(userId);

        // 设置新的默认地址
        Address address = addressMapper.findById(addressId);
        if (address != null && address.getUserId().equals(userId)) {
            address.setIsDefault(true);
            return addressMapper.update(address) > 0;
        }

        return false;
    }
} 