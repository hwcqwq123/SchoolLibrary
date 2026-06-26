package cn.edu.library.util;

import java.security.MessageDigest;

/**
 * MD5 工具类。
 * 毕业设计中可用于基础密码加密演示；正式生产系统应使用 BCrypt 等更安全方案。
 */
public class Md5Util {
    public static String md5(String text) {
        if (text == null) {
            text = "";
        }
        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            byte[] bytes = digest.digest(text.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : bytes) {
                String hex = Integer.toHexString(b & 0xff);
                if (hex.length() == 1) {
                    sb.append('0');
                }
                sb.append(hex);
            }
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("MD5 加密失败", e);
        }
    }
}
