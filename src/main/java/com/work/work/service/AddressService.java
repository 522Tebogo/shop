package com.work.work.service;

import com.work.work.entity.Address;

import java.util.List;

public interface AddressService {
    
    List<Address> getAddressByUserId(Integer userId);
    
    Address getAddressById(Integer id);
    
    Address getDefaultAddress(Integer userId);
    
    boolean saveAddress(Address address);
    
    boolean updateAddress(Address address);
    
    boolean deleteAddress(Integer id);
    
    boolean setDefault(Integer userId, Integer addressId);
} 