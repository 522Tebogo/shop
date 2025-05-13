package com.work.work.service;

import com.work.work.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

public interface UserService {

    public User login(String account, String password, HttpSession session);

    public boolean insertUser(String account, String password, String telphone, String email, MultipartFile avatar) throws IOException;

    public String saveAvatar(MultipartFile file) throws IOException;

}
