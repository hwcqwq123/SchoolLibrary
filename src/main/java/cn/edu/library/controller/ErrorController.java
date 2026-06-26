package cn.edu.library.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

/** 错误页面控制器。 */
@Controller
public class ErrorController {
    @GetMapping("/error/403")
    public String forbidden() {
        return "error/403";
    }
}
