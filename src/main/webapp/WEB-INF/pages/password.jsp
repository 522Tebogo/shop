<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>修改密码 - 嗨购商城</title>
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
        .password-requirements {
            font-size: 0.85rem;
            margin-top: -15px;
            margin-bottom: 20px;
            color: #6c757d;
        }
        .password-requirements i {
            margin-right: 5px;
        }
        .requirement-met {
            color: #28a745;
        }
        .requirement-not-met {
            color: #dc3545;
        }
        .password-toggle {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #6c757d;
        }
    </style>
</head>

<body>
<div class="container">
    <div class="profile-container">
        <div class="profile-header">
            <h1>修改密码</h1>
            <p>定期更换密码可以保障您的账号安全</p>
        </div>

        <div class="profile-nav">
            <ul>
                <li><a href="/user/profile"><i class="bi bi-person-fill me-2"></i>基本资料</a></li>
                <li><a href="/user/password" class="active"><i class="bi bi-key-fill me-2"></i>修改密码</a></li>
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

            <form id="passwordForm" class="row justify-content-center">
                <div class="col-md-8">
                    <input type="hidden" id="userId" name="userId" value="${user.id}">

                    <div class="mb-4 position-relative">
                        <label for="oldPassword" class="form-label">当前密码</label>
                        <input type="password" class="form-control" id="oldPassword" name="oldPassword" required>
                        <span class="password-toggle" data-target="oldPassword">
                                <i class="bi bi-eye-slash"></i>
                            </span>
                    </div>

                    <div class="mb-2 position-relative">
                        <label for="newPassword" class="form-label">新密码</label>
                        <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                        <span class="password-toggle" data-target="newPassword">
                                <i class="bi bi-eye-slash"></i>
                            </span>
                    </div>

                    <div class="password-requirements">
                        <div><i class="bi bi-check-circle" id="req-uppercase"></i> 以大写字母开头</div>
                        <div><i class="bi bi-check-circle" id="req-length"></i> 长度为6-10位</div>
                        <div><i class="bi bi-check-circle" id="req-alphanumeric"></i> 只包含字母和数字</div>
                    </div>

                    <div class="mb-4 position-relative">
                        <label for="confirmPassword" class="form-label">确认新密码</label>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                        <span class="password-toggle" data-target="confirmPassword">
                                <i class="bi bi-eye-slash"></i>
                            </span>
                    </div>

                    <div class="d-grid gap-2">
                        <button type="submit" class="btn btn-primary" id="submitBtn">
                            <i class="bi bi-check-circle-fill me-2"></i> 保存修改
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        // 密码输入验证
        $('#newPassword').on('input', function() {
            validatePassword();
        });

        // 密码显示切换
        $('.password-toggle').click(function() {
            const target = $(this).data('target');
            const input = $('#' + target);
            
            if (input.attr('type') === 'password') {
                input.attr('type', 'text');
                $(this).find('i').removeClass('bi-eye-slash').addClass('bi-eye');
            } else {
                input.attr('type', 'password');
                $(this).find('i').removeClass('bi-eye').addClass('bi-eye-slash');
            }
        });
        
        // 验证新密码格式
        function validatePassword() {
            const password = $('#newPassword').val();
            
            // 检查以大写字母开头
            if (/^[A-Z]/.test(password)) {
                $('#req-uppercase').addClass('requirement-met').removeClass('requirement-not-met');
            } else {
                $('#req-uppercase').addClass('requirement-not-met').removeClass('requirement-met');
            }
            
            // 检查长度为6-10位
            if (password.length >= 6 && password.length <= 10) {
                $('#req-length').addClass('requirement-met').removeClass('requirement-not-met');
            } else {
                $('#req-length').addClass('requirement-not-met').removeClass('requirement-met');
            }
            
            // 检查只包含字母和数字
            if (/^[a-zA-Z0-9]+$/.test(password)) {
                $('#req-alphanumeric').addClass('requirement-met').removeClass('requirement-not-met');
            } else {
                $('#req-alphanumeric').addClass('requirement-not-met').removeClass('requirement-met');
            }
        }
        
        // 表单提交
        $('#passwordForm').submit(function(e) {
            e.preventDefault();
            
            // 验证两次密码是否一致
            const newPassword = $('#newPassword').val();
            const confirmPassword = $('#confirmPassword').val();
            
            if (newPassword !== confirmPassword) {
                showAlert('danger', '两次输入的密码不一致');
                return;
            }
            
            // 验证新密码格式
            if (!/^[A-Z][a-zA-Z0-9]{5,9}$/.test(newPassword)) {
                showAlert('danger', '新密码格式不符合要求');
                return;
            }
            
            // 发送AJAX请求
            const formData = {
                userId: $('#userId').val(),
                oldPassword: $('#oldPassword').val(),
                newPassword: newPassword,
                confirmPassword: confirmPassword
            };
            
            $.ajax({
                url: '/user/password/change',
                type: 'POST',
                data: formData,
                success: function(response) {
                    if (response === 'success') {
                        showAlert('success', '密码修改成功,即将返回登录界面');
                        setTimeout(function() {
                            window.location.href = '/';
                        }, 3000);
                        // 清空表单
                        $('#passwordForm')[0].reset();
                    } else {
                        showAlert('danger', response);
                    }
                },
                error: function() {
                    showAlert('danger', '请求失败，请稍后再试');
                }
            });
        });
        
        // 显示提示消息
        function showAlert(type, message) {
            $('#alertBox').removeClass('alert-success alert-danger alert-warning')
                .addClass('alert-' + type)
                .find('#alertMessage').text(message);
            $('#alertBox').fadeIn();
            
            // 5秒后自动隐藏
            setTimeout(function() {
                $('#alertBox').fadeOut();
            }, 5000);
        }
    });
</script>
</body>
</html> 