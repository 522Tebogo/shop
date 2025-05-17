<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>商品展示 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        /* 保持原有样式不变 */
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
            min-height: 100vh;
        }
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
        .category-tabs {
            margin: 15px 0;
        }
        .category-tab {
            padding: 8px 16px;
            margin-right: 8px;
            border-radius: 4px;
            text-decoration: none;
        }
        .category-tab.active {
            background-color: #5d6bdf;
            color: white;
        }
        .category-tab:not(.active) {
            background-color: white;
            color: #495057;
            border: 1px solid #dee2e6;
        }
        .search-box {
            background: white;
            border-radius: 8px;
            padding: 12px;
            margin: 15px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .search-input {
            flex: 1;
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }
        .search-btn {
            background: #5d6bdf;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            margin-left: 8px;
        }
        .price-filter {
            background: white;
            border-radius: 8px;
            padding: 12px;
            margin: 15px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .price-input {
            width: 100px;
            padding: 8px;
            border: 1px solid #dee2e6;
            border-radius: 4px;
        }
        .filter-btn {
            background: #5d6bdf;
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            margin: 0 8px;
        }
        .reset-btn {
            background: white;
            color: #495057;
            border: 1px solid #dee2e6;
            padding: 8px 16px;
            border-radius: 4px;
        }
        .product-card {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s;
            margin-bottom: 20px;
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
        .pagination-container {
            margin: 30px 0;
        }
        .pagination .page-item.active .page-link {
            background-color: #5d6bdf;
            border-color: #5d6bdf;
        }
        .pagination .page-link {
            color: #5d6bdf;
        }
    </style>
</head>
<body>
<!-- 导航栏 -->
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
                    <a class="nav-link active" href="/"><i class="bi bi-house-door"></i> 首页</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#"><i class="bi bi-grid"></i> 商品分类</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/good/hot"><i class="bi bi-star"></i> 热卖商品</a>
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
    <!-- 分类标签 -->
    <div class="category-tabs">
        <a href="/good/all" class="category-tab ${empty param.category ? 'active' : ''}">全部</a>
        <a href="/good/all?category=数码" class="category-tab ${param.category == '数码' ? 'active' : ''}">数码</a>
        <a href="/good/all?category=电器" class="category-tab ${param.category == '电器' ? 'active' : ''}">电器</a>
        <a href="/good/all?category=服饰" class="category-tab ${param.category == '服饰' ? 'active' : ''}">服饰</a>
        <a href="/good/all?category=食品" class="category-tab ${param.category == '食品' ? 'active' : ''}">食品</a>
    </div>

    <!-- Vue应用容器 -->
    <div id="app">
        <!-- 搜索框 -->
        <div class="search-box">
            <form @submit.prevent="applySearch" class="d-flex">
                <input type="text" class="search-input" placeholder="输入商品名称或描述..." v-model="searchKeyword">
                <button type="submit" class="search-btn">
                    <i class="bi bi-search"></i> 搜索
                </button>
            </form>
        </div>

        <!-- 价格筛选 -->
        <div class="price-filter">
            <div class="d-flex align-items-center">
                <input type="number" class="price-input" placeholder="最低价" v-model.number="filter.min" min="0">
                <span class="mx-2">-</span>
                <input type="number" class="price-input" placeholder="最高价" v-model.number="filter.max" min="0">
                <button class="filter-btn" @click="applyFilter">
                    <i class="bi bi-funnel"></i> 筛选
                </button>
                <button class="reset-btn" @click="resetFilter">
                    <i class="bi bi-arrow-counterclockwise"></i> 重置
                </button>
            </div>
        </div>

        <!-- 商品展示 -->
        <h4 class="my-4">${not empty param.category ? param.category : '全部商品'} <small class="text-muted">(共 {{ allItems.length }} 件)</small></h4>

        <div class="row">
            <div class="col-md-3 col-6 mb-4" v-for="item in paginatedItems" :key="item.id">
                <div class="product-card h-100">
                    <div class="product-image-container d-flex justify-content-center align-items-center" style="height: 180px; background: #f8f9fa;">
                        <img :src="item.imageUrl" class="product-img" :alt="item.name">
                    </div>
                    <div class="p-3">
                        <h5 class="mb-2">{{ item.name }}</h5>
                        <div class="d-flex align-items-center mb-2">
                            <span class="product-price">¥{{ item.surprisePrice }}</span>
                            <span class="original-price ms-2">¥{{ item.normalPrice }}</span>
                        </div>
                        <p class="text-muted small mb-2">{{ item.description }}</p>
                        <div class="badge bg-light text-secondary">{{ item.category }}</div>
                    </div>
                    <div class="p-3 border-top">
                        <a :href="'/good/single/' + item.id" class="btn btn-outline-primary w-100 btn-sm">
                            <i class="bi bi-cart3"></i> 立即购买
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- 分页控件 -->
        <div class="pagination-container" v-if="totalPages > 1">
            <nav aria-label="Page navigation">
                <ul class="pagination justify-content-center">
                    <li class="page-item" :class="{ disabled: currentPage === 1 }">
                        <a class="page-link" href="#" @click.prevent="prevPage">&laquo; 上一页</a>
                    </li>
                    <li class="page-item" v-for="page in pageRange"
                        :key="page"
                        :class="{ active: page === currentPage }">
                        <a class="page-link" href="#" @click.prevent="goToPage(page)">{{ page }}</a>
                    </li>
                    <li class="page-item" :class="{ disabled: currentPage === totalPages }">
                        <a class="page-link" href="#" @click.prevent="nextPage">下一页 &raquo;</a>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vue@2.6.14/dist/vue.js"></script>
<script>
    const rawData = [
        <c:forEach items="${goods}" var="item" varStatus="status">
        {
            id: "${item.id}",
            name: "${item.name}",
            description: "${item.description}",
            category: "${item.category}",
            normalPrice: parseFloat("${item.normalPrice}"),
            surprisePrice: parseFloat("${item.surprisePrice}"),
            imageUrl: "${not empty item.imageUrl ? item.imageUrl : '//via.placeholder.com/300x200?text=商品图片'}",
            stock: ${item.stock}
        }<c:if test="${not status.last}">,</c:if>
        </c:forEach>
    ];

    new Vue({
        el: '#app',
        data: {
            currentPage: 1,
            itemsPerPage: 8, // 修改为每页8个商品
            maxVisiblePages: 5,
            filter: { min: null, max: null },
            searchKeyword: '',
            isFilterActive: false,
            isSearchActive: false,
            allItems: rawData
        },
        computed: {
            filteredItems() {
                let result = this.allItems;

                if (this.isFilterActive) {
                    result = result.filter(item => {
                        const price = item.surprisePrice;
                        const min = this.filter.min || 0;
                        const max = this.filter.max || Infinity;
                        return price >= min && price <= max;
                    });
                }

                if (this.isSearchActive) {
                    const keyword = this.searchKeyword.toLowerCase();
                    result = result.filter(item =>
                        item.name.toLowerCase().includes(keyword) ||
                        item.description.toLowerCase().includes(keyword)
                    );
                }

                return result;
            },
            totalPages() {
                return Math.ceil(this.filteredItems.length / this.itemsPerPage);
            },
            paginatedItems() {
                const start = (this.currentPage - 1) * this.itemsPerPage;
                const end = start + this.itemsPerPage;
                return this.filteredItems.slice(start, end);
            },
            pageRange() {
                let start = Math.max(1, this.currentPage - Math.floor(this.maxVisiblePages / 2));
                let end = Math.min(start + this.maxVisiblePages - 1, this.totalPages);

                if (end - start < this.maxVisiblePages - 1) {
                    start = Math.max(end - this.maxVisiblePages + 1, 1);
                }

                return Array.from({length: end - start + 1}, (_, i) => start + i);
            }
        },
        methods: {
            applySearch() {
                this.isSearchActive = this.searchKeyword.trim() !== '';
                this.currentPage = 1;
            },
            applyFilter() {
                if (this.filter.min !== null && this.filter.max !== null && this.filter.min > this.filter.max) {
                    alert("最高价不能低于最低价");
                    return;
                }
                this.isFilterActive = true;
                this.currentPage = 1;
            },
            resetFilter() {
                this.filter.min = null;
                this.filter.max = null;
                this.searchKeyword = '';
                this.isFilterActive = false;
                this.isSearchActive = false;
                this.currentPage = 1;
            },
            goToPage(page) {
                if (page >= 1 && page <= this.totalPages) {
                    this.currentPage = page;
                    window.scrollTo({
                        top: document.querySelector('.pagination-container').offsetTop - 100,
                        behavior: 'smooth'
                    });
                }
            },
            prevPage() {
                this.goToPage(this.currentPage - 1);
            },
            nextPage() {
                this.goToPage(this.currentPage + 1);
            }
        }
    });
</script>
</body>
</html>