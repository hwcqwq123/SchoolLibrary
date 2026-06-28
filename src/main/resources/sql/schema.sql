-- =========================================================
-- SchoolLibrary v2 完整数据库脚本
-- 文件名：schema-v2-full-with-v2-004.sql
--
-- 【本次合并】
-- 1. schema.sql
-- 2. V2_004_fix_remaining_logic.sql
--
-- 【执行方式】
-- mysql -u root -p
-- source E:/SchoolLibrary/src/main/resources/sql/schema.sql;
--
-- 【注意】
-- 该文件是完整初始化 + V2_004 逻辑修复整合版。
-- 如果 schema.sql 中包含 DROP DATABASE / DROP TABLE / 初始化数据，
-- 执行本文件会重建或覆盖开发库数据，执行前请确认没有需要保留的数据。
-- =========================================================

-- =========================================================
-- Part 1：基础完整数据库 schema.sql
-- =========================================================

-- =========================================================
-- SchoolLibrary v2 完整数据库脚本
-- 文件名：schema.sql
--
-- 【本次合并】
-- 1. schema.sql
-- 2. V2_003_borrow_copy_admin_role.sql
--
-- 【执行方式】
-- source E:/SchoolLibrary/src/main/resources/sql/schema.sql;
--
-- 【注意】
-- 如果 schema.sql 中包含 DROP DATABASE / DROP TABLE / 初始化数据，
-- 执行本文件会重建或覆盖开发库数据。执行前请先备份重要数据。
-- =========================================================

-- 【本次修复】直接整合 book_copy 实体书表、实体书编码借阅字段、初始化实体书数据。
-- 这样只执行 schema.sql 一个文件，也会创建 book_copy 表。

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- Part 1：基础完整数据库 schema.sql
-- =========================================================

-- =========================================================
-- SchoolLibrary v2 完整数据库脚本
-- 文件名：schema-v2-full-combined.sql
--
-- 【本次合并】
-- 1. 合并 schema.sql
-- 2. 合并 V2_001_v2_delta.sql
-- 3. 合并 V2_002_business_constraints.sql
--
-- 【使用说明】
-- 开发环境推荐直接执行本文件：
-- source E:/SchoolLibrary/src/main/resources/sql/schema.sql;
--
-- 注意：
-- 该脚本包含完整初始化内容，可能会重建数据库和表。
-- 执行前如需保留旧数据，请先备份数据库。
-- =========================================================

-- =========================================================
-- Part 1：完整数据库初始化 schema.sql
-- =========================================================

-- =========================================================
-- SchoolLibrary v2.0 集成版完整数据库初始化脚本
-- 文件用途：替换原 src/main/resources/sql/schema.sql
--
-- 【本次整合】
-- 1. 合并 schema.sql / v2-final-schema.sql / v2-compat-fix.sql
-- 2. 修复 V2Mapper.xml 使用 due_date / borrow_date / return_date 但旧表只有 due_time / borrow_time / return_time 的问题
-- 3. 修复 book_category.description 缺失导致 /admin/v2/categories 报错的问题
-- 4. 兼容 renew_request.borrow_record_id 与旧字段 borrow_id
-- 5. 兼容 fine_record.borrow_record_id 与旧字段 borrow_id
-- 6. 兼容 seat_reservation.reservation_date / time_slot_id 与旧字段 reserve_date / slot_id
-- 7. 兼容 operation_log.operation / request_url 与旧字段 action / description
--
-- 注意：
-- 本脚本会 DROP 并重建 school_library 中的业务表，会清空原有数据。
-- 如果需要保留已有数据，请先备份数据库。
-- 默认账号密码均为 123456，MD5：e10adc3949ba59abbe56e057f20f883e
-- =========================================================

CREATE DATABASE IF NOT EXISTS school_library
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE school_library;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- =========================================================
-- 清理旧触发器
-- =========================================================
DROP TRIGGER IF EXISTS tr_borrow_record_bi;
DROP TRIGGER IF EXISTS tr_borrow_record_bu;
DROP TRIGGER IF EXISTS tr_renew_request_bi;
DROP TRIGGER IF EXISTS tr_renew_request_bu;
DROP TRIGGER IF EXISTS tr_fine_record_bi;
DROP TRIGGER IF EXISTS tr_fine_record_bu;
DROP TRIGGER IF EXISTS tr_operation_log_bi;
DROP TRIGGER IF EXISTS tr_operation_log_bu;
DROP TRIGGER IF EXISTS tr_seat_lock_bi;
DROP TRIGGER IF EXISTS tr_seat_lock_bu;
DROP TRIGGER IF EXISTS tr_seat_reservation_bi;
DROP TRIGGER IF EXISTS tr_seat_reservation_bu;

-- =========================================================
-- 清理旧表
-- =========================================================
DROP TABLE IF EXISTS seat_lock;
DROP TABLE IF EXISTS seat_reservation;
DROP TABLE IF EXISTS library_seat;
DROP TABLE IF EXISTS library_floor;
DROP TABLE IF EXISTS seat_time_slot;

DROP TABLE IF EXISTS fine_record;
DROP TABLE IF EXISTS renew_request;
DROP TABLE IF EXISTS operation_log;
DROP TABLE IF EXISTS notice;

DROP TABLE IF EXISTS borrow_record;
DROP TABLE IF EXISTS book_copy;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS book_category;
DROP TABLE IF EXISTS reader;
DROP TABLE IF EXISTS admin;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- 1. 管理员表
-- =========================================================
CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '管理员ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '管理员账号',
    password VARCHAR(64) NOT NULL COMMENT 'MD5加密后的密码',
    real_name VARCHAR(50) NOT NULL COMMENT '管理员姓名',
    role VARCHAR(30) NOT NULL DEFAULT 'ADMIN' COMMENT '角色：SUPER_ADMIN超级管理员，ADMIN普通管理员',
    phone VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    avatar VARCHAR(255) DEFAULT NULL COMMENT '管理员头像路径',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

-- =========================================================
-- 2. 读者表
-- =========================================================
CREATE TABLE reader (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '读者ID',
    reader_no VARCHAR(50) NOT NULL UNIQUE COMMENT '读者编号/借阅证号',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '登录账号',
    password VARCHAR(64) NOT NULL COMMENT 'MD5加密后的密码',
    student_no VARCHAR(50) DEFAULT NULL COMMENT '学号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    gender VARCHAR(10) DEFAULT NULL COMMENT '性别',
    college VARCHAR(100) DEFAULT NULL COMMENT '学院',
    major VARCHAR(100) DEFAULT NULL COMMENT '专业',
    class_name VARCHAR(100) DEFAULT NULL COMMENT '班级',
    department VARCHAR(100) DEFAULT NULL COMMENT '院系/部门，兼容旧字段',
    phone VARCHAR(20) DEFAULT NULL COMMENT '电话',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    avatar VARCHAR(255) DEFAULT NULL COMMENT '头像路径',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',
    UNIQUE KEY uk_reader_student_no(student_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='读者表';

-- =========================================================
-- 3. 图书分类表
-- =========================================================
CREATE TABLE book_category (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '分类ID',

    -- 【本次修改】允许为空，避免 V2Mapper.addCategory 只插入 category_name / description 时报 category_code 无默认值
    category_code VARCHAR(50) DEFAULT NULL COMMENT '分类编码，兼容旧字段',

    category_name VARCHAR(100) NOT NULL COMMENT '分类名称',

    -- 【本次修改】新增：V2Mapper.listCategories 会读取 c.description
    description VARCHAR(500) DEFAULT NULL COMMENT '分类描述',

    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    UNIQUE KEY uk_category_code(category_code),
    UNIQUE KEY uk_category_name(category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书分类表';

-- =========================================================
-- 4. 图书表
-- =========================================================
CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '图书ID',
    book_no VARCHAR(50) NOT NULL UNIQUE COMMENT '图书编号',
    isbn VARCHAR(50) DEFAULT NULL COMMENT 'ISBN',
    book_name VARCHAR(100) NOT NULL COMMENT '书名',
    author VARCHAR(100) DEFAULT NULL COMMENT '作者',
    publisher VARCHAR(100) DEFAULT NULL COMMENT '出版社',
    category VARCHAR(50) DEFAULT NULL COMMENT '分类名称，兼容旧字段',
    category_id INT DEFAULT NULL COMMENT '分类ID',
    total_count INT NOT NULL DEFAULT 0 COMMENT '总库存',
    available_count INT NOT NULL DEFAULT 0 COMMENT '可借库存',
    location VARCHAR(100) DEFAULT NULL COMMENT '馆藏位置/书架',
    cover_image VARCHAR(255) DEFAULT NULL COMMENT '图书封面图片路径',
    description TEXT COMMENT '图书简介',
    borrow_count INT NOT NULL DEFAULT 0 COMMENT '累计借阅次数',
    recommend_flag TINYINT NOT NULL DEFAULT 0 COMMENT '是否推荐：1推荐，0不推荐',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1上架，0下架',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_book_category FOREIGN KEY(category_id) REFERENCES book_category(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_book_name(book_name),
    INDEX idx_book_category_id(category_id),
    INDEX idx_book_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书信息表';

-- =========================================================
-- 5. 实体书副本表
-- =========================================================
CREATE TABLE book_copy (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '实体书ID',
    book_id INT NOT NULL COMMENT '图书种类ID',
    copy_no VARCHAR(64) NOT NULL COMMENT '实体书编码，例如 B2026001-001',
    shelf_status VARCHAR(32) NOT NULL DEFAULT 'ON_SHELF' COMMENT '实体书状态：ON_SHELF已上架，BORROWED借出中，RETURN_PROCESSING上架中，OFF_SHELF下架，DAMAGED损坏，LOST遗失',
    location VARCHAR(100) DEFAULT NULL COMMENT '馆藏位置',
    current_borrow_id INT DEFAULT NULL COMMENT '当前借阅记录ID',
    return_process_start_time DATETIME DEFAULT NULL COMMENT '进入上架中时间',
    available_at DATETIME DEFAULT NULL COMMENT '预计自动上架时间',
    shelf_time DATETIME DEFAULT NULL COMMENT '实际上架时间',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '数据状态：1有效，0无效',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_book_copy_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    UNIQUE KEY uk_book_copy_no(copy_no),
    INDEX idx_book_copy_book_id(book_id),
    INDEX idx_book_copy_shelf_status(shelf_status),
    INDEX idx_book_copy_available_at(available_at),
    INDEX idx_book_copy_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='实体书副本表';

-- =========================================================
-- 5. 借阅记录表
-- =========================================================
CREATE TABLE borrow_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '借阅记录ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    book_id INT NOT NULL COMMENT '图书ID',
    copy_id INT DEFAULT NULL COMMENT '实体书ID',
    copy_no VARCHAR(64) DEFAULT NULL COMMENT '实体书编码',

    -- 旧版字段：旧 BorrowMapper / Service 可能使用
    borrow_time DATETIME DEFAULT NULL COMMENT '借阅时间，旧字段',
    due_time DATETIME DEFAULT NULL COMMENT '应还时间，旧字段',
    return_time DATETIME DEFAULT NULL COMMENT '实际归还时间，旧字段',

    -- 【本次修改】V2Mapper 使用的新字段
    borrow_date DATETIME DEFAULT NULL COMMENT '借阅时间，V2字段',
    due_date DATETIME DEFAULT NULL COMMENT '应还时间，V2字段',
    return_date DATETIME DEFAULT NULL COMMENT '实际归还时间，V2字段',

    status VARCHAR(30) NOT NULL DEFAULT 'BORROWED' COMMENT '状态：BORROWED借阅中，RETURNED正常归还，OVERDUE逾期，OVERDUE_RETURNED逾期归还',
    renew_count INT NOT NULL DEFAULT 0 COMMENT '续借次数',
    overdue_days INT NOT NULL DEFAULT 0 COMMENT '逾期天数',
    fine DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '逾期罚款金额',
    fine_status VARCHAR(20) NOT NULL DEFAULT 'NONE' COMMENT '罚款状态：NONE无罚款，UNPAID未缴费，PAID已缴费',
    borrow_admin_id INT DEFAULT NULL COMMENT '借书办理管理员ID',
    return_admin_id INT DEFAULT NULL COMMENT '还书办理管理员ID',
    shelf_admin_id INT DEFAULT NULL COMMENT '上架确认管理员ID',
    shelf_time DATETIME DEFAULT NULL COMMENT '上架确认时间',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_borrow_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_borrow_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_borrow_copy FOREIGN KEY(copy_id) REFERENCES book_copy(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_borrow_reader_id(reader_id),
    INDEX idx_borrow_book_id(book_id),
    INDEX idx_borrow_copy_id(copy_id),
    INDEX idx_borrow_copy_no(copy_no),
    INDEX idx_borrow_status(status),
    INDEX idx_borrow_due_time(due_time),
    INDEX idx_borrow_due_date(due_date),
    INDEX idx_borrow_date(borrow_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='借阅记录表';

-- =========================================================
-- 6. 续借申请表
-- =========================================================
CREATE TABLE renew_request (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '续借申请ID',

    -- 旧版字段
    borrow_id INT DEFAULT NULL COMMENT '借阅记录ID，旧字段',
    book_id INT DEFAULT NULL COMMENT '图书ID，旧字段',
    old_due_time DATETIME DEFAULT NULL COMMENT '原应还时间，旧字段',
    new_due_time DATETIME DEFAULT NULL COMMENT '申请后的新应还时间，旧字段',
    audit_admin_id INT DEFAULT NULL COMMENT '审核管理员ID，旧字段',
    audit_time DATETIME DEFAULT NULL COMMENT '审核时间，旧字段',
    audit_remark VARCHAR(500) DEFAULT NULL COMMENT '审核备注，旧字段',

    -- 【本次修改】V2Mapper 使用的新字段
    borrow_record_id INT DEFAULT NULL COMMENT '借阅记录ID，V2字段',
    reader_id INT NOT NULL COMMENT '读者ID',
    reason VARCHAR(500) DEFAULT NULL COMMENT '续借原因',
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待审核，APPROVED已通过，REJECTED已拒绝',
    apply_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',
    handler_id INT DEFAULT NULL COMMENT '处理管理员ID，V2字段',
    handler_name VARCHAR(100) DEFAULT NULL COMMENT '处理管理员姓名，V2字段',
    handle_time DATETIME DEFAULT NULL COMMENT '处理时间，V2字段',
    remark VARCHAR(500) DEFAULT NULL COMMENT '处理备注，V2字段',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_renew_borrow_old FOREIGN KEY(borrow_id) REFERENCES borrow_record(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_renew_borrow_v2 FOREIGN KEY(borrow_record_id) REFERENCES borrow_record(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_renew_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_renew_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_renew_admin_old FOREIGN KEY(audit_admin_id) REFERENCES admin(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_renew_admin_v2 FOREIGN KEY(handler_id) REFERENCES admin(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_renew_status(status),
    INDEX idx_renew_reader_id(reader_id),
    INDEX idx_renew_borrow_record_id(borrow_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='续借申请表';

-- =========================================================
-- 7. 罚款记录表
-- =========================================================
CREATE TABLE fine_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '罚款记录ID',

    -- 旧版字段
    borrow_id INT DEFAULT NULL COMMENT '借阅记录ID，旧字段',
    book_id INT DEFAULT NULL COMMENT '图书ID，旧字段',

    -- 【本次修改】V2Mapper 使用的新字段
    borrow_record_id INT DEFAULT NULL COMMENT '借阅记录ID，V2字段',

    reader_id INT NOT NULL COMMENT '读者ID',
    overdue_days INT NOT NULL DEFAULT 0 COMMENT '逾期天数',
    amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '罚款金额',
    status VARCHAR(20) NOT NULL DEFAULT 'UNPAID' COMMENT '状态：UNPAID未缴费，PAID已缴费，CANCELED已取消',
    pay_time DATETIME DEFAULT NULL COMMENT '缴费时间',
    operator_admin_id INT DEFAULT NULL COMMENT '操作管理员ID',
    operator_name VARCHAR(100) DEFAULT NULL COMMENT '操作管理员姓名',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_fine_borrow_old FOREIGN KEY(borrow_id) REFERENCES borrow_record(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_fine_borrow_v2 FOREIGN KEY(borrow_record_id) REFERENCES borrow_record(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_fine_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_fine_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_fine_admin FOREIGN KEY(operator_admin_id) REFERENCES admin(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_fine_status(status),
    INDEX idx_fine_reader_id(reader_id),
    INDEX idx_fine_borrow_record_id(borrow_record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='逾期罚款记录表';

-- =========================================================
-- 8. 公告表
-- =========================================================
CREATE TABLE notice (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '公告ID',
    title VARCHAR(200) NOT NULL COMMENT '公告标题',
    content TEXT NOT NULL COMMENT '公告内容',
    publisher_id INT DEFAULT NULL COMMENT '发布管理员ID',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1发布，0隐藏',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发布时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_notice_admin FOREIGN KEY(publisher_id) REFERENCES admin(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_notice_status(status),
    INDEX idx_notice_create_time(create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='公告表';

-- =========================================================
-- 9. 操作日志表
-- =========================================================
CREATE TABLE operation_log (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '日志ID',
    operator_type VARCHAR(20) DEFAULT NULL COMMENT '操作人类型：ADMIN或READER',
    operator_id INT DEFAULT NULL COMMENT '操作人ID',
    operator_name VARCHAR(100) DEFAULT NULL COMMENT '操作人名称',
    module VARCHAR(100) DEFAULT NULL COMMENT '操作模块',

    -- 旧版字段
    action VARCHAR(100) DEFAULT NULL COMMENT '操作类型，旧字段',
    description VARCHAR(1000) DEFAULT NULL COMMENT '操作描述，旧字段',

    -- 【本次修改】V2Mapper 使用的新字段
    operation VARCHAR(255) DEFAULT NULL COMMENT '操作类型，V2字段',
    request_url VARCHAR(500) DEFAULT NULL COMMENT '请求地址，V2字段',

    ip VARCHAR(80) DEFAULT NULL COMMENT 'IP地址',
    result VARCHAR(20) NOT NULL DEFAULT 'SUCCESS' COMMENT '结果：SUCCESS成功，FAIL失败',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',

    INDEX idx_log_operator(operator_type, operator_id),
    INDEX idx_log_module(module),
    INDEX idx_log_create_time(create_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='操作日志表';

-- =========================================================
-- 10. 图书馆楼层表
-- =========================================================
CREATE TABLE library_floor (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '楼层ID',
    floor_no INT NOT NULL UNIQUE COMMENT '楼层编号',
    floor_name VARCHAR(100) NOT NULL COMMENT '楼层名称',
    seat_count INT NOT NULL DEFAULT 100 COMMENT '座位数量',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书馆楼层表';

-- =========================================================
-- 11. 图书馆座位表
-- =========================================================
CREATE TABLE library_seat (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '座位ID',
    floor_id INT NOT NULL COMMENT '楼层ID',
    seat_no VARCHAR(30) NOT NULL COMMENT '座位编号，例如 F1-001',
    row_no INT NOT NULL COMMENT '行号：1-10',
    col_no INT NOT NULL COMMENT '列号：1-10',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_seat_floor FOREIGN KEY(floor_id) REFERENCES library_floor(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    UNIQUE KEY uk_floor_seat_no(floor_id, seat_no),
    INDEX idx_seat_floor_id(floor_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书馆座位表';

-- =========================================================
-- 12. 座位预约时段表
-- =========================================================
CREATE TABLE seat_time_slot (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '时段ID',
    slot_name VARCHAR(50) DEFAULT NULL COMMENT '时段名称，兼容旧字段',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值，兼容旧字段',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位预约时段表';

-- =========================================================
-- 13. 座位临时锁定表
-- =========================================================
CREATE TABLE seat_lock (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '锁定ID',
    seat_id INT NOT NULL COMMENT '座位ID',
    reader_id INT NOT NULL COMMENT '读者ID',

    -- 旧版字段
    reserve_date DATE DEFAULT NULL COMMENT '预约日期，旧字段',
    slot_id INT DEFAULT NULL COMMENT '时段ID，旧字段',
    active_key TINYINT DEFAULT 1 COMMENT '有效锁唯一标记，兼容旧字段',

    -- 【本次修改】V2Mapper 使用的新字段
    reservation_date DATE DEFAULT NULL COMMENT '预约日期，V2字段',
    time_slot_id INT DEFAULT NULL COMMENT '时段ID，V2字段',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1有效，0失效',

    expire_time DATETIME NOT NULL COMMENT '锁定过期时间',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    CONSTRAINT fk_lock_seat FOREIGN KEY(seat_id) REFERENCES library_seat(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_lock_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_lock_slot_old FOREIGN KEY(slot_id) REFERENCES seat_time_slot(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_lock_slot_v2 FOREIGN KEY(time_slot_id) REFERENCES seat_time_slot(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_lock_seat_date_slot(seat_id, reservation_date, time_slot_id, status),
    INDEX idx_lock_reader_date_slot(reader_id, reservation_date, time_slot_id, status),
    INDEX idx_lock_expire_time(expire_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位临时锁定表';

-- =========================================================
-- 14. 座位预约记录表
-- =========================================================
CREATE TABLE seat_reservation (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '预约ID',
    seat_id INT NOT NULL COMMENT '座位ID',
    reader_id INT NOT NULL COMMENT '读者ID',

    -- 旧版字段
    reserve_date DATE DEFAULT NULL COMMENT '预约日期，旧字段',
    slot_id INT DEFAULT NULL COMMENT '时段ID，旧字段',
    active_key TINYINT DEFAULT 1 COMMENT '有效预约唯一标记，兼容旧字段',

    -- 【本次修改】V2Mapper 使用的新字段
    reservation_date DATE DEFAULT NULL COMMENT '预约日期，V2字段',
    time_slot_id INT DEFAULT NULL COMMENT '时段ID，V2字段',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1有效，0取消或过期',

    cancel_by VARCHAR(20) DEFAULT NULL COMMENT '取消人类型：READER或ADMIN',
    cancel_user_id INT DEFAULT NULL COMMENT '取消人ID',
    cancel_time DATETIME DEFAULT NULL COMMENT '取消时间',
    cancel_reason VARCHAR(255) DEFAULT NULL COMMENT '取消原因',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '预约创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_reservation_seat FOREIGN KEY(seat_id) REFERENCES library_seat(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservation_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_reservation_slot_old FOREIGN KEY(slot_id) REFERENCES seat_time_slot(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    CONSTRAINT fk_reservation_slot_v2 FOREIGN KEY(time_slot_id) REFERENCES seat_time_slot(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_reservation_date_slot(reservation_date, time_slot_id),
    INDEX idx_reservation_status(status),
    INDEX idx_reservation_reader(reader_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位预约记录表';

-- =========================================================
-- 15. 字段同步触发器
-- =========================================================
DELIMITER $$

CREATE TRIGGER tr_borrow_record_bi
BEFORE INSERT ON borrow_record
FOR EACH ROW
BEGIN
    IF NEW.borrow_date IS NULL AND NEW.borrow_time IS NOT NULL THEN
        SET NEW.borrow_date = NEW.borrow_time;
    END IF;
    IF NEW.borrow_time IS NULL AND NEW.borrow_date IS NOT NULL THEN
        SET NEW.borrow_time = NEW.borrow_date;
    END IF;

    IF NEW.due_date IS NULL AND NEW.due_time IS NOT NULL THEN
        SET NEW.due_date = NEW.due_time;
    END IF;
    IF NEW.due_time IS NULL AND NEW.due_date IS NOT NULL THEN
        SET NEW.due_time = NEW.due_date;
    END IF;

    IF NEW.return_date IS NULL AND NEW.return_time IS NOT NULL THEN
        SET NEW.return_date = NEW.return_time;
    END IF;
    IF NEW.return_time IS NULL AND NEW.return_date IS NOT NULL THEN
        SET NEW.return_time = NEW.return_date;
    END IF;
END$$

CREATE TRIGGER tr_borrow_record_bu
BEFORE UPDATE ON borrow_record
FOR EACH ROW
BEGIN
    IF NEW.borrow_date IS NULL AND NEW.borrow_time IS NOT NULL THEN
        SET NEW.borrow_date = NEW.borrow_time;
    END IF;
    IF NEW.borrow_time IS NULL AND NEW.borrow_date IS NOT NULL THEN
        SET NEW.borrow_time = NEW.borrow_date;
    END IF;
    IF NEW.borrow_time <> OLD.borrow_time THEN
        SET NEW.borrow_date = NEW.borrow_time;
    END IF;
    IF NEW.borrow_date <> OLD.borrow_date THEN
        SET NEW.borrow_time = NEW.borrow_date;
    END IF;

    IF NEW.due_date IS NULL AND NEW.due_time IS NOT NULL THEN
        SET NEW.due_date = NEW.due_time;
    END IF;
    IF NEW.due_time IS NULL AND NEW.due_date IS NOT NULL THEN
        SET NEW.due_time = NEW.due_date;
    END IF;
    IF NEW.due_time <> OLD.due_time THEN
        SET NEW.due_date = NEW.due_time;
    END IF;
    IF NEW.due_date <> OLD.due_date THEN
        SET NEW.due_time = NEW.due_date;
    END IF;

    IF NEW.return_date IS NULL AND NEW.return_time IS NOT NULL THEN
        SET NEW.return_date = NEW.return_time;
    END IF;
    IF NEW.return_time IS NULL AND NEW.return_date IS NOT NULL THEN
        SET NEW.return_time = NEW.return_date;
    END IF;
END$$

CREATE TRIGGER tr_renew_request_bi
BEFORE INSERT ON renew_request
FOR EACH ROW
BEGIN
    IF NEW.borrow_record_id IS NULL AND NEW.borrow_id IS NOT NULL THEN
        SET NEW.borrow_record_id = NEW.borrow_id;
    END IF;
    IF NEW.borrow_id IS NULL AND NEW.borrow_record_id IS NOT NULL THEN
        SET NEW.borrow_id = NEW.borrow_record_id;
    END IF;

    IF NEW.handler_id IS NULL AND NEW.audit_admin_id IS NOT NULL THEN
        SET NEW.handler_id = NEW.audit_admin_id;
    END IF;
    IF NEW.audit_admin_id IS NULL AND NEW.handler_id IS NOT NULL THEN
        SET NEW.audit_admin_id = NEW.handler_id;
    END IF;

    IF NEW.handle_time IS NULL AND NEW.audit_time IS NOT NULL THEN
        SET NEW.handle_time = NEW.audit_time;
    END IF;
    IF NEW.audit_time IS NULL AND NEW.handle_time IS NOT NULL THEN
        SET NEW.audit_time = NEW.handle_time;
    END IF;

    IF NEW.remark IS NULL AND NEW.audit_remark IS NOT NULL THEN
        SET NEW.remark = NEW.audit_remark;
    END IF;
    IF NEW.audit_remark IS NULL AND NEW.remark IS NOT NULL THEN
        SET NEW.audit_remark = NEW.remark;
    END IF;
END$$

CREATE TRIGGER tr_renew_request_bu
BEFORE UPDATE ON renew_request
FOR EACH ROW
BEGIN
    IF NEW.borrow_record_id IS NULL AND NEW.borrow_id IS NOT NULL THEN
        SET NEW.borrow_record_id = NEW.borrow_id;
    END IF;
    IF NEW.borrow_id IS NULL AND NEW.borrow_record_id IS NOT NULL THEN
        SET NEW.borrow_id = NEW.borrow_record_id;
    END IF;

    IF NEW.handler_id IS NULL AND NEW.audit_admin_id IS NOT NULL THEN
        SET NEW.handler_id = NEW.audit_admin_id;
    END IF;
    IF NEW.audit_admin_id IS NULL AND NEW.handler_id IS NOT NULL THEN
        SET NEW.audit_admin_id = NEW.handler_id;
    END IF;

    IF NEW.handle_time IS NULL AND NEW.audit_time IS NOT NULL THEN
        SET NEW.handle_time = NEW.audit_time;
    END IF;
    IF NEW.audit_time IS NULL AND NEW.handle_time IS NOT NULL THEN
        SET NEW.audit_time = NEW.handle_time;
    END IF;

    IF NEW.remark IS NULL AND NEW.audit_remark IS NOT NULL THEN
        SET NEW.remark = NEW.audit_remark;
    END IF;
    IF NEW.audit_remark IS NULL AND NEW.remark IS NOT NULL THEN
        SET NEW.audit_remark = NEW.remark;
    END IF;
END$$

CREATE TRIGGER tr_fine_record_bi
BEFORE INSERT ON fine_record
FOR EACH ROW
BEGIN
    IF NEW.borrow_record_id IS NULL AND NEW.borrow_id IS NOT NULL THEN
        SET NEW.borrow_record_id = NEW.borrow_id;
    END IF;
    IF NEW.borrow_id IS NULL AND NEW.borrow_record_id IS NOT NULL THEN
        SET NEW.borrow_id = NEW.borrow_record_id;
    END IF;
END$$

CREATE TRIGGER tr_fine_record_bu
BEFORE UPDATE ON fine_record
FOR EACH ROW
BEGIN
    IF NEW.borrow_record_id IS NULL AND NEW.borrow_id IS NOT NULL THEN
        SET NEW.borrow_record_id = NEW.borrow_id;
    END IF;
    IF NEW.borrow_id IS NULL AND NEW.borrow_record_id IS NOT NULL THEN
        SET NEW.borrow_id = NEW.borrow_record_id;
    END IF;
END$$

CREATE TRIGGER tr_operation_log_bi
BEFORE INSERT ON operation_log
FOR EACH ROW
BEGIN
    IF NEW.operation IS NULL AND NEW.action IS NOT NULL THEN
        SET NEW.operation = NEW.action;
    END IF;
    IF NEW.action IS NULL AND NEW.operation IS NOT NULL THEN
        SET NEW.action = NEW.operation;
    END IF;
END$$

CREATE TRIGGER tr_operation_log_bu
BEFORE UPDATE ON operation_log
FOR EACH ROW
BEGIN
    IF NEW.operation IS NULL AND NEW.action IS NOT NULL THEN
        SET NEW.operation = NEW.action;
    END IF;
    IF NEW.action IS NULL AND NEW.operation IS NOT NULL THEN
        SET NEW.action = NEW.operation;
    END IF;
END$$

CREATE TRIGGER tr_seat_lock_bi
BEFORE INSERT ON seat_lock
FOR EACH ROW
BEGIN
    IF NEW.reservation_date IS NULL AND NEW.reserve_date IS NOT NULL THEN
        SET NEW.reservation_date = NEW.reserve_date;
    END IF;
    IF NEW.reserve_date IS NULL AND NEW.reservation_date IS NOT NULL THEN
        SET NEW.reserve_date = NEW.reservation_date;
    END IF;

    IF NEW.time_slot_id IS NULL AND NEW.slot_id IS NOT NULL THEN
        SET NEW.time_slot_id = NEW.slot_id;
    END IF;
    IF NEW.slot_id IS NULL AND NEW.time_slot_id IS NOT NULL THEN
        SET NEW.slot_id = NEW.time_slot_id;
    END IF;

    IF NEW.status = 0 THEN
        SET NEW.active_key = NULL;
    END IF;
END$$

CREATE TRIGGER tr_seat_lock_bu
BEFORE UPDATE ON seat_lock
FOR EACH ROW
BEGIN
    IF NEW.reservation_date IS NULL AND NEW.reserve_date IS NOT NULL THEN
        SET NEW.reservation_date = NEW.reserve_date;
    END IF;
    IF NEW.reserve_date IS NULL AND NEW.reservation_date IS NOT NULL THEN
        SET NEW.reserve_date = NEW.reservation_date;
    END IF;

    IF NEW.time_slot_id IS NULL AND NEW.slot_id IS NOT NULL THEN
        SET NEW.time_slot_id = NEW.slot_id;
    END IF;
    IF NEW.slot_id IS NULL AND NEW.time_slot_id IS NOT NULL THEN
        SET NEW.slot_id = NEW.time_slot_id;
    END IF;

    IF NEW.status = 0 THEN
        SET NEW.active_key = NULL;
    END IF;
END$$

CREATE TRIGGER tr_seat_reservation_bi
BEFORE INSERT ON seat_reservation
FOR EACH ROW
BEGIN
    IF NEW.reservation_date IS NULL AND NEW.reserve_date IS NOT NULL THEN
        SET NEW.reservation_date = NEW.reserve_date;
    END IF;
    IF NEW.reserve_date IS NULL AND NEW.reservation_date IS NOT NULL THEN
        SET NEW.reserve_date = NEW.reservation_date;
    END IF;

    IF NEW.time_slot_id IS NULL AND NEW.slot_id IS NOT NULL THEN
        SET NEW.time_slot_id = NEW.slot_id;
    END IF;
    IF NEW.slot_id IS NULL AND NEW.time_slot_id IS NOT NULL THEN
        SET NEW.slot_id = NEW.time_slot_id;
    END IF;

    IF NEW.status = 0 THEN
        SET NEW.active_key = NULL;
    END IF;
END$$

CREATE TRIGGER tr_seat_reservation_bu
BEFORE UPDATE ON seat_reservation
FOR EACH ROW
BEGIN
    IF NEW.reservation_date IS NULL AND NEW.reserve_date IS NOT NULL THEN
        SET NEW.reservation_date = NEW.reserve_date;
    END IF;
    IF NEW.reserve_date IS NULL AND NEW.reservation_date IS NOT NULL THEN
        SET NEW.reserve_date = NEW.reservation_date;
    END IF;

    IF NEW.time_slot_id IS NULL AND NEW.slot_id IS NOT NULL THEN
        SET NEW.time_slot_id = NEW.slot_id;
    END IF;
    IF NEW.slot_id IS NULL AND NEW.time_slot_id IS NOT NULL THEN
        SET NEW.slot_id = NEW.time_slot_id;
    END IF;

    IF NEW.status = 0 THEN
        SET NEW.active_key = NULL;
    END IF;
END$$

DELIMITER ;

-- =========================================================
-- 初始化数据
-- =========================================================

-- =========================================================
-- 【本次新增】实体书副本自动维护触发器
-- 说明：
-- 1. 新增图书时，按 total_count 自动生成 book_copy。
-- 2. 增加 total_count 时，自动补齐新增实体书编码。
-- 3. 减少 total_count 时，不删除历史实体书，只把超出的已上架实体书标记为 OFF_SHELF。
-- =========================================================
DROP TRIGGER IF EXISTS trg_book_after_insert_copy;
DROP TRIGGER IF EXISTS trg_book_after_update_copy;

DELIMITER $$

CREATE TRIGGER trg_book_after_insert_copy
AFTER INSERT ON book
FOR EACH ROW
BEGIN
    INSERT INTO book_copy(book_id, copy_no, shelf_status, location, status, shelf_time, create_time)
    SELECT
        NEW.id,
        CONCAT(NEW.book_no, '-', LPAD(seq.n, 3, '0')),
        'ON_SHELF',
        NEW.location,
        1,
        NOW(),
        NOW()
    FROM (
        SELECT ones.n + tens.n * 10 + hundreds.n * 100 + 1 AS n
        FROM
            (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
             UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
        CROSS JOIN
            (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
             UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
        CROSS JOIN
            (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
             UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) hundreds
    ) seq
    WHERE seq.n <= IFNULL(NEW.total_count, 0)
    ON DUPLICATE KEY UPDATE update_time = NOW();
END$$

CREATE TRIGGER trg_book_after_update_copy
AFTER UPDATE ON book
FOR EACH ROW
BEGIN
    IF IFNULL(NEW.total_count, 0) > IFNULL(OLD.total_count, 0) THEN
        INSERT INTO book_copy(book_id, copy_no, shelf_status, location, status, shelf_time, create_time)
        SELECT
            NEW.id,
            CONCAT(NEW.book_no, '-', LPAD(seq.n, 3, '0')),
            'ON_SHELF',
            NEW.location,
            1,
            NOW(),
            NOW()
        FROM (
            SELECT ones.n + tens.n * 10 + hundreds.n * 100 + 1 AS n
            FROM
                (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
                 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
            CROSS JOIN
                (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
                 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) tens
            CROSS JOIN
                (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
                 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) hundreds
        ) seq
        WHERE seq.n > IFNULL(OLD.total_count, 0)
          AND seq.n <= IFNULL(NEW.total_count, 0)
        ON DUPLICATE KEY UPDATE update_time = NOW();
    END IF;

    IF IFNULL(NEW.total_count, 0) < IFNULL(OLD.total_count, 0) THEN
        UPDATE book_copy
        SET shelf_status = 'OFF_SHELF', update_time = NOW()
        WHERE book_id = NEW.id
          AND shelf_status = 'ON_SHELF'
          AND CAST(SUBSTRING_INDEX(copy_no, '-', -1) AS UNSIGNED) > IFNULL(NEW.total_count, 0);
    END IF;
END$$

DELIMITER ;

INSERT INTO admin(id, username, password, real_name, role, phone, email, status)
VALUES
(1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', '超级管理员', 'SUPER_ADMIN', '13800000000', 'admin@example.com', 1),
(2, 'libadmin', 'e10adc3949ba59abbe56e057f20f883e', '普通管理员', 'ADMIN', '13800000009', 'libadmin@example.com', 1);

INSERT INTO reader(
    id, reader_no, username, password,
    student_no, name, gender, college, major, class_name, department,
    phone, email, status
)
VALUES
(1, 'R2026001', 'R2026001', 'e10adc3949ba59abbe56e057f20f883e',
 '202401001', '王同学', '男', '计算机学院', '计算机科学与技术', '计科一班', '计算机学院',
 '13800000001', 'reader1@example.com', 1),

(2, 'R2026002', 'R2026002', 'e10adc3949ba59abbe56e057f20f883e',
 '202401002', '李同学', '女', '信息工程学院', '软件工程', '软工一班', '信息工程学院',
 '13800000002', 'reader2@example.com', 1);

INSERT INTO book_category(id, category_code, category_name, description, sort_order, remark, status)
VALUES
(1, 'CS', '计算机类', '计算机、软件、人工智能、网络、数据库等相关图书', 1, '计算机、软件、网络、数据库等相关图书', 1),
(2, 'LIT', '文学类', '小说、散文、诗歌等文学类图书', 2, '小说、散文、诗歌等文学类图书', 1),
(3, 'ENG', '外语类', '英语及其他语言学习图书', 3, '英语及其他语言学习图书', 1),
(4, 'MGT', '管理类', '管理学、经济学相关图书', 4, '管理学、经济学相关图书', 1),
(5, 'SCI', '自然科学类', '数学、物理、化学等自然科学图书', 5, '数学、物理、化学等自然科学图书', 1);

INSERT INTO book(
    id, book_no, isbn, book_name, author, publisher,
    category, category_id,
    total_count, available_count, location,
    cover_image, description, borrow_count, recommend_flag, status
)
VALUES
(1, 'B2026001', '9787300000011', 'Java Web程序设计', '张三', '清华大学出版社',
 '计算机类', 1, 10, 9, 'A-01',
 NULL, '本书介绍 Java Web 开发基础知识，适合作为 Web 开发入门教材。', 1, 1, 1),

(2, 'B2026002', '9787300000028', '数据库系统概论', '王珊', '高等教育出版社',
 '计算机类', 1, 8, 7, 'A-02',
 NULL, '本书系统介绍数据库基本概念、关系模型、SQL语言和数据库设计方法。', 1, 1, 1),

(3, 'B2026003', '9787300000035', '软件工程导论', '李四', '人民邮电出版社',
 '计算机类', 1, 6, 6, 'A-03',
 NULL, '本书介绍软件工程的基本过程、需求分析、系统设计、测试与维护。', 0, 0, 1),

(4, 'B2026004', '9787300000042', '大学英语阅读', '赵五', '外语教学出版社',
 '外语类', 3, 5, 5, 'B-01',
 NULL, '本书适合大学英语阅读训练使用，包含多种题材的阅读材料。', 0, 0, 1),

(5, 'B2026005', '9787300000059', '管理学基础', '周六', '机械工业出版社',
 '管理类', 4, 7, 7, 'C-01',
 NULL, '本书介绍管理学基础理论、组织管理、计划控制等内容。', 0, 0, 1);

INSERT INTO borrow_record(
    id, reader_id, book_id,
    borrow_time, due_time, return_time,
    borrow_date, due_date, return_date,
    status, renew_count, overdue_days, fine, fine_status
)
VALUES
(1, 1, 1,
 DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 25 DAY), NULL,
 DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(NOW(), INTERVAL 25 DAY), NULL,
 'BORROWED', 0, 0, 0.00, 'NONE'),

(2, 1, 2,
 DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), NULL,
 DATE_SUB(NOW(), INTERVAL 40 DAY), DATE_SUB(NOW(), INTERVAL 10 DAY), NULL,
 'BORROWED', 0, 10, 5.00, 'UNPAID');

-- =========================================================
-- 【本次修复】绑定初始化借阅记录与实体书副本
-- 说明：必须在 borrow_record 初始化完成后执行。
-- =========================================================
UPDATE borrow_record br
JOIN book_copy bc ON bc.copy_no = 'B2026001-001'
SET br.copy_id = bc.id,
    br.copy_no = bc.copy_no,
    br.borrow_admin_id = 2
WHERE br.id = 1;

UPDATE borrow_record br
JOIN book_copy bc ON bc.copy_no = 'B2026002-001'
SET br.copy_id = bc.id,
    br.copy_no = bc.copy_no,
    br.borrow_admin_id = 2
WHERE br.id = 2;

UPDATE book_copy bc
JOIN borrow_record br ON br.copy_id = bc.id
SET bc.shelf_status = 'BORROWED',
    bc.current_borrow_id = br.id,
    bc.update_time = NOW()
WHERE br.status = 'BORROWED'
  AND br.return_date IS NULL
  AND br.return_time IS NULL;

UPDATE book b
SET b.total_count = (
        SELECT COUNT(1)
        FROM book_copy bc
        WHERE bc.book_id = b.id
          AND bc.status = 1
    ),
    b.available_count = (
        SELECT COUNT(1)
        FROM book_copy bc
        WHERE bc.book_id = b.id
          AND bc.status = 1
          AND bc.shelf_status = 'ON_SHELF'
    ),
    b.update_time = NOW()
WHERE EXISTS (
    SELECT 1 FROM book_copy bc WHERE bc.book_id = b.id
);

INSERT INTO fine_record(
    id, borrow_id, borrow_record_id, reader_id, book_id,
    overdue_days, amount, status, remark
)
VALUES
(1, 2, 2, 1, 2, 10, 5.00, 'UNPAID', '初始化逾期罚款示例');

INSERT INTO notice(title, content, publisher_id, status)
VALUES
('图书馆系统试运行通知', '校园图书馆管理系统已进入试运行阶段，读者可登录系统查询图书、查看借阅记录并预约座位。', 1, 1),
('借阅规则提醒', '普通读者每次借阅期限默认为30天，请按时归还图书，逾期将产生罚款。', 1, 1),
('座位预约功能上线', '读者可在系统中按楼层、日期和时段预约座位。', 1, 1);

INSERT INTO library_floor(id, floor_no, floor_name, seat_count, status)
VALUES
(1, 1, '一楼阅览区', 100, 1),
(2, 2, '二楼自习区', 100, 1),
(3, 3, '三楼考研区', 100, 1);

INSERT INTO seat_time_slot(id, slot_name, start_time, end_time, status, sort_order)
VALUES
(1, '08:00-10:00', '08:00:00', '10:00:00', 1, 1),
(2, '10:00-12:00', '10:00:00', '12:00:00', 1, 2),
(3, '12:00-14:00', '12:00:00', '14:00:00', 1, 3),
(4, '14:00-16:00', '14:00:00', '16:00:00', 1, 4),
(5, '16:00-18:00', '16:00:00', '18:00:00', 1, 5),
(6, '18:00-20:00', '18:00:00', '20:00:00', 1, 6),
(7, '20:00-22:00', '20:00:00', '22:00:00', 1, 7);

INSERT INTO library_seat(floor_id, seat_no, row_no, col_no, status)
SELECT
    f.id AS floor_id,
    CONCAT('F', f.floor_no, '-', LPAD(((r.n - 1) * 10 + c.n), 3, '0')) AS seat_no,
    r.n AS row_no,
    c.n AS col_no,
    1 AS status
FROM library_floor f
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) r
JOIN (
    SELECT 1 AS n UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
    UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10
) c
WHERE f.floor_no IN (1, 2, 3)
ORDER BY f.floor_no, r.n, c.n;

INSERT INTO operation_log(operator_type, operator_id, operator_name, module, action, operation, description, request_url, ip, result)
VALUES
('ADMIN', 1, '超级管理员', '系统初始化', 'INIT_DATABASE', 'INIT_DATABASE', '初始化 SchoolLibrary v2.0 集成版数据库结构和基础数据', '/schema-v2-integrated.sql', '127.0.0.1', 'SUCCESS');

-- =========================================================
-- 校验数据
-- =========================================================
SELECT 'admin' AS table_name, COUNT(*) AS total FROM admin
UNION ALL SELECT 'reader', COUNT(*) FROM reader
UNION ALL SELECT 'book_category', COUNT(*) FROM book_category
UNION ALL SELECT 'book', COUNT(*) FROM book
UNION ALL SELECT 'borrow_record', COUNT(*) FROM borrow_record
UNION ALL SELECT 'notice', COUNT(*) FROM notice
UNION ALL SELECT 'library_floor', COUNT(*) FROM library_floor
UNION ALL SELECT 'library_seat', COUNT(*) FROM library_seat
UNION ALL SELECT 'seat_time_slot', COUNT(*) FROM seat_time_slot
UNION ALL SELECT 'fine_record', COUNT(*) FROM fine_record;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- Part 2：v2 增量迁移 V2_001_v2_delta.sql
-- 说明：该部分是幂等迁移，完整初始化后再次执行不会重复加字段。
-- =========================================================

-- =========================================================
-- SchoolLibrary v2 增量迁移脚本 001
-- 作用：从旧 schema 平滑升级到 v2 字段结构
-- 执行方式：source E:/SchoolLibrary/src/main/resources/sql/migration/V2_001_v2_delta.sql;
-- 特点：可重复执行，不会重复加字段
-- =========================================================

USE school_library;

DROP PROCEDURE IF EXISTS add_col_if_missing;
DROP PROCEDURE IF EXISTS add_index_if_missing;

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

CREATE PROCEDURE add_index_if_missing(
    IN tableName VARCHAR(64),
    IN indexName VARCHAR(64),
    IN indexDefinition TEXT
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM information_schema.STATISTICS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = tableName
          AND INDEX_NAME = indexName
    ) THEN
        SET @sql = CONCAT('ALTER TABLE `', tableName, '` ADD ', indexDefinition);
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END IF;
END//

DELIMITER ;

-- 1. book_category v2 字段
CALL add_col_if_missing('book_category', 'description', '`description` VARCHAR(500) NULL COMMENT ''分类描述''');
CALL add_col_if_missing('book_category', 'update_time', '`update_time` DATETIME NULL');
UPDATE book_category SET description = '系统默认分类' WHERE description IS NULL;

-- 2. borrow_record 兼容字段
CALL add_col_if_missing('borrow_record', 'borrow_date', '`borrow_date` DATETIME NULL');
CALL add_col_if_missing('borrow_record', 'due_date', '`due_date` DATETIME NULL');
CALL add_col_if_missing('borrow_record', 'return_date', '`return_date` DATETIME NULL');
CALL add_col_if_missing('borrow_record', 'renew_count', '`renew_count` INT NOT NULL DEFAULT 0');
CALL add_col_if_missing('borrow_record', 'fine', '`fine` DECIMAL(10,2) NOT NULL DEFAULT 0.00');
CALL add_col_if_missing('borrow_record', 'fine_status', '`fine_status` VARCHAR(20) NOT NULL DEFAULT ''NONE''');
CALL add_col_if_missing('borrow_record', 'update_time', '`update_time` DATETIME NULL');

UPDATE borrow_record SET borrow_date = borrow_time WHERE borrow_date IS NULL AND borrow_time IS NOT NULL;
UPDATE borrow_record SET due_date = due_time WHERE due_date IS NULL AND due_time IS NOT NULL;
UPDATE borrow_record SET return_date = return_time WHERE return_date IS NULL AND return_time IS NOT NULL;

-- 3. renew_request 兼容字段
CALL add_col_if_missing('renew_request', 'borrow_record_id', '`borrow_record_id` INT NULL');
CALL add_col_if_missing('renew_request', 'reader_id', '`reader_id` INT NULL');
CALL add_col_if_missing('renew_request', 'handler_id', '`handler_id` INT NULL');
CALL add_col_if_missing('renew_request', 'handler_name', '`handler_name` VARCHAR(100) NULL');
CALL add_col_if_missing('renew_request', 'handle_time', '`handle_time` DATETIME NULL');
CALL add_col_if_missing('renew_request', 'remark', '`remark` VARCHAR(500) NULL');
CALL add_col_if_missing('renew_request', 'update_time', '`update_time` DATETIME NULL');

UPDATE renew_request SET borrow_record_id = borrow_id WHERE borrow_record_id IS NULL AND borrow_id IS NOT NULL;
UPDATE renew_request SET handler_id = audit_admin_id WHERE handler_id IS NULL AND audit_admin_id IS NOT NULL;
UPDATE renew_request SET handle_time = audit_time WHERE handle_time IS NULL AND audit_time IS NOT NULL;
UPDATE renew_request SET remark = audit_remark WHERE remark IS NULL AND audit_remark IS NOT NULL;

-- 4. fine_record 兼容字段
CALL add_col_if_missing('fine_record', 'borrow_record_id', '`borrow_record_id` INT NULL');
CALL add_col_if_missing('fine_record', 'operator_id', '`operator_id` INT NULL');
CALL add_col_if_missing('fine_record', 'operator_name', '`operator_name` VARCHAR(100) NULL');
CALL add_col_if_missing('fine_record', 'pay_time', '`pay_time` DATETIME NULL');
CALL add_col_if_missing('fine_record', 'update_time', '`update_time` DATETIME NULL');
UPDATE fine_record SET borrow_record_id = borrow_id WHERE borrow_record_id IS NULL AND borrow_id IS NOT NULL;

-- 5. seat_lock 兼容字段
CALL add_col_if_missing('seat_lock', 'reservation_date', '`reservation_date` DATE NULL');
CALL add_col_if_missing('seat_lock', 'time_slot_id', '`time_slot_id` INT NULL');
CALL add_col_if_missing('seat_lock', 'status', '`status` TINYINT NOT NULL DEFAULT 1');
CALL add_col_if_missing('seat_lock', 'create_time', '`create_time` DATETIME NULL');
CALL add_col_if_missing('seat_lock', 'update_time', '`update_time` DATETIME NULL');
UPDATE seat_lock SET reservation_date = reserve_date WHERE reservation_date IS NULL AND reserve_date IS NOT NULL;
UPDATE seat_lock SET time_slot_id = slot_id WHERE time_slot_id IS NULL AND slot_id IS NOT NULL;

-- 6. seat_reservation 兼容字段
CALL add_col_if_missing('seat_reservation', 'reservation_date', '`reservation_date` DATE NULL');
CALL add_col_if_missing('seat_reservation', 'time_slot_id', '`time_slot_id` INT NULL');
CALL add_col_if_missing('seat_reservation', 'cancel_time', '`cancel_time` DATETIME NULL');
CALL add_col_if_missing('seat_reservation', 'update_time', '`update_time` DATETIME NULL');
UPDATE seat_reservation SET reservation_date = reserve_date WHERE reservation_date IS NULL AND reserve_date IS NOT NULL;
UPDATE seat_reservation SET time_slot_id = slot_id WHERE time_slot_id IS NULL AND slot_id IS NOT NULL;

-- 7. operation_log 兼容字段
CALL add_col_if_missing('operation_log', 'operation', '`operation` VARCHAR(255) NULL');
CALL add_col_if_missing('operation_log', 'request_url', '`request_url` VARCHAR(500) NULL');
CALL add_col_if_missing('operation_log', 'operator_type', '`operator_type` VARCHAR(30) NULL');
CALL add_col_if_missing('operation_log', 'operator_id', '`operator_id` INT NULL');
CALL add_col_if_missing('operation_log', 'operator_name', '`operator_name` VARCHAR(100) NULL');
CALL add_col_if_missing('operation_log', 'module', '`module` VARCHAR(100) NULL');
CALL add_col_if_missing('operation_log', 'ip', '`ip` VARCHAR(64) NULL');
CALL add_col_if_missing('operation_log', 'create_time', '`create_time` DATETIME NULL');
UPDATE operation_log SET operation = action WHERE operation IS NULL AND action IS NOT NULL;

-- 8. 索引与唯一约束
CALL add_index_if_missing('seat_reservation', 'idx_reader_seat_slot_status', 'KEY `idx_reader_seat_slot_status` (`reader_id`, `reservation_date`, `time_slot_id`, `status`)');
CALL add_index_if_missing('seat_reservation', 'idx_seat_slot', 'KEY `idx_seat_slot` (`seat_id`, `reservation_date`, `time_slot_id`, `status`)');
CALL add_index_if_missing('renew_request', 'idx_renew_borrow_status', 'KEY `idx_renew_borrow_status` (`borrow_record_id`, `status`)');
CALL add_index_if_missing('fine_record', 'idx_fine_borrow_status', 'KEY `idx_fine_borrow_status` (`borrow_record_id`, `status`)');
CALL add_index_if_missing('operation_log', 'idx_operation_log_time', 'KEY `idx_operation_log_time` (`create_time`)');
CALL add_index_if_missing('operation_log', 'idx_operation_log_module', 'KEY `idx_operation_log_module` (`module`)');

DROP PROCEDURE IF EXISTS add_col_if_missing;
DROP PROCEDURE IF EXISTS add_index_if_missing;

-- =========================================================
-- Part 3：v2 业务约束迁移 V2_002_business_constraints.sql
-- =========================================================

-- =========================================================
-- SchoolLibrary v2 增量迁移脚本 002
-- 作用：补充业务约束说明和校验用索引
-- 执行方式：source E:/SchoolLibrary/src/main/resources/sql/migration/V2_002_business_constraints.sql;
-- =========================================================

USE school_library;

-- 说明：
-- 1. “同一读者同一日期同一时段只能预约一个座位”已由 uk_reader_seat_slot 和后端 Service 双重保证。
-- 2. “不能预约过去日期/时段”由 V2BusinessService + V2Mapper.countPastSeatTimeSlot 保证。
-- 3. 续借、罚款生成、缴费确认由 @Transactional 保护。

INSERT INTO operation_log(operator_type, operator_id, operator_name, module, operation, request_url, ip, create_time)
VALUES('SYSTEM', NULL, '数据库迁移', '数据库迁移', '已执行 v2 业务约束迁移脚本', 'sql/migration/V2_002_business_constraints.sql', 'localhost', NOW());

-- =========================================================
-- SchoolLibrary v2 完整数据库脚本执行结束
-- =========================================================


-- =========================================================
-- 【本次新增】执行完成检查
-- 如果下面三条有结果，说明实体书借阅所需表和字段已经创建成功。
-- =========================================================
SHOW TABLES LIKE 'book_copy';
SHOW COLUMNS FROM borrow_record LIKE 'copy_id';
SELECT COUNT(*) AS book_copy_count FROM book_copy;

SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================
-- SchoolLibrary v2 完整数据库脚本执行结束
-- =========================================================

-- =========================================================
-- Part 2：V2_004 剩余逻辑修复
-- 来源：V2_004_fix_remaining_logic.sql
-- =========================================================

-- =========================================================
-- V2_004_fix_remaining_logic.sql
-- 【本次新增】剩余 13 个逻辑问题的数据库侧修复
--
-- 执行方式：
-- mysql -u root -p
-- source E:/SchoolLibrary/src/main/resources/sql/migration/V2_004_fix_remaining_logic.sql;
-- =========================================================

USE school_library;

-- 1. 保证 admin 是唯一超级管理员，其他 SUPER_ADMIN 纠正为 ADMIN。
UPDATE admin
SET role = 'ADMIN', update_time = NOW()
WHERE role = 'SUPER_ADMIN'
  AND username <> 'admin';

-- 2. 如果 admin 不存在，则补一个超级管理员。
INSERT INTO admin(username, password, real_name, role, phone, email, status, create_time)
SELECT 'admin', MD5('123456'), '超级管理员', 'SUPER_ADMIN', NULL, NULL, 1, NOW()
WHERE NOT EXISTS (
    SELECT 1 FROM admin WHERE username = 'admin'
);

-- 3. 强制 admin 为 SUPER_ADMIN 且启用。
UPDATE admin
SET role = 'SUPER_ADMIN',
    status = 1,
    update_time = NOW()
WHERE username = 'admin';

-- 4. 清理旧触发器。
DROP TRIGGER IF EXISTS tr_admin_unique_super_bi;
DROP TRIGGER IF EXISTS tr_admin_unique_super_bu;

DELIMITER $$

-- 5. 插入管理员时，数据库层面阻止第二个超级管理员。
CREATE TRIGGER tr_admin_unique_super_bi
BEFORE INSERT ON admin
FOR EACH ROW
BEGIN
    IF NEW.role = 'SUPER_ADMIN' AND NEW.username <> 'admin' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'SUPER_ADMIN 账号固定唯一为 admin，不能新增其他超级管理员';
    END IF;

    IF NEW.role = 'SUPER_ADMIN'
       AND EXISTS (SELECT 1 FROM admin WHERE role = 'SUPER_ADMIN') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '系统中已经存在超级管理员 admin，不能新增第二个超级管理员';
    END IF;

    IF NEW.username = 'admin' THEN
        SET NEW.role = 'SUPER_ADMIN';
        SET NEW.status = 1;
    END IF;
END$$

-- 6. 更新管理员时，数据库层面阻止破坏 admin 唯一超级管理员规则。
CREATE TRIGGER tr_admin_unique_super_bu
BEFORE UPDATE ON admin
FOR EACH ROW
BEGIN
    IF OLD.username = 'admin' AND NEW.username <> 'admin' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '超级管理员账号 admin 不允许改名';
    END IF;

    IF OLD.username = 'admin' AND NEW.role <> 'SUPER_ADMIN' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'admin 必须保持 SUPER_ADMIN 角色';
    END IF;

    IF OLD.username = 'admin' AND NEW.status <> 1 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '超级管理员 admin 不允许禁用';
    END IF;

    IF NEW.role = 'SUPER_ADMIN' AND NEW.username <> 'admin' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'SUPER_ADMIN 账号固定唯一为 admin，不能把普通管理员改为超级管理员';
    END IF;

    IF NEW.role = 'SUPER_ADMIN'
       AND EXISTS (
           SELECT 1
           FROM admin
           WHERE role = 'SUPER_ADMIN'
             AND id <> OLD.id
       ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '系统中已经存在超级管理员 admin，不能出现第二个超级管理员';
    END IF;
END$$

DELIMITER ;

-- 7. 修复历史导入可能造成的 book.available_count 与 book_copy 状态不一致。
UPDATE book b
SET b.total_count = (
        SELECT COUNT(1)
        FROM book_copy bc
        WHERE bc.book_id = b.id
          AND bc.status = 1
    ),
    b.available_count = (
        SELECT COUNT(1)
        FROM book_copy bc
        WHERE bc.book_id = b.id
          AND bc.status = 1
          AND bc.shelf_status = 'ON_SHELF'
    ),
    b.update_time = NOW()
WHERE EXISTS (
    SELECT 1
    FROM book_copy bc
    WHERE bc.book_id = b.id
);

-- 8. 检查结果。
SELECT username, role, status FROM admin WHERE username = 'admin';
SELECT COUNT(*) AS super_admin_count FROM admin WHERE role = 'SUPER_ADMIN';
SELECT COUNT(*) AS book_copy_count FROM book_copy;

-- =========================================================
-- SchoolLibrary v2 完整数据库脚本执行结束
-- =========================================================
