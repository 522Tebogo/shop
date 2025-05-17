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
    public String single(HttpSession session,@PathVariable(name = "id") int goodid, Model model) {
        Goods good = goodService.getGoodById(goodid);
        model.addAttribute("good", good);
        session.removeAttribute("msg");

        return "single_info";
    }

    @GetMapping("/all")
    public String all(@RequestParam(name = "category", required = false) String category, Model model) {
        System.out.println("这是种类:"+category);
        List<Goods> goods;
        if (category != null && !category.isEmpty()) {
            goods = goodService.getGoodsByCategory(category);
        } else {
            goods = goodService.getAllGoods();
        }
        model.addAttribute("goods", goods);
        model.addAttribute("category", category);
        return "all_goods";
    }


}
