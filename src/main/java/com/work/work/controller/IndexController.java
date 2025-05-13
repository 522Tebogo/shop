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

        Object user = session.getAttribute("user");
        

        if (user != null) {
            model.addAttribute("user", user);
        }
        

        Object successMessage = session.getAttribute("successMessage");
        if (successMessage != null) {
            model.addAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        List<Goods> goods =goodService.getRandomGoods();
        System.out.println("下列是商品信息："+goods);
        session.setAttribute("goods", goods);
        return "index";
    }
    
    @GetMapping("/index")
    public String redirectToIndex() {
        return "redirect:/";
    }
}
