package com.work.work.mapper;

import com.work.work.entity.Admin;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface AdminMapper {
    Admin getAdminByAccount(String account);
    int insertAdmin(Admin admin); // 新增方法
    int deleteAdminByAccount(@Param("account") String account); // 新增方法：根据账户删除管理员
}
