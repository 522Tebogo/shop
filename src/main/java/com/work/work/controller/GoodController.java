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

import java.util.Comparator;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/good")
public class GoodController {
    private static final int PAGE_SIZE = 30; // 每页显示12个商品

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
    public String all(@RequestParam(name = "category", required = false) String category,
                      @RequestParam(name = "page", defaultValue = "1") int page,
                      Model model) {
        System.out.println("这是种类:"+category);
        List<Goods> goods;
        if (category != null && !category.isEmpty()) {
            goods = goodService.getGoodsByCategory(category);
        } else {
            goods = goodService.getAllGoods();
        }

        // 计算分页信息
        int totalItems = goods.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

        // 确保页码在有效范围内
        page = Math.max(1, Math.min(page, totalPages));

        // 获取当前页的商品
        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<Goods> pagedGoods = goods.subList(fromIndex, toIndex);

        model.addAttribute("goods", pagedGoods);
        model.addAttribute("category", category);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        return "all_goods";
    }
    @GetMapping("/hot")
    public String hot(@RequestParam(name = "page", defaultValue = "1") int page,
                      Model model) {
        // 获取总商品数
        int totalItems = goodService.countAllGoods();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

        // 确保页码在有效范围内
        page = Math.max(1, Math.min(page, totalPages));

        // 获取当前页的热卖商品
        List<Goods> hotGoods = goodService.getHotGoodsByPage(page, PAGE_SIZE);

        model.addAttribute("goods", hotGoods);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        return "hot_goods";
    }

    @GetMapping("/discount")
    public String discount(Model model) {
        // 获取所有商品并按折扣力度排序(惊喜价/原价)，取前12个作为特惠商品
        List<Goods> allGoods = goodService.getAllGoods();
        List<Goods> discountGoods = allGoods.stream()
                .sorted(Comparator.comparingDouble(g -> g.getSurprisePrice() / g.getNormalPrice()))
                .limit(12)
                .collect(Collectors.toList());

        // 如果商品不足12个，随机补充
        if (discountGoods.size() < 12) {
            Random random = new Random();
            int needed = 12 - discountGoods.size();
            List<Goods> remainingGoods = allGoods.stream()
                    .filter(g -> !discountGoods.contains(g))
                    .collect(Collectors.toList());

            for (int i = 0; i < needed && !remainingGoods.isEmpty(); i++) {
                int randomIndex = random.nextInt(remainingGoods.size());
                discountGoods.add(remainingGoods.get(randomIndex));
                remainingGoods.remove(randomIndex);
            }
        }

        model.addAttribute("goods", discountGoods);
        return "discount_goods";
    }

}
