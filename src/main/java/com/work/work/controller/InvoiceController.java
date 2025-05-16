package com.work.work.controller;

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
            // 未登录，跳转登录页或订单页
            return "redirect:/login";
        }

        // 查找该用户该订单的发票列表（包含已开具和未开具）
        List<Invoice> invoices = invoiceService.searchInvoices(null, orderCode, user.getId());

        if (invoices != null && !invoices.isEmpty()) {
            // 假设一订单只有一张发票，取第一张发票跳转详情
            Invoice invoice = invoices.get(0);
            return "redirect:/invoice/detail/" + invoice.getId();
        } else {
            // 没有发票，跳转创建发票页面
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
    public String invoiceList(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Invoice> invoiceList = invoiceService.getInvoiceList(user.getId());
        model.addAttribute("invoiceList", invoiceList);
        return "invoice_list";
    }

    // 搜索发票
    @GetMapping("/search")
    public String searchInvoices(@RequestParam(required = false) Long invoiceNumber,
                                 @RequestParam(required = false) Long orderCode,
                                 HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        List<Invoice> invoiceList = invoiceService.searchInvoices(invoiceNumber, orderCode, user.getId());
        model.addAttribute("invoiceList", invoiceList);
        return "invoice_list";
    }

    // 查看发票详情
    @GetMapping("/detail/{id}")
    public String invoiceDetail(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        Invoice invoice = invoiceService.getInvoiceById(id);

        if (invoice == null || invoice.getUserId() != user.getId()) {
            return "redirect:/invoice/list";
        }

        model.addAttribute("invoice", invoice);
        return "invoice_detail";
    }

    // 跳转到编辑发票页面
    @GetMapping("/toEdit/{id}")
    public String toEditInvoice(@PathVariable int id, HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
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
        Invoice invoice = invoiceService.getInvoiceById(id);

        if (invoice != null && invoice.getUserId() == user.getId()) {
            invoiceService.deleteInvoice(id);
        }

        return "redirect:/invoice/list";
    }

    // 开具发票
    @GetMapping("/issue/{id}")
    public String issueInvoice(@PathVariable int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        Invoice invoice = invoiceService.getInvoiceById(id);

        if (invoice != null && invoice.getUserId() == user.getId()) {
            invoiceService.issueInvoice(id);
        }

        return "redirect:/invoice/detail/" + id;
    }
}