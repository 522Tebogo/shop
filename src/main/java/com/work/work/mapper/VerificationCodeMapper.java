package com.work.work.mapper;

import com.work.work.entity.VerificationCode;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface VerificationCodeMapper {

    /**
     * 插入新的验证码
     */
    int insert(VerificationCode code);

    /**
     * 根据目标(手机号/邮箱)和验证码查询
     */
    VerificationCode getByTargetAndCode(@Param("target") String target, @Param("code") String code);

    /**
     * 获取最新的一条未过期且未使用的验证码
     */
    VerificationCode getLatestValidCode(@Param("target") String target);

    /**
     * 将验证码标记为已使用
     */
    int markAsUsed(Integer id);

    /**
     * 将验证码标记为已过期
     */
    int markAsExpired(Integer id);

    /**
     * 清理过期的验证码
     */
    int cleanExpiredCodes();
} 