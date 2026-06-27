package cn.edu.library.controller;

import cn.edu.library.mapper.V2Mapper;
import cn.edu.library.util.UploadUtil;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.lang.reflect.Method;
import java.util.Calendar;

/**
 * 读者端 v2 控制器。
 *
 * 【本次修改】
 * 1. 座位预约增加“同一读者同一日期同一时段只能预约一个座位”的后端校验。
 * 2. 预约结果通过 seatMsg 返回给 JSP 页面提示。
 */
@Controller
@RequestMapping("/reader/v2")
public class V2ReaderController {

    @Resource
    private V2Mapper v2Mapper;

    @GetMapping({"", "/", "/home"})
    public String home(Model model, HttpSession session) {
        Integer readerId = currentUserId(session);
        model.addAttribute("notices", v2Mapper.latestNotices(6));
        model.addAttribute("recommendBooks", v2Mapper.recommendBooks(8));
        model.addAttribute("currentBorrows", v2Mapper.listReaderBorrows(readerId, 0));
        model.addAttribute("profile", v2Mapper.findReaderProfile(readerId));
        return "reader/v2-home";
    }

    @GetMapping("/books")
    public String books(@RequestParam(required = false) String keyword,
                        @RequestParam(required = false) Integer categoryId,
                        @RequestParam(required = false) Integer recommend,
                        Model model) {
        model.addAttribute("books", v2Mapper.searchBooks(keyword, categoryId, recommend));
        model.addAttribute("categories", v2Mapper.listCategories(null));
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("recommend", recommend);
        return "reader/v2-books";
    }

    @GetMapping("/books/{id}")
    public String bookDetail(@PathVariable Integer id, Model model) {
        model.addAttribute("book", v2Mapper.findBookDetail(id));
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
    public String applyRenew(@RequestParam Integer borrowRecordId,
                             @RequestParam(required = false) String reason,
                             HttpSession session) {
        v2Mapper.addRenewRequest(borrowRecordId, currentUserId(session), reason);
        return "redirect:/reader/v2/borrows";
    }

    @GetMapping("/seats")
    public String seats(@RequestParam(required = false) Integer floorId,
                        @RequestParam(required = false) String reservationDate,
                        @RequestParam(required = false) Integer timeSlotId,
                        @RequestParam(required = false) String seatMsg,
                        Model model,
                        HttpSession session) {
        Integer readerId = currentUserId(session);
        v2Mapper.clearExpiredLocks();
        model.addAttribute("floors", v2Mapper.listFloors());
        model.addAttribute("slots", v2Mapper.listSlots());
        model.addAttribute("seats", v2Mapper.listSeats(floorId, reservationDate, timeSlotId, readerId));
        model.addAttribute("myReservations", v2Mapper.listReaderSeatReservations(readerId));
        model.addAttribute("floorId", floorId);
        model.addAttribute("reservationDate", reservationDate);
        model.addAttribute("timeSlotId", timeSlotId);
        model.addAttribute("seatMsg", seatMsg);
        return "reader/v2-seats";
    }

    @PostMapping("/seats/reserve")
    public String reserveSeat(@RequestParam Integer seatId,
                              @RequestParam String reservationDate,
                              @RequestParam Integer timeSlotId,
                              @RequestParam(required = false) Integer floorId,
                              HttpSession session) {
        Integer readerId = currentUserId(session);
        v2Mapper.clearExpiredLocks();

        /*
         * 【本次新增】
         * 同一读者在同一日期、同一时段只能预约一个座位。
         */
        if (v2Mapper.countReaderSeatTimeReservation(readerId, reservationDate, timeSlotId) > 0) {
            return redirectSeat(floorId, reservationDate, timeSlotId, "one");
        }

        if (v2Mapper.countSeatConflict(seatId, reservationDate, timeSlotId) > 0) {
            return redirectSeat(floorId, reservationDate, timeSlotId, "occupied");
        }

        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.MINUTE, 10);
        v2Mapper.lockSeat(seatId, readerId, reservationDate, timeSlotId, calendar.getTime());
        v2Mapper.createSeatReservation(seatId, readerId, reservationDate, timeSlotId);

        return redirectSeat(floorId, reservationDate, timeSlotId, "success");
    }

    @GetMapping("/seats/cancel/{id}")
    public String cancelSeat(@PathVariable Integer id, HttpSession session) {
        v2Mapper.cancelOwnSeatReservation(id, currentUserId(session));
        return "redirect:/reader/v2/seats";
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
                                HttpSession session) throws Exception {
        String avatar = null;
        if (avatarFile != null && !avatarFile.isEmpty()) {
            avatar = UploadUtil.saveImage(avatarFile, request, "avatar");
        }
        v2Mapper.updateReaderProfile(currentUserId(session), phone, email, avatar);
        return "redirect:/reader/v2/profile";
    }

    private String redirectSeat(Integer floorId, String reservationDate, Integer timeSlotId, String seatMsg) {
        return "redirect:/reader/v2/seats?floorId=" + (floorId == null ? "" : floorId)
                + "&reservationDate=" + reservationDate
                + "&timeSlotId=" + timeSlotId
                + "&seatMsg=" + seatMsg;
    }

    private Integer currentUserId(HttpSession session) {
        Object user = session.getAttribute("loginUser");
        Object value = call(user, "getId");
        return value instanceof Integer ? (Integer) value : null;
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
}
