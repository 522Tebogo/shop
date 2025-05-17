package com.work.work.service.ServiceImpl;

import com.work.work.entity.Invoice;
import com.work.work.mapper.InvoiceMapper;
import com.work.work.service.InvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Random;

@Service
public class InvoiceServiceImpl implements InvoiceService {
    @Autowired
    private InvoiceMapper invoiceMapper;

    @Override
    public boolean createInvoice(Invoice invoice) {
        invoice.setStatus(0); // 初始状态为未开具
        invoice.setCreateTime(new Date());
        // 生成发票号
        long timestamp = System.currentTimeMillis();
        int randomNum = new Random().nextInt(9000) + 1000;
        invoice.setInvoiceNumber(Long.parseLong(String.valueOf(timestamp) + randomNum));
        return invoiceMapper.insertInvoice(invoice) > 0;
    }

    @Override
    public List<Invoice> getAllInvoices() {
        return invoiceMapper.selectAllInvoices();
    }

    @Override
    public List<Invoice> getInvoicesByUserId(int userId) {
        return invoiceMapper.selectByUserId(userId);
    }

    @Override
    public List<Invoice> searchAllInvoices(Long invoiceNumber, Long orderCode) {
        return invoiceMapper.searchAllInvoices(invoiceNumber, orderCode);
    }

    @Override
    public List<Invoice> searchInvoices(Long invoiceNumber, Long orderCode, int userId) {
        return invoiceMapper.searchInvoices(invoiceNumber, orderCode, userId);
    }

    @Override
    public Invoice getInvoiceById(int id) {
        return invoiceMapper.getInvoiceById(id);
    }

    @Override
    public boolean updateInvoice(Invoice invoice) {
        Invoice existing = invoiceMapper.getInvoiceById(invoice.getId());
        if (existing == null || existing.getStatus() != 0) {
            return false;
        }
        invoice.setUpdateTime(new Date());
        return invoiceMapper.updateInvoice(invoice) > 0;
    }

    @Override
    public boolean deleteInvoice(int id) {
        return invoiceMapper.updateInvoiceStatus(id, 2) > 0;
    }

    @Override
    public boolean issueInvoice(int id) {
        return invoiceMapper.updateInvoiceStatus(id, 1) > 0;
    }
}