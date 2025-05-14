package com.work.work.controller;

import com.work.work.service.VerificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
/**
 * Verification Code Controller
 */
@Controller
@RequestMapping("/verification")
public class VerificationController {

    @Autowired
    private VerificationService verificationService;

    @PostMapping("/sendPhoneCode")
    @ResponseBody
    public String sendPhoneCode(@RequestParam String phone) {

        System.out.println("准备发送验证码");

        System.out.println("发送手机验证码到: " + phone);
        
        // Validate phone format
        if (!verificationService.isValidPhone(phone)) {
            System.out.println("手机号格式不正确");
            return "Phone number format is incorrect, must be 11 digits and start with 1";
        }
        
        try {
            verificationService.generateCode(phone);
            System.out.println("验证码发送成功");
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("验证码发送失败: " + e.getMessage());
            return "Failed to send verification code: " + e.getMessage();
        }
    }
    
    /**
     * Send email verification code
     */
    @PostMapping("/sendEmailCode")
    @ResponseBody
    public String sendEmailCode(@RequestParam String email) {
        System.out.println("发送邮箱验证码到: " + email);
        
        // Validate email format
        if (!verificationService.isValidEmail(email)) {
            System.out.println("邮箱格式不正确");
            return "Email format is incorrect";
        }
        
        try {
            verificationService.generateCode(email);
            System.out.println("验证码发送成功");
            return "success";
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("验证码发送失败: " + e.getMessage());
            return "Failed to send verification code: " + e.getMessage();
        }
    }
} 