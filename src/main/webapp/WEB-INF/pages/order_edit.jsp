<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑订单 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .cart-item {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 20px;
            padding: 20px;
            display: flex;
            align-items: center;
        }
        .cart-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 20px;
            border-radius: 8px;
        }
        .cart-total {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-top: 30px;
        }
        .address-card {
            background: #fff;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .address-item {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: border-color 0.2s;
        }
        .address-item:hover, .address-item.selected {
            border-color: #0d6efd;
            background-color: #f0f7ff;
        }
        .address-item.selected {
            box-shadow: 0 0 0 2px rgba(13, 110, 253, 0.25);
        }
    </style>
</head>
<body>

<div class="container mt-5">
    <h2 class="section-title" style="text-align: center">编辑订单 - 订单号: ${orderCode}</h2>

    <c:if test="${not empty msg}">
        <div class="container mt-4">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill"></i>
                    ${msg}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </div>
    </c:if>
    <c:if test="${empty goods}">
        <div class="alert alert-info text-center">
            您的购物车为空，<a href="/" class="alert-link">去首页看看</a>吧！
        </div>
    </c:if>

    <c:if test="${not empty goods}">
        <!-- 收货地址选择区域 -->
        <div class="address-card">
            <h4><i class="bi bi-geo-alt"></i> 收货地址</h4>
            <hr>
            <c:if test="${empty addresses}">
                <p class="text-muted">您还没有添加收货地址，<a href="/address/add" class="btn btn-sm btn-outline-primary">添加地址</a></p>
            </c:if>
            <c:if test="${not empty addresses}">
                <div class="address-list">
                    <c:forEach var="address" items="${addresses}">
                        <div class="address-item ${address.id eq order.addressId ? 'selected' : ''}" data-address-id="${address.id}">
                            <div class="d-flex justify-content-between">
                                <strong>${address.receiver}</strong>
                                <span>${address.phone}</span>
                            </div>
                            <div class="text-muted mt-2">
                                ${address.province}${address.city}${address.district}${address.detailAddress}
                                <c:if test="${address.isDefault}">
                                    <span class="badge bg-primary ms-2">默认</span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div class="mt-3">
                    <a href="/address/add" class="btn btn-sm btn-outline-primary">
                        <i class="bi bi-plus-circle"></i> 新建收货地址
                    </a>
                </div>
            </c:if>
        </div>
        
        <%-- 后端先算出初始价格 --%>
        <c:set var="totalPrice" value="0" />
        <c:forEach var="item" items="${goods}">
            <c:set var="totalPrice" value="${totalPrice + (item.surprisePrice * item.num)}" />
        </c:forEach>
        <c:set var="shippingFee" value="${totalPrice * 0.02}" />
        <c:set var="finalTotal" value="${totalPrice + shippingFee}" />

        <c:forEach var="item" items="${goods}">
            <div class="cart-item">
                <img src="${item.imageUrl}" alt="${item.name}">
                <div class="flex-grow-1">
                    <h5>${item.name}</h5>
                    <p class="text-muted">描述: ${item.description}</p>
                    <p class="text-danger">单价: ¥<fmt:formatNumber value="${item.surprisePrice}" type="number" minFractionDigits="2" /></p>
                    <div class="d-flex align-items-center">
                        <label class="me-2">数量:</label>
                        <input type="number"
                               class="form-control form-control-sm quantity-input"
                               style="width: 80px"
                               data-good-id="${item.id}"
                               data-price="${item.surprisePrice}"
                               value="${item.num}" min="1">
                    </div>
                </div>
            </div>
        </c:forEach>

        <div class="cart-total">
            <h4>订单总计</h4>
            <div class="d-flex justify-content-between">
                <span>商品总价:</span>
                <strong id="total-price">¥<fmt:formatNumber value="${totalPrice}" type="number" minFractionDigits="2" /></strong>
            </div>
            <div class="d-flex justify-content-between">
                <span>运费 (2%):</span>
                <strong id="shipping-fee">¥<fmt:formatNumber value="${shippingFee}" type="number" minFractionDigits="2" /></strong>
            </div>
            <hr>
            <div class="d-flex justify-content-between">
                <span>应付总额:</span>
                <strong class="text-danger fs-5" id="final-total">¥<fmt:formatNumber value="${finalTotal}" type="number" minFractionDigits="2" /></strong>
            </div>
            <div class="text-end mt-3">
                <form method="post" action="/order/update">
                    <input type="hidden" name="orderCode" value="${orderCode}" />
                    <input type="hidden" name="addressId" id="selectedAddressId" value="${order.addressId}" />
                    <c:forEach var="item" items="${goods}">
                        <input type="hidden" name="goodsId" value="${item.id}" />
                        <input type="hidden" name="nums" id="hidden-num-${item.id}" value="${item.num}" />
                    </c:forEach>
                    <a href="/order/getOrder" class="btn btn-outline-secondary me-2">取消</a>
                    <button type="submit" class="btn btn-primary">保存</button>
                </form>
            </div>
        </div>
    </c:if>
</div>

<script>
    const orderCode = "${orderCode}"; // 使用字符串形式，避免Long类型转换问题

    // 处理地址选择
    document.querySelectorAll('.address-item').forEach(item => {
        item.addEventListener('click', () => {
            // 移除其他所有选中状态
            document.querySelectorAll('.address-item').forEach(el => {
                el.classList.remove('selected');
            });
            
            // 为当前点击的添加选中状态
            item.classList.add('selected');
            
            // 更新隐藏字段的值
            const addressId = item.getAttribute('data-address-id');
            document.getElementById('selectedAddressId').value = addressId;
        });
    });

    // 监听数量变化并更新服务器与前端总价
    document.querySelectorAll('.quantity-input').forEach(input => {

        input.addEventListener('change', () => {
            const goodId = input.dataset.goodId;
            const quantity = parseInt(input.value);
            if (quantity < 1) {
                alert("数量不能小于 1");
                input.value = 1;
                return;
            }

            // 发送异步请求到后台
            fetch('/car/updateQuantityTwo', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ goodId, quantity, orderCode: Number(orderCode) })
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        updateCartSummary(data.updatedGoods);
                    } else {
                        alert("库存不足！");
                    }
                })
                .catch(err => {
                    console.error("请求失败:", err);
                    alert("更新失败，请检查网络或稍后再试。");
                });
        });
    });
    document.querySelector('form').addEventListener('submit', (e) => {
        document.querySelectorAll('.quantity-input').forEach(input => {
            const goodId = input.dataset.goodId;
            const quantity = input.value;
            const hiddenInput = document.getElementById('hidden-num-' + goodId);
            if (hiddenInput) {
                hiddenInput.value = quantity;
            }
        });
    });

    // 动态更新总价、运费、总额
    function updateCartSummary(goods) {
        let total = 0;
        goods.forEach(item => {
            total += item.surprisePrice * item.num;
        });
        const shipping = total * 0.02;
        const finalTotal = total + shipping;

        document.querySelector('#total-price').textContent = '¥' + total.toFixed(2);
        document.querySelector('#shipping-fee').textContent = '¥' + shipping.toFixed(2);
        document.querySelector('#final-total').textContent = '¥' + finalTotal.toFixed(2);
    }
</script>

</body>
</html>
