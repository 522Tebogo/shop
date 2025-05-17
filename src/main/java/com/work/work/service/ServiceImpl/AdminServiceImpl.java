package com.work.work.service.ServiceImpl;

import com.work.work.entity.Admin;
import com.work.work.entity.User;
import com.work.work.mapper.AdminMapper;
import com.work.work.mapper.UserMapper;
import com.work.work.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.DigestUtils;

import java.nio.charset.StandardCharsets;
import java.util.List;

@Service("adminServiceImpl") // 保持或确认这个 bean 名称
public class AdminServiceImpl implements AdminService {
    @Autowired
    private AdminMapper adminMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public Admin getAdminByAccount(String account) {
        return adminMapper.getAdminByAccount(account); // 假设AdminMapper有此方法
    }

    @Override
    public List<User> getAllUser() {
        return userMapper.getAllUser();
    }

    @Override
    public Admin login(String account, String password) {
        Admin admin = adminMapper.getAdminByAccount(account); // 修正：应为 getAdminByAccount
        if (admin == null) {
            return null; // 账号不存在
        }
        // 密码校验，与AdminController保持一致
        String inputPasswordHash = DigestUtils.md5DigestAsHex(password.getBytes(StandardCharsets.UTF_8));
        if (!admin.getPassword().equals(inputPasswordHash)) {
            return null; // 密码错误
        }
        return admin; // 登录成功
    }
}
