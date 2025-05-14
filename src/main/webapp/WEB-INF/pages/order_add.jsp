<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单确认 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        .navbar-brand img {
            height: 40px;
        }
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        .section-title {
            text-align: center;
            margin-bottom: 30px;
            position: relative;
            padding-bottom: 15px;
        }
        .default-logo {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px;
            border-radius: 4px;
            display: inline-block;
        }
        .section-title:after {
            content: '';
            width: 70px;
            height: 3px;
            background: #6e8efb;
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%);
        }
        .order-item {
            background: white;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            display: flex;
            align-items: center;
        }
        .order-item img {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 4px;
        }
        .order-item-details {
            flex-grow: 1;
        }
        .order-total {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/"><div class="default-logo">嗨购商城</div></a>
        <!-- 其他导航栏内容 -->
    </div>
</nav>

<!-- 订单确认内容 -->
<div class="container mt-5">
    <h2 class="section-title">订单确认</h2>

    <!-- 显示订单提交成功提示 -->
    <div class="alert alert-success" role="alert">
        <strong>成功！</strong> ${message}
    </div>

    <div class="order-total">
        <h4>订单信息</h4>
        <hr>
        <div class="d-flex justify-content-between">
            <p>订单编号:</p>
            <p class="fw-bold">${order.orderCode}</p>
        </div>
        <div class="d-flex justify-content-between">
            <p>下单时间:</p>
            <p class="fw-bold">${order.orderTime}</p>
        </div>
        <hr>
        <h5>订单详情</h5>

        <c:set var="totalPrice" value="0" />
        <c:forEach var="item" items="${order.items}">
            <c:set var="itemTotal" value="${item.price * item.quantity}" />
            <c:set var="totalPrice" value="${totalPrice + itemTotal}" />

            <div class="order-item">
                <img src="${item.imageUrl}" alt="${item.name}">
                <div class="order-item-details">
                    <h5>${item.name}</h5>
                    <p class="text-muted">规格: ${item.description}</p>
                    <p class="text-danger fw-bold">¥<fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
                    <p class="text-muted">数量: ${item.quantity}</p>
                    <p class="text-muted">小计: ¥<fmt:formatNumber value="${item.price * item.quantity}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
                </div>
            </div>
        </c:forEach>

        <hr>
        <div class="d-flex justify-content-between">
            <p>总金额:</p>
            <p class="fw-bold">¥<fmt:formatNumber value="${totalPrice}" type="number" maxFractionDigits="2" minFractionDigits="2"/></p>
        </div>
    </div>
</div>

<!-- 页脚 -->
<footer class="footer mt-5">
    <div class="container">
        <!-- 页脚内容 -->
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
