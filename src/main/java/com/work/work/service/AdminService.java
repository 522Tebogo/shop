package com.work.work.service;

import com.work.work.entity.Admin;
import com.work.work.mapper.AdminMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public interface AdminService {
    Admin getAdminByAccount(String account);
}
