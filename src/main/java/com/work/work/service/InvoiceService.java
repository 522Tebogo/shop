package com.work.work.service;

import com.work.work.entity.Invoice;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public interface InvoiceService {
    // 创建发票
    boolean createInvoice(Invoice invoice);

    // 管理员获取所有发票
    List<Invoice> getAllInvoices();

    // 用户获取自己的发票
    List<Invoice> getInvoicesByUserId(int userId);

    // 管理员搜索所有发票
    List<Invoice> searchAllInvoices(Long invoiceNumber, Long orderCode);

    // 用户搜索自己的发票
    List<Invoice> searchInvoices(Long invoiceNumber, Long orderCode, int userId);

    // 获取单个发票详情
    Invoice getInvoiceById(int id);

    // 更新发票信息
    boolean updateInvoice(Invoice invoice);

    // 删除发票（逻辑删除）
    boolean deleteInvoice(int id);

    // 开具发票（将状态从未开具改为已开具）
    boolean issueInvoice(int id);
}