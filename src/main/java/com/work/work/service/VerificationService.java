package com.work.work.service;

import com.work.work.entity.VerificationCode;
import org.springframework.stereotype.Service;

/**
 * 验证码服务接口
 */
@Service
public interface VerificationService {
    
    /**
     * 生成并保存验证码
     * @param target 目标手机号或邮箱
     * @return 验证码对象
     */
    VerificationCode generateCode(String target);
    
    /**
     * 验证验证码
     * @param target 目标手机号或邮箱
     * @param code 验证码
     * @return 是否有效
     */
    boolean verifyCode(String target, String code);
    
    /**
     * 使验证码失效
     * @param target 目标手机号或邮箱
     * @param code 验证码
     */
    void invalidateCode(String target, String code);
    
    /**
     * 清理过期的验证码
     */
    void cleanExpiredCodes();
    
    /**
     * 校验手机号格式
     * @param phone 手机号
     * @return 是否有效
     */
    boolean isValidPhone(String phone);
    
    /**
     * 校验邮箱格式
     * @param email 邮箱
     * @return 是否有效
     */
    boolean isValidEmail(String email);
} 