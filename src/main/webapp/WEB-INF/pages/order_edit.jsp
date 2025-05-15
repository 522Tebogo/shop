<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的购物车 - 嗨购商城</title>
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
    </style>
</head>
<body>

<div class="container mt-5">
    <h2 class="section-title" style="text-align: center">编辑订单 - 订单号: ${orderCode}</h2>


    <c:if test="${empty goods}">
        <div class="alert alert-info text-center">
            您的购物车为空，<a href="/" class="alert-link">去首页看看</a>吧！
        </div>
    </c:if>

    <c:if test="${not empty goods}">
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
                <span>运费 (5%):</span>
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
                    <c:forEach var="item" items="${goods}">
                        <input type="hidden" name="goodsId" value="${item.id}" />
                        <input type="hidden" name="nums" id="hidden-num-${item.id}" value="${item.num}" />
                    </c:forEach>
                    <button type="submit" class="btn btn-primary">保存</button>
                </form>
            </div>
        </div>
    </c:if>
</div>

<script>
    const orderCode = ${orderCode}; // 直接拿 JSP 变量赋值给 JS


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
                body: JSON.stringify({ goodId, quantity ,orderCode})
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        updateCartSummary(data.updatedGoods);
                    } else {
                        alert("更新失败，请稍后再试。");
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
