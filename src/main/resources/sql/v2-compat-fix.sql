USE school_library;

-- =========================================================
-- 【本次新增】SchoolLibrary v2 兼容字段修复脚本
--
-- 解决问题：
-- 1. V2Mapper.xml 使用 borrow_date / due_date / return_date
--    但数据库实际是 borrow_time / due_time / return_time
--
-- 2. V2Mapper.xml 使用 reservation_date / time_slot_id
--    但数据库实际是 reserve_date / slot_id
--
-- 3. V2Mapper.xml 使用 renew_request.borrow_record_id
--    但数据库实际是 renew_request.borrow_id
--
-- 4. V2Mapper.xml 使用 fine_record.borrow_record_id
--    但数据库实际是 fine_record.borrow_id
--
-- 5. V2Mapper.xml 使用 operation_log.operation / request_url
--    但数据库实际是 action / description
-- =========================================================

DROP PROCEDURE IF EXISTS add_col_if_missing;

DELIMITER //

CREATE PROCEDURE add_col_if_missing(
    IN tableName VARCHAR(64),
    IN columnName VARCHAR(64),
    IN columnDefinition TEXT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = tableName
          AND COLUMN_NAME = columnName
    ) THEN
        SET @sql = CONCAT('ALTER TABLE `', tableName, '` ADD COLUMN ', columnDefinition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END//

DELIMITER ;

-- =========================================================
-- 1. borrow_record 表兼容字段
-- =========================================================

CALL add_col_if_missing('borrow_record', 'borrow_date', '`borrow_date` DATETIME NULL');
CALL add_col_if_missing('borrow_record', 'due_date', '`due_date` DATETIME NULL');
CALL add_col_if_missing('borrow_record', 'return_date', '`return_date` DATETIME NULL');

UPDATE borrow_record
SET borrow_date = borrow_time
WHERE borrow_date IS NULL
  AND borrow_time IS NOT NULL;

UPDATE borrow_record
SET due_date = due_time
WHERE due_date IS NULL
  AND due_time IS NOT NULL;

UPDATE borrow_record
SET return_date = return_time
WHERE return_date IS NULL
  AND return_time IS NOT NULL;

-- =========================================================
-- 2. renew_request 表兼容字段
-- =========================================================

CALL add_col_if_missing('renew_request', 'borrow_record_id', '`borrow_record_id` INT NULL');
CALL add_col_if_missing('renew_request', 'handler_id', '`handler_id` INT NULL');
CALL add_col_if_missing('renew_request', 'handler_name', '`handler_name` VARCHAR(100) NULL');
CALL add_col_if_missing('renew_request', 'handle_time', '`handle_time` DATETIME NULL');
CALL add_col_if_missing('renew_request', 'remark', '`remark` VARCHAR(500) NULL');
CALL add_col_if_missing('renew_request', 'update_time', '`update_time` DATETIME NULL');

UPDATE renew_request
SET borrow_record_id = borrow_id
WHERE borrow_record_id IS NULL
  AND borrow_id IS NOT NULL;

UPDATE renew_request
SET handler_id = audit_admin_id
WHERE handler_id IS NULL
  AND audit_admin_id IS NOT NULL;

UPDATE renew_request
SET handle_time = audit_time
WHERE handle_time IS NULL
  AND audit_time IS NOT NULL;

UPDATE renew_request
SET remark = audit_remark
WHERE remark IS NULL
  AND audit_remark IS NOT NULL;

-- 【本次修改】为了兼容 V2Mapper.xml 的简化 insert，允许旧字段为空
ALTER TABLE renew_request MODIFY borrow_id INT NULL;
ALTER TABLE renew_request MODIFY book_id INT NULL;
ALTER TABLE renew_request MODIFY old_due_time DATETIME NULL;
ALTER TABLE renew_request MODIFY new_due_time DATETIME NULL;

-- =========================================================
-- 3. fine_record 表兼容字段
-- =========================================================

CALL add_col_if_missing('fine_record', 'borrow_record_id', '`borrow_record_id` INT NULL');

UPDATE fine_record
SET borrow_record_id = borrow_id
WHERE borrow_record_id IS NULL
  AND borrow_id IS NOT NULL;

-- 【本次修改】为了兼容 V2Mapper.xml 的简化 insert，允许旧字段为空
ALTER TABLE fine_record MODIFY borrow_id INT NULL;
ALTER TABLE fine_record MODIFY book_id INT NULL;

-- =========================================================
-- 4. operation_log 表兼容字段
-- =========================================================

CALL add_col_if_missing('operation_log', 'operation', '`operation` VARCHAR(100) NULL');
CALL add_col_if_missing('operation_log', 'request_url', '`request_url` VARCHAR(500) NULL');

UPDATE operation_log
SET operation = action
WHERE operation IS NULL
  AND action IS NOT NULL;

-- 【本次修改】为了兼容 V2Mapper.xml 的 insert，允许 action 为空
ALTER TABLE operation_log MODIFY action VARCHAR(100) NULL;

-- =========================================================
-- 5. seat_lock 表兼容字段
-- =========================================================

CALL add_col_if_missing('seat_lock', 'reservation_date', '`reservation_date` DATE NULL');
CALL add_col_if_missing('seat_lock', 'time_slot_id', '`time_slot_id` INT NULL');
CALL add_col_if_missing('seat_lock', 'status', '`status` TINYINT NOT NULL DEFAULT 1');

UPDATE seat_lock
SET reservation_date = reserve_date
WHERE reservation_date IS NULL
  AND reserve_date IS NOT NULL;

UPDATE seat_lock
SET time_slot_id = slot_id
WHERE time_slot_id IS NULL
  AND slot_id IS NOT NULL;

UPDATE seat_lock
SET status = CASE WHEN active_key IS NULL THEN 0 ELSE 1 END;

-- 【本次修改】为了兼容 V2Mapper.xml 的 insert，允许旧字段为空
ALTER TABLE seat_lock MODIFY reserve_date DATE NULL;
ALTER TABLE seat_lock MODIFY slot_id INT NULL;

-- =========================================================
-- 6. seat_reservation 表兼容字段
-- =========================================================

CALL add_col_if_missing('seat_reservation', 'reservation_date', '`reservation_date` DATE NULL');
CALL add_col_if_missing('seat_reservation', 'time_slot_id', '`time_slot_id` INT NULL');

UPDATE seat_reservation
SET reservation_date = reserve_date
WHERE reservation_date IS NULL
  AND reserve_date IS NOT NULL;

UPDATE seat_reservation
SET time_slot_id = slot_id
WHERE time_slot_id IS NULL
  AND slot_id IS NOT NULL;

-- 【本次修改】为了兼容 V2Mapper.xml 的 insert，允许旧字段为空
ALTER TABLE seat_reservation MODIFY reserve_date DATE NULL;
ALTER TABLE seat_reservation MODIFY slot_id INT NULL;

-- =========================================================
-- 7. 清理临时过程
-- =========================================================

DROP PROCEDURE IF EXISTS add_col_if_missing;

-- =========================================================
-- 8. 验证字段是否补齐
-- =========================================================

SHOW COLUMNS FROM borrow_record;
SHOW COLUMNS FROM seat_reservation;
SHOW COLUMNS FROM seat_lock;
SHOW COLUMNS FROM renew_request;
SHOW COLUMNS FROM fine_record;
SHOW COLUMNS FROM operation_log;