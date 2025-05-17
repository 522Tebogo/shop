package com.work.work.service;

import com.work.work.entity.Admin;
import com.work.work.entity.User;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface   AdminService {
    Admin getAdminByAccount(String account);
    List<User> getAllUser();
    Admin login(String account, String password); // 移除非接口方法声明


}
