package com.work.work.service.ServiceImpl;

import com.work.work.entity.VerificationCode;
import com.work.work.mapper.VerificationCodeMapper;
import com.work.work.service.VerificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Random;
import java.util.regex.Pattern;

@Service
public class VerificationServiceImpl implements VerificationService {

    private static final int CODE_LENGTH = 6;
    private static final int CODE_EXPIRE_MINUTES = 5;

    @Autowired
    private VerificationCodeMapper verificationCodeMapper;

    @Override
    public VerificationCode generateCode(String target) {
        // 清理该目标的旧验证码（将状态设为已过期）
        VerificationCode existingCode = verificationCodeMapper.getLatestValidCode(target);
        if (existingCode != null) {
            verificationCodeMapper.markAsExpired(existingCode.getId());
        }

        // 生成6位随机数字验证码
        String code = generateRandomCode(CODE_LENGTH);

        // 创建验证码对象
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expireTime = now.plusMinutes(CODE_EXPIRE_MINUTES);
        VerificationCode verificationCode = new VerificationCode(target, code, now, expireTime);

        // 保存验证码
        verificationCodeMapper.insert(verificationCode);

        // 模拟发送验证码（打印到控制台）
        System.out.println("====================================================");
        System.out.println("向 " + target + " 发送验证码: " + code);
        System.out.println("有效期 " + CODE_EXPIRE_MINUTES + " 分钟，至 " + expireTime);
        System.out.println("====================================================");

        return verificationCode;
    }

    @Override
    public boolean verifyCode(String target, String code) {
        if (target == null || code == null) {
            return false;
        }

        // 获取验证码记录
        VerificationCode verificationCode = verificationCodeMapper.getByTargetAndCode(target, code);

        // 验证码不存在
        if (verificationCode == null) {
            return false;
        }

        // 验证码已使用或已过期
        if (verificationCode.getStatus() != 0) {
            return false;
        }

        // 验证码已过期
        if (verificationCode.getExpireTime().isBefore(LocalDateTime.now())) {
            verificationCodeMapper.markAsExpired(verificationCode.getId());
            return false;
        }

        return true;
    }

    @Override
    public void invalidateCode(String target, String code) {
        VerificationCode verificationCode = verificationCodeMapper.getByTargetAndCode(target, code);
        if (verificationCode != null) {
            verificationCodeMapper.markAsUsed(verificationCode.getId());
        }
    }

    @Override
    public void cleanExpiredCodes() {
        verificationCodeMapper.cleanExpiredCodes();
    }

    @Override
    public boolean isValidPhone(String phone) {
        // 11位数字，且第一位必须是1
        return phone != null && Pattern.matches("^1\\d{10}$", phone);
    }

    @Override
    public boolean isValidEmail(String email) {
        // 简单的邮箱格式验证
        return email != null && Pattern.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$", email);
    }

    /**
     * 生成指定长度的随机数字验证码
     */
    private String generateRandomCode(int length) {
        Random random = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(random.nextInt(10));
        }
        return sb.toString();
    }
} 