<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>${good.name} - 嗨购商城</title>
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
        .footer {
            background: #343a40;
            color: white;
            padding: 40px 0;
            margin-top: 50px;
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
        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        .footer a {
            color: #adb5bd;
            text-decoration: none;
        }
        .footer a:hover {
            color: white;
            text-decoration: underline;
        }
        .product-image {
            width: 100%;
            height: 500px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-weight: bold;
            object-fit: contain;
        }
        .product-details {
            padding: 50px 0;
        }
        .product-title {
            font-size: 2rem;
            font-weight: bold;
        }
        .product-price {
            font-size: 1.5rem;
            color: #dc3545;
            font-weight: bold;
        }
        .product-description {
            font-size: 1.1rem;
            margin-top: 20px;
        }
        .add-to-cart-btn {
            margin-top: 30px;
        }
    </style>
</head>
<body>

<!-- 导航条 -->
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
                    <a class="nav-link active" href="/"><i class="bi bi-house-door"></i> 首页</a>
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
                <p class="welcome-message" style="margin-right: 20px;margin-bottom: 2px"><i class="bi bi-person-check"></i> 欢迎，${user.account}</p>
                <c:choose>
                    <c:when test="${not empty user.avatar}">
                        <img src="${user.avatar}" width="40px" height="40px" alt="用户头像" class="user-avatar me-2">
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
                        <li><a class="dropdown-item" href="#"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-person"></i>购物车</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-basket"></i> 我的订单</a></li>
                        <li><a class="dropdown-item" href="#"><i class="bi bi-gear"></i> 账户设置</a></li>
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

<c:if test="${not empty msg}">
    <div class="container mt-4">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill"></i>
                ${msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </div>
</c:if>

<section class="product-details py-5">
    <div class="container">
        <div class="row g-5 align-items-start">

            <!-- 左侧图片区域 -->
            <div class="col-md-6">
                <div class="bg-white rounded-4 shadow-sm p-4 d-flex align-items-center justify-content-center" style="width: 100%; height: 500px;">
                    <img src="${good.imageUrl}" alt="${good.name}" width="500px" height="500px" class="img-fluid rounded-3" style="max-height: 100%; max-width: 100%; object-fit: contain;">
                </div>
            </div>

            <!-- 右侧商品信息区域 -->
            <div class="col-md-6 d-flex flex-column justify-content-between" style="height: 500px;">
                <div>
                    <h2 class="fw-bold text-dark mb-3">${good.name}</h2>

                    <div class="mb-3">
                        <span class="text-secondary text-decoration-line-through">原价：¥${good.normalPrice}</span><br>
                        <span class="fs-3 fw-bold text-danger mt-2 d-inline-block">惊喜价：¥${good.surprisePrice}</span>
                    </div>

                    <div class="mb-4">
                        <h6 class="text-muted">商品描述</h6>
                        <p class="text-dark">${good.description}</p>
                    </div>

                    <div class="mb-4">
                        <label for="quantity" class="form-label fw-semibold">选择数量</label>
                        <input type="number" id="quantity" name="visibleQuantity" min="1" value="1" class="form-control form-control-lg w-25">
                    </div>
                </div>

                <!-- 表单提交加购物车 -->
                <form action="/car/add" method="post" class="d-flex flex-column flex-md-row gap-3">
                    <input type="hidden" name="goodId" value="${good.id}">
                    <input type="hidden" id="hiddenQuantity" name="quantity" value="1">

                    <button type="submit" class="btn btn-primary btn-lg w-100">
                        <i class="bi bi-cart-plus"></i> 加入购物车
                    </button>
                </form>

            </div>
        </div>
    </div>
</section>


<!-- 页脚 -->
<footer class="footer">
    <div class="container">
        <div class="row">
            <div class="col-md-3">
                <h5>关于我们</h5>
                <ul class="list-unstyled">
                    <li><a href="#">公司简介</a></li>
                    <li><a href="#">企业文化</a></li>
                    <li><a href="#">发展历程</a></li>
                    <li><a href="#">联系我们</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>帮助中心</h5>
                <ul class="list-unstyled">
                    <li><a href="#">购物指南</a></li>
                    <li><a href="#">支付方式</a></li>
                    <li><a href="#">配送方式</a></li>
                    <li><a href="#">售后服务</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>商家服务</h5>
                <ul class="list-unstyled">
                    <li><a href="#">商家入驻</a></li>
                    <li><a href="#">商家中心</a></li>
                    <li><a href="#">营销服务</a></li>
                    <li><a href="#">物流服务</a></li>
                </ul>
            </div>
            <div class="col-md-3">
                <h5>关注我们</h5>
                <p>
                    <i class="bi bi-wechat me-2"></i> 官方微信<br>
                    <i class="bi bi-phone me-2"></i> 客服热线: 400-123-4567<br>
                    <i class="bi bi-envelope me-2"></i> 客服邮箱: service@example.com
                </p>
            </div>
        </div>
        <hr class="my-4 bg-secondary">
        <div class="text-center">
            <p>© 2024 嗨购商城. 保留所有权利.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const quantityInput = document.getElementById('quantity');
    const hiddenQuantity = document.getElementById('hiddenQuantity');
    const buyQuantity = document.getElementById('buyQuantity'); // 新增

    quantityInput.addEventListener('input', () => {
        const value = parseInt(quantityInput.value) || 1;
        hiddenQuantity.value = value;
        buyQuantity.value = value; // 同步给立即购买的表单
    });

</script>

</body>
</html>
