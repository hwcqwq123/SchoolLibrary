package cn.edu.library.mapper;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

/**
 * 【本次新增】读者端图书状态聚合 Mapper。
 *
 * 读者端不直接借书，只展示实体书状态：馆藏、已上架、借出中、上架中。
 */
public interface V2BookCopyStatusMapper {

    @Select({
            "<script>",
            "SELECT book_id AS bookId,",
            "       COUNT(1) AS totalCopyCount,",
            "       SUM(CASE WHEN shelf_status = 'ON_SHELF' THEN 1 ELSE 0 END) AS onShelfCount,",
            "       SUM(CASE WHEN shelf_status = 'BORROWED' THEN 1 ELSE 0 END) AS borrowedCopyCount,",
            "       SUM(CASE WHEN shelf_status = 'RETURN_PROCESSING' THEN 1 ELSE 0 END) AS processingCount,",
            "       SUM(CASE WHEN shelf_status IN ('OFF_SHELF', 'DAMAGED', 'LOST') THEN 1 ELSE 0 END) AS unavailableCount",
            "FROM book_copy",
            "WHERE status = 1",
            "AND book_id IN",
            "<foreach collection='bookIds' item='id' open='(' separator=',' close=')'>",
            "  #{id}",
            "</foreach>",
            "GROUP BY book_id",
            "</script>"
    })
    List<Map<String, Object>> listStatusByBookIds(@Param("bookIds") List<Integer> bookIds);

    @Select("SELECT book_id AS bookId, " +
            "COUNT(1) AS totalCopyCount, " +
            "SUM(CASE WHEN shelf_status = 'ON_SHELF' THEN 1 ELSE 0 END) AS onShelfCount, " +
            "SUM(CASE WHEN shelf_status = 'BORROWED' THEN 1 ELSE 0 END) AS borrowedCopyCount, " +
            "SUM(CASE WHEN shelf_status = 'RETURN_PROCESSING' THEN 1 ELSE 0 END) AS processingCount, " +
            "SUM(CASE WHEN shelf_status IN ('OFF_SHELF', 'DAMAGED', 'LOST') THEN 1 ELSE 0 END) AS unavailableCount " +
            "FROM book_copy WHERE status = 1 AND book_id = #{bookId} GROUP BY book_id")
    Map<String, Object> findStatusByBookId(@Param("bookId") Integer bookId);
}
