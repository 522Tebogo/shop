package com.work.work.service.ServiceImpl;

import com.work.work.entity.Admin;
import com.work.work.mapper.AdminMapper;
import com.work.work.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminServiceImpl implements AdminService {
    @Autowired
    private AdminMapper adminMapper;

    @Override
    public Admin getAdminByAccount(String account) {
        return adminMapper.getAdminByAccount(account);
    }
}
