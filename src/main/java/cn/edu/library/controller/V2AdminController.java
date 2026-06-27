package cn.edu.library.controller;

import cn.edu.library.mapper.V2Mapper;
import cn.edu.library.util.Md5Util;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.lang.reflect.Method;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;

/**
 * 【本次新增】管理员端 v2 完整功能控制器。
 */
@Controller
@RequestMapping("/admin/v2")
public class V2AdminController {

    @Resource
    private V2Mapper v2Mapper;

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
    public String addCategory(@RequestParam String categoryName,
                              @RequestParam(required = false) String description,
                              HttpServletRequest request) {
        v2Mapper.addCategory(categoryName, description);
        log(request, "分类管理", "新增分类：" + categoryName);
        return "redirect:/admin/v2/categories";
    }

    @PostMapping("/categories/update")
    public String updateCategory(@RequestParam Integer id,
                                 @RequestParam String categoryName,
                                 @RequestParam(required = false) String description,
                                 @RequestParam(defaultValue = "1") Integer status,
                                 HttpServletRequest request) {
        v2Mapper.updateCategory(id, categoryName, description, status);
        log(request, "分类管理", "修改分类：" + categoryName);
        return "redirect:/admin/v2/categories";
    }

    @GetMapping("/categories/disable/{id}")
    public String disableCategory(@PathVariable Integer id, HttpServletRequest request) {
        v2Mapper.disableCategory(id);
        log(request, "分类管理", "禁用分类ID：" + id);
        return "redirect:/admin/v2/categories";
    }

    @GetMapping("/notices")
    public String notices(@RequestParam(required = false) String keyword, Model model) {
        model.addAttribute("list", v2Mapper.listNotices(keyword));
        model.addAttribute("keyword", keyword);
        return "admin/v2-notices";
    }

    @PostMapping("/notices/add")
    public String addNotice(@RequestParam String title,
                            @RequestParam String content,
                            @RequestParam(defaultValue = "1") Integer status,
                            HttpServletRequest request) {
        v2Mapper.addNotice(title, content, currentUserId(request.getSession()), status);
        log(request, "公告管理", "发布公告：" + title);
        return "redirect:/admin/v2/notices";
    }

    @PostMapping("/notices/update")
    public String updateNotice(@RequestParam Integer id,
                               @RequestParam String title,
                               @RequestParam String content,
                               @RequestParam(defaultValue = "1") Integer status,
                               HttpServletRequest request) {
        v2Mapper.updateNotice(id, title, content, status);
        log(request, "公告管理", "修改公告：" + title);
        return "redirect:/admin/v2/notices";
    }

    @GetMapping("/notices/delete/{id}")
    public String deleteNotice(@PathVariable Integer id, HttpServletRequest request) {
        v2Mapper.deleteNotice(id);
        log(request, "公告管理", "删除公告ID：" + id);
        return "redirect:/admin/v2/notices";
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
                               HttpServletRequest request) {
        Integer handlerId = currentUserId(request.getSession());
        String handlerName = currentUserName(request.getSession());
        v2Mapper.approveRenew(id, handlerId, handlerName, remark);
        v2Mapper.extendBorrowDueDate(borrowRecordId);
        v2Mapper.increaseBorrowRenewCount(borrowRecordId);
        log(request, "续借管理", "通过续借申请ID：" + id);
        return "redirect:/admin/v2/renews";
    }

    @PostMapping("/renews/reject")
    public String rejectRenew(@RequestParam Integer id,
                              @RequestParam(required = false) String remark,
                              HttpServletRequest request) {
        v2Mapper.rejectRenew(id, currentUserId(request.getSession()), currentUserName(request.getSession()), remark);
        log(request, "续借管理", "拒绝续借申请ID：" + id);
        return "redirect:/admin/v2/renews";
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
    public String generateFines(HttpServletRequest request) {
        v2Mapper.generateOverdueFines();
        log(request, "罚款管理", "生成逾期罚款");
        return "redirect:/admin/v2/fines";
    }

    @GetMapping("/fines/pay/{id}/{borrowRecordId}")
    public String payFine(@PathVariable Integer id,
                          @PathVariable Integer borrowRecordId,
                          HttpServletRequest request) {
        v2Mapper.markFinePaid(id, currentUserId(request.getSession()), currentUserName(request.getSession()));
        v2Mapper.updateBorrowFinePaid(borrowRecordId);
        log(request, "罚款管理", "确认缴费罚款ID：" + id);
        return "redirect:/admin/v2/fines";
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
    public String cancelSeat(@PathVariable Integer id, HttpServletRequest request) {
        v2Mapper.cancelSeatReservation(id);
        log(request, "座位管理", "管理员取消座位预约ID：" + id);
        return "redirect:/admin/v2/seats";
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
    public String importBooks(@RequestParam("file") MultipartFile file, HttpServletRequest request) throws Exception {
        if (file != null && !file.isEmpty()) {
            BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream(), StandardCharsets.UTF_8));
            String line;
            boolean first = true;
            while ((line = reader.readLine()) != null) {
                if (first) {
                    first = false;
                    if (line.contains("bookNo") || line.contains("图书编号")) continue;
                }
                String[] arr = line.split(",");
                if (arr.length < 4) continue;
                String bookNo = arr[0].trim();
                String bookName = arr[1].trim();
                String author = arr.length > 2 ? arr[2].trim() : "";
                String publisher = arr.length > 3 ? arr[3].trim() : "";
                Integer categoryId = parseInt(arr.length > 4 ? arr[4].trim() : null, 1);
                Integer total = parseInt(arr.length > 5 ? arr[5].trim() : null, 1);
                Integer available = parseInt(arr.length > 6 ? arr[6].trim() : null, total);
                if (!bookNo.isEmpty() && !bookName.isEmpty()) {
                    v2Mapper.importBook(bookNo, bookName, author, publisher, categoryId, total, available);
                }
            }
        }
        log(request, "数据维护", "导入图书CSV");
        return "redirect:/admin/v2/data";
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
    public String addAdmin(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam String realName,
                           @RequestParam(defaultValue = "ADMIN") String role,
                           @RequestParam(required = false) String phone,
                           @RequestParam(required = false) String email,
                           HttpServletRequest request) {
        v2Mapper.addAdmin(username, Md5Util.md5(password), realName, role, phone, email);
        log(request, "系统管理", "新增管理员：" + username);
        return "redirect:/admin/v2/system";
    }

    @GetMapping("/system/admins/disable/{id}")
    public String disableAdmin(@PathVariable Integer id, HttpServletRequest request) {
        v2Mapper.disableAdmin(id);
        log(request, "系统管理", "禁用管理员ID：" + id);
        return "redirect:/admin/v2/system";
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
                    if (!first) writer.print(",");
                    writer.print(csv(value));
                    first = false;
                }
                writer.println();
            }
        }
        writer.flush();
    }

    private String csv(Object value) {
        if (value == null) return "";
        String s = String.valueOf(value).replace("\"", "\"\"");
        return "\"" + s + "\"";
    }

    private Integer parseInt(String s, Integer defaultValue) {
        try { return s == null || s.trim().isEmpty() ? defaultValue : Integer.parseInt(s.trim()); }
        catch (Exception e) { return defaultValue; }
    }

    private void log(HttpServletRequest request, String module, String operation) {
        HttpSession session = request.getSession(false);
        String type = session == null ? "UNKNOWN" : String.valueOf(session.getAttribute("userType"));
        Integer id = session == null ? null : currentUserId(session);
        String name = session == null ? "系统" : currentUserName(session);
        v2Mapper.addOperationLog(type, id, name, module, operation, request.getRequestURI(), request.getRemoteAddr());
    }

    private Integer currentUserId(HttpSession session) {
        Object user = session.getAttribute("loginUser");
        Object value = call(user, "getId");
        return value instanceof Integer ? (Integer) value : null;
    }

    private String currentUserName(HttpSession session) {
        Object user = session.getAttribute("loginUser");
        Object name = call(user, "getRealName");
        if (name == null || String.valueOf(name).trim().isEmpty()) name = call(user, "getName");
        if (name == null || String.valueOf(name).trim().isEmpty()) name = call(user, "getUsername");
        return name == null ? "未知用户" : String.valueOf(name);
    }

    private Object call(Object obj, String methodName) {
        if (obj == null) return null;
        try {
            Method method = obj.getClass().getMethod(methodName);
            return method.invoke(obj);
        } catch (Exception e) {
            return null;
        }
    }
}
