package com.work.work.mapper;

import com.work.work.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserMapper {
    // 根据用户名获取用户
    User getUserByAccount(String account);

    // 根据手机号获取用户
    User getUserByPhone(String phone);

    // 根据手机号获取所有用户（可能有多个）
    List<User> getUsersByPhone(String phone);

    // 检查手机号是否存在
    boolean checkPhoneExists(String phone);

    // 根据邮箱获取用户
    User getUserByEmail(String email);

    // 新增用户
    int insert(User newUser);

    // 更新用户信息
    int updateUser(User user);

    // 更新密码
    int updatePassword(@Param("id") Integer id, @Param("newPassword") String newPassword);

    // 更新用户头像
    int updateAvatar(@Param("id") Integer id, @Param("avatar") String avatar);

    // 更新用户昵称
    int updateNickname(@Param("id") Integer id, @Param("nickname") String nickname);

    // 更新用户名
    int updateAccount(@Param("id") Integer id, @Param("account") String account);

    // 更新手机号
    int updatePhone(@Param("id") Integer id, @Param("phone") String phone);

    // 更新邮箱
    int updateEmail(@Param("id") Integer id, @Param("email") String email);
}
