package com.work.work.controller;

// ... (保持所有其他 import 不变) ...
import com.work.work.entity.Admin;
import com.work.work.entity.Goods;
import com.work.work.entity.Order;
import com.work.work.entity.User;
import com.work.work.service.AdminService;
import com.work.work.service.GoodService;
import com.work.work.service.OrderService;
import com.work.work.service.UserService;
import jakarta.servlet.http.HttpSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.DigestUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    private static final Logger logger = LoggerFactory.getLogger(AdminController.class);
    @Autowired
    private GoodService goodService;

    @Autowired
    private AdminService adminService;
    @Autowired
    private UserService userService;
    @Autowired
    private OrderService orderService;

    @Value("${myapp.upload-dir.goods:/tmp/uploads/goods}")
    private String goodsUploadDir;

    private boolean isAdminSession(HttpSession session) {
        User sessionUser = (User) session.getAttribute("user");
        if (sessionUser == null) return false;
        String role = (String) session.getAttribute("user_role");
        return "ADMIN".equals(role);
    }

    @PostMapping("/login")
    public String handleAdminLogin(@RequestParam String account,
                                   @RequestParam String password,
                                   HttpSession session,
                                   RedirectAttributes redirectAttributes) {
        logger.info("========== 管理员登录尝试: {} ==========", account);
        System.out.println("到了控制器");
        Admin adminFromDb = adminService.getAdminByAccount(account);
        if (adminFromDb != null) {
            logger.debug("数据库 GET - 管理员账号: '{}', 密码 (MD5哈希): '{}'", adminFromDb.getAccount(), adminFromDb.getPassword());
            String inputPasswordHash = DigestUtils.md5DigestAsHex(password.getBytes(StandardCharsets.UTF_8));
            logger.debug("客户端 POST 密码计算得到的 MD5 哈希: '{}'", inputPasswordHash);

            if (adminFromDb.getPassword().equals(inputPasswordHash)) {
                logger.info("密码匹配: 管理员账号 '{}' 登录成功。", account);
                User adminAsUser = new User();
                adminAsUser.setAccount(adminFromDb.getAccount());
                adminAsUser.setId(adminFromDb.getId());
                adminAsUser.setPassword(adminFromDb.getPassword());

                session.setAttribute("user", adminAsUser);
                session.setAttribute("user_role", "ADMIN");
                session.removeAttribute("loginError");
                logger.debug("为管理员 '{}' 设置 Session 属性: user_account='{}', user_role='ADMIN'", account, adminAsUser.getAccount());
                logger.info("========== 管理员登录结束 (成功) ==========");

                if ("admin".equals(adminFromDb.getAccount())) {
                    logger.info("管理员 'admin' 登录，重定向到 /admin (admin.jsp)");
                    return "redirect:/admin";
                } else {
                    logger.info("其他管理员 '{}' 登录，重定向到 /admin/dashboard_other (admin1.jsp)", adminFromDb.getAccount());
                    return "redirect:/admin/dashboard_other";
                }
            } else {
                logger.warn("密码不匹配: 管理员账号 '{}' 登录失败。", account);
                logger.warn("   数据库哈希密码:     '{}'", adminFromDb.getPassword());
                logger.warn("   输入计算的哈希:  '{}'", inputPasswordHash);
            }
        } else {
            logger.warn("账号未找到: 管理员账号 '{}' 登录失败。", account);
        }
        String errorMessage = "管理员账号或密码错误！";
        redirectAttributes.addFlashAttribute("loginError", errorMessage);
        redirectAttributes.addFlashAttribute("account_admin", account);
        redirectAttributes.addAttribute("is_admin_login", "true");
        logger.debug("重定向到 /user/login 并携带账号 '{}' 的错误信息。Flash 'loginError' 已设置。", account);
        logger.info("========== 管理员登录结束 (失败) ==========");
        return "redirect:/user/login";
    }

    @GetMapping("")
    public String adminDashboard(HttpSession session, Model model) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        model.addAttribute("user", adminUser);

        if (adminUser == null || !"admin".equals(adminUser.getAccount())) {
            logger.warn("非 'admin' 用户 {} 尝试访问主管理仪表盘或 session 无效，重定向。", adminUser != null ? adminUser.getAccount() : "未知用户");
            if (adminUser != null && !"admin".equals(adminUser.getAccount())) {
                return "redirect:/admin/dashboard_other";
            }
            return "redirect:/user/login";
        }
        logger.info("管理员 'admin' ({}) 访问了管理后台主页 (admin.jsp)。", adminUser.getAccount());
        return "admin";
    }

    @GetMapping("/dashboard_other")
    public String otherAdminDashboard(HttpSession session, Model model) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        model.addAttribute("user", adminUser);

        if (adminUser != null && "admin".equals(adminUser.getAccount())) {
            logger.warn("'admin' 用户 {} 意外访问了其他管理员仪表盘，重定向回主仪表盘。", adminUser.getAccount());
            return "redirect:/admin";
        }
        if (adminUser == null) {
            return "redirect:/user/login";
        }
        logger.info("管理员 {} 访问了其专用的管理后台主页 (admin1.jsp)。", adminUser.getAccount());
        return "admin1";
    }

    // --- 商品管理方法 (保持不变) ---
    @GetMapping("/goods/add")
    public String showAddGoodForm(HttpSession session, Model model) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        model.addAttribute("user", adminUser);
        Goods goodsInstance;
        if (model.containsAttribute("goodsFlash")) {
            goodsInstance = (Goods) model.getAttribute("goodsFlash");
        } else {
            goodsInstance = new Goods();
        }
        model.addAttribute("goods", goodsInstance);
        List<Goods> goodsList = goodService.getAllGoods();
        for (Goods goods : goodsList) {
            System.out.println("当前商品的状态为:"+goods.getIsOut());
        }
        model.addAttribute("goodsList", goodsList);
        logger.info("管理员 {} 访问了商品添加/列表页面。", adminUser.getAccount());
        return "goods_add";
    }

    @PostMapping("/goods/add")
    public String handleAddGoodSubmit(@ModelAttribute("goods") Goods goods,
                                      @RequestParam("file") MultipartFile file,
                                      HttpSession session,
                                      RedirectAttributes redirectAttributes) {
        logger.info(">>>> AdminController.handleAddGoodSubmit 被调用，商品名称: {} <<<<", goods.getName());
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        if (goods.getMarketPrice() != null) {
            goods.setNormalPrice(goods.getMarketPrice().intValue());
        }
        if (goods.getSalePrice() != null) {
            goods.setSurprisePrice(goods.getSalePrice().intValue());
        }
        String uploadedImageRelativePath = null;
        if (file != null && !file.isEmpty()) {
            try {
                String originalFilename = file.getOriginalFilename();
                String fileExtension = "";
                if (originalFilename != null && originalFilename.contains(".")) {
                    fileExtension = originalFilename.substring(originalFilename.lastIndexOf(".") + 1).toLowerCase();
                }
                if (!List.of("jpg", "jpeg", "png", "gif").contains(fileExtension)) {
                    redirectAttributes.addFlashAttribute("errorMessage", "不支持的图片格式！请上传 .jpg, .jpeg, .png, 或 .gif格式的图片。");
                    redirectAttributes.addFlashAttribute("goodsFlash", goods);
                    return "redirect:/admin/goods/add";
                }

                byte[] fileBytes = file.getBytes();
                String base64 = Base64.getEncoder().encodeToString(fileBytes);
                String dataUrl = "data:image/" + fileExtension + ";base64," + base64;
                goods.setImageUrl(dataUrl);

                logger.info("商品图片以Base64字符串形式上传成功，管理员: {}", adminUser.getAccount());
            } catch (IOException e) {
                logger.error("管理员 {} 上传商品图片时出错。", adminUser.getAccount(), e);
                redirectAttributes.addFlashAttribute("errorMessage", "图片上传失败: " + e.getMessage());
                redirectAttributes.addFlashAttribute("goodsFlash", goods);
                return "redirect:/admin/goods/add";
            }
        }

        if (goods.getName() == null || goods.getName().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "商品名称不能为空！");
            redirectAttributes.addFlashAttribute("goodsFlash", goods);
            return "redirect:/admin/goods/add";
        }
        if (goods.getCategory() == null || goods.getCategory().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "商品分类不能为空！");
            redirectAttributes.addFlashAttribute("goodsFlash", goods);
            return "redirect:/admin/goods/add";
        }
        if (goods.getNormalPrice() < 0 || goods.getSurprisePrice() < 0) {
            redirectAttributes.addFlashAttribute("errorMessage", "商品价格不能为负！");
            redirectAttributes.addFlashAttribute("goodsFlash", goods);
            return "redirect:/admin/goods/add";
        }
        boolean saved = goodService.saveGoods(goods);
        System.out.println("是否保存?"+saved);
        if (saved) {
            redirectAttributes.addFlashAttribute("successMessage", "商品 '" + goods.getName() + "' 添加成功！");
            logger.info("商品 {} 由管理员 {} 添加成功。", goods.getName(), adminUser.getAccount());
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "商品添加失败，请检查数据或联系管理员。");
            redirectAttributes.addFlashAttribute("goodsFlash", goods);
            logger.error("管理员 {} 保存商品 {} 失败。", adminUser.getAccount(), goods.getName());
        }
        return "redirect:/admin/goods/add";
    }

    @GetMapping("/goods/list")
    public String showGoodsList(HttpSession session, Model model,
                                @RequestParam(defaultValue = "1") int page,
                                @RequestParam(defaultValue = "10") int pageSize,
                                @RequestParam(required = false) String keyword) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        model.addAttribute("user", adminUser);
        List<Goods> goodsList = goodService.findByPage(page, pageSize, keyword);
        long totalGoods = goodService.count(keyword);
        long totalPages = (totalGoods + pageSize - 1) / pageSize;
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalGoods", totalGoods);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("keyword", keyword);
        logger.info("管理员 {} 访问了商品列表(分页)。页码: {}, 关键词: '{}'", adminUser.getAccount(), page, keyword);
        return "admin_goods_list";
    }

    @GetMapping("/goods/delete/{id}")
    public String deleteGoods(@PathVariable("id") int goodId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        logger.info("尝试删除商品 ID: {}", goodId);

        // 检查管理员权限
        if (!isAdminSession(session)) {
            redirectAttributes.addFlashAttribute("errorMessage", "请先以管理员身份登录。");
            return "redirect:/user/login";
        }

        User adminUser = (User) session.getAttribute("user");
        Goods goodToDelete = goodService.getGoodById(goodId);

        // 处理图片路径
        String imagePathToDeleteOnFS = null;
        if (goodToDelete != null && goodToDelete.getImageUrl() != null && !goodToDelete.getImageUrl().isEmpty()) {
            try {
                // 清理URL中的查询参数和非法字符
                String cleanImageUrl = goodToDelete.getImageUrl().split("\\?")[0];
                // 获取文件名部分
                String filename = cleanImageUrl.substring(cleanImageUrl.lastIndexOf("/") + 1);
                // 构建完整的文件系统路径
                imagePathToDeleteOnFS = Paths.get(goodsUploadDir, filename).normalize().toString();

                // 安全验证：确保路径在允许的目录下
                Path resolvedPath = Paths.get(goodsUploadDir).resolve(filename).normalize();
                if (!resolvedPath.startsWith(Paths.get(goodsUploadDir).normalize())) {
                    logger.error("尝试访问非法路径: {}", resolvedPath);
                    imagePathToDeleteOnFS = null;
                }
            } catch (Exception e) {
                logger.error("处理图片路径时出错: {}", e.getMessage());
                imagePathToDeleteOnFS = null;
            }
        }

        // 删除数据库记录
        boolean deletedFromDb = goodService.deleteGoodsById(goodId);

        if (deletedFromDb) {
            redirectAttributes.addFlashAttribute("successMessage", "商品 (ID: " + goodId + ") 状态已改变！");
            logger.info("商品 ID: {} 由管理员 {} 从数据库成功删除。", goodId, adminUser.getAccount());

            // 删除关联的图片文件
            if (imagePathToDeleteOnFS != null) {
                try {
                    Path path = Paths.get(imagePathToDeleteOnFS);
                    if (Files.exists(path)) {
                        Files.delete(path);
                        logger.info("成功删除商品 ID {} 的图片文件: {}", goodId, imagePathToDeleteOnFS);
                    } else {
                        logger.warn("尝试删除商品 ID {} 的图片文件，但文件未找到: {}", goodId, imagePathToDeleteOnFS);
                    }
                } catch (IOException e) {
                    logger.error("删除商品 ID {} 的图片文件 {} 时出错: {}", goodId, imagePathToDeleteOnFS, e.getMessage());
                    redirectAttributes.addFlashAttribute("warningMessage",
                            "商品记录已删除，但其关联的图片文件删除失败: " + e.getMessage());
                }
            }
        } else {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "删除商品 (ID: " + goodId + ") 失败！商品可能不存在或发生数据库错误。");
            logger.warn("管理员 {} 删除商品 ID: {} 失败。", adminUser.getAccount(), goodId);
        }

        return "redirect:/admin/goods/add";
    }

     //--- 订单管理方法 ---
    @GetMapping("/orders/manage")
    public String showManageOrdersPage(HttpSession session, Model model) {
        if (!isAdminSession(session)) {
            return "redirect:/user/login";
        }
        User adminUser = (User) session.getAttribute("user");
        model.addAttribute("user", adminUser);

        List<Order> orderList = orderService.getAllOrdersForAdmin();
        model.addAttribute("orderList", orderList);
        logger.info("管理员 {} 访问了订单管理页面。", adminUser.getAccount());
        return "admin_order_manage";
    }

    @GetMapping("/orders/ship/{orderCode}")
    public String handleShipOrder(@PathVariable Long orderCode,
                                  HttpSession session,
                                  RedirectAttributes redirectAttributes) {
        if (!isAdminSession(session)) {
            return "redirect:/user/login";
        }
        User adminUser = (User) session.getAttribute("user");

        boolean success = orderService.markOrderAsShipped(orderCode);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "订单 (编码: " + orderCode + ") 已成功标记为已发货！");
            logger.info("订单 {} 由管理员 {} 标记为已发货。", orderCode, adminUser.getAccount());
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "标记订单 (编码: " + orderCode + ") 为已发货失败！");
            logger.error("管理员 {} 标记订单 {} 为已发货失败。", adminUser.getAccount(), orderCode);
        }
        return "redirect:/admin/orders/manage";
    }

    // --- 用户管理 和 登出 方法 ---
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser != null) logger.info("用户/管理员 {} 退出登录。", currentUser.getAccount());
        session.invalidate();
        redirectAttributes.addFlashAttribute("logoutMessage", "您已成功退出。");
        return "redirect:/user/login";
    }

    // 用户列表方法，给 "admin" 用户
    @GetMapping("/user/list")
    public String listUsersForAdmin(HttpSession session, Model model) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        if (adminUser == null) return "redirect:/user/login";
        model.addAttribute("user", adminUser);

        if (!"admin".equals(adminUser.getAccount())) {
            logger.warn("非 'admin' 用户 {} 尝试访问 /admin/user/list，重定向到其专用的用户列表。", adminUser.getAccount());
            return "redirect:/admin/user/list_other";
        }

        List<User> userlist = adminService.getAllUser();
        model.addAttribute("userlist", userlist);
        logger.info("管理员 'admin' ({}) 访问了用户列表页面 (admin_list.jsp)。", adminUser.getAccount());
        return "admin_list";
    }

    // 新增：用户列表方法，给其他管理员
    @GetMapping("/user/list_other")
    public String listUsersForOtherAdmins(HttpSession session, Model model) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        User adminUser = (User) session.getAttribute("user");
        if (adminUser == null) return "redirect:/user/login";
        model.addAttribute("user", adminUser);

        if ("admin".equals(adminUser.getAccount())) {
            logger.warn("'admin' 用户 {} 意外访问了其他管理员的用户列表，重定向回主用户列表。", adminUser.getAccount());
            return "redirect:/admin/user/list";
        }

        List<User> userlist = adminService.getAllUser();
        model.addAttribute("userlist", userlist);
        logger.info("管理员 {} 访问了其专用的用户列表页面 (admin_list1.jsp)。", adminUser.getAccount());
        return "admin_list1";
    }

    private String getUserListRedirectUrl(HttpSession session) {
        User adminUser = (User) session.getAttribute("user");
        // 添加 adminUser null 检查以避免 NullPointerException
        if (adminUser != null && "admin".equals(adminUser.getAccount())) {
            return "redirect:/admin/user/list";
        } else {
            // 如果 adminUser 为 null 或不是 "admin"，都重定向到 list_other
            // （如果 adminUser 为 null，isAdminSession 应该已经处理了，但这里是双重保险）
            return "redirect:/admin/user/list_other";
        }
    }

    @GetMapping("/user/freeze")
    public String freeze(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        boolean success = userService.freezeUser(id);
        if(success) redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 已冻结。");
        else redirectAttributes.addFlashAttribute("errorMessage", "冻结用户 (ID: " + id + ") 失败。");
        return getUserListRedirectUrl(session);
    }

    @GetMapping("/user/unfreeze")
    public String unfreeze(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        boolean success = userService.unfreezeUser(id);
        if(success) redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 已解冻。");
        else redirectAttributes.addFlashAttribute("errorMessage", "解冻用户 (ID: " + id + ") 失败。");
        return getUserListRedirectUrl(session);
    }

    @GetMapping("/user/blacklist/add")
    public String addToBlacklist(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        boolean success = userService.addToBlacklist(id);
        if(success) redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 已加入黑名单。");
        else redirectAttributes.addFlashAttribute("errorMessage", "将用户 (ID: " + id + ") 加入黑名单失败。");
        return getUserListRedirectUrl(session);
    }

    @GetMapping("/user/blacklist/remove")
    public String removeFromBlacklist(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        boolean success = userService.removeFromBlacklist(id);
        if(success) redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 已从黑名单移除。");
        else redirectAttributes.addFlashAttribute("errorMessage", "将用户 (ID: " + id + ") 从黑名单移除失败。");
        return getUserListRedirectUrl(session);
    }

    @GetMapping("/user/delete")
    public String delete(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) return "redirect:/user/login";
        logger.info(">>>> AdminController.delete 方法被调用，ID: " + id + " <<<<");
        boolean success = userService.deleteUser(id);
        if(success) redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 已逻辑删除。");
        else redirectAttributes.addFlashAttribute("errorMessage", "删除用户 (ID: " + id + ") 失败。");
        return getUserListRedirectUrl(session);
    }

    // 恢复“升级用户为管理员”的方法
    @GetMapping("/user/upgradeToAdmin")
    public String upgradeToAdmin(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) {
            return "redirect:/user/login";
        }
        User currentUser = (User) session.getAttribute("user");
        // 防止管理员升级自己 (如果已经是管理员)
        // 并且确保只有 "admin" 主管理员有此权限
        if (!"admin".equals(currentUser.getAccount())) {
            redirectAttributes.addFlashAttribute("errorMessage", "您没有权限执行此操作。");
            return getUserListRedirectUrl(session);
        }
        if (currentUser != null && currentUser.getId() != null && currentUser.getId().equals(id) && "ADMIN".equals(session.getAttribute("user_role")) ) {
            redirectAttributes.addFlashAttribute("errorMessage", "不能对自己执行升级操作。");
            return getUserListRedirectUrl(session);
        }

        boolean success = userService.upgradeUserToAdmin(id);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 已成功升级为管理员！");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "用户升级为管理员失败！");
        }
        return getUserListRedirectUrl(session); // 动态重定向
    }

    // 恢复“取消管理员身份”的方法
    @GetMapping("/user/demoteToUser")
    public String demoteToUser(@RequestParam Integer id, RedirectAttributes redirectAttributes, HttpSession session) {
        if (!isAdminSession(session)) {
            return "redirect:/user/login";
        }
        User currentAdminSessionUser = (User) session.getAttribute("user");
        // 确保只有 "admin" 主管理员有此权限
        if (!"admin".equals(currentAdminSessionUser.getAccount())) {
            redirectAttributes.addFlashAttribute("errorMessage", "您没有权限执行此操作。");
            return getUserListRedirectUrl(session);
        }

        // 防止管理员取消自己的管理员身份
        if (currentAdminSessionUser != null && currentAdminSessionUser.getId() != null &&
                currentAdminSessionUser.getId().equals(id)) {
            redirectAttributes.addFlashAttribute("errorMessage", "不能取消自己的管理员身份！");
            return getUserListRedirectUrl(session);
        }

        boolean success = userService.demoteAdminToUser(id);
        if (success) {
            redirectAttributes.addFlashAttribute("successMessage", "用户 (ID: " + id + ") 的管理员身份已取消！");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "取消管理员身份失败！");
        }
        return getUserListRedirectUrl(session); // 动态重定向
    }
}