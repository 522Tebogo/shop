package com.work.work.controller;

import com.work.work.entity.User;
import com.work.work.service.ServiceImpl.UserServiceImpl;
import com.work.work.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserServiceImpl userService;


    @GetMapping("/login")
    public String login() {
        return "login";
    }
    @PostMapping("/login")
    public String login(@RequestParam String account, @RequestParam String password, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = userService.login(account, password, session);
        
        if (user != null) {
            // 登录成功，存储用户信息到session
            session.setAttribute("user", user);
            session.removeAttribute("loginError");
            
            // 添加成功消息
            String successMessage = "登录成功，欢迎回来 " + user.getAccount() + "！";
            redirectAttributes.addFlashAttribute("successMessage", successMessage);
            System.out.println("登录成功，设置成功消息: " + successMessage);
            
            return "redirect:/";
        } else {
            // 登录失败
            String errorMessage = "账号或密码错误，请重试";
            redirectAttributes.addFlashAttribute("loginError", errorMessage);
            System.out.println("登录失败，设置错误消息: " + errorMessage);
            
            return "redirect:/user/login";
        }
    }
    @GetMapping("/register")
    public String register() {
        return "register";
    }
    //注册功能
    @PostMapping("/register")
    @ResponseBody
    public String register(@RequestParam String account,
                           @RequestParam String password,
                           @RequestParam String telphone,
                           @RequestParam String email,
                           @RequestPart(required = false) MultipartFile avatar
    ) throws IOException {
        try {
            boolean re = userService.insertUser(account, password, telphone, email, avatar);
            if(re){
                return "success";
            } else {
                return "用户名已存在，请更换用户名";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "注册失败: " + e.getMessage();
        }
    }


    // 登出功能（可選）
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.removeAttribute("user");
        redirectAttributes.addFlashAttribute("successMessage", "您已成功退出登录");
        return "redirect:/user/login";
    }

}
