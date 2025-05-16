<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>选择收货地址 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .modal-title {
            color: #5d6bdf;
            font-weight: 600;
        }
        .address-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            position: relative;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .address-card:hover {
            border-color: #5d6bdf;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .address-card.selected {
            border: 2px solid #5d6bdf;
            background-color: #f9f9ff;
        }
        .default-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #5d6bdf;
            color: white;
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .add-address-card {
            border: 2px dashed #ddd;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .add-address-card:hover {
            border-color: #5d6bdf;
            background-color: #f8f9ff;
        }
        .add-address-icon {
            font-size: 2rem;
            color: #5d6bdf;
            margin-bottom: 10px;
        }
        .btn-primary {
            background-color: #5d6bdf;
            border-color: #5d6bdf;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
            border-color: #4a56c9;
        }
    </style>
</head>
<body>
<div class="modal-dialog modal-lg">
    <div class="modal-content">
        <div class="modal-header">
            <h5 class="modal-title"><i class="bi bi-geo-alt-fill"></i> 选择收货地址</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="window.history.back()"></button>
        </div>
        <div class="modal-body">
            <c:choose>
                <c:when test="${empty addresses}">
                    <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle me-2"></i> 您还没有添加收货地址，请添加新地址。
                    </div>
                </c:when>
                <c:otherwise>
                    <c:forEach var="address" items="${addresses}">
                        <div class="address-card ${address.isDefault ? 'selected' : ''}" data-address-id="${address.id}">
                            <c:if test="${address.isDefault}">
                                <span class="default-badge">默认地址</span>
                            </c:if>

                            <h5 class="mb-1"><i class="bi bi-person-fill"></i> ${address.receiver}</h5>
                            <p class="mb-1"><i class="bi bi-telephone-fill"></i> ${address.phone}</p>
                            <p class="mb-0"><i class="bi bi-geo-alt-fill"></i> ${address.province} ${address.city} ${address.district} ${address.detailAddress}</p>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <a href="/address/add?redirect=select" class="text-decoration-none">
                <div class="add-address-card">
                    <div class="add-address-icon">
                        <i class="bi bi-plus-circle"></i>
                    </div>
                    <h5>添加新地址</h5>
                    <p class="text-muted mb-0">添加一个新的收货地址</p>
                </div>
            </a>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" onclick="window.history.back()">
                <i class="bi bi-x-lg"></i> 取消
            </button>
            <button type="button" class="btn btn-primary" id="confirmAddressBtn">
                <i class="bi bi-check-lg"></i> 确认选择
            </button>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        let selectedAddressId = $('.address-card.selected').data('address-id');

        // 点击地址卡片选择地址
        $('.address-card').click(function() {
            $('.address-card').removeClass('selected');
            $(this).addClass('selected');
            selectedAddressId = $(this).data('address-id');
        });

        // 确认选择地址
        $('#confirmAddressBtn').click(function() {
            if (selectedAddressId) {
                window.opener.setSelectedAddress(selectedAddressId);
                window.close();
            } else {
                alert('请选择一个收货地址');
            }
        });
    });
</script>
</body>
</html> 