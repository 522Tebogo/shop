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
        // 生成发票号，格式：当前时间毫秒数 + 4位随机数字符串
        long timestamp = System.currentTimeMillis();
        int randomNum = new Random().nextInt(9000) + 1000; // 1000~9999随机数
        invoice.setInvoiceNumber(Long.parseLong(String.valueOf(timestamp) + randomNum));
        return invoiceMapper.insertInvoice(invoice) > 0;
    }

    @Override
    public List<Invoice> getInvoiceList(int userId) {
        return invoiceMapper.getInvoiceListByUserId(userId);
    }

    @Override
    public List<Invoice> searchInvoices(Long invoiceNumber, Long orderCode, Integer userId) {
        return invoiceMapper.searchInvoices(invoiceNumber, orderCode, userId);
    }

    @Override
    public Invoice getInvoiceById(int id) {
        return invoiceMapper.getInvoiceById(id);
    }

    @Override
    public boolean updateInvoice(Invoice invoice) {
        // 只能修改未开具的发票
        Invoice existing = invoiceMapper.getInvoiceById(invoice.getId());
        if (existing == null || existing.getStatus() != 0) {
            return false;
        }
        invoice.setUpdateTime(new Date());
        return invoiceMapper.updateInvoice(invoice) > 0;
    }

    @Override
    public boolean deleteInvoice(int id) {
        // 逻辑删除，将状态改为2
        return invoiceMapper.updateInvoiceStatus(id, 2) > 0;
    }

    @Override
    public boolean issueInvoice(int id) {
        // 开具发票，将状态改为1
        return invoiceMapper.updateInvoiceStatus(id, 1) > 0;
    }
}