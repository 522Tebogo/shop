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
            return "���ȵ�¼";
        }
        
        address.setUserId(user.getId());
        
        boolean success;
        if (address.getId() == null) {
            success = addressService.saveAddress(address);
        } else {
            Address existingAddress = addressService.getAddressById(address.getId());
            if (existingAddress == null || !existingAddress.getUserId().equals(user.getId())) {
                return "��Ȩ�޸Ĵ˵�ַ";
            }
            success = addressService.updateAddress(address);
        }
        
        return success ? "success" : "����ʧ�ܣ����Ժ�����";
    }
    
    @PostMapping("/delete/{id}")
    @ResponseBody
    public String deleteAddress(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "���ȵ�¼";
        }
        
        Address address = addressService.getAddressById(id);
        if (address == null || !address.getUserId().equals(user.getId())) {
            return "��Ȩɾ���˵�ַ";
        }
        
        boolean success = addressService.deleteAddress(id);
        return success ? "success" : "ɾ��ʧ�ܣ����Ժ�����";
    }
    
    @PostMapping("/setDefault/{id}")
    @ResponseBody
    public String setDefault(@PathVariable Integer id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "���ȵ�¼";
        }
        
        boolean success = addressService.setDefault(user.getId(), id);
        return success ? "success" : "����ʧ�ܣ����Ժ�����";
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