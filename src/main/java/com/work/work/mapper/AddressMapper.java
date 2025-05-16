package com.work.work.mapper;

import com.work.work.entity.Address;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AddressMapper {
    
    @Select("SELECT * FROM address WHERE user_id = #{userId}")
    List<Address> findByUserId(Integer userId);
    
    @Select("SELECT * FROM address WHERE id = #{id}")
    Address findById(Integer id);
    
    @Select("SELECT * FROM address WHERE user_id = #{userId} AND is_default = true LIMIT 1")
    Address findDefaultByUserId(Integer userId);
    
    @Insert("INSERT INTO address (user_id, receiver, phone, province, city, district, detail_address, is_default, create_time, update_time) " +
            "VALUES (#{userId}, #{receiver}, #{phone}, #{province}, #{city}, #{district}, #{detailAddress}, #{isDefault}, NOW(), NOW())")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(Address address);
    
    @Update("UPDATE address SET receiver = #{receiver}, phone = #{phone}, province = #{province}, " +
            "city = #{city}, district = #{district}, detail_address = #{detailAddress}, " +
            "is_default = #{isDefault}, update_time = NOW() WHERE id = #{id}")
    int update(Address address);
    
    @Delete("DELETE FROM address WHERE id = #{id}")
    int deleteById(Integer id);
    
    @Update("UPDATE address SET is_default = false WHERE user_id = #{userId}")
    void clearDefaultForUser(Integer userId);
} 