package cn.edu.library.filter;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.UUID;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import javax.servlet.http.HttpSession;

/**
 * 【本次新增】全链路请求 Debug 过滤器
 *
 * 作用：
 * 1. 打印每一次请求的 URI、method、参数、session。
 * 2. 打印响应状态码。
 * 3. 捕获 redirect 跳转地址。
 * 4. 捕获 sendError 错误。
 * 5. 帮助判断“点击登录后为什么不跳转”。
 */
public class DebugFilter implements Filter {

    private static final SimpleDateFormat FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS");

    @Override
    public void init(FilterConfig filterConfig) {
        System.out.println("========== [DEBUG FILTER INIT] DebugFilter 已启动 ==========");
    }

    @Override
    public void doFilter(ServletRequest request,
                         ServletResponse response,
                         FilterChain chain) throws IOException, ServletException {

        if (!(request instanceof HttpServletRequest) || !(response instanceof HttpServletResponse)) {
            chain.doFilter(request, response);
            return;
        }

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse rawResp = (HttpServletResponse) response;
        DebugResponseWrapper resp = new DebugResponseWrapper(rawResp);

        String traceId = UUID.randomUUID().toString().replace("-", "").substring(0, 8);
        long start = System.currentTimeMillis();

        printRequestStart(traceId, req);

        try {
            chain.doFilter(request, resp);
        } catch (Exception e) {
            System.out.println("========== [REQ-" + traceId + "] EXCEPTION ==========");
            System.out.println("异常类型: " + e.getClass().getName());
            System.out.println("异常信息: " + e.getMessage());
            e.printStackTrace(System.out);
            throw e;
        } finally {
            long cost = System.currentTimeMillis() - start;
            printRequestEnd(traceId, req, resp, cost);
        }
    }

    /**
     * 【本次新增】打印请求开始信息
     */
    private void printRequestStart(String traceId, HttpServletRequest req) {
        System.out.println();
        System.out.println("========== [REQ-" + traceId + "] REQUEST START ==========");
        System.out.println("时间: " + FORMAT.format(new Date()));
        System.out.println("Method: " + req.getMethod());
        System.out.println("RequestURI: " + req.getRequestURI());
        System.out.println("ContextPath: " + req.getContextPath());
        System.out.println("ServletPath: " + req.getServletPath());
        System.out.println("QueryString: " + req.getQueryString());
        System.out.println("RemoteAddr: " + req.getRemoteAddr());
        System.out.println("Referer: " + req.getHeader("Referer"));
        System.out.println("UserAgent: " + req.getHeader("User-Agent"));

        HttpSession session = req.getSession(false);
        if (session == null) {
            System.out.println("Session: null");
        } else {
            System.out.println("SessionId: " + session.getId());
            System.out.println("Session userType: " + session.getAttribute("userType"));
            System.out.println("Session adminRole: " + session.getAttribute("adminRole"));
            System.out.println("Session loginUser: " + session.getAttribute("loginUser"));
        }

        System.out.println("Parameters:");
        Enumeration<String> names = req.getParameterNames();
        if (!names.hasMoreElements()) {
            System.out.println("  无参数");
        }

        while (names.hasMoreElements()) {
            String name = names.nextElement();
            String[] values = req.getParameterValues(name);

            if (values == null) {
                System.out.println("  " + name + " = null");
                continue;
            }

            for (String value : values) {
                if (isSensitive(name)) {
                    System.out.println("  " + name + " = ******");
                } else {
                    System.out.println("  " + name + " = " + value);
                }
            }
        }

        System.out.println("========== [REQ-" + traceId + "] REQUEST END ==========");
    }

    /**
     * 【本次新增】打印请求结束信息
     */
    private void printRequestEnd(String traceId,
                                 HttpServletRequest req,
                                 DebugResponseWrapper resp,
                                 long cost) {

        System.out.println("========== [REQ-" + traceId + "] RESPONSE START ==========");
        System.out.println("RequestURI: " + req.getRequestURI());
        System.out.println("Status: " + resp.getDebugStatus());
        System.out.println("RedirectLocation: " + resp.getRedirectLocation());
        System.out.println("ErrorMessage: " + resp.getErrorMessage());
        System.out.println("Cost: " + cost + " ms");

        if (resp.getRedirectLocation() != null) {
            System.out.println("结论: 当前请求发生了重定向，浏览器理论上应该跳转到 -> " + resp.getRedirectLocation());
        } else if (resp.getDebugStatus() >= 400) {
            System.out.println("结论: 当前请求返回错误状态码 -> " + resp.getDebugStatus());
        } else {
            System.out.println("结论: 当前请求没有发生 redirect，可能是返回了 JSP 页面或登录失败回到原页。");
        }

        System.out.println("========== [REQ-" + traceId + "] RESPONSE END ==========");
        System.out.println();
    }

    private boolean isSensitive(String name) {
        if (name == null) {
            return false;
        }
        String lower = name.toLowerCase();
        return lower.contains("password")
                || lower.contains("pwd")
                || lower.contains("token");
    }

    @Override
    public void destroy() {
        System.out.println("========== [DEBUG FILTER DESTROY] DebugFilter 已销毁 ==========");
    }

    /**
     * 【本次新增】响应包装器
     *
     * 作用：
     * 1. 捕获 sendRedirect。
     * 2. 捕获 sendError。
     * 3. 捕获 setStatus。
     * 4. 记录最终响应状态。
     */
    private static class DebugResponseWrapper extends HttpServletResponseWrapper {

        private int status = 200;
        private String redirectLocation;
        private String errorMessage;

        public DebugResponseWrapper(HttpServletResponse response) {
            super(response);
        }

        @Override
        public void sendRedirect(String location) throws IOException {
            this.status = 302;
            this.redirectLocation = location;
            System.out.println("[DEBUG RESPONSE] sendRedirect -> " + location);
            super.sendRedirect(location);
        }

        @Override
        public void sendError(int sc) throws IOException {
            this.status = sc;
            this.errorMessage = "sendError(" + sc + ")";
            System.out.println("[DEBUG RESPONSE] sendError -> " + sc);
            super.sendError(sc);
        }

        @Override
        public void sendError(int sc, String msg) throws IOException {
            this.status = sc;
            this.errorMessage = msg;
            System.out.println("[DEBUG RESPONSE] sendError -> " + sc + ", msg = " + msg);
            super.sendError(sc, msg);
        }

        @Override
        public void setStatus(int sc) {
            this.status = sc;
            super.setStatus(sc);
        }

        @Override
        public void setHeader(String name, String value) {
            if ("Location".equalsIgnoreCase(name)) {
                this.redirectLocation = value;
                System.out.println("[DEBUG RESPONSE] setHeader Location -> " + value);
            }
            super.setHeader(name, value);
        }

        @Override
        public void addHeader(String name, String value) {
            if ("Location".equalsIgnoreCase(name)) {
                this.redirectLocation = value;
                System.out.println("[DEBUG RESPONSE] addHeader Location -> " + value);
            }
            super.addHeader(name, value);
        }

        public int getDebugStatus() {
            return status;
        }

        public String getRedirectLocation() {
            return redirectLocation;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}