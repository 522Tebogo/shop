<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${empty address ? '添加' : '编辑'}收货地址 - 嗨购商城</title>
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
        .address-form-card {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
        .form-label {
            font-weight: 500;
        }
        .btn-primary {
            background-color: #5d6bdf;
            border-color: #5d6bdf;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
            border-color: #4a56c9;
        }
        .btn-outline-secondary {
            color: #6c757d;
            border-color: #6c757d;
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
        /* 返回按钮样式 */
        .back-btn {
            margin-bottom: 15px;
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
    <h2 class="section-title">${empty address ? '添加' : '编辑'}收货地址</h2>

    <!-- 添加返回按钮 -->
    <div class="row justify-content-center">
        <div class="col-md-8 text-start">
            <a href="/address/list" class="btn btn-outline-secondary back-btn">
                <i class="bi bi-arrow-left"></i> 返回地址列表
            </a>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="address-form-card">
                <form id="addressForm">
                    <c:if test="${not empty address}">
                        <input type="hidden" id="id" name="id" value="${address.id}">
                    </c:if>

                    <div class="mb-3">
                        <label for="receiver" class="form-label">收货人姓名 <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" id="receiver" name="receiver" value="${address.receiver}" required>
                    </div>

                    <div class="mb-3">
                        <label for="phone" class="form-label">联系电话 <span class="text-danger">*</span></label>
                        <input type="tel" class="form-control" id="phone" name="phone" value="${address.phone}" required pattern="^1\d{10}$">
                        <div class="form-text">请输入11位手机号码</div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-4">
                            <label for="province" class="form-label">省份 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="province" name="province" value="${address.province}" required>
                        </div>
                        <div class="col-md-4">
                            <label for="city" class="form-label">城市 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="city" name="city" value="${address.city}" required>
                        </div>
                        <div class="col-md-4">
                            <label for="district" class="form-label">区/县 <span class="text-danger">*</span></label>
                            <input type="text" class="form-control" id="district" name="district" value="${address.district}" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="detailAddress" class="form-label">详细地址 <span class="text-danger">*</span></label>
                        <textarea class="form-control" id="detailAddress" name="detailAddress" rows="3" required>${address.detailAddress}</textarea>
                        <div class="form-text">如街道、门牌号、小区、楼栋号、单元室等</div>
                    </div>

                    <div class="mb-4">
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="isDefault" name="isDefault" ${address.isDefault ? 'checked' : ''}>
                            <label class="form-check-label" for="isDefault">设为默认收货地址</label>
                        </div>
                    </div>

                    <div class="d-flex justify-content-between">
                        <a href="/address/list" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> 返回地址列表
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-lg"></i> 保存地址
                        </button>
                    </div>
                </form>
            </div>
        </div>
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
        $('#addressForm').submit(function(e) {
            e.preventDefault();

            const formData = {
                id: $('#id').val() || null,
                receiver: $('#receiver').val(),
                phone: $('#phone').val(),
                province: $('#province').val(),
                city: $('#city').val(),
                district: $('#district').val(),
                detailAddress: $('#detailAddress').val(),
                isDefault: $('#isDefault').is(':checked')
            };

            $.ajax({
                url: '/address/save',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify(formData),
                success: function(response) {
                    if(response === 'success') {
                        window.location.href = '/address/list';
                    } else {
                        alert('保存地址失败: ' + response);
                    }
                },
                error: function() {
                    alert('保存地址失败，请稍后再试');
                }
            });
        });
    });
</script>
</body>
</html> 