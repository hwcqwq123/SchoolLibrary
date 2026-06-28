package cn.edu.library.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 读者端图书实体状态聚合 Mapper。
 */
public interface V2BookCopyStatusMapper {

    @Select({
            "<script>",
            "SELECT",
            "    book_id AS bookId,",
            "    COUNT(1) AS totalCopyCount,",
            "    SUM(CASE WHEN shelf_status = 'ON_SHELF' THEN 1 ELSE 0 END) AS onShelfCount,",
            "    SUM(CASE WHEN shelf_status = 'BORROWED' THEN 1 ELSE 0 END) AS borrowedCopyCount,",
            "    SUM(CASE WHEN shelf_status = 'RETURN_PROCESSING' THEN 1 ELSE 0 END) AS processingCount,",
            "    SUM(CASE WHEN shelf_status IN ('OFF_SHELF', 'DAMAGED', 'LOST') THEN 1 ELSE 0 END) AS unavailableCount",
            "FROM book_copy",
            "WHERE status = 1",
            "<choose>",
            "  <when test='bookIds != null and bookIds.size() > 0'>",
            "    AND book_id IN",
            "    <foreach collection='bookIds' item='bookId' open='(' separator=',' close=')'>",
            "      #{bookId}",
            "    </foreach>",
            "  </when>",
            "  <otherwise>",
            "    AND 1 = 0",
            "  </otherwise>",
            "</choose>",
            "GROUP BY book_id",
            "</script>"
    })
    List<Map<String, Object>> listStatusByBookIds(@Param("bookIds") List<Integer> bookIds);

    @Select({
            "SELECT",
            "    book_id AS bookId,",
            "    COUNT(1) AS totalCopyCount,",
            "    SUM(CASE WHEN shelf_status = 'ON_SHELF' THEN 1 ELSE 0 END) AS onShelfCount,",
            "    SUM(CASE WHEN shelf_status = 'BORROWED' THEN 1 ELSE 0 END) AS borrowedCopyCount,",
            "    SUM(CASE WHEN shelf_status = 'RETURN_PROCESSING' THEN 1 ELSE 0 END) AS processingCount,",
            "    SUM(CASE WHEN shelf_status IN ('OFF_SHELF', 'DAMAGED', 'LOST') THEN 1 ELSE 0 END) AS unavailableCount",
            "FROM book_copy",
            "WHERE status = 1",
            "  AND book_id = #{bookId}",
            "GROUP BY book_id"
    })
    Map<String, Object> findStatusByBookId(@Param("bookId") Integer bookId);
}