package cn.edu.library.dto;

import java.io.Serializable;

/**
 * 【本次修改】v2 业务操作统一返回结果
 *
 * 作用：
 * 1. 兼容 V2BusinessService / V2AdminController / V2ReaderController 中的 success(...) / error(...) 调用。
 * 2. 兼容 V2AdminManageService / V2BorrowBusinessService 中的 ok(...) / fail(...) 调用。
 * 3. 不依赖 Lombok，兼容 Java 8。
 */
public class V2ActionResult implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 操作是否成功
     */
    private boolean success;

    /**
     * 提示标题
     */
    private String title;

    /**
     * 提示内容
     */
    private String message;

    /**
     * 业务编码，可选
     */
    private String code;

    /**
     * 附加数据，可选
     */
    private Object data;

    /**
     * 跳转地址，可选
     */
    private String redirectUrl;

    public V2ActionResult() {
    }

    public V2ActionResult(boolean success, String title, String message) {
        this.success = success;
        this.title = title;
        this.message = message;
    }

    /**
     * 【本次修改】成功结果：只传提示内容
     */
    public static V2ActionResult success(String message) {
        return new V2ActionResult(true, "操作成功", message);
    }

    /**
     * 【本次修改】成功结果：传标题和提示内容
     */
    public static V2ActionResult success(String title, String message) {
        return new V2ActionResult(true, title, message);
    }

    /**
     * 【本次新增】成功结果别名
     * 兼容 V2AdminManageService / V2BorrowBusinessService。
     */
    public static V2ActionResult ok(String message) {
        return success(message);
    }

    /**
     * 【本次新增】成功结果别名：传标题和提示内容
     */
    public static V2ActionResult ok(String title, String message) {
        return success(title, message);
    }

    /**
     * 【本次修改】失败结果：只传提示内容
     */
    public static V2ActionResult error(String message) {
        return new V2ActionResult(false, "操作失败", message);
    }

    /**
     * 【本次修改】失败结果：传标题和提示内容
     */
    public static V2ActionResult error(String title, String message) {
        return new V2ActionResult(false, title, message);
    }

    /**
     * 【本次新增】失败结果别名
     * 兼容 V2AdminManageService / V2BorrowBusinessService。
     */
    public static V2ActionResult fail(String message) {
        return error(message);
    }

    /**
     * 【本次新增】失败结果别名：传标题和提示内容
     */
    public static V2ActionResult fail(String title, String message) {
        return error(title, message);
    }

    /**
     * 设置业务编码，支持链式调用。
     */
    public V2ActionResult code(String code) {
        this.code = code;
        return this;
    }

    /**
     * 设置附加数据，支持链式调用。
     */
    public V2ActionResult data(Object data) {
        this.data = data;
        return this;
    }

    /**
     * 设置跳转地址，支持链式调用。
     */
    public V2ActionResult redirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
        return this;
    }

    public boolean isSuccess() {
        return success;
    }

    /**
     * 兼容部分 JSP / Bean 工具按 getSuccess 读取 boolean 字段。
     */
    public boolean getSuccess() {
        return success;
    }

    /**
     * 兼容部分代码可能使用 isOk()。
     */
    public boolean isOk() {
        return success;
    }

    /**
     * 兼容部分代码可能使用 getOk()。
     */
    public boolean getOk() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * 兼容部分 JSP 可能使用 ${result.type}。
     */
    public String getType() {
        return success ? "success" : "error";
    }

    public String getMessage() {
        return message;
    }

    /**
     * 兼容部分 JSP 可能使用 ${result.msg}。
     */
    public String getMsg() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public void setMsg(String message) {
        this.message = message;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }

    public String getRedirectUrl() {
        return redirectUrl;
    }

    public void setRedirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
    }

    @Override
    public String toString() {
        return "V2ActionResult{" +
                "success=" + success +
                ", title='" + title + '\'' +
                ", message='" + message + '\'' +
                ", code='" + code + '\'' +
                ", data=" + data +
                ", redirectUrl='" + redirectUrl + '\'' +
                '}';
    }
}