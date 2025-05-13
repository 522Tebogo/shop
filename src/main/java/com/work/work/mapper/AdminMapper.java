package com.work.work.mapper;

import com.work.work.entity.Admin;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AdminMapper {
    Admin getAdminByAccount(String account);
}
