package com.work.work.mapper;

import com.work.work.entity.User;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface UserMapper {
    public User getUserByAccount(String account);
    int insert(User newUser);
}
