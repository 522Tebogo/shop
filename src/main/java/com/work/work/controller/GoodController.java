package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.service.GoodService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/good")
public class GoodController {
    @Autowired
    GoodService goodService;
    @GetMapping("/single/{id}")
    public String single(@PathVariable(name = "id") int goodid, Model model) {
        Goods good = goodService.getGoodById(goodid);
        model.addAttribute("good", good);
        return "single_info";
    }
}
