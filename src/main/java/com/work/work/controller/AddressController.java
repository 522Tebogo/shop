package com.work.work.controller;

import com.work.work.entity.Address;
import com.work.work.entity.User;
import com.work.work.service.AddressService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/address")
public class AddressController {

    @Autowired
    private AddressService addressService;
    
    @GetMapping("/list")
    public String list(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<Address> addresses = addressService.getAddressByUserId(user.getId());
        model.addAttribute("addresses", addresses);
        
        return "address_list";
    }
    
    @GetMapping("/add")
    public String showAddForm(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        return "address_form";
    }
    
    @GetMapping("/edit/{id}")
    public String showEditForm(@PathVariable Integer id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        Address address = addressService.getAddressById(id);
        if (address == null || !address.getUserId().equals(user.getId())) {
            return "redirect:/address/list";
        }
        
        model.addAttribute("address", address);
        return "address_form";
    }
    
    @PostMapping("/save")
    @ResponseBody
    public String saveAddress(@RequestBody Address address, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "请先登录";
        }
        
        address.setUserId(user.getId());
        
        boolean success;
        if (address.getId() == null) {
            success = addressService.saveAddress(address);
        } else {
            Address existingAddress = addressService.getAddressById(address.getId());
            if (existingAddress == null || !existingAddress.getUserId().equals(user.getId())) {
                return "无权修改此地址";
            }
            success = addressService.updateAddress(address);
        }
        
        return success ? "success" : "保存失败，请稍后再试";
    }
    
    @PostMapping("/delete/{id}")
    @ResponseBody
    public String deleteAddress(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "请先登录";
        }
        
        Address address = addressService.getAddressById(id);
        if (address == null || !address.getUserId().equals(user.getId())) {
            return "无权删除此地址";
        }
        
        boolean success = addressService.deleteAddress(id);
        return success ? "success" : "删除失败，请稍后再试";
    }
    
    @PostMapping("/setDefault/{id}")
    @ResponseBody
    public String setDefault(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "请先登录";
        }
        
        boolean success = addressService.setDefault(user.getId(), id);
        return success ? "success" : "设置失败，请稍后再试";
    }
    
    @GetMapping("/select")
    public String selectAddress(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        
        List<Address> addresses = addressService.getAddressByUserId(user.getId());
        model.addAttribute("addresses", addresses);
        
        return "address_select";
    }
} 