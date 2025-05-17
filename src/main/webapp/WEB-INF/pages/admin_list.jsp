<%@ page language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>后台管理 - 用户列表</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- 引入 Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入 Bootstrap Icons (可选) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">

    <%-- 你原有的 admin.css，如果需要可以保留，但很多样式会被 Bootstrap 或下面的内联样式覆盖 --%>
    <%-- <link rel="stylesheet" href="<c:url value='/css/admin.css'/>"/> --%>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            display: flex;
            min-height: 100vh;
            flex-direction: column;
        }

        /* === Navbar 和 Sidebar 的样式可以从 admin.jsp 中复用或提取到公共CSS === */
        /* Admin Navbar 样式 (与 admin.jsp 保持一致) */
        .admin-navbar {
            background-color: #343a40;
            color: #f8f9fa;
            padding: 0.75rem 1rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.15);
        }
        .admin-navbar .navbar-brand { color: #fff; font-weight: bold; font-size: 1.5rem; }
        .admin-navbar .nav-link, .admin-navbar .user-info span, .admin-navbar .user-info a { color: #adb5bd; margin-left: 15px; }
        .admin-navbar .nav-link:hover, .admin-navbar .user-info a:hover { color: #fff; }
        .admin-navbar .user-info .bold { color: #fff; }
        .default-admin-logo { background-color: #5d6bdf; color: white; font-weight: bold; text-align: center; padding: 5px 10px; border-radius: 4px; display: inline-block; font-size: 1.2rem; }

        /* 主体内容区域布局 (与 admin.jsp 保持一致) */
        .admin-main-wrapper { display: flex; flex-grow: 1; }

        /* 左侧菜单栏样式 (与 admin.jsp 保持一致) */
        #admin_left_sidebar { /* 重命名 id 以示区分，或者使用 class */
            width: 250px;
            background-color: #495057;
            padding-top: 20px; /* 上方留白 */
            color: #f8f9fa;
            min-height: calc(100vh - 70px); /* Navbar 高度假设为70px */
        }
        #admin_left_sidebar .menu { list-style: none; padding: 0; margin: 0; }
        #admin_left_sidebar .menu li a { display: block; padding: 12px 20px; color: #e9ecef; text-decoration: none; transition: background-color 0.2s ease, color 0.2s ease; border-left: 3px solid transparent; }
        #admin_left_sidebar .menu li a:hover, #admin_left_sidebar .menu li a.active { background-color: #5a6268; color: #fff; border-left-color: #6e8efb; }
        #admin_left_sidebar .menu li a i { margin-right: 10px; }
        #admin_left_sidebar .copyright-text { text-align: center; padding: 20px 0; font-size: 0.85em; color: #adb5bd; position: absolute; bottom: 10px; width: 250px; }


        /* 右侧内容区域样式 (与 admin.jsp 类似) */
        #admin_right_content { /* 重命名 id */
            flex-grow: 1;
            padding: 30px;
            background-color: #fff;
        }
        #admin_right_content .page-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #333;
            margin-bottom: 25px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        /* 用户列表特定样式 */
        .search_form_bootstrap { /* 新的搜索表单容器 */
            margin-bottom: 20px;
            padding: 20px;
            background-color: #f8f9fa;
            border: 1px solid #e9ecef;
            border-radius: 8px;
        }

        /* Bootstrap 表格美化 */
        .table th {
            white-space: nowrap; /* 防止表头文字换行 */
        }
        .table td {
            vertical-align: middle; /* 内容垂直居中 */
        }
        .action-buttons .btn { /* 统一操作按钮间距 */
            margin: 2px;
            min-width: 70px; /* 按钮最小宽度 */
            font-size: 0.8rem; /* 按钮字体稍小 */
            padding: 0.25rem 0.5rem;
        }

        /* 用户状态显示 - 使用 Bootstrap Badges */
        .status-badge { font-size: 0.85em; padding: 0.3em 0.6em; }
        .status_y { background-color: #28a745 !important; color: white !important; } /* 正常 - 绿色 */
        .status_f { background-color: #ffc107 !important; color: black !important; } /* 冻结 - 黄色 */
        .status_b { background-color: #dc3545 !important; color: white !important; } /* 黑名单 - 红色 */
        .status_d { background-color: #6c757d !important; color: white !important; } /* 已删除 - 灰色 */
        .status_m { background-color: #0d6efd !important; color: white !important; } /* 管理员 - 蓝色 */
        .status_unknown { background-color: #adb5bd !important; color: white !important; }

        #separator { display: none; } /* 在新布局中通常不需要 */
    </style>
    <script type="text/javascript">
        const CTX_PATH = "${pageContext.request.contextPath}";

        function confirmAction(message, url) {
            if (confirm(message)) {
                window.location.href = url;
            }
        }

        function freezeUser(userId) {
            confirmAction('确定要冻结该用户 (ID: ' + userId + ') 吗？', CTX_PATH + '/admin/user/freeze?id=' + userId);
        }
        function unfreezeUser(userId) {
            confirmAction('确定要解冻该用户 (ID: ' + userId + ') 吗？', CTX_PATH + '/admin/user/unfreeze?id=' + userId);
        }
        function addToBlacklist(userId) {
            confirmAction('确定要将该用户 (ID: ' + userId + ') 加入黑名单吗？', CTX_PATH + '/admin/user/blacklist/add?id=' + userId);
        }
        function removeFromBlacklist(userId) {
            confirmAction('确定要将该用户 (ID: ' + userId + ') 从黑名单中移除吗？', CTX_PATH + '/admin/user/blacklist/remove?id=' + userId);
        }
        function deleteUser(userId) {
            confirmAction('确定要删除该用户 (ID: ' + userId + ') 吗？此操作可能不可恢复！', CTX_PATH + '/admin/user/delete?id=' + userId);
        }
        function upgradeToAdmin(userId, userAccount) {
            confirmAction('确定要将用户 "' + userAccount + '" (ID: ' + userId + ') 升级为管理员吗？', CTX_PATH + '/admin/user/upgradeToAdmin?id=' + userId);
        }
        function demoteToUser(userId, userAccount) {
            confirmAction('确定要取消用户 "' + userAccount + '" (ID: ' + userId + ') 的管理员身份吗？', CTX_PATH + '/admin/user/demoteToUser?id=' + userId);
        }
    </script>
</head>
<body>

<!-- Navbar (与 admin.jsp 保持一致) -->
<nav class="admin-navbar navbar navbar-expand-lg">
    <div class="container-fluid">
        <a class="navbar-brand" href="<c:url value='/admin'/>"><span class="default-admin-logo">嗨购后台</span></a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNavbarContent" aria-controls="adminNavbarContent" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon" style="background-image: url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 30 30'%3e%3cpath stroke='rgba%28255, 255, 255, 0.55%29' stroke-linecap='round' stroke-miterlimit='10' stroke-width='2' d='M4 7h22M4 15h22M4 23h22'/%3e%3c/svg%3e\");"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNavbarContent">
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center user-info">
                <li class="nav-item"><span>您好, <label class='bold'>${sessionScope.user.account}</label></span></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/'/>" target='_blank'><i class="bi bi-shop"></i> 商城首页</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/admin'/>"><i class="bi bi-speedometer2"></i> 后台首页</a></li>
                <li class="nav-item"><a class="nav-link" href="<c:url value='/admin/logout'/>"><i class="bi bi-box-arrow-right"></i> 退出管理</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="admin-main-wrapper">
    <!-- 左侧 Sidebar (与 admin.jsp 保持一致) -->
    <div id="admin_left_sidebar">
        <ul class="menu">
            <li><a href="<c:url value='/admin'/>" class="${pageContext.request.requestURI.endsWith('/admin') && !pageContext.request.requestURI.contains('/admin/') ? 'active' : ''}"><i class="bi bi-house-door-fill"></i> 管理首页</a></li>
            <li><a href="<c:url value='/admin/goods/add'/>" class="${pageContext.request.requestURI.contains('/admin/goods/add') ? 'active' : ''}"><i class="bi bi-plus-square-fill"></i> 商品管理</a></li>
            <li><a href="<c:url value='/admin/user/list'/>" class="${pageContext.request.requestURI.contains('/admin/user/list') ? 'active' : ''}"><i class="bi bi-people-fill"></i> 用户列表</a></li>
            <li><a href="<c:url value='/admin/orders/manage'/>" class="${pageContext.request.requestURI.contains('/admin/orders/manage') ? 'active' : ''}"><i class="bi bi-truck"></i> 订单发货管理</a></li>
        </ul>
        <div class="copyright-text">© 2024 嗨购后台</div>
    </div>

    <!-- 右侧主内容区 -->
    <div id="admin_right_content">
        <h2 class="page-title"><i class="bi bi-people"></i> 用户列表管理</h2>

        <!-- 反馈信息区域 -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 搜索表单 -->
        <div class="search_form_bootstrap">
            <form action="<c:url value='/admin/user/list'/>" method="get" class="row g-3 align-items-center">
                <div class="col-md-4">
                    <label for="account_search_input" class="form-label visually-hidden">账号</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-person"></i></span>
                        <input type="text" class="form-control" id="account_search_input" name="account_search" placeholder="按账号搜索" value="${param.account_search}">
                    </div>
                </div>
                <div class="col-md-4">
                    <label for="email_search_input" class="form-label visually-hidden">邮箱</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                        <input type="text" class="form-control" id="email_search_input" name="email_search" placeholder="按邮箱搜索" value="${param.email_search}">
                    </div>
                </div>
                <div class="col-md-auto">
                    <button class="btn btn-primary" type="submit"><i class="bi bi-search"></i> 搜索</button>
                </div>
            </form>
        </div>

        <!-- 用户列表表格 -->
        <div class="table-responsive"> <%-- 确保小屏幕上表格可滚动 --%>
            <table class="table table-striped table-hover table-bordered">
                <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>账号</th>
                    <th>邮箱</th>
                    <th>电话</th>
                    <th>状态</th>
                    <th style="min-width: 280px;">操作</th> <%-- 给操作列一个最小宽度 --%>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${userlist}" var="userItem">
                    <tr>
                        <td>${userItem.id}</td>
                        <td><c:out value="${userItem.account}"/></td>
                        <td><c:out value="${userItem.email}"/></td>
                        <td><c:out value="${userItem.telphone}"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${userItem.status == 'Y'}"><span class="badge status_y status-badge">正常</span></c:when>
                                <c:when test="${userItem.status == 'F'}"><span class="badge status_f status-badge">已冻结</span></c:when>
                                <c:when test="${userItem.status == 'B'}"><span class="badge status_b status-badge">黑名单</span></c:when>
                                <c:when test="${userItem.status == 'D'}"><span class="badge status_d status-badge">已删除</span></c:when>
                                <c:when test="${userItem.status == 'M'}"><span class="badge status_m status-badge">管理员</span></c:when>
                                <c:otherwise><span class="badge status_unknown status-badge">${userItem.status} (未知)</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="action-buttons">
                            <c:choose>
                                <c:when test="${userItem.status == 'Y'}">
                                    <button type="button" onclick="freezeUser(${userItem.id})" class="btn btn-sm btn-warning"><i class="bi bi-snow2"></i> 冻结</button>
                                    <button type="button" onclick="addToBlacklist(${userItem.id})" class="btn btn-sm btn-danger"><i class="bi bi-person-fill-slash"></i> 拉黑</button>
                                    <button type="button" onclick="upgradeToAdmin(${userItem.id}, '${userItem.account}')" class="btn btn-sm btn-info"><i class="bi bi-person-fill-up"></i> 设为管理员</button>
                                    <button type="button" onclick="deleteUser(${userItem.id})" class="btn btn-sm btn-secondary"><i class="bi bi-trash3"></i> 删除</button>
                                </c:when>
                                <c:when test="${userItem.status == 'F'}">
                                    <button type="button" onclick="unfreezeUser(${userItem.id})" class="btn btn-sm btn-success"><i class="bi bi-unlock"></i> 解冻</button>
                                    <button type="button" onclick="addToBlacklist(${userItem.id})" class="btn btn-sm btn-danger"><i class="bi bi-person-fill-slash"></i> 拉黑</button>
                                    <button type="button" onclick="deleteUser(${userItem.id})" class="btn btn-sm btn-secondary"><i class="bi bi-trash3"></i> 删除</button>
                                </c:when>
                                <c:when test="${userItem.status == 'B'}">
                                    <button type="button" onclick="removeFromBlacklist(${userItem.id})" class="btn btn-sm btn-info"><i class="bi bi-person-check"></i> 移除黑名单</button>
                                    <button type="button" onclick="deleteUser(${userItem.id})" class="btn btn-sm btn-secondary"><i class="bi bi-trash3"></i> 删除</button>
                                </c:when>
                                <c:when test="${userItem.status == 'M'}">
                                    <button type="button" onclick="demoteToUser(${userItem.id}, '${userItem.account}')" class="btn btn-sm btn-warning"><i class="bi bi-person-fill-down"></i> 取消管理员</button>
                                </c:when>
                                <c:when test="${userItem.status == 'D'}">
                                    <span class="text-muted"><i>已删除</i></span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-muted"><i>无操作</i></span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty userlist}">
                    <tr>
                        <td colspan="6" class="text-center fst-italic text-muted py-4">暂无用户数据。</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div id="separator"></div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>