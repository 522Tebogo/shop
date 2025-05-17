package com.work.work.controller;

import com.work.work.entity.Admin;
import com.work.work.entity.Invoice;
import com.work.work.entity.Order;
import com.work.work.entity.User;
import com.work.work.service.InvoiceService;
import com.work.work.service.OrderService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/invoice")
public class InvoiceController {
    @Autowired
    private InvoiceService invoiceService;

    @Autowired
    private OrderService orderService;

    // 根据订单号判断发票是否存在，跳转相应页面
    @GetMapping("/check/{orderCode}")
    public String checkInvoiceByOrderCode(@PathVariable long orderCode, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        List<Invoice> invoices = invoiceService.searchInvoices(null, orderCode, user.getId());

        if (invoices != null && !invoices.isEmpty()) {
            Invoice invoice = invoices.get(0);
            return "redirect:/invoice/detail/" + invoice.getId();
        } else {
            return "redirect:/invoice/toCreate/" + orderCode;
        }
    }

    // 跳转到申请发票页面
    @GetMapping("/toCreate/{orderCode}")
    public String toCreateInvoice(@PathVariable long orderCode, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Order order = orderService.getOrderByOrderCode(orderCode);

        if (order == null || order.getUserId() != user.getId()) {
            return "redirect:/order/getOrder";
        }

        model.addAttribute("order", order);
        return "invoice_create";
    }

    // 创建发票
    @PostMapping("/create")
    public String createInvoice(HttpSession session, Invoice invoice, Model model) {
        User user = (User) session.getAttribute("user");
        invoice.setUserId(user.getId());
        invoice.setStatus(0); // 未开具状态

        boolean success = invoiceService.createInvoice(invoice);
        if (success) {
            return "redirect:/invoice/list";
        }
        model.addAttribute("error", "发票创建失败");
        return "invoice_create";
    }

    // 发票列表
    @GetMapping("/list")
    public String listInvoices(HttpSession session, Model model) {
        Object currentUser = session.getAttribute("user");
        if (currentUser == null) {
            currentUser = session.getAttribute("admin");
            if (currentUser == null) {
                return "redirect:/login";
            }
        }

        System.out.println("当前状态是："+session.getAttribute("user_role"));
        List<Invoice> invoices;
        boolean isAdmin = false;

        if (session.getAttribute("user_role").equals("ADMIN")) {
            invoices = invoiceService.getAllInvoices();
            isAdmin = true;
        } else {
            User user = (User) currentUser;
            invoices = invoiceService.getInvoicesByUserId(user.getId());
        }
        System.out.println("invoices : "+invoices);
        model.addAttribute("invoices", invoices);
        model.addAttribute("isAdmin", isAdmin);
        return "invoice_list";
    }

    // 搜索发票
    @GetMapping("/search")
    public String searchInvoices(@RequestParam(required = false) Long invoiceNumber,
                                 @RequestParam(required = false) Long orderCode,
                                 HttpSession session, Model model) {
        Object currentUser = session.getAttribute("user");
        if (currentUser == null) {
            currentUser = session.getAttribute("admin");
            if (currentUser == null) {
                return "redirect:/login";
            }
        }

        List<Invoice> invoiceList;
        boolean isAdmin = false;

        if (currentUser instanceof Admin) {
            invoiceList = invoiceService.searchAllInvoices(invoiceNumber, orderCode);
            isAdmin = true;
        } else {
            User user = (User) currentUser;
            invoiceList = invoiceService.searchInvoices(invoiceNumber, orderCode, user.getId());
        }

        model.addAttribute("invoiceList", invoiceList);
        model.addAttribute("isAdmin", isAdmin);
        return "invoice_list";
    }

    // 查看发票详情
    @GetMapping("/detail/{id}")
    public String invoiceDetail(@PathVariable int id, HttpSession session, Model model) {
        Object currentUser = session.getAttribute("user");
        boolean isAdmin = false;

        if (currentUser == null) {
            currentUser = session.getAttribute("admin");
            if (currentUser == null) {
                return "redirect:/login";
            }
            isAdmin = true;
        }

        Invoice invoice = invoiceService.getInvoiceById(id);

        // 管理员可以查看所有发票，用户只能查看自己的
        if (invoice == null || (!isAdmin && invoice.getUserId() != ((User)currentUser).getId())) {
            return "redirect:/invoice/list";
        }

        model.addAttribute("invoice", invoice);
        model.addAttribute("isAdmin", isAdmin);
        return "invoice_detail";
    }

    // 跳转到编辑发票页面
    @GetMapping("/toEdit/{id}")
    public String toEditInvoice(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Invoice invoice = invoiceService.getInvoiceById(id);

        if (invoice == null || invoice.getUserId() != user.getId() || invoice.getStatus() != 0) {
            return "redirect:/invoice/list";
        }

        model.addAttribute("invoice", invoice);
        return "invoice_edit";
    }

    // 更新发票
    @PostMapping("/update")
    public String updateInvoice(HttpSession session, Invoice invoice, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        invoice.setUserId(user.getId());

        boolean success = invoiceService.updateInvoice(invoice);
        if (success) {
            return "redirect:/invoice/detail/" + invoice.getId();
        }
        model.addAttribute("error", "发票更新失败，可能已开具或不存在");
        return "invoice_edit";
    }

    // 删除发票
    @GetMapping("/delete/{id}")
    public String deleteInvoice(@PathVariable int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        Invoice invoice = invoiceService.getInvoiceById(id);

        if (invoice != null && invoice.getUserId() == user.getId()) {
            invoiceService.deleteInvoice(id);
        }

        return "redirect:/invoice/list";
    }

    // 开具发票（管理员专用）
    @GetMapping("/admin/issue/{id}")
    public String adminIssueInvoice(@PathVariable int id, HttpSession session) {
        System.out.println("here");
        String admin = (String) session.getAttribute("user_role");
                System.out.println("admin:"+admin);
        if (admin == null) {
            return "redirect:/admin/login";
        }
        invoiceService.issueInvoice(id);
        System.out.println("logic success");
        return "redirect:/invoice/admin/detail/"+id;
    }

    // 管理员查看发票详情
    @GetMapping("/admin/detail/{id}")
    public String adminInvoiceDetail(@PathVariable int id, HttpSession session, Model model) {
        System.out.println("准备获取详细信息");
        String admin = (String) session.getAttribute("user_role");

        if (admin == null) {
            return "redirect:/admin/login";
        }

        Invoice invoice = invoiceService.getInvoiceById(id);
        if (invoice == null) {
            return "redirect:/invoice/list";
        }
        System.out.println("发票的信息："+invoice);
        model.addAttribute("invoice", invoice);
        model.addAttribute("isAdmin", true);
        return "invoice_detail";
    }
}