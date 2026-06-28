package cn.edu.library.dto;

import java.io.Serializable;

/**
 * 【本次修改】v2 业务操作统一返回结果。
 *
 * 兼容 success/error 与 ok/fail 两套调用方式。
 */
public class V2ActionResult implements Serializable {

    private static final long serialVersionUID = 1L;

    private boolean success;
    private String title;
    private String message;
    private String code;
    private Object data;
    private String redirectUrl;

    public V2ActionResult() {
    }

    public V2ActionResult(boolean success, String title, String message) {
        this.success = success;
        this.title = title;
        this.message = message;
    }

    public static V2ActionResult success(String message) {
        return new V2ActionResult(true, "操作成功", message);
    }

    public static V2ActionResult success(String title, String message) {
        return new V2ActionResult(true, title, message);
    }

    public static V2ActionResult ok(String message) {
        return success(message);
    }

    public static V2ActionResult ok(String title, String message) {
        return success(title, message);
    }

    public static V2ActionResult error(String message) {
        return new V2ActionResult(false, "操作失败", message);
    }

    public static V2ActionResult error(String title, String message) {
        return new V2ActionResult(false, title, message);
    }

    public static V2ActionResult fail(String message) {
        return error(message);
    }

    public static V2ActionResult fail(String title, String message) {
        return error(title, message);
    }

    public V2ActionResult code(String code) {
        this.code = code;
        return this;
    }

    public V2ActionResult data(Object data) {
        this.data = data;
        return this;
    }

    public V2ActionResult redirectUrl(String redirectUrl) {
        this.redirectUrl = redirectUrl;
        return this;
    }

    public boolean isSuccess() {
        return success;
    }

    public boolean getSuccess() {
        return success;
    }

    public boolean isOk() {
        return success;
    }

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

    public String getType() {
        return success ? "success" : "error";
    }

    public String getMessage() {
        return message;
    }

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
}
