<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html >
<html>
<head>
    <%-- base href="${base}/" --%> <%-- 暂时注释掉，如果需要，确保路径正确 --%>
    <title>后台管理 - 嗨购商城</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1"> <%-- 响应式布局需要 --%>

    <!-- 引入 Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入 Bootstrap Icons (可选) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <%-- 保留原有的 admin.css，如果它有一些基础布局或不想丢失的样式 --%>
    <%-- <link rel="stylesheet" href="css/admin.css" /> --%>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa; /* 统一背景色 */
            display: flex;
            min-height: 100vh;
            flex-direction: column;
        }

        /* 自定义 Admin Navbar 样式 */
        .admin-navbar {
            background-color: #343a40; /* 深色导航栏，类似首页页脚 */
            color: #f8f9fa;
            padding: 0.75rem 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }
        .admin-navbar .navbar-brand {
            color: #fff;
            font-weight: bold;
            font-size: 1.5rem;
        }
        .admin-navbar .nav-link,
        .admin-navbar .user-info span,
        .admin-navbar .user-info a {
            color: #adb5bd; /* 链接和文字颜色 */
            margin-left: 15px;
        }
        .admin-navbar .nav-link:hover,
        .admin-navbar .user-info a:hover {
            color: #fff; /* 悬停时变白 */
        }
        .admin-navbar .user-info .bold {
            color: #fff; /* 用户名加粗且白色 */
        }

        /* 主体内容区域布局 */
        .admin-main-wrapper {
            display: flex;
            flex-grow: 1; /* 占据剩余空间 */
        }

        /* 左侧菜单栏样式 */
        #admin_left {
            width: 250px; /* 侧边栏宽度 */
            background-color: #495057; /* 深灰色侧边栏 */
            padding: 20px 0;
            color: #f8f9fa;
            min-height: calc(100vh - 70px); /* 减去 Navbar 高度，确保撑满 */
        }
        #admin_left .menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        #admin_left .menu li a {
            display: block;
            padding: 12px 20px;
            color: #e9ecef; /* 菜单项文字颜色 */
            text-decoration: none;
            transition: background-color 0.2s ease, color 0.2s ease;
            border-left: 3px solid transparent; /* 左侧指示条 */
        }
        #admin_left .menu li a:hover,
        #admin_left .menu li a.active { /* 假设有 active 类用于当前页面 */
            background-color: #5a6268; /* 悬停/激活背景色 */
            color: #fff;
            border-left-color: #6e8efb; /* 激活时左侧指示条颜色，借鉴首页主题色 */
        }
        #admin_left .menu li a i { /* 图标样式 */
            margin-right: 10px;
        }
        #admin_left #copyright { /* 版权信息可以放在底部 */
            text-align: center;
            padding: 20px 0;
            font-size: 0.85em;
            color: #adb5bd;
            position: absolute; /* 或者使用 flexbox 将其推到底部 */
            bottom: 10px;
            width: 100%;
        }


        /* 右侧内容区域样式 */
        #admin_right {
            flex-grow: 1; /* 占据右侧剩余空间 */
            padding: 30px;
            background-color: #fff; /* 主内容区白色背景 */
        }
        #admin_right .welcome-card { /* 卡片式欢迎信息 */
            padding: 25px;
            background-color: #e9f7fd; /* 淡蓝色背景 */
            border-left: 5px solid #6e8efb; /* 左侧主题色边框 */
            border-radius: 5px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        #admin_right .welcome-card h4 {
            color: #333;
            margin-bottom: 10px;
        }

        /* 为了兼容你原有的 id="separator"，如果它有特殊用途 */
        #separator {
            display: none; /* 在新布局中可能不需要 */
        }

        /* 如果你的 logo 是图片 */
        .admin-navbar .navbar-brand img {
            height: 30px; /* 调整 Navbar 中的 Logo 大小 */
            vertical-align: middle;
        }
        /* 如果 logo 是文字 */
        .default-admin-logo {
            background-color: #5d6bdf; /* 借鉴首页 */
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 5px 10px;
            border-radius: 4px;
            display: inline-block;
            font-size: 1.2rem; /* 调整字体大小 */
        }
    </style>
</head>
<body>

<!-- 新的 Bootstrap 风格 Navbar -->
<nav class="admin-navbar navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="<c:url value='/admin'/>">
            <%-- 如果你有图片logo --%>
            <%-- <img src="<c:url value='images/admin/logo.png'/>" alt="后台管理系统" /> --%>
            <%-- 如果是文字logo --%>
            <span class="default-admin-logo">嗨购后台</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbarContent" aria-controls="adminNavbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="background-image: url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.55%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e\");"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbarContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center user-info">
                <li class="nav-item">
                    <span>您好, <label class='bold'>${sessionScope.user.account != null ? sessionScope.user.account : (sessionScope.loginUser.account != null ? sessionScope.loginUser.account : '管理员')}</label></span>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/'/>" target='_blank'><i class="bi bi-shop"></i> 商城首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin'/>"><i class="bi bi-speedometer2"></i> 后台首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/admin/logout'/>"><i class="bi bi-box-arrow-right"></i> 退出管理</a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<div class="admin-main-wrapper">
    <div id="admin_left">
        <ul class="menu">
            <%-- 假设当前页面是 /admin，可以给它一个 active 类 --%>
            <li><a href="<c:url value='/admin'/>" class="${pageContext.request.requestURI.endsWith('/admin') && !pageContext.request.requestURI.contains('/admin/') ? 'active' : ''}"><i class="bi bi-house-door-fill"></i> 管理首页</a></li>
            <li><a href="<c:url value='/admin/goods/add'/>" class="${pageContext.request.requestURI.contains('/admin/goods/add') ? 'active' : ''}"><i class="bi bi-plus-square-fill"></i> 商品管理</a></li>
            <li><a href="<c:url value='/admin/user/list'/>" class="${pageContext.request.requestURI.contains('/admin/user/list') ? 'active' : ''}"><i class="bi bi-people-fill"></i> 用户列表</a></li>
                <li><a href="<c:url value='/admin/orders/manage'/>" class="${pageContext.request.requestURI.contains('/admin/orders/manage') ? 'active' : ''}"><i class="bi bi-truck"></i> 订单发货管理</a></li>
                <li><a class="dropdown-item" href="/invoice/list"><i class="bi bi-envelope"></i> 发票管理</a></li>
            <%-- 根据需要添加更多菜单项 --%>
        </ul>
        <div id="copyright">© 2024 嗨购后台</div>
    </div>

    <div id="admin_right">
        <div class="welcome-card">
            <h4>欢迎回来！</h4>
            <p class="lead">欢迎使用嗨购商城后台管理平台。</p>
            <p>您可以在左侧菜单中选择相应功能进行操作。</p>
        </div>
        <%-- 这里可以根据不同页面加载不同的内容片段 --%>
    </div>
</div>

<%-- 如果你的 #separator 有实际作用，可以取消注释并调整样式 --%>
<%-- <div id="separator"></div> --%>

<!-- Bootstrap 5 JS Bundle (Popper.js included) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>