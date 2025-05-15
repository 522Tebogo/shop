<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>订单详情 - 嗨购商城</title>
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
        .order-summary {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }
    </style>

    <script>
        // 页面加载后 5 秒跳转到订单列表页
        setTimeout(function() {
            window.location.href = '/order/getOrder';
        }, 5000);
    </script>
</head>
<body>

<!-- 导航栏 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/"><div class="default-logo">嗨购商城</div></a>
    </div>
</nav>

<!-- 页面内容 -->
<div class="container mt-5">

    <!-- 成功提示 -->
    <div class="alert alert-success text-center" role="alert">
        <strong>订单确认成功！</strong> 系统将在 5 秒后跳转至订单列表页面。
    </div>

    <h2 class="section-title">订单详情</h2>

    <div class="order-summary">
        <h4>订单信息</h4>
        <hr>
        <div class="d-flex justify-content-between">
            <p>订单编号：</p>
            <p class="fw-bold">${order.orderCode}</p>
        </div>
        <div class="d-flex justify-content-between">
            <p>下单时间：</p>
            <p class="fw-bold">${order.createTime}</p>
        </div>
        <div class="d-flex justify-content-between">
            <p>订单总金额：</p>
            <p class="fw-bold text-danger">¥<fmt:formatNumber value="${order.totalPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/></p>
        </div>
        <c:if test="${not empty user}">
            <div class="d-flex justify-content-between">
                <p>下单用户：</p>
                <p class="fw-bold">${user.nickname}</p>
            </div>
        </c:if>
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
