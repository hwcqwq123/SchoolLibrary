package cn.edu.library.dto;

/**
 * 【本次新增】v2 业务操作结果对象。
 *
 * 作用：
 * 1. Controller 不再直接拼接错误文字。
 * 2. Service 统一返回 success / error / message。
 * 3. 页面通过 success 或 error 参数展示明确提示。
 */
public class V2ActionResult {

    private final boolean success;
    private final String code;
    private final String message;

    private V2ActionResult(boolean success, String code, String message) {
        this.success = success;
        this.code = code;
        this.message = message;
    }

    public static V2ActionResult success(String message) {
        return new V2ActionResult(true, "SUCCESS", message);
    }

    public static V2ActionResult error(String code, String message) {
        return new V2ActionResult(false, code, message);
    }

    public boolean isSuccess() {
        return success;
    }

    public String getCode() {
        return code;
    }

    public String getMessage() {
        return message;
    }
}
