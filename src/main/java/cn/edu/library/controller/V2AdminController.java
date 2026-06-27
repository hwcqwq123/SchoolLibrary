package cn.edu.library.controller;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.mapper.V2Mapper;
import cn.edu.library.service.V2BusinessService;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * 管理员端 v2 控制器。
 *
 * 【本次修改】
 * 1. 关键多步骤业务改由 V2BusinessService 处理，并加事务。
 * 2. 所有写操作增加后端参数校验。
 * 3. 操作结果通过 success / error 参数反馈到页面。
 * 4. 分类、公告、续借、罚款、座位、系统管理等操作统一写操作日志。
 */
@Controller
@RequestMapping("/admin/v2")
public class V2AdminController {

    @Resource
    private V2Mapper v2Mapper;

    @Resource
    private V2BusinessService v2BusinessService;

    @GetMapping({"", "/", "/dashboard"})
    public String dashboard(Model model) {
        model.addAttribute("stats", v2Mapper.dashboardStats());
        model.addAttribute("categoryStats", v2Mapper.categoryStats());
        model.addAttribute("latestNotices", v2Mapper.latestNotices(5));
        model.addAttribute("recentBorrows", v2Mapper.recentBorrows(8));
        model.addAttribute("overdueList", v2Mapper.overdueList());
        return "admin/v2-dashboard";
    }

    @GetMapping("/categories")
    public String categories(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("list", v2Mapper.listCategories(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/v2-categories";
    }

    @PostMapping("/categories/add")
    public String addCategory(@RequestParam(required = false) String categoryName,
                              @RequestParam(required = false) String description,
                              HttpServletRequest request,
                              RedirectAttributes ra) {
        if (isBlank(categoryName)) {
            return redirect("redirect:/admin/v2/categories", V2ActionResult.error("INVALID_CATEGORY", "分类名称不能为空"), ra);
        }
        v2Mapper.addCategory(categoryName.trim(), trim(description));
        log(request, "分类管理", "新增分类：" + categoryName.trim());
        return redirect("redirect:/admin/v2/categories", V2ActionResult.success("分类新增成功"), ra);
    }

    @PostMapping("/categories/update")
    public String updateCategory(@RequestParam Integer id,
                                 @RequestParam(required = false) String categoryName,
                                 @RequestParam(required = false) String description,
                                 @RequestParam(defaultValue = "1") Integer status,
                                 HttpServletRequest request,
                                 RedirectAttributes ra) {
        if (id == null || id <= 0) {
            return redirect("redirect:/admin/v2/categories", V2ActionResult.error("INVALID_CATEGORY", "分类 ID 无效"), ra);
        }
        if (isBlank(categoryName)) {
            return redirect("redirect:/admin/v2/categories", V2ActionResult.error("INVALID_CATEGORY", "分类名称不能为空"), ra);
        }
        v2Mapper.updateCategory(id, categoryName.trim(), trim(description), status == null ? 1 : status);
        log(request, "分类管理", "修改分类：" + categoryName.trim());
        return redirect("redirect:/admin/v2/categories", V2ActionResult.success("分类修改成功"), ra);
    }

    @GetMapping("/categories/disable/{id}")
    public String disableCategory(@PathVariable Integer id, HttpServletRequest request, RedirectAttributes ra) {
        if (id == null || id <= 0) {
            return redirect("redirect:/admin/v2/categories", V2ActionResult.error("INVALID_CATEGORY", "分类 ID 无效"), ra);
        }
        v2Mapper.disableCategory(id);
        log(request, "分类管理", "禁用分类ID：" + id);
        return redirect("redirect:/admin/v2/categories", V2ActionResult.success("分类已禁用"), ra);
    }

    @GetMapping("/notices")
    public String notices(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("list", v2Mapper.listNotices(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/v2-notices";
    }

    @PostMapping("/notices/add")
    public String addNotice(@RequestParam(required = false) String title,
                            @RequestParam(required = false) String content,
                            @RequestParam(defaultValue = "1") Integer status,
                            HttpServletRequest request,
                            RedirectAttributes ra) {
        if (isBlank(title)) {
            return redirect("redirect:/admin/v2/notices", V2ActionResult.error("INVALID_NOTICE", "公告标题不能为空"), ra);
        }
        if (isBlank(content)) {
            return redirect("redirect:/admin/v2/notices", V2ActionResult.error("INVALID_NOTICE", "公告内容不能为空"), ra);
        }
        v2Mapper.addNotice(title.trim(), content.trim(), currentUserId(request.getSession()), status == null ? 1 : status);
        log(request, "公告管理", "发布公告：" + title.trim());
        return redirect("redirect:/admin/v2/notices", V2ActionResult.success("公告发布成功"), ra);
    }

    @PostMapping("/notices/update")
    public String updateNotice(@RequestParam Integer id,
                               @RequestParam(required = false) String title,
                               @RequestParam(required = false) String content,
                               @RequestParam(defaultValue = "1") Integer status,
                               HttpServletRequest request,
                               RedirectAttributes ra) {
        if (id == null || id <= 0) {
            return redirect("redirect:/admin/v2/notices", V2ActionResult.error("INVALID_NOTICE", "公告 ID 无效"), ra);
        }
        if (isBlank(title) || isBlank(content)) {
            return redirect("redirect:/admin/v2/notices", V2ActionResult.error("INVALID_NOTICE", "公告标题和内容不能为空"), ra);
        }
        v2Mapper.updateNotice(id, title.trim(), content.trim(), status == null ? 1 : status);
        log(request, "公告管理", "修改公告：" + title.trim());
        return redirect("redirect:/admin/v2/notices", V2ActionResult.success("公告修改成功"), ra);
    }

    @GetMapping("/notices/delete/{id}")
    public String deleteNotice(@PathVariable Integer id, HttpServletRequest request, RedirectAttributes ra) {
        if (id == null || id <= 0) {
            return redirect("redirect:/admin/v2/notices", V2ActionResult.error("INVALID_NOTICE", "公告 ID 无效"), ra);
        }
        v2Mapper.deleteNotice(id);
        log(request, "公告管理", "删除公告ID：" + id);
        return redirect("redirect:/admin/v2/notices", V2ActionResult.success("公告已下线"), ra);
    }

    @GetMapping("/renews")
    public String renews(@RequestParam(required = false) String status, Model model) {
        model.addAttribute("list", v2Mapper.listRenewRequests(status));
        model.addAttribute("status", status);
        return "admin/v2-renews";
    }

    @PostMapping("/renews/approve")
    public String approveRenew(@RequestParam Integer id,
                               @RequestParam Integer borrowRecordId,
                               @RequestParam(required = false) String remark,
                               HttpServletRequest request,
                               RedirectAttributes ra) {
        V2ActionResult result = v2BusinessService.approveRenew(id,
                borrowRecordId,
                remark,
                currentUserId(request.getSession()),
                currentUserName(request.getSession()),
                request.getRequestURI(),
                request.getRemoteAddr());
        return redirect("redirect:/admin/v2/renews", result, ra);
    }

    @PostMapping("/renews/reject")
    public String rejectRenew(@RequestParam Integer id,
                              @RequestParam(required = false) String remark,
                              HttpServletRequest request,
                              RedirectAttributes ra) {
        V2ActionResult result = v2BusinessService.rejectRenew(id,
                remark,
                currentUserId(request.getSession()),
                currentUserName(request.getSession()),
                request.getRequestURI(),
                request.getRemoteAddr());
        return redirect("redirect:/admin/v2/renews", result, ra);
    }

    @GetMapping("/fines")
    public String fines(@RequestParam(required = false) String status,
                        @RequestParam(required = false) String keyword,
                        Model model) {
        model.addAttribute("list", v2Mapper.listFines(status, keyword));
        model.addAttribute("status", status);
        model.addAttribute("keyword", keyword);
        return "admin/v2-fines";
    }

    @GetMapping("/fines/generate")
    public String generateFines(HttpServletRequest request, RedirectAttributes ra) {
        V2ActionResult result = v2BusinessService.generateOverdueFines(currentUserId(request.getSession()),
                currentUserName(request.getSession()),
                request.getRequestURI(),
                request.getRemoteAddr());
        return redirect("redirect:/admin/v2/fines", result, ra);
    }

    @GetMapping("/fines/pay/{id}/{borrowRecordId}")
    public String payFine(@PathVariable Integer id,
                          @PathVariable Integer borrowRecordId,
                          HttpServletRequest request,
                          RedirectAttributes ra) {
        V2ActionResult result = v2BusinessService.payFine(id,
                borrowRecordId,
                currentUserId(request.getSession()),
                currentUserName(request.getSession()),
                request.getRequestURI(),
                request.getRemoteAddr());
        return redirect("redirect:/admin/v2/fines", result, ra);
    }

    @GetMapping("/seats")
    public String seats(@RequestParam(required = false) Integer floorId,
                        @RequestParam(required = false) String reservationDate,
                        @RequestParam(required = false) Integer timeSlotId,
                        @RequestParam(required = false) String keyword,
                        Model model) {
        v2Mapper.clearExpiredLocks();
        model.addAttribute("floors", v2Mapper.listFloors());
        model.addAttribute("slots", v2Mapper.listSlots());
        model.addAttribute("reservations", v2Mapper.listSeatReservations(reservationDate, floorId, keyword));
        model.addAttribute("floorId", floorId);
        model.addAttribute("reservationDate", reservationDate);
        model.addAttribute("timeSlotId", timeSlotId);
        model.addAttribute("keyword", keyword);
        return "admin/v2-seats";
    }

    @GetMapping("/seats/cancel/{id}")
    public String cancelSeat(@PathVariable Integer id, HttpServletRequest request, RedirectAttributes ra) {
        V2ActionResult result = v2BusinessService.cancelSeatReservationByAdmin(id,
                currentUserId(request.getSession()),
                currentUserName(request.getSession()),
                request.getRequestURI(),
                request.getRemoteAddr());
        return redirect("redirect:/admin/v2/seats", result, ra);
    }

    @GetMapping("/data")
    public String dataPage() {
        return "admin/v2-data";
    }

    @GetMapping("/data/export-books")
    public void exportBooks(HttpServletResponse response) throws Exception {
        writeCsv(response, "books.csv", v2Mapper.exportBooks());
    }

    @GetMapping("/data/export-borrows")
    public void exportBorrows(HttpServletResponse response) throws Exception {
        writeCsv(response, "borrows.csv", v2Mapper.exportBorrows());
    }

    @PostMapping("/data/import-books")
    public String importBooks(@RequestParam("file") MultipartFile file,
                              HttpServletRequest request,
                              RedirectAttributes ra) throws Exception {
        if (file == null || file.isEmpty()) {
            return redirect("redirect:/admin/v2/data", V2ActionResult.error("EMPTY_FILE", "请选择需要导入的 CSV 文件"), ra);
        }

        int imported = 0;
        BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8));
        String line;
        boolean first = true;
        while ((line = reader.readLine()) != null) {
            if (first) {
                first = false;
                if (line.contains("bookNo") || line.contains("图书编号")) {
                    continue;
                }
            }
            String[] arr = line.split(",");
            if (arr.length < 4) {
                continue;
            }
            String bookNo = arr[0].trim();
            String bookName = arr[1].trim();
            String author = arr.length > 2 ? arr[2].trim() : "";
            String publisher = arr.length > 3 ? arr[3].trim() : "";
            Integer categoryId = parseInt(arr.length > 4 ? arr[4].trim() : null, 1);
            Integer total = parseInt(arr.length > 5 ? arr[5].trim() : null, 1);
            Integer available = parseInt(arr.length > 6 ? arr[6].trim() : null, total);
            if (!bookNo.isEmpty() && !bookName.isEmpty()) {
                v2Mapper.importBook(bookNo, bookName, author, publisher, categoryId, total, available);
                imported++;
            }
        }
        log(request, "数据维护", "导入图书CSV，成功记录数：" + imported);
        return redirect("redirect:/admin/v2/data", V2ActionResult.success("导入完成，成功处理 " + imported + " 条图书记录"), ra);
    }

    @GetMapping("/system")
    public String system(@RequestParam(required = false) String keyword,
                         @RequestParam(required = false) String module,
                         Model model) {
        model.addAttribute("admins", v2Mapper.listAdmins(keyword));
        model.addAttribute("logs", v2Mapper.listOperationLogs(keyword, module));
        model.addAttribute("keyword", keyword);
        model.addAttribute("module", module);
        return "admin/v2-system";
    }

    @PostMapping("/system/admins/add")
    public String addAdmin(@RequestParam(required = false) String username,
                           @RequestParam(required = false) String password,
                           @RequestParam(required = false) String realName,
                           @RequestParam(defaultValue = "ADMIN") String role,
                           @RequestParam(required = false) String phone,
                           @RequestParam(required = false) String email,
                           HttpServletRequest request,
                           RedirectAttributes ra) {
        if (isBlank(username) || isBlank(password) || isBlank(realName)) {
            return redirect("redirect:/admin/v2/system", V2ActionResult.error("INVALID_ADMIN", "用户名、密码和姓名不能为空"), ra);
        }
        if (password.length() < 6) {
            return redirect("redirect:/admin/v2/system", V2ActionResult.error("WEAK_PASSWORD", "管理员密码至少 6 位"), ra);
        }
        v2Mapper.addAdmin(username.trim(), Md5Util.md5(password.trim()), realName.trim(), emptyTo(role, "ADMIN"), trim(phone), trim(email));
        log(request, "系统管理", "新增管理员：" + username.trim());
        return redirect("redirect:/admin/v2/system", V2ActionResult.success("管理员新增成功"), ra);
    }

    @GetMapping("/system/admins/disable/{id}")
    public String disableAdmin(@PathVariable Integer id, HttpServletRequest request, RedirectAttributes ra) {
        if (id == null || id <= 0) {
            return redirect("redirect:/admin/v2/system", V2ActionResult.error("INVALID_ADMIN", "管理员 ID 无效"), ra);
        }
        v2Mapper.disableAdmin(id);
        log(request, "系统管理", "禁用管理员ID：" + id);
        return redirect("redirect:/admin/v2/system", V2ActionResult.success("管理员已禁用"), ra);
    }

    private void writeCsv(HttpServletResponse response, String filename, List<Map<String, Object>> rows) throws Exception {
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + URLEncoder.encode(filename, "UTF-8"));
        PrintWriter writer = new PrintWriter(new OutputStreamWriter(response.getOutputStream(), StandardCharsets.UTF_8));
        writer.write('\ufeff');
        if (rows != null && !rows.isEmpty()) {
            boolean headerWritten = false;
            for (Map<String, Object> row : rows) {
                if (!headerWritten) {
                    writer.println(String.join(",", row.keySet()));
                    headerWritten = true;
                }
                boolean first = true;
                for (Object value : row.values()) {
                    if (!first) {
                        writer.print(",");
                    }
                    writer.print(csv(value));
                    first = false;
                }
                writer.println();
            }
        }
        writer.flush();
    }

    private String csv(Object value) {
        if (value == null) {
            return "";
        }
        String s = String.valueOf(value).replace("\"", "\"\"");
        return "\"" + s + "\"";
    }

    private Integer parseInt(String s, Integer defaultValue) {
        try {
            return s == null || s.trim().isEmpty() ? defaultValue : Integer.parseInt(s.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private void log(HttpServletRequest request, String module, String operation) {
        HttpSession session = request.getSession(false);
        String type = session == null ? "UNKNOWN" : String.valueOf(session.getAttribute("userType"));
        Integer id = session == null ? null : currentUserId(session);
        String name = session == null ? "系统" : currentUserName(session);
        v2BusinessService.logOperation(type, id, name, module, operation, request.getRequestURI(), request.getRemoteAddr());
    }

    private String redirect(String target, V2ActionResult result, RedirectAttributes ra) {
        if (result != null) {
            if (result.isSuccess()) {
                ra.addAttribute("success", result.getMessage());
            } else {
                ra.addAttribute("error", result.getMessage());
            }
        }
        return target;
    }

    private Integer currentUserId(HttpSession session) {
        Object user = session == null ? null : session.getAttribute("loginUser");
        Object value = call(user, "getId");
        return value instanceof Integer ? (Integer) value : null;
    }

    private String currentUserName(HttpSession session) {
        Object user = session == null ? null : session.getAttribute("loginUser");
        Object name = call(user, "getRealName");
        if (isBlank(String.valueOf(name))) {
            name = call(user, "getName");
        }
        if (isBlank(String.valueOf(name))) {
            name = call(user, "getUsername");
        }
        return name == null ? "未知用户" : String.valueOf(name);
    }

    private Object call(Object obj, String methodName) {
        if (obj == null) {
            return null;
        }
        try {
            Method method = obj.getClass().getMethod(methodName);
            return method.invoke(obj);
        } catch (Exception e) {
            return null;
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty() || "null".equals(value.trim());
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private String emptyTo(String value, String fallback) {
        return isBlank(value) ? fallback : value.trim();
    }
}
