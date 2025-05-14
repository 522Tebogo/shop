package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.User;
import com.work.work.service.ItemService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
@RequestMapping("/order")
public class OrderController {
    @Autowired
    ItemService itemService;
    @GetMapping("/toOrder")
    public String toOrder(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Goods> goods = itemService.getGoodsByUserId(user.getId());
        model.addAttribute("goods", goods);
        return "order_sure";
    }

}
