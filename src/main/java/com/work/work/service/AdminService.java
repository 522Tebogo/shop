package com.work.work.service;

import com.work.work.entity.Admin;
import org.springframework.stereotype.Service;

@Service
public interface AdminService {
    Admin getAdminByAccount(String account);
}
