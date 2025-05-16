<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <base href="${base}/" />
    <meta charset="utf-8" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>用户注册 - 嗨购商城</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .register-container {
            max-width: 650px;
            margin: 3% auto;
            padding: 30px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
        }
        .register-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .register-header h2 {
            color: #5d6bdf;
            font-weight: 600;
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
            padding: 12px;
            font-weight: 500;
            border-radius: 8px;
            width: 100%;
            margin-top: 10px;
        }
        .btn-primary:hover {
            background-color: #4a56c9;
        }
        .register-footer {
            text-align: center;
            margin-top: 20px;
        }
        .register-footer a {
            color: #5d6bdf;
            text-decoration: none;
        }
        .register-footer a:hover {
            text-decoration: underline;
        }
        .alert {
            margin-bottom: 20px;
            padding: 12px;
            border-radius: 8px;
        }
        .logo {
            text-align: center;
            margin-bottom: 20px;
        }
        .logo img {
            max-height: 60px;
        }
        .form-text {
            font-size: 0.85rem;
            color: #6c757d;
        }
        #avatar-preview {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid #e0e0e0;
            display: none;
            margin-top: 10px;
        }
        .default-logo {
            background-color: #5d6bdf;
            color: white;
            font-weight: bold;
            text-align: center;
            padding: 10px 20px;
            border-radius: 4px;
            display: inline-block;
            font-size: 20px;
        }
        .register-type-nav {
            display: flex;
            justify-content: center;
            margin-bottom: 20px;
        }
        .register-type-nav a {
            padding: 8px 15px;
            margin: 0 5px;
            border-radius: 20px;
            color: #5d6bdf;
            text-decoration: none;
            font-weight: 500;
        }
        .register-type-nav a.active {
            background-color: #5d6bdf;
            color: white;
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
    </style>
    <script type="text/javascript">
        $(function (){
        })
    </script>
</head>
<body class="second">
<div class="container">
    <div class="register-container">
        <div class="logo">
            <div class="default-logo">嗨购商城</div>
        </div>

        <div class="register-header">
            <h2>用户注册</h2>
            <p class="text-muted">欢迎加入嗨购商城，请填写以下信息完成注册</p>
        </div>

        <div class="register-type-nav">
            <a href="/user/register" class="active">常规注册</a>
            <a href="/user/register/phone">手机号注册</a>
        </div>

        <div id="registerAlert" class="alert alert-danger" style="display: none;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <span id="alertMessage"></span>
        </div>

        <form id="registerForm" enctype="multipart/form-data" accept-charset="UTF-8">
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="account" class="form-label">用户名</label>
                        <input type="text" class="form-control" id="account" name="account" placeholder="请设置6-10位用户名" required>
                        <div class="password-requirements">
                            <div><i class="bi bi-check-circle" id="req-username-start"></i> 不能以数字开头</div>
                            <div><i class="bi bi-check-circle" id="req-username-length"></i> 长度为6-10位</div>
                            <div><i class="bi bi-check-circle" id="req-username-alphanumeric"></i> 只包含字母和数字</div>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="password" class="form-label">密码</label>
                        <input type="password" class="form-control" id="password" name="password" placeholder="请设置6-10位密码" required>
                        <div class="password-requirements">
                            <div><i class="bi bi-check-circle" id="req-uppercase"></i> 以大写字母开头</div>
                            <div><i class="bi bi-check-circle" id="req-length"></i> 长度为6-10位</div>
                            <div><i class="bi bi-check-circle" id="req-alphanumeric"></i> 只包含字母和数字</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="telphone" class="form-label">手机号码</label>
                        <input type="tel" class="form-control" id="telphone" name="telphone" placeholder="请输入11位手机号码" pattern="^1\d{10}$">
                        <div class="form-text">手机号必须是11位，且以1开头</div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="email" class="form-label">邮箱地址</label>
                        <input type="email" class="form-control" id="email" name="email" placeholder="请输入您的邮箱地址">
                    </div>
                </div>
            </div>

            <div class="mb-4">
                <label for="avatarInput" class="form-label">上传头像</label>
                <input type="file" class="form-control" id="avatarInput" name="avatar" accept="image/*" max-size="10485760">
                <div class="form-text">请选择10MB以内的图片文件</div>
                <img id="showImage" class="img-thumbnail mt-2" style="max-width: 200px; max-height: 200px; display: none;" />
            </div>

            <button type="button" id="submitBtn" class="btn btn-primary">
                <i class="bi bi-person-plus-fill me-2"></i> 注册
            </button>
        </form>

        <div class="register-footer">
            <p>已有账号？<a href="/user/login">立即登录</a></p>
            <p class="mt-3"><small class="text-muted">注册即表示您同意我们的服务条款和隐私政策</small></p>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // 验证用户名和密码
        $('#account').on('input', validateUsername);
        $('#password').on('input', validatePassword);

        // 头像预览
        $('#avatarInput').change(function() {
            if (this.files && this.files[0]) {
                // 检查文件大小是否超过10MB
                const maxSize = 10 * 1024 * 1024; // 10MB
                if (this.files[0].size > maxSize) {
                    showAlert('文件大小超过限制，请选择10MB以内的图片');
                    // 清空文件输入
                    $(this).val('');
                    return;
                }

                var reader = new FileReader();
                reader.onload = function(e) {
                    $('#showImage').attr('src', e.target.result).css('display', 'block');
                };
                reader.readAsDataURL(this.files[0]);
            }
        });

        // 提交注册
        $('#submitBtn').click(function() {
            // 验证表单
            if (!validateForm()) {
                return;
            }

            // 禁用提交按钮
            $(this).prop('disabled', true).html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 注册中...');

            // 提交表单
            var formData = new FormData($('#registerForm')[0]);

            $.ajax({
                url: '/user/register',
                type: 'POST',
                data: formData,
                processData: false,
                contentType: false,
                timeout: 60000, // 设置超时时间为60秒
                success: function(response) {
                    if (response === 'success') {
                        $('#registerAlert').removeClass('alert-danger').addClass('alert-success')
                            .find('#alertMessage').text('注册成功！即将跳转到登录页面...');
                        $('#registerAlert').fadeIn();

                        setTimeout(function() {
                            window.location.href = '/user/login';
                        }, 2000);
                    } else {
                        $('#registerAlert').removeClass('alert-success').addClass('alert-danger')
                            .find('#alertMessage').text(response);
                        $('#registerAlert').fadeIn();
                        $('#submitBtn').prop('disabled', false).html('<i class="bi bi-person-plus-fill me-2"></i> 注册');
                    }
                },
                error: function(xhr, status, error) {
                    console.log("错误状态:", status);
                    console.log("错误信息:", error);
                    console.log("HTTP状态码:", xhr.status);

                    let errorMsg = '注册失败，请稍后再试';
                    if (xhr.status === 413) {
                        errorMsg = '上传的文件太大，请选择小于10MB的图片';
                    }

                    $('#registerAlert').removeClass('alert-success').addClass('alert-danger')
                        .find('#alertMessage').text(errorMsg);
                    $('#registerAlert').fadeIn();
                    $('#submitBtn').prop('disabled', false).html('<i class="bi bi-person-plus-fill me-2"></i> 注册');
                }
            });
        });

        // 验证表单
        function validateForm() {
            const account = $('#account').val();
            const password = $('#password').val();
            const telphone = $('#telphone').val();

            // 验证用户名
            if (!account) {
                showAlert('请输入用户名');
                return false;
            }

            if (!validateUsername()) {
                showAlert('用户名格式不正确，只能包含字母和数字，且不能以数字开头，6~10位');
                return false;
            }

            // 验证密码
            if (!password) {
                showAlert('请输入密码');
                return false;
            }

            if (!validatePassword()) {
                showAlert('密码格式不正确，必须以大写字母开头，长度6-10位，只包含字母和数字');
                return false;
            }

            // 验证手机号（如果有输入）
            if (telphone && !telphone.match(/^1\d{10}$/)) {
                showAlert('手机号格式不正确，必须是11位数字，且第一位必须是1');
                return false;
            }

            return true;
        }

        // 验证用户名格式
        function validateUsername() {
            const username = $('#account').val();
            let isValid = true;

            // 验证不能以数字开头
            const notStartWithNumber = /^[^0-9]/.test(username);
            updateRequirement('req-username-start', notStartWithNumber);
            isValid = isValid && notStartWithNumber;

            // 验证长度为6-10位
            const validLength = username.length >= 6 && username.length <= 10;
            updateRequirement('req-username-length', validLength);
            isValid = isValid && validLength;

            // 验证只包含字母和数字
            const alphanumericOnly = /^[a-zA-Z0-9]+$/.test(username);
            updateRequirement('req-username-alphanumeric', alphanumericOnly);
            isValid = isValid && alphanumericOnly;

            return isValid;
        }

        // 验证密码格式
        function validatePassword() {
            const password = $('#password').val();
            let isValid = true;

            // 验证以大写字母开头
            const startsWithUppercase = /^[A-Z]/.test(password);
            updateRequirement('req-uppercase', startsWithUppercase);
            isValid = isValid && startsWithUppercase;

            // 验证长度为6-10位
            const validLength = password.length >= 6 && password.length <= 10;
            updateRequirement('req-length', validLength);
            isValid = isValid && validLength;

            // 验证只包含字母和数字
            const alphanumericOnly = /^[a-zA-Z0-9]+$/.test(password);
            updateRequirement('req-alphanumeric', alphanumericOnly);
            isValid = isValid && alphanumericOnly;

            return isValid;
        }

        // 更新要求状态
        function updateRequirement(id, isMet) {
            const element = $('#' + id);
            if (isMet) {
                element.removeClass('bi-x-circle requirement-not-met').addClass('bi-check-circle requirement-met');
            } else {
                element.removeClass('bi-check-circle requirement-met').addClass('bi-x-circle requirement-not-met');
            }
        }

        // 显示提示信息
        function showAlert(message) {
            $('#alertMessage').text(message);
            $('#registerAlert').fadeIn();

            // 3秒后自动隐藏
            setTimeout(function() {
                $('#registerAlert').fadeOut();
            }, 3000);
        }
    });
</script>
</body>
</html>

