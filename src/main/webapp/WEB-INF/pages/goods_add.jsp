<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>后台管理 - 商品管理</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- 引入 Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入 Bootstrap Icons (可选) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

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

        /* === Navbar 和 Sidebar 的样式可以从 admin.jsp/admin_list.jsp 中复用或提取到公共CSS === */
        .admin-navbar { background-color: #343a40; color: #f8f9fa; padding: 0.75rem 1rem; box-shadow: 0 2px 10px rgba(0,0,0,0.15); }
        .admin-navbar .navbar-brand { color: #fff; font-weight: bold; font-size: 1.5rem; }
        .admin-navbar .nav-link, .admin-navbar .user-info span, .admin-navbar .user-info a { color: #adb5bd; margin-left: 15px; }
        .admin-navbar .nav-link:hover, .admin-navbar .user-info a:hover { color: #fff; }
        .admin-navbar .user-info .bold { color: #fff; }
        .default-admin-logo { background-color: #5d6bdf; color: white; font-weight: bold; text-align: center; padding: 5px 10px; border-radius: 4px; display: inline-block; font-size: 1.2rem; }
        .admin-main-wrapper { display: flex; flex-grow: 1; }
        #admin_left_sidebar { width: 250px; background-color: #495057; padding-top: 20px; color: #f8f9fa; min-height: calc(100vh - 70px); } /* Navbar 高度假设为70px */
        #admin_left_sidebar .menu { list-style: none; padding: 0; margin: 0; }
        #admin_left_sidebar .menu li a { display: block; padding: 12px 20px; color: #e9ecef; text-decoration: none; transition: background-color 0.2s ease, color 0.2s ease; border-left: 3px solid transparent; }
        #admin_left_sidebar .menu li a:hover, #admin_left_sidebar .menu li a.active { background-color: #5a6268; color: #fff; border-left-color: #6e8efb; }
        #admin_left_sidebar .menu li a i { margin-right: 10px; }
        #admin_left_sidebar .copyright-text { text-align: center; padding: 20px 0; font-size: 0.85em; color: #adb5bd; position: absolute; bottom: 10px; width: 250px; }

        #admin_right_content { flex-grow: 1; padding: 30px; background-color: #fff; }
        #admin_right_content .page-title { font-size: 1.8rem; font-weight: 600; color: #333; margin-bottom: 25px; padding-bottom: 10px; border-bottom: 1px solid #eee; }

        /* 商品管理页面特定样式 */
        .add-goods-form-section {
            padding: 25px;
            background-color: #fdfdff; /* 淡雅的背景色 */
            border: 1px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .form-label { font-weight: 500; } /* 表单标签稍加粗 */
        .required-star { color: red; margin-left: 2px; }

        .goods-list-table-section {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #e0e0e0;
        }
        .table th { white-space: nowrap; }
        .table td { vertical-align: middle; }
        .thumbnail_img_list { max-width: 60px; max-height: 60px; border: 1px solid #eee; border-radius: 4px; }

        .action-buttons-list .btn { margin: 2px; font-size: 0.8rem; padding: 0.25rem 0.5rem; }

        #showImagePreview { /* 修改ID以区分列表中的缩略图 */
            max-width: 120px;
            max-height: 120px;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            object-fit: cover; /* 保持图片比例 */
        }
        #separator { display: none; }
    </style>
    <script type="text/javascript">
        $(function() {
            // 图片预览功能
            $('#uploadInput').on('change', function() {
                if (this.files && this.files[0]) {
                    const file = this.files[0];
                    if (file.type.startsWith('image/')) {
                        let reader = new FileReader();
                        reader.onload = function(e) {
                            $('#showImagePreview').attr('src', e.target.result).show();
                        }
                        reader.readAsDataURL(file);
                    } else {
                        $('#showImagePreview').attr('src', '').hide(); // 如果非图片则清空
                        alert("请选择图片文件！");
                    }
                } else {
                    $('#showImagePreview').attr('src', '').hide();
                }
            });

            // 删除商品确认
            $('.delete-good-btn-list').on('click', function(e) { // 修改类名以区分
                if (!confirm('您确定要删除这个商品吗？此操作不可恢复！')) {
                    e.preventDefault();
                }
            });

            // 清空表单按钮
            $('#clearFormBtn').on('click', function() {
                // 先重置表单
                $('#goodsForm')[0].reset();

                // 清空文件输入框和图片预览
                $('#uploadInput').val('');
                $('#showImagePreview').attr('src', '').hide();
            });

        });
    </script>
</head>
<body>

<!-- Navbar (与 admin.jsp/admin_list.jsp 保持一致) -->
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
    <!-- 左侧 Sidebar (与 admin.jsp/admin_list.jsp 保持一致) -->
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
        <h2 class="page-title"><i class="bi bi-box-seam"></i> 商品管理</h2>

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
        <c:if test="${not empty warningMessage}">
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-circle-fill me-2"></i>${warningMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>
        <c:if test="${not empty org.springframework.validation.BindingResult.goods}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <strong><i class="bi bi-exclamation-octagon-fill me-2"></i>表单验证错误：</strong>
                <ul>
                    <c:forEach items="${org.springframework.validation.BindingResult.goods.allErrors}" var="error">
                        <li>${error.defaultMessage}</li>
                    </c:forEach>
                </ul>
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>


        <!-- 添加商品表单 -->
        <div class="add-goods-form-section">
            <h3 class="mb-3"><i class="bi bi-plus-circle"></i> 添加新商品</h3>
            <form action="<c:url value='/admin/goods/add'/>" method="post" enctype="multipart/form-data" id="goodsForm" class="row g-3">
                <div class="col-md-6">
                    <label for="goodsName" class="form-label">商品名称 <span class="required-star">*</span></label>
                    <input type="text" class="form-control" id="goodsName" name="name" value="${goods.name}" required>
                </div>
                <div class="col-md-6">
                    <label for="goodsNo" class="form-label">商品编号 (可选)</label>
                    <input type="text" class="form-control" id="goodsNo" name="no" value="${goods.no}">
                </div>
                <div class="col-md-6">
                    <label for="goodsCategory" class="form-label">所属分类 <span class="required-star">*</span></label>
                    <input type="text" class="form-control" id="goodsCategory" name="category" value="${goods.category}" placeholder="例如：数码产品" required>
                </div>
                <div class="col-md-6">
                    <label for="goodsStock" class="form-label">库存</label>
                    <input type="number" class="form-control" id="goodsStock" name="stock" min="0" value="${goods.stock}">
                </div>
                <div class="col-md-6">
                    <label for="goodsMarketPrice" class="form-label">市场价格 (元)</label>
                    <input type="number" class="form-control" id="goodsMarketPrice" name="marketPrice" min="0" step="0.01" value="${goods.normalPrice}">
                </div>
                <div class="col-md-6">
                    <label for="goodsSalePrice" class="form-label">销售价格 (元)</label>
                    <input type="number" class="form-control" id="goodsSalePrice" name="salePrice" min="0" step="0.01" value="${goods.surprisePrice}">
                </div>
                <div class="col-md-12">
                    <label for="uploadInput" class="form-label">商品缩略图</label>
                    <input class="form-control" type="file" name="file" id="uploadInput" accept="image/png, image/jpeg, image/gif">
                    <img src="${not empty goods.imageUrl ? goods.imageUrl : ''}" id="showImagePreview" alt="图片预览" style="display:${not empty goods.imageUrl ? 'inline-block' : 'none'};">
                </div>
                <div class="col-12">
                    <label for="goodsDescription" class="form-label">产品描述</label>
                    <textarea class="form-control" id="goodsDescription" name="description" rows="3">${goods.description}</textarea>
                </div>
                <div class="col-12 mt-3">
                    <button type="submit" class="btn btn-primary"><i class="bi bi-send-plus"></i> 发布商品</button>
                    <button type="button" class="btn btn-outline-secondary ms-2" id="clearFormBtn"><i class="bi bi-eraser"></i> 清空表单</button>
                </div>
            </form>
        </div>

        <!-- 现有商品列表 -->
        <div class="goods-list-table-section">
            <h3 class="mb-3"><i class="bi bi-list-ul"></i> 现有商品列表</h3>
            <div class="table-responsive">
                <table class="table table-striped table-hover table-bordered">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>图片</th>
                        <th>名称</th>
                        <th>分类</th>
                        <th>市场价</th>
                        <th>销售价</th>
<%--                        <th>库存</th>--%>
                        <th style="min-width: 100px;">操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="goodItem" items="${goodsList}">
                        <tr>
                            <td>${goodItem.id}</td>
                            <td>
                                <c:if test="${not empty goodItem.imageUrl}">
                                    <img src="${pageContext.request.contextPath}${goodItem.imageUrl}" alt="${goodItem.name}" class="thumbnail_img_list"/>
                                </c:if>
                                <c:if test="${empty goodItem.imageUrl}">
                                    <span class="text-muted fst-italic">无图</span>
                                </c:if>
                            </td>
                            <td><c:out value="${goodItem.name}"/></td>
                            <td><c:out value="${goodItem.category}"/></td>
                            <td><fmt:formatNumber value="${goodItem.normalPrice}" type="currency" currencySymbol="¥"/></td>
                            <td><fmt:formatNumber value="${goodItem.surprisePrice}" type="currency" currencySymbol="¥"/></td>
<%--                            <td>${not empty goodItem.stock ? goodItem.stock : 'N/A'}</td>--%>
                            <td class="action-buttons-list">
                                <c:choose>
                                    <c:when test="${goodItem.isOut == 0}">
                                        <a href="<c:url value='/admin/goods/delete/${goodItem.id}'/>" class="btn btn-sm btn-warning">
                                            <i class="bi bi-box-arrow-down"></i> 下架
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="<c:url value='/admin/goods/delete/${goodItem.id}'/>" class="btn btn-sm btn-success">
                                            <i class="bi bi-box-arrow-up"></i> 上架
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty goodsList}">
                        <tr>
                            <td colspan="8" class="text-center fst-italic text-muted py-4">当前没有商品数据。</td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<div id="separator"></div>

<!-- Bootstrap 5 JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>