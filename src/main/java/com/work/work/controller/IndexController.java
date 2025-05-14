package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.service.GoodService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/")
public class IndexController {

    @Autowired
    GoodService goodService;
    @GetMapping("")
    public String index(HttpSession session, Model model) {
        // Get user info from session
        Object user = session.getAttribute("user");
        List<Goods> goods = goodService.getRandomGoods();
        // If user is logged in, add user info to model
        if (user != null) {
            model.addAttribute("user", user);
        }
        model.addAttribute("goods", goods);
        // If there is a success message, get it from session and add to model
        Object successMessage = session.getAttribute("successMessage");
        if (successMessage != null) {
            model.addAttribute("successMessage", successMessage);
            // Clear message after displaying it once
            session.removeAttribute("successMessage");
        }

        return "index";
    }

    @GetMapping("/index")
    public String redirectToIndex() {
        // Redirect /index requests to homepage
        return "redirect:/";
    }
}