package com.work.work.service;

import com.work.work.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Map;

@Service
public interface UserService {

    User login(String account, String password, HttpSession session);


    User loginByPhone(String phone, String code, HttpSession session);


    User loginByEmail(String email, String code, HttpSession session);


    boolean registerByPhone(String phone, String code, String password, String account, MultipartFile avatar, HttpSession session) throws IOException;

    /**
     * 常规注册
     */
    boolean insertUser(String account, String password, String telphone, String email, MultipartFile avatar) throws IOException;

    /**
     * 验证用户名格式是否合法
     * 只能包含字母和数字，且不能以数字开头，6~10位
     */
    boolean isValidUsername(String username);

    /**
     * 验证密码格式是否合法
     * 只能包含字母和数字，且必需以大写字母开头，6~10位
     */
    boolean isValidPassword(String password);

    /**
     * 检查用户名是否已存在
     */
    boolean isUsernameExists(String username);

    /**
     * 根据手机号获取用户
     */
    User getUserByPhone(String phone);

    /**
     * 根据邮箱获取用户
     */
    User getUserByEmail(String email);

    /**
     * 保存头像
     */
    String saveAvatar(MultipartFile file) throws IOException;

    /**
     * 更新用户信息
     */
    boolean updateUserInfo(Integer userId, Map<String, String> userInfo, HttpSession session) throws IOException;

    /**
     * 修改密码
     */
    boolean changePassword(Integer userId, String oldPassword, String newPassword, HttpSession session);

    /**
     * 绑定/修改手机号
     */
    boolean changePhone(Integer userId, String newPhone, String code, HttpSession session);

    /**
     * 绑定/修改邮箱
     */
    boolean changeEmail(Integer userId, String newEmail, String code, HttpSession session);

}
