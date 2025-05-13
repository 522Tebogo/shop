package com.work.work.controller;

import com.work.work.entity.User;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
    @GetMapping("/admin")
    public String admin(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        System.out.println("拿到了");
        if (user == null) {
            return "login";
        }

        model.addAttribute("user", user);
        return "admin";
    }

}
