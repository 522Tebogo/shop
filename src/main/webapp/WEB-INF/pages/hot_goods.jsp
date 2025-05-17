<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>热卖商品 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            min-height: 100vh;
        }

        /* 导航栏样式 - 与主界面一致 */
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .navbar-brand .logo-text {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            padding: 10px 15px;
            border-radius: 4px;
        }
        .nav-link.active {
            color: #5d6bdf;
            font-weight: 500;
        }
        .welcome-message {
            font-size: 0.9rem;
            color: #495057;
        }

        /* 热卖商品特定样式 */
        .hot-badge {
            position: absolute;
            top: 10px;
            right: 10px;
            background-color: #dc3545;
            color: white;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 0.8rem;
        }

        /* 商品卡片样式 - 与主界面一致 */
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
            position: relative;
        }
        .product-card:hover {
            transform: translateY(-5px);
        }
        .product-img {
            height: 180px;
            object-fit: contain;
            background: #f8f9fa;
        }
        .product-price {
            color: #dc3545;
            font-weight: bold;
        }
        .original-price {
            text-decoration: line-through;
            color: #6c757d;
        }

        /* 分页样式 */
        .pagination .page-item.active .page-link {
            background-color: #5d6bdf;
            border-color: #5d6bdf;
        }
        .pagination .page-link {
            color: #5d6bdf;
        }
        .pagination .page-item.disabled .page-link {
            color: #6c757d;
        }
    </style>
</head>
<body>
<!-- 导航栏 - 与主界面完全一致 -->
<nav class="navbar navbar-expand-lg navbar-light bg-white sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/">
            <div class="logo-text">嗨购商城</div>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="/index"><i class="bi bi-house-door"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/good/all"><i class="bi bi-grid"></i> 商品分类</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="/good/hot"><i class="bi bi-star"></i> 热卖商品</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/good/discount"><i class="bi bi-gift"></i> 限时特惠</a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <% if (session.getAttribute("user") != null) { %>
                <p class="welcome-message mb-0 me-2"><i class="bi bi-person-check"></i> 欢迎，${user.account}</p>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}" alt="用户头像" class="rounded-circle me-2" style="width: 38px; height: 38px;">
                    </c:when>
                    <c:otherwise>
                        <div class="bg-secondary rounded-circle p-2 me-2">
                            <i class="bi bi-person text-white"></i>
                        </div>
                    </c:otherwise>
                </c:choose>
                <div class="dropdown">
                    <button class="btn btn-outline-secondary dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        我的账户
                    </button>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-cart"></i> 购物车</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-receipt"></i> 我的订单</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item" href="/user/logout"><i class="bi bi-box-arrow-right"></i> 退出</a></li>
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

<div class="container">
    <!-- 页面标题 -->
    <h2 class="my-4"><i class="bi bi-fire text-danger"></i> 热卖商品</h2>
    <p class="text-muted mb-4">精选最受欢迎的热销商品</p>

    <!-- 商品展示 -->
    <div class="row">
        <c:forEach items="${goods}" var="item">
            <div class="col-md-3 col-6 mb-4">
                <div class="product-card h-100">
                    <span class="hot-badge">热卖</span>
                    <div class="product-image-container d-flex justify-content-center align-items-center" style="height: 180px; background: #f8f9fa;">
                        <img src="${not empty item.imageUrl ? item.imageUrl : '//via.placeholder.com/300x200?text=商品图片'}" class="product-img" alt="${item.name}">
                    </div>
                    <div class="p-3">
                        <h5 class="mb-2">${item.name}</h5>
                        <div class="d-flex align-items-center mb-2">
                            <span class="product-price">¥${item.surprisePrice}</span>
                            <span class="original-price ms-2">¥${item.normalPrice}</span>
                        </div>
                        <p class="text-muted small mb-2">${item.description}</p>
                        <div class="badge bg-light text-secondary">${item.category}</div>
                    </div>
                    <div class="p-3 border-top">
                        <a href="/good/single/${item.id}" class="btn btn-outline-primary w-100 btn-sm">
                            <i class="bi bi-cart3"></i> 立即购买
                        </a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- 分页导航 -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center mt-4">
                    <%-- 上一页按钮 --%>
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="/good/hot?page=${currentPage - 1}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>

                    <%-- 页码按钮 --%>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="/good/hot?page=${i}">${i}</a>
                    </li>
                </c:forEach>

                    <%-- 下一页按钮 --%>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="/good/hot?page=${currentPage + 1}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </ul>
        </nav>
    </c:if>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>