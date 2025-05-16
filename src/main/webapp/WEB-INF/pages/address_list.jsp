<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>我的收货地址 - 嗨购商城</title>
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
        .welcome-message {
            margin-bottom: 0;
            margin-right: 20px;
        }
        .address-card {
            background: white;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            position: relative;
        }
        .address-card.default {
            border: 2px solid #5d6bdf;
            background-color: #f8f9ff;
        }
        .default-badge {
            position: absolute;
            top: 15px;
            right: 15px;
            background-color: #5d6bdf;
            color: white;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
        }
        .address-actions {
            margin-top: 15px;
            display: flex;
            gap: 10px;
        }
        .default-logo {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px 15px;
            border-radius: 4px;
            display: inline-block;
        }
        .add-address-card {
            background: white;
            border-radius: 8px;
            margin-bottom: 20px;
            padding: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            text-align: center;
            border: 2px dashed #ddd;
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
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <div class="default-logo">嗨购商城</div>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/"><i class="bi bi-house-door"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-grid"></i> 商品分类</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-star"></i> 热卖商品</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-gift"></i> 限时特惠</a>
                </li>
            </ul>

            <div class="d-flex align-items-center">
                <% if (session.getAttribute("user") != null) { %>
                <p class="welcome-message"><i class="bi bi-person-check"></i> 欢迎，${user.account}</p>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}" width="50px" height="50px" alt="用户头像" class="user-avatar me-2">
                    </c:when>
                    <c:otherwise>
                        <div style="width: 35px; height: 35px; background-color: #e9ecef; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-right: 10px;">
                            <i class="bi bi-person"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                        我的账户
                    </button>
                    <ul class="dropdown-menu" aria-labelledby="userDropdown">
                        <li><a class="dropdown-item" href="/user/profile"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-cart"></i> 购物车</a></li>
                        <li><a class="dropdown-item" href="/order/getOrder"><i class="bi bi-basket"></i> 我的订单</a></li>
                        <li><a class="dropdown-item active" href="/address/list"><i class="bi bi-geo-alt"></i> 收货地址</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/user/logout"><i class="bi bi-box-arrow-right"></i> 退出登录</a></li>
                    </ul>
                </div>
                <% } else { %>
                <a href="/user/login" class="btn btn-outline-primary me-2"><i class="bi bi-box-arrow-in-right"></i> 登录</a>
                <a href="/user/register" class="btn btn-primary"><i class="bi bi-person-plus"></i> 注册</a>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<div class="container mt-5">
    <h2 class="section-title">我的收货地址</h2>

    <div class="d-flex justify-content-end mb-4">
        <a href="/" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left"></i> 返回首页
        </a>
    </div>

    <div class="row">
        <div class="col-md-12 mb-4">
            <a href="/address/add" class="text-decoration-none">
                <div class="add-address-card">
                    <div class="add-address-icon">
                        <i class="bi bi-plus-circle"></i>
                    </div>
                    <h5>添加新地址</h5>
                    <p class="text-muted">添加一个新的收货地址</p>
                </div>
            </a>
        </div>

        <c:choose>
            <c:when test="${empty addresses}">
                <div class="col-md-12">
                    <div class="alert alert-info" role="alert">
                        <i class="bi bi-info-circle me-2"></i> 您还没有添加收货地址，请点击上方的"添加新地址"按钮添加。
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <c:forEach var="address" items="${addresses}">
                    <div class="col-md-6">
                        <div class="address-card ${address.isDefault ? 'default' : ''}">
                            <c:if test="${address.isDefault}">
                                <span class="default-badge">默认地址</span>
                            </c:if>

                            <h5><i class="bi bi-person-fill"></i> ${address.receiver}</h5>
                            <p class="mb-1"><i class="bi bi-telephone-fill"></i> ${address.phone}</p>
                            <p><i class="bi bi-geo-alt-fill"></i> ${address.province} ${address.city} ${address.district} ${address.detailAddress}</p>

                            <div class="address-actions">
                                <c:if test="${!address.isDefault}">
                                    <button class="btn btn-sm btn-outline-primary set-default-btn" data-address-id="${address.id}">
                                        <i class="bi bi-check-circle"></i> 设为默认
                                    </button>
                                </c:if>
                                <a href="/address/edit/${address.id}" class="btn btn-sm btn-outline-secondary">
                                    <i class="bi bi-pencil"></i> 编辑
                                </a>
                                <button class="btn btn-sm btn-outline-danger delete-address-btn" data-address-id="${address.id}">
                                    <i class="bi bi-trash"></i> 删除
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<footer class="footer mt-5 py-3 bg-light">
    <div class="container text-center">
        <p class="text-muted mb-0">© 2024 嗨购商城. 保留所有权利.</p>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // 设置默认地址
        $('.set-default-btn').click(function() {
            const addressId = $(this).data('address-id');

            $.ajax({
                url: '/address/setDefault/' + addressId,
                type: 'POST',
                success: function(response) {
                    if(response === 'success') {
                        window.location.reload();
                    } else {
                        alert('设置默认地址失败: ' + response);
                    }
                },
                error: function() {
                    alert('设置默认地址失败，请稍后再试');
                }
            });
        });

        // 删除地址
        $('.delete-address-btn').click(function() {
            if(confirm('确定要删除这个地址吗？')) {
                const addressId = $(this).data('address-id');

                $.ajax({
                    url: '/address/delete/' + addressId,
                    type: 'POST',
                    success: function(response) {
                        if(response === 'success') {
                            window.location.reload();
                        } else {
                            alert('删除地址失败: ' + response);
                        }
                    },
                    error: function() {
                        alert('删除地址失败，请稍后再试');
                    }
                });
            }
        });
    });
</script>
</body>
</html> 