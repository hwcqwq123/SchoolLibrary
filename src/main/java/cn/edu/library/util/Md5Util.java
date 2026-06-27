package cn.edu.library.util;

import java.security.MessageDigest;

/**
 * MD5 工具类
 */
public class Md5Util {

    /**
     * 【本次修改】
     * 统一返回 32 位小写 MD5。
     *
     * 例如：
     * md5("123456") = e10adc3949ba59abbe56e057f20f883e
     */
    public static String md5(String text) {
        if (text == null) {
            text = "";
        }

        try {
            MessageDigest digest = MessageDigest.getInstance("MD5");
            byte[] bytes = digest.digest(text.getBytes("UTF-8"));

            StringBuilder builder = new StringBuilder();

            for (byte b : bytes) {
                String hex = Integer.toHexString(b & 0xff);

                if (hex.length() == 1) {
                    builder.append("0");
                }

                builder.append(hex);
            }

            return builder.toString();
        } catch (Exception e) {
            throw new RuntimeException("MD5 加密失败", e);
        }
    }
}