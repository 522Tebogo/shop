package com.work.work.controller;

import com.work.work.entity.Goods;
import com.work.work.entity.User;
import com.work.work.service.GoodService;
import com.work.work.service.UserService;
import com.work.work.service.VerificationService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    GoodService goodService;

    @Autowired
    private UserService userService;

    @Autowired
    private VerificationService verificationService;

    /**
     * 用户名密码登录页面
     */
    @GetMapping("/login")
    public String login() {
        return "login";
    }

    /**
     * 用户名密码登录处理
     */
    @PostMapping("/login")
    public String login(@RequestParam String account, @RequestParam String password, HttpSession session,Model model, RedirectAttributes redirectAttributes) {
        User user = userService.login(account, password, session);

        if (user != null) {
            // 更新登录时间
            user.setLastLoginTime(new Date());

            // 登录成功，存储用户信息到session
            session.setAttribute("user", user);
            session.removeAttribute("loginError");

            List<Goods>goods = goodService.getRandomGoods();
            model.addAttribute("goods", goods);
            // 添加成功消息
            String successMessage = "登录成功，欢迎回来 " + user.getAccount() + "！";
            redirectAttributes.addFlashAttribute("successMessage", successMessage);
            System.out.println("登录成功，设置成功消息: " + successMessage);

            return "index";
        } else {
            // 登录失败
            String errorMessage = (String) session.getAttribute("msg");
            if (errorMessage == null) {
                errorMessage = "账号或密码错误，请重试";
            }
            redirectAttributes.addFlashAttribute("loginError", errorMessage);
            System.out.println("登录失败，设置错误消息: " + errorMessage);
            session.removeAttribute("msg");

            return "redirect:/user/login";
        }
    }

    /**
     * 手机验证码登录页面
     */
    @GetMapping("/login/phone")
    public String phoneLogin() {
        return "phone_login";
    }

    /**
     * 手机验证码登录处理
     */
    @PostMapping("/login/phone")
    public String phoneLogin(@RequestParam String phone, @RequestParam String code, HttpSession session,Model model, RedirectAttributes redirectAttributes) {
        User user = userService.loginByPhone(phone, code, session);
        System.out.println("来了controller");
        if (user != null) {
            // 更新登录时间
            user.setLastLoginTime(new Date());
            List<Goods>goods = goodService.getRandomGoods();
            model.addAttribute("goods", goods);
            // 登录成功，存储用户信息到session
            session.setAttribute("user", user);
            session.removeAttribute("loginError");

            // 添加成功消息
            String successMessage = "登录成功，欢迎回来！";
            redirectAttributes.addFlashAttribute("successMessage", successMessage);
            return "index";

        } else {
            // 登录失败
            String errorMessage = (String) session.getAttribute("msg");
            if (errorMessage == null) {
                errorMessage = "验证码错误或已过期";
            }
            redirectAttributes.addFlashAttribute("loginError", errorMessage);
            session.removeAttribute("msg");

            return "redirect:/user/login/phone";
        }
    }

    /**
     * 邮箱验证码登录页面
     */
    @GetMapping("/login/email")
    public String emailLogin() {
        return "email_login";
    }

    /**
     * 邮箱验证码登录处理
     */
    @PostMapping("/login/email")
    public String emailLogin(@RequestParam String email, @RequestParam String code, HttpSession session, Model model,RedirectAttributes redirectAttributes) {
        User user = userService.loginByEmail(email, code, session);

        if (user != null) {
            // 更新登录时间
            user.setLastLoginTime(new Date());
            List<Goods>goods = goodService.getRandomGoods();
            model.addAttribute("goods", goods);
            // 登录成功，存储用户信息到session
            session.setAttribute("user", user);
            session.removeAttribute("loginError");

            // 添加成功消息
            String successMessage = "登录成功，欢迎回来！";
            redirectAttributes.addFlashAttribute("successMessage", successMessage);

            return "index";
        } else {
            // 登录失败
            String errorMessage = (String) session.getAttribute("msg");
            if (errorMessage == null) {
                errorMessage = "验证码错误或已过期";
            }
            redirectAttributes.addFlashAttribute("loginError", errorMessage);
            session.removeAttribute("msg");

            return "redirect:/user/login/email";
        }
    }

    /**
     * 注册页面
     */
    @GetMapping("/register")
    public String register() {
        return "register";
    }

    /**
     * 常规注册处理
     */
    @PostMapping("/register")
    @ResponseBody
    public String register(@RequestParam String account,
                           @RequestParam String password,
                           @RequestParam String telphone,
                           @RequestParam String email,
                           @RequestPart(required = false) MultipartFile avatar
    ) throws IOException {
        // 验证用户名格式
        if (!userService.isValidUsername(account)) {
            return "用户名格式不正确，只能包含字母和数字，且不能以数字开头，6~10位";
        }

        // 验证密码格式
        if (!userService.isValidPassword(password)) {
            return "密码格式不正确，只能包含字母和数字，且必需以大写字母开头，6~10位";
        }

        // 验证手机号格式
        if (telphone != null && !telphone.isEmpty() && !verificationService.isValidPhone(telphone)) {
            return "手机号格式不正确，必须是11位数字，且第一位必须是1";
        }

        // 检查用户名是否已存在
        if (userService.isUsernameExists(account)) {
            return "用户名已存在，请更换用户名";
        }

        // 检查手机号是否已存在
        if (telphone != null && !telphone.isEmpty()) {
            User phoneUser = userService.getUserByPhone(telphone);
            if (phoneUser != null) {
                return "该手机号已被注册，请更换手机号";
            }
        }

        // 检查邮箱是否已存在
        if (email != null && !email.isEmpty()) {
            User emailUser = userService.getUserByEmail(email);
            if (emailUser != null) {
                return "该邮箱已被注册，请更换邮箱";
            }
        }

        try {
            boolean re = userService.insertUser(account, password, telphone, email, avatar);
            if(re){
                return "success";
            } else {
                return "注册失败，请稍后重试";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "注册失败: " + e.getMessage();
        }
    }

    /**
     * 手机验证码注册页面
     */
    @GetMapping("/register/phone")
    public String phoneRegister() {
        return "phone_register";
    }

    /**
     * 手机验证码注册处理
     */
    @PostMapping("/register/phone")
    @ResponseBody
    public String phoneRegister(@RequestParam String phone,
                                @RequestParam String code,
                                @RequestParam String password,
                                @RequestParam(required = false) String account,
                                @RequestPart(required = false) MultipartFile avatar,
                                HttpSession session) throws IOException {
        // 验证密码格式
        if (!userService.isValidPassword(password)) {
            return "密码格式不正确，只能包含字母和数字，且必需以大写字母开头，6~10位";
        }

        // 验证用户名格式（如果提供）
        if (account != null && !account.isEmpty()) {
            if (!userService.isValidUsername(account)) {
                return "用户名格式不正确，只能包含字母和数字，且不能以数字开头，6~10位";
            }

            // 检查用户名是否已存在
            if (userService.isUsernameExists(account)) {
                return "用户名已存在，请更换用户名";
            }
        }

        try {
            boolean re = userService.registerByPhone(phone, code, password, account, avatar, session);
            if(re){
                return "success";
            } else {
                String errorMsg = (String) session.getAttribute("msg");
                session.removeAttribute("msg");
                return errorMsg != null ? errorMsg : "注册失败，请重试";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "注册失败: " + e.getMessage();
        }
    }

    /**
     * 登出功能
     */
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        session.removeAttribute("user");
        redirectAttributes.addFlashAttribute("successMessage", "您已成功退出登录");
        return "redirect:/user/login";
    }

    /**
     * 个人信息页面
     */
    @GetMapping("/profile")
    public String profile(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        LocalDateTime localDateTime = user.getRegTime();
        Date date = Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
        model.addAttribute("regTime", date);
        model.addAttribute("user", user);
        return "profile";
    }

    /**
     * 更新个人信息
     */
    @PostMapping("/profile/update")
    @ResponseBody
    public String updateProfile(@RequestParam Integer userId,
                                @RequestParam(required = false) String nickname,
                                @RequestParam(required = false) String account,
                                @RequestPart(required = false) MultipartFile avatar,
                                HttpSession session) throws IOException {
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getId().equals(userId)) {
            return "未登录或无权限";
        }

        Map<String, String> userInfo = new HashMap<>();
        if (nickname != null && !nickname.isEmpty()) {
            userInfo.put("nickname", nickname);
        }

        // 处理修改用户名
        if (account != null && !account.isEmpty() && !account.equals(user.getAccount())) {
            // 验证用户名格式
            if (!userService.isValidUsername(account)) {
                return "用户名格式不正确，只能包含字母和数字，且不能以数字开头，6~10位";
            }

            // 检查用户名是否已存在
            if (userService.isUsernameExists(account)) {
                return "用户名已存在，请更换用户名";
            }

            userInfo.put("account", account);
        }

        // 处理头像上传
        if (avatar != null && !avatar.isEmpty()) {
            String avatarPath = userService.saveAvatar(avatar);
            if (avatarPath != null) {
                user.setAvatar(avatarPath);
                if (userService.updateUserInfo(userId, userInfo, session)) {
                    // 更新session中的用户信息
                    session.setAttribute("user", user);
                    return "success";
                }
            }
        }

        if (userService.updateUserInfo(userId, userInfo, session)) {
            // 更新session中的用户信息
            if (nickname != null && !nickname.isEmpty()) {
                user.setNickname(nickname);
            }
            if (account != null && !account.isEmpty() && !account.equals(user.getAccount())) {
                user.setAccount(account);
            }
            session.setAttribute("user", user);
            return "success";
        } else {
            String errorMsg = (String) session.getAttribute("msg");
            session.removeAttribute("msg");
            return errorMsg != null ? errorMsg : "更新失败，请重试";
        }
    }

    /**
     * 密码修改页面
     */
    @GetMapping("/password")
    public String password(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        return "password";
    }

    /**
     * 密码修改处理
     */
    @PostMapping("/password/change")
    @ResponseBody
    public String changePassword(@RequestParam Integer userId,
                                 @RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmPassword,
                                 HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getId().equals(userId)) {
            return "未登录或无权限";
        }

        // 检查两次输入的新密码是否一致
        if (!newPassword.equals(confirmPassword)) {
            return "两次输入的新密码不一致";
        }

        // 验证新密码格式
        if (!userService.isValidPassword(newPassword)) {
            return "新密码格式不正确，只能包含字母和数字，且必需以大写字母开头，6~10位";
        }

        // 检查新旧密码是否相同
        if (oldPassword.equals(newPassword)) {
            return "新密码不能与旧密码相同";
        }

        if (userService.changePassword(userId, oldPassword, newPassword, session)) {
            session.removeAttribute("user");
            return "success";
        } else {
            String errorMsg = (String) session.getAttribute("msg");
            session.removeAttribute("msg");
            return errorMsg != null ? errorMsg : "修改失败，请重试";
        }
    }

    /**
     * 手机号绑定/修改页面
     */
    @GetMapping("/phone")
    public String phone(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        return "phone";
    }

    /**
     * 手机号绑定/修改处理
     */
    @PostMapping("/phone/change")
    @ResponseBody
    public String changePhone(@RequestParam Integer userId,
                              @RequestParam String newPhone,
                              @RequestParam String code,
                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getId().equals(userId)) {
            return "未登录或无权限";
        }

        // 验证手机号格式
        if (!verificationService.isValidPhone(newPhone)) {
            return "手机号格式不正确，必须是11位数字，且第一位必须是1";
        }

        if (userService.changePhone(userId, newPhone, code, session)) {
            return "success";
        } else {
            String errorMsg = (String) session.getAttribute("msg");
            session.removeAttribute("msg");
            return errorMsg != null ? errorMsg : "修改失败，请重试";
        }
    }

    /**
     * 邮箱绑定/修改页面
     */
    @GetMapping("/email")
    public String email(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        return "email";
    }

    /**
     * 邮箱绑定/修改处理
     */
    @PostMapping("/email/change")
    @ResponseBody
    public String changeEmail(@RequestParam Integer userId,
                              @RequestParam String newEmail,
                              @RequestParam String code,
                              HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null || !user.getId().equals(userId)) {
            return "未登录或无权限";
        }

        // 验证邮箱格式
        if (!verificationService.isValidEmail(newEmail)) {
            return "邮箱格式不正确";
        }

        if (userService.changeEmail(userId, newEmail, code, session)) {
            return "success";
        } else {
            String errorMsg = (String) session.getAttribute("msg");
            session.removeAttribute("msg");
            return errorMsg != null ? errorMsg : "修改失败，请重试";
        }
    }
}
