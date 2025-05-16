package com.work.work.service;

import com.work.work.entity.Invoice;

import java.util.List;

public interface InvoiceService {
    // 创建发票
    boolean createInvoice(Invoice invoice);

    // 查询发票列表
    List<Invoice> getInvoiceList(int userId);

    // 根据条件查询发票
    List<Invoice> searchInvoices(Long invoiceNumber, Long orderCode, Integer userId);

    // 获取单个发票详情
    Invoice getInvoiceById(int id);

    // 更新发票信息
    boolean updateInvoice(Invoice invoice);

    // 删除发票（逻辑删除）
    boolean deleteInvoice(int id);

    // 开具发票（将状态从未开具改为已开具）
    boolean issueInvoice(int id);
}