package cn.edu.library.controller;

import cn.edu.library.dto.V2ActionResult;
import cn.edu.library.mapper.V2BookCopyStatusMapper;
import cn.edu.library.mapper.V2Mapper;
import cn.edu.library.service.V2BusinessService;
import cn.edu.library.util.UploadUtil;
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
import javax.servlet.http.HttpSession;
import java.lang.reflect.Method;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 【本次修改】读者端 v2 控制器。
 *
 * 新增：读者图书查询、详情页展示实体书状态聚合。
 */
@Controller
@RequestMapping("/reader/v2")
public class V2ReaderController {

    @Resource
    private V2Mapper v2Mapper;

    @Resource
    private V2BusinessService v2BusinessService;

    @Resource
    private V2BookCopyStatusMapper bookCopyStatusMapper;

    @GetMapping({"", "/", "/home"})
    public String home(Model model, HttpSession session) {
        Integer readerId = currentUserId(session);
        List<Map<String, Object>> recommendBooks = v2Mapper.recommendBooks(8);
        enrichBookStatus(recommendBooks);
        model.addAttribute("notices", v2Mapper.latestNotices(6));
        model.addAttribute("recommendBooks", recommendBooks);
        model.addAttribute("currentBorrows", v2Mapper.listReaderBorrows(readerId, 0));
        model.addAttribute("profile", v2Mapper.findReaderProfile(readerId));
        return "reader/v2-home";
    }

    @GetMapping("/books")
    public String books(@RequestParam(required = false) String keyword,
                        @RequestParam(required = false) Integer categoryId,
                        @RequestParam(required = false) Integer recommend,
                        Model model) {
        List<Map<String, Object>> books = v2Mapper.searchBooks(keyword, categoryId, recommend);
        enrichBookStatus(books);
        model.addAttribute("books", books);
        model.addAttribute("categories", v2Mapper.listCategories(null));
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("recommend", recommend);
        return "reader/v2-books";
    }

    @GetMapping("/books/{id}")
    public String bookDetail(@PathVariable Integer id, Model model) {
        Map<String, Object> book = v2Mapper.findBookDetail(id);
        enrichOneBookStatus(book);
        model.addAttribute("book", book);
        return "reader/v2-book-detail";
    }

    @GetMapping("/borrows")
    public String borrows(Model model, HttpSession session) {
        Integer readerId = currentUserId(session);
        model.addAttribute("currentList", v2Mapper.listReaderBorrows(readerId, 0));
        model.addAttribute("historyList", v2Mapper.listReaderBorrows(readerId, 1));
        return "reader/v2-borrows";
    }

    @PostMapping("/renews/apply")
    public String applyRenew(@RequestParam(required = false) Integer borrowRecordId,
                             @RequestParam(required = false) String reason,
                             HttpServletRequest request,
                             RedirectAttributes ra) {
        HttpSession session = request.getSession(false);
        V2ActionResult result = v2BusinessService.applyRenew(
                borrowRecordId,
                currentUserId(session),
                reason,
                currentUserName(session),
                request.getRequestURI(),
                request.getRemoteAddr()
        );
        return redirect("redirect:/reader/v2/borrows", result, ra);
    }

    @GetMapping("/seats")
    public String seats(@RequestParam(required = false) Integer floorId,
                        @RequestParam(required = false) String reservationDate,
                        @RequestParam(required = false) Integer timeSlotId,
                        Model model,
                        HttpSession session) {
        Integer readerId = currentUserId(session);
        v2Mapper.clearExpiredLocks();
        boolean pastSlot = false;
        if (!isBlank(reservationDate) && timeSlotId != null) {
            pastSlot = v2Mapper.countPastSeatTimeSlot(reservationDate, timeSlotId) > 0;
        }
        model.addAttribute("floors", v2Mapper.listFloors());
        model.addAttribute("slots", v2Mapper.listSlots());
        model.addAttribute("seats", v2Mapper.listSeats(floorId, reservationDate, timeSlotId, readerId));
        model.addAttribute("myReservations", v2Mapper.listReaderSeatReservations(readerId));
        model.addAttribute("floorId", floorId);
        model.addAttribute("reservationDate", reservationDate);
        model.addAttribute("timeSlotId", timeSlotId);
        model.addAttribute("pastSlot", pastSlot);
        model.addAttribute("today", LocalDate.now().toString());
        return "reader/v2-seats";
    }

    @PostMapping("/seats/reserve")
    public String reserveSeat(@RequestParam(required = false) Integer seatId,
                              @RequestParam(required = false) String reservationDate,
                              @RequestParam(required = false) Integer timeSlotId,
                              @RequestParam(required = false) Integer floorId,
                              HttpServletRequest request,
                              RedirectAttributes ra) {
        HttpSession session = request.getSession(false);
        V2ActionResult result = v2BusinessService.reserveSeat(
                seatId,
                currentUserId(session),
                reservationDate,
                timeSlotId,
                currentUserName(session),
                request.getRequestURI(),
                request.getRemoteAddr()
        );
        ra.addAttribute("floorId", floorId == null ? "" : floorId);
        ra.addAttribute("reservationDate", reservationDate == null ? "" : reservationDate);
        ra.addAttribute("timeSlotId", timeSlotId == null ? "" : timeSlotId);
        return redirect("redirect:/reader/v2/seats", result, ra);
    }

    @GetMapping("/seats/cancel/{id}")
    public String cancelSeat(@PathVariable Integer id,
                             HttpServletRequest request,
                             RedirectAttributes ra) {
        HttpSession session = request.getSession(false);
        V2ActionResult result = v2BusinessService.cancelOwnSeatReservation(
                id,
                currentUserId(session),
                currentUserName(session),
                request.getRequestURI(),
                request.getRemoteAddr()
        );
        return redirect("redirect:/reader/v2/seats", result, ra);
    }

    @GetMapping("/profile")
    public String profile(Model model, HttpSession session) {
        model.addAttribute("profile", v2Mapper.findReaderProfile(currentUserId(session)));
        return "reader/v2-profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@RequestParam(required = false) String phone,
                                @RequestParam(required = false) String email,
                                @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                                HttpServletRequest request,
                                HttpSession session,
                                RedirectAttributes ra) throws Exception {
        String avatar = null;
        if (avatarFile != null && !avatarFile.isEmpty()) {
            avatar = UploadUtil.saveImage(avatarFile, request, "avatar");
        }
        v2Mapper.updateReaderProfile(currentUserId(session), phone, email, avatar);
        v2BusinessService.logOperation("READER", currentUserId(session), currentUserName(session), "个人中心", "更新个人资料", request.getRequestURI(), request.getRemoteAddr());
        return redirect("redirect:/reader/v2/profile", V2ActionResult.success("个人资料已更新"), ra);
    }

    private void enrichBookStatus(List<Map<String, Object>> books) {
        if (books == null || books.isEmpty()) {
            return;
        }
        List<Integer> ids = new ArrayList<Integer>();
        for (Map<String, Object> book : books) {
            Integer id = toInt(book.get("id"));
            if (id != null) {
                ids.add(id);
            }
        }
        if (ids.isEmpty()) {
            return;
        }
        List<Map<String, Object>> stats = bookCopyStatusMapper.listStatusByBookIds(ids);
        Map<Integer, Map<String, Object>> statMap = new HashMap<Integer, Map<String, Object>>();
        if (stats != null) {
            for (Map<String, Object> stat : stats) {
                Integer bookId = toInt(stat.get("bookId"));
                if (bookId != null) {
                    statMap.put(bookId, stat);
                }
            }
        }
        for (Map<String, Object> book : books) {
            Integer id = toInt(book.get("id"));
            applyStatus(book, statMap.get(id));
        }
    }

    private void enrichOneBookStatus(Map<String, Object> book) {
        if (book == null) {
            return;
        }
        Integer id = toInt(book.get("id"));
        if (id == null) {
            return;
        }
        applyStatus(book, bookCopyStatusMapper.findStatusByBookId(id));
    }

    private void applyStatus(Map<String, Object> book, Map<String, Object> stat) {
        if (book == null) {
            return;
        }
        int total = stat == null ? toIntDefault(book.get("totalCount")) : toIntDefault(stat.get("totalCopyCount"));
        int onShelf = stat == null ? toIntDefault(book.get("availableCount")) : toIntDefault(stat.get("onShelfCount"));
        int borrowed = stat == null ? toIntDefault(book.get("borrowCount")) : toIntDefault(stat.get("borrowedCopyCount"));
        int processing = stat == null ? 0 : toIntDefault(stat.get("processingCount"));
        int unavailable = stat == null ? 0 : toIntDefault(stat.get("unavailableCount"));
        book.put("totalCopyCount", total);
        book.put("onShelfCount", onShelf);
        book.put("borrowedCopyCount", borrowed);
        book.put("processingCount", processing);
        book.put("unavailableCount", unavailable);
        book.put("displayStatus", onShelf > 0 ? "可借" : (processing > 0 ? "上架中" : "暂无可借"));
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
        return value instanceof Integer ? (Integer) value : toInt(value);
    }

    private String currentUserName(HttpSession session) {
        Object user = session == null ? null : session.getAttribute("loginUser");
        Object name = call(user, "getName");
        if (isBlank(String.valueOf(name))) {
            name = call(user, "getRealName");
        }
        if (isBlank(String.valueOf(name))) {
            name = call(user, "getUsername");
        }
        return name == null ? "未知读者" : String.valueOf(name);
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

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty() || "null".equals(value.trim());
    }

    private Integer toInt(Object value) {
        if (value == null) return null;
        if (value instanceof Number) return ((Number) value).intValue();
        try {
            return Integer.parseInt(String.valueOf(value));
        } catch (Exception e) {
            return null;
        }
    }

    private int toIntDefault(Object value) {
        Integer v = toInt(value);
        return v == null ? 0 : v;
    }
}
