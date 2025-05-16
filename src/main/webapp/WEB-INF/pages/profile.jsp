<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>个人资料 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .profile-container {
            max-width: 1000px;
            margin: 40px auto;
            background: white;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .profile-header {
            background-color: #5d6bdf;
            color: white;
            padding: 30px;
            text-align: center;
        }
        .profile-header h1 {
            font-weight: 700;
            margin-bottom: 10px;
        }
        .profile-header p {
            margin-bottom: 0;
            opacity: 0.8;
        }
        .profile-nav {
            padding: 20px 30px;
            border-bottom: 1px solid #e9ecef;
        }
        .profile-nav ul {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        .profile-nav a {
            color: #6c757d;
            text-decoration: none;
            padding: 8px 15px;
            border-radius: 5px;
            display: block;
            transition: all 0.3s;
        }
        .profile-nav a:hover {
            background-color: #e9ecef;
        }
        .profile-nav a.active {
            background-color: #5d6bdf;
            color: white;
        }
        .profile-content {
            padding: 30px;
        }
        .avatar-container {
            text-align: center;
            margin-bottom: 30px;
        }
        .avatar {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 15px;
            border: 5px solid #e9ecef;
        }
        .btn-primary {
            background-color: #5d6bdf;
            border-color: #5d6bdf;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
            border-color: #4a56c9;
        }
        .form-label {
            font-weight: 500;
        }
        .user-stats {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 30px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: 700;
            color: #5d6bdf;
        }
        .stat-label {
            color: #6c757d;
            font-size: 14px;
        }
        .upload-btn {
            border: 1px dashed #5d6bdf;
            border-radius: 8px;
            padding: 12px;
            cursor: pointer;
            display: inline-block;
            transition: all 0.3s;
        }
        .upload-btn:hover {
            background-color: #e0e4f5;
        }
        .upload-btn input[type="file"] {
            display: none;
        }
        .navbar-brand img {
            height: 40px;
        }
        .navbar {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .user-avatar {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e9ecef;
        }
        .welcome-message {
            margin-bottom: 0;
            margin-right: 20px;
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
    </style>
</head>

<body>
<!-- 导航栏 -->
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
                        <li><a class="dropdown-item active" href="/user/profile"><i class="bi bi-person"></i> 个人中心</a></li>
                        <li><a class="dropdown-item" href="/car/toCar"><i class="bi bi-cart"></i> 购物车</a></li>
                        <li><a class="dropdown-item" href="/order/getOrder"><i class="bi bi-basket"></i> 我的订单</a></li>
                        <li><a class="dropdown-item" href="/address/list"><i class="bi bi-geo-alt"></i> 收货地址</a></li>
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

<div class="container">
    <div class="profile-container">
        <div class="profile-header">
            <h1>个人资料</h1>
            <p>管理您的账号信息</p>
        </div>

        <div class="profile-nav">
            <ul>
                <li><a href="/user/profile" class="active"><i class="bi bi-person-fill me-2"></i>基本资料</a></li>
                <li><a href="/user/password"><i class="bi bi-key-fill me-2"></i>修改密码</a></li>
                <li><a href="/user/phone"><i class="bi bi-phone-fill me-2"></i>绑定手机</a></li>
                <li><a href="/user/email"><i class="bi bi-envelope-fill me-2"></i>绑定邮箱</a></li>
                <li><a href="/"><i class="bi bi-house-fill me-2"></i>返回首页</a></li>
            </ul>
        </div>

        <div class="profile-content">
            <!-- 添加返回按钮 -->
            <div class="d-flex justify-content-end mb-4">
                <a href="/" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> 返回首页
                </a>
            </div>

            <!-- 显示提示消息 -->
            <div id="alertBox" class="alert" style="display: none;">
                <i class="bi bi-info-circle-fill me-2"></i> <span id="alertMessage"></span>
            </div>

            <form id="profileForm" enctype="multipart/form-data">
                <input type="hidden" id="userId" name="userId" value="${user.id}">

                <div class="avatar-container">
                    <c:choose>
                        <c:when test="${not empty user.avatar}">
                            <img src="${user.avatar}" alt="用户头像" class="avatar" id="avatarPreview" onerror="this.src='/static/images/default_avatar.png'">
                        </c:when>
                        <c:otherwise>
                            <img src="/static/images/default_avatar.png" alt="默认头像" class="avatar" id="avatarPreview">
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <label class="upload-btn">
                            <i class="bi bi-camera-fill me-2"></i> 更换头像
                            <input type="file" id="avatar" name="avatar" accept="image/*">
                        </label>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="account" class="form-label">用户名</label>
                            <input type="text" class="form-control" id="account" name="account" value="${user.account}">
                            <div class="form-text">用户名只能包含字母和数字，且不能以数字开头，6~10位</div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="nickname" class="form-label">昵称</label>
                            <input type="text" class="form-control" id="nickname" name="nickname" value="${user.nickname}">
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="telphone" class="form-label">手机号</label>
                            <input type="text" class="form-control" id="telphone" value="${user.telphone}" readonly>
                            <div class="form-text">如需修改，请前往"绑定手机"</div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="email" class="form-label">邮箱</label>
                            <input type="email" class="form-control" id="email" value="${user.email}" readonly>
                            <div class="form-text">如需修改，请前往"绑定邮箱"</div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="regTime" class="form-label">注册时间</label>
                            <c:if test="${not empty regTime}">
                                <input type="text" class="form-control" id="regTime" value="${regTime.year}-${regTime.monthValue < 10 ? '0' : ''}${regTime.monthValue}-${regTime.dayOfMonth < 10 ? '0' : ''}${regTime.dayOfMonth} ${regTime.hour < 10 ? '0' : ''}${regTime.hour}:${regTime.minute < 10 ? '0' : ''}${regTime.minute}:${regTime.second < 10 ? '0' : ''}${regTime.second}" readonly>
                            </c:if>
                            <c:if test="${empty regTime}">
                                <input type="text" class="form-control" id="regTime" value="未记录" readonly>
                            </c:if>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="mb-3">
                            <label for="lastLoginTime" class="form-label">上次登录时间</label>
                            <input type="text" class="form-control" id="lastLoginTime" value="<fmt:formatDate value='${user.lastLoginTime}' pattern='yyyy-MM-dd HH:mm:ss'/>" readonly>
                        </div>
                    </div>
                </div>

                <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                    <button type="button" id="submitBtn" class="btn btn-primary">
                        <i class="bi bi-check-circle-fill me-2"></i> 保存修改
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // 头像预览
        $('#avatar').change(function() {
            if (this.files && this.files[0]) {
                // 检查文件大小是否超过10MB
                const maxSize = 10 * 1024 * 1024; // 10MB
                if (this.files[0].size > maxSize) {
                    showAlert('danger', '文件大小超过限制，请选择10MB以内的图片');
                    // 清空文件输入
                    $(this).val('');
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#avatarPreview').attr('src', e.target.result);
                };
                reader.readAsDataURL(this.files[0]);
            }
        });

        // 提交表单
        $('#submitBtn').click(function() {
            // 禁用提交按钮
            $(this).prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 保存中...');

            // 创建FormData对象
            var formData = new FormData();
            formData.append('userId', $('#userId').val());
            formData.append('nickname', $('#nickname').val());
            formData.append('account', $('#account').val());

            // 添加头像文件（如果有选择）
            var avatarFile = $('#avatar')[0].files[0];
            if (avatarFile) {
                formData.append('avatar', avatarFile);
            }

            // 提交请求
            $.ajax({
                url: '/user/profile/update',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                success: function(response) {
                    if (response === 'success') {
                        showAlert('success', '个人资料更新成功！');
                        setTimeout(function() {
                            location.reload();
                        }, 2000);
                    } else {
                        showAlert('danger', response);
                        $('#submitBtn').prop('disabled', false).html('<i class="bi bi-check-circle-fill me-2"></i> 保存修改');
                    }
                },
                error: function() {
                    showAlert('danger', '更新失败，请稍后再试');
                    $('#submitBtn').prop('disabled', false).html('<i class="bi bi-check-circle-fill me-2"></i> 保存修改');
                }
            });
        });

        // 显示提示信息
        function showAlert(type, message) {
            const alertBox = $('#alertBox');
            const alertMessage = $('#alertMessage');

            alertBox.removeClass('alert-success alert-danger').addClass('alert-' + type);
            alertMessage.text(message);
            alertBox.fadeIn();

            // 自动隐藏（成功消息）
            if (type === 'success') {
                setTimeout(function() {
                    alertBox.fadeOut();
                }, 3000);
            }
        }
    });
</script>
</body>
</html> 