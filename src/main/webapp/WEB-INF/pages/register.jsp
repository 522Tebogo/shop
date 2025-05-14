<%@ page language="java" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <base href="${base}/" />
    <meta charset="utf-8" />
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
    </style>
    <script type="text/javascript">
        $(function (){
            let selectedFiles = [];
            let inputId = "avatarInput";
            let imgId = "showImage";
            let fileInput = $('#'+inputId);
            // 上传文件点击事件，选择文件之后就开始上传
            fileInput.on('change', function() {
                if (this.files.length > 0) {
                    handleFiles(this.files);
                }
            });
            function handleFiles(files) {
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];

                    // 检查是否是图片
                    if (!file.type.startsWith('image/')) {
                        continue;
                    }

                    // 检查文件是否已存在
                    let isDuplicate = false;
                    for (let j = 0; j < selectedFiles.length; j++) {
                        if (selectedFiles[j].name === file.name &&
                            selectedFiles[j].size === file.size &&
                            selectedFiles[j].lastModified === file.lastModified) {
                            isDuplicate = true;
                            break;
                        }
                    }

                    if (!isDuplicate) {
                        selectedFiles.push(file);
                    }
                }
                //上传图片
                if(selectedFiles.length>0){
                    for (let i = 0; i < selectedFiles.length; i++) {
                        uploadFile(selectedFiles[i]);
                    }
                }
            }



            // 上传单个文件
            function uploadFile(file, callback) {
                const formData = new FormData();
                formData.append('file', file);
                $.ajax({
                    url: '/admin/upload/good',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        console.log(response);
                        $('#'+imgId).attr("src",response); },
                    error: function(xhr) {
                        alert("上传文件失败");
                    },
                    complete: function() {
                        if (callback) callback();
                    }
                });

            }


        })


        //用于用户中心左边菜单栏的选择项的样式
        function setSelectedClass(url){
            $('div.cont ul.list li a[href~="'+url+'"]').parent().addClass("current");
        }
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
        
        <div id="registerAlert" class="alert alert-danger" style="display: none;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> <span id="alertMessage"></span>
        </div>
        
        <form id="registerForm" method="post" enctype="multipart/form-data">
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="registerAccount" class="form-label">用户名</label>
                        <input type="text" class="form-control" id="registerAccount" name="account" required>
                        <div class="form-text">用户名长度2-20个字符，支持字母、数字、下划线和中文</div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="registerPhone" class="form-label">手机号码</label>
                        <input type="tel" class="form-control" id="registerPhone" name="telphone" required>
                        <div class="form-text">请输入11位有效手机号码</div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="registerPassword" class="form-label">设置密码</label>
                        <input type="password" class="form-control" id="registerPassword" name="password" required>
                        <div class="form-text">密码长度6-32个字符</div>
                    </div>
                </div>
                
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">确认密码</label>
                        <input type="password" class="form-control" id="confirmPassword" name="repassword" required>
                        <div class="form-text">请再次输入密码进行确认</div>
                    </div>
                </div>
            </div>
            
            <div class="mb-3">
                <label for="registerEmail" class="form-label">电子邮箱</label>
                <input type="email" class="form-control" id="registerEmail" name="email" required>
                <div class="form-text">请输入有效的电子邮箱地址</div>
            </div>
            
            <div class="mb-3">
                <label for="avatarInput" class="form-label">用户头像</label>
                <input type="file" class="form-control" id="avatarInput" name="avatar" accept="image/*">
                <div class="form-text">支持JPG、JPEG、PNG格式，最大5MB</div>
                <img id="avatar-preview" src="#" alt="头像预览">
            </div>
            
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="agreement" required>
                <label class="form-check-label" for="agreement">我已阅读并同意<a href="#" data-bs-toggle="modal" data-bs-target="#termsModal">服务条款和隐私政策</a></label>
            </div>
            
            <button type="button" class="btn btn-primary" onclick="register()">
                <i class="bi bi-person-plus me-2"></i> 立即注册
            </button>
        </form>
        
        <div class="register-footer">
            <p>已有账号？<a href="/user/login">立即登录</a></p>
        </div>
    </div>
</div>

<!-- 服务条款模态框 -->
<div class="modal fade" id="termsModal" tabindex="-1" aria-labelledby="termsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="termsModalLabel">服务条款和隐私政策</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p><strong>一、本站服务条款的确认和接纳</strong><br>
                本站的各项电子服务的所有权和运作权归本站。本站提供的服务将完全按照其发布的服务条款和操作规则严格执行。用户同意所有服务条款并完成注册程序，才能成为本站的正式用户。用户确认：本协议条款是处理双方权利义务的约定，除非违反国家强制性法律，否则始终有效。</p>
                
                <p><strong>二、服务简介</strong><br>
                本站运用自己的操作系统通过国际互联网络为用户提供网络服务。同时，用户必须：<br>
                (1)自行配备上网的所需设备，包括个人电脑、调制解调器或其它必备上网装置。<br>
                (2)自行负担个人上网所支付的与此服务有关的电话费用、网络费用。</p>
                
                <!-- 其余条款内容 -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-bs-dismiss="modal">我已阅读并同意</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // 头像预览
    $(document).ready(function() {
        $('#avatarInput').change(function() {
            const file = this.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    $('#avatar-preview').attr('src', e.target.result).show();
                }
                reader.readAsDataURL(file);
            }
        });
    });
    
    // 注册功能
    function register() {
        // 隐藏之前的警告
        $('#registerAlert').hide();
        
        const account = $('#registerAccount').val().trim();
        const password = $('#registerPassword').val().trim();
        const confirmPassword = $('#confirmPassword').val().trim();
        const email = $('#registerEmail').val().trim();
        const phone = $('#registerPhone').val().trim();
        const avatarFile = $('#avatarInput')[0].files[0];

        // 表单验证
        if (!account || !/^[a-zA-Z0-9_\u4e00-\u9fa5]{2,20}$/.test(account)) {
            showAlert('账号格式错误：2-20个字符，支持字母、数字、下划线和中文');
            return;
        }
        if (!password || !/^.{6,32}$/.test(password)) {
            showAlert('密码格式错误：6-32个字符');
            return;
        }
        if (password !== confirmPassword) {
            showAlert('两次输入的密码不一致');
            return;
        }
        if (!phone || !/^1[3-9]\d{9}$/.test(phone)) {
            showAlert('手机号格式错误：请输入11位有效号码');
            return;
        }
        if (!email || !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) {
            showAlert('邮箱格式错误：请输入有效的邮箱地址');
            return;
        }
        if (avatarFile && avatarFile.size > 5 * 1024 * 1024) {
            showAlert('头像文件过大，最大支持5MB');
            return;
        }
        if (!$('#agreement').is(':checked')) {
            showAlert('请阅读并同意服务条款和隐私政策');
            return;
        }

        // 创建 FormData 对象
        const formData = new FormData();
        formData.append('account', account);
        formData.append('password', password);
        formData.append('email', email);
        formData.append('telphone', phone);
        
        // 添加头像文件，如果没有选择头像，则创建一个空文件
        if (avatarFile) {
            formData.append('avatar', avatarFile);
        } else {
            // 确保即使没有选择头像也能发送请求
            let emptyBlob = new Blob([''], { type: 'application/octet-stream' });
            formData.append('avatar', emptyBlob, 'empty.jpg');
        }
        
        // 显示加载状态
        const registerButton = $('.btn-primary');
        const originalText = registerButton.html();
        registerButton.html('<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> 注册中...');
        registerButton.prop('disabled', true);

        $.ajax({
            url: '/user/register',
            type: 'POST',
            data: formData,
            processData: false,
            contentType: false,
            success: function(response) {
                if (response === 'success') {
                    // 注册成功，显示成功消息并重定向
                    showSuccessModal('注册成功！', '您的账号已创建成功，即将跳转到登录页面...');
                    setTimeout(function() {
                    window.location.href = "/user/login";
                    }, 2000);
                } else {
                    showAlert('注册失败：' + response);
                    registerButton.html(originalText);
                    registerButton.prop('disabled', false);
                }
            },
            error: function(xhr, status, error) {
                showAlert('系统错误：' + (xhr.responseText || error));
                registerButton.html(originalText);
                registerButton.prop('disabled', false);
            }
        });
    }
    
    function showAlert(message) {
        $('#alertMessage').text(message);
        $('#registerAlert').show();
        // 滚动到警告消息
        $('html, body').animate({
            scrollTop: $('#registerAlert').offset().top - 100
        }, 200);
    }
    
    function showSuccessModal(title, message) {
        // 创建成功模态框
        const modalHtml = `
            <div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white">
                            <h5 class="modal-title">${title}</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <div class="text-center mb-4">
                                <i class="bi bi-check-circle-fill text-success" style="font-size: 4rem;"></i>
                            </div>
                            <p class="text-center">${message}</p>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // 添加到页面并显示
        $('body').append(modalHtml);
        const successModal = new bootstrap.Modal(document.getElementById('successModal'));
        successModal.show();
        
        // 模态框关闭后移除
        $('#successModal').on('hidden.bs.modal', function() {
            $(this).remove();
        });
    }
</script>
</body>
</html>
