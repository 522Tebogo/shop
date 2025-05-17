package com.work.work.mapper;

import com.work.work.entity.Invoice;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface InvoiceMapper {
    int insertInvoice(Invoice invoice);

    List<Invoice> selectAllInvoices();

    List<Invoice> selectByUserId(Integer userId);

    List<Invoice> searchAllInvoices(Long invoiceNumber, Long orderCode);

    List<Invoice> searchInvoices(Long invoiceNumber, Long orderCode, Integer userId);

    Invoice getInvoiceById(int id);

    int updateInvoice(Invoice invoice);

    int updateInvoiceStatus(int id, int status);
}