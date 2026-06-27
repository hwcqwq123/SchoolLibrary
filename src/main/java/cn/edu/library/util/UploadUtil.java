package cn.edu.library.util;

import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.springframework.web.multipart.MultipartFile;

/**
 * 【本次新增】文件上传工具类
 *
 * 作用：
 * 1. 保存图书封面、读者头像等图片
 * 2. 校验上传文件类型
 * 3. 返回可以直接在 JSP 中访问的相对路径
 */
public class UploadUtil {

    private static final long MAX_IMAGE_SIZE = 10 * 1024 * 1024;

    /**
     * 【本次新增】保存图片文件
     *
     * @param file 上传文件
     * @param request 当前请求
     * @param folderName 上传子目录，例如 book、avatar
     * @return 数据库中保存的访问路径，例如 /uploads/book/xxx.jpg
     */
    public static String saveImage(MultipartFile file, HttpServletRequest request, String folderName) throws IOException {
        if (file == null || file.isEmpty()) {
            return null;
        }

        if (file.getSize() > MAX_IMAGE_SIZE) {
            throw new RuntimeException("图片大小不能超过 10MB");
        }

        String originalFilename = file.getOriginalFilename();
        if (originalFilename == null || originalFilename.trim().length() == 0) {
            throw new RuntimeException("上传文件名不能为空");
        }

        String suffix = getSuffix(originalFilename);
        if (!isAllowedImageSuffix(suffix)) {
            throw new RuntimeException("只允许上传 jpg、jpeg、png、gif、webp 格式的图片");
        }

        String newFileName = UUID.randomUUID().toString().replace("-", "") + suffix;

        String relativeDir = "/uploads/" + folderName + "/";
        String realDir = request.getServletContext().getRealPath(relativeDir);

        File dir = new File(realDir);
        if (!dir.exists()) {
            boolean created = dir.mkdirs();
            if (!created) {
                throw new RuntimeException("创建上传目录失败");
            }
        }

        File targetFile = new File(dir, newFileName);
        file.transferTo(targetFile);

        return relativeDir + newFileName;
    }

    private static String getSuffix(String filename) {
        int index = filename.lastIndexOf(".");
        if (index == -1) {
            return "";
        }
        return filename.substring(index).toLowerCase(Locale.ROOT);
    }

    private static boolean isAllowedImageSuffix(String suffix) {
        return ".jpg".equals(suffix)
                || ".jpeg".equals(suffix)
                || ".png".equals(suffix)
                || ".gif".equals(suffix)
                || ".webp".equals(suffix);
    }
}