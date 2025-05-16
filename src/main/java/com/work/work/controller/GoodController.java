package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.service.GoodService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/good")
public class GoodController {
    @Autowired
    GoodService goodService;
    @GetMapping("/single/{id}")
    public String single(@PathVariable(name = "id") int goodid, Model model, HttpSession session) {
        Goods good = goodService.getGoodById(goodid);
        model.addAttribute("good", good);
        
        // 添加用户信息到模型中
        Object user = session.getAttribute("user");
        if (user != null) {
            model.addAttribute("user", user);
            // 确保清除可能存在的登录提示消息
            model.addAttribute("msg", null);
        }
        
        return "single_info";
    }

    @GetMapping("/all")
    public String all(@RequestParam(name = "category", required = false) String category, Model model, HttpSession session) {
        System.out.println("这是种类:"+category);
        List<Goods> goods;
        if (category != null && !category.isEmpty()) {
            goods = goodService.getGoodsByCategory(category);
        } else {
            goods = goodService.getAllGoods();
        }
        model.addAttribute("goods", goods);
        model.addAttribute("category", category);
        
        // 添加用户信息到模型中
        Object user = session.getAttribute("user");
        if (user != null) {
            model.addAttribute("user", user);
        }
        
        return "all_goods";
    }


}
