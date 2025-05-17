<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>个人资料 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .profile-container {
            max-width: 900px;
            margin: 3% auto;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .profile-header {
            background-color: #5d6bdf;
            color: white;
            padding: 20px;
            text-align: center;
        }
        .profile-header h1 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 0;
        }
        .profile-nav {
            background-color: #f1f3f9;
            padding: 15px 20px;
            border-bottom: 1px solid #e0e0e0;
        }
        .profile-nav ul {
            display: flex;
            list-style: none;
            padding: 0;
            margin: 0;
            gap: 20px;
        }
        .profile-nav li a {
            color: #333;
            text-decoration: none;
            font-weight: 500;
            padding: 8px 15px;
            border-radius: 20px;
            transition: all 0.3s;
        }
        .profile-nav li a:hover {
            background-color: #e0e4f5;
        }
        .profile-nav li a.active {
            background-color: #5d6bdf;
            color: white;
        }
        .profile-content {
            padding: 30px;
        }
        .form-label {
            font-weight: 500;
            margin-bottom: 8px;
        }
        .form-control {
            padding: 12px;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            margin-bottom: 20px;
        }
        .form-control:focus {
            border-color: #5d6bdf;
            box-shadow: 0 0 0 0.2rem rgba(93, 107, 223, 0.25);
        }
        .btn-primary {
            background-color: #5d6bdf;
            border: none;
            padding: 12px 24px;
            font-weight: 500;
            border-radius: 8px;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
        }
        .alert {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 8px;
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
            border: 5px solid #5d6bdf;
            margin-bottom: 15px;
        }
        .upload-btn {
            background-color: #f1f3f9;
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
    </style>
</head>

<body>
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
                            <input type="text" class="form-control" id="regTime" value="<fmt:formatDate value='${regTime}' pattern='yyyy-MM-dd HH:mm:ss'/>" readonly>
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