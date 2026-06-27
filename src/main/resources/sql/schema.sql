-- =========================================================
-- SchoolLibrary v2.0 完整数据库初始化脚本
-- 兼容 MySQL 5.7 / 较老版本 MySQL / MySQL 8.0
-- 默认账号密码均为 123456，MD5：e10adc3949ba59abbe56e057f20f883e
-- =========================================================

CREATE DATABASE IF NOT EXISTS school_library
DEFAULT CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE school_library;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

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
    category_code VARCHAR(50) NOT NULL UNIQUE COMMENT '分类编码',
    category_name VARCHAR(100) NOT NULL COMMENT '分类名称',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间'
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
-- 5. 借阅记录表
-- =========================================================
CREATE TABLE borrow_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '借阅记录ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    book_id INT NOT NULL COMMENT '图书ID',

    borrow_time DATETIME NOT NULL COMMENT '借阅时间',
    due_time DATETIME NOT NULL COMMENT '应还时间',
    return_time DATETIME DEFAULT NULL COMMENT '实际归还时间',

    status VARCHAR(30) NOT NULL DEFAULT 'BORROWED' COMMENT '状态：BORROWED借阅中，RETURNED正常归还，OVERDUE逾期，OVERDUE_RETURNED逾期归还',
    renew_count INT NOT NULL DEFAULT 0 COMMENT '续借次数',

    overdue_days INT NOT NULL DEFAULT 0 COMMENT '逾期天数',
    fine DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '逾期罚款金额',
    fine_status VARCHAR(20) NOT NULL DEFAULT 'NONE' COMMENT '罚款状态：NONE无罚款，UNPAID未缴费，PAID已缴费',

    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_borrow_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_borrow_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    INDEX idx_borrow_reader_id(reader_id),
    INDEX idx_borrow_book_id(book_id),
    INDEX idx_borrow_status(status),
    INDEX idx_borrow_due_time(due_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='借阅记录表';

-- =========================================================
-- 6. 续借申请表
-- =========================================================
CREATE TABLE renew_request (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '续借申请ID',
    borrow_id INT NOT NULL COMMENT '借阅记录ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    book_id INT NOT NULL COMMENT '图书ID',

    old_due_time DATETIME NOT NULL COMMENT '原应还时间',
    new_due_time DATETIME NOT NULL COMMENT '申请后的新应还时间',
    reason VARCHAR(500) DEFAULT NULL COMMENT '续借原因',

    status VARCHAR(20) NOT NULL DEFAULT 'PENDING' COMMENT '状态：PENDING待审核，APPROVED已通过，REJECTED已拒绝',
    apply_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '申请时间',

    audit_admin_id INT DEFAULT NULL COMMENT '审核管理员ID',
    audit_time DATETIME DEFAULT NULL COMMENT '审核时间',
    audit_remark VARCHAR(500) DEFAULT NULL COMMENT '审核备注',

    CONSTRAINT fk_renew_borrow FOREIGN KEY(borrow_id) REFERENCES borrow_record(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_renew_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_renew_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_renew_admin FOREIGN KEY(audit_admin_id) REFERENCES admin(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_renew_status(status),
    INDEX idx_renew_reader_id(reader_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='续借申请表';

-- =========================================================
-- 7. 罚款记录表
-- =========================================================
CREATE TABLE fine_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '罚款记录ID',
    borrow_id INT NOT NULL COMMENT '借阅记录ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    book_id INT NOT NULL COMMENT '图书ID',

    overdue_days INT NOT NULL DEFAULT 0 COMMENT '逾期天数',
    amount DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '罚款金额',
    status VARCHAR(20) NOT NULL DEFAULT 'UNPAID' COMMENT '状态：UNPAID未缴费，PAID已缴费，CANCELED已取消',

    pay_time DATETIME DEFAULT NULL COMMENT '缴费时间',
    operator_admin_id INT DEFAULT NULL COMMENT '操作管理员ID',
    remark VARCHAR(255) DEFAULT NULL COMMENT '备注',

    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT NULL COMMENT '更新时间',

    CONSTRAINT fk_fine_borrow FOREIGN KEY(borrow_id) REFERENCES borrow_record(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_fine_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_fine_book FOREIGN KEY(book_id) REFERENCES book(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_fine_admin FOREIGN KEY(operator_admin_id) REFERENCES admin(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,

    INDEX idx_fine_status(status),
    INDEX idx_fine_reader_id(reader_id)
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
    operator_type VARCHAR(20) NOT NULL COMMENT '操作人类型：ADMIN或READER',
    operator_id INT DEFAULT NULL COMMENT '操作人ID',
    operator_name VARCHAR(100) DEFAULT NULL COMMENT '操作人名称',

    module VARCHAR(100) NOT NULL COMMENT '操作模块',
    action VARCHAR(100) NOT NULL COMMENT '操作类型',
    description VARCHAR(1000) DEFAULT NULL COMMENT '操作描述',

    ip VARCHAR(50) DEFAULT NULL COMMENT 'IP地址',
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
    floor_name VARCHAR(50) NOT NULL COMMENT '楼层名称',
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
    seat_no VARCHAR(20) NOT NULL COMMENT '座位编号，例如 F1-001',
    row_no INT NOT NULL COMMENT '行号：1-10',
    col_no INT NOT NULL COMMENT '列号：1-10',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

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
    slot_name VARCHAR(50) NOT NULL COMMENT '时段名称',
    start_time TIME NOT NULL COMMENT '开始时间',
    end_time TIME NOT NULL COMMENT '结束时间',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1启用，0禁用',
    sort_order INT NOT NULL DEFAULT 0 COMMENT '排序值'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位预约时段表';

-- =========================================================
-- 13. 座位临时锁定表
-- =========================================================
CREATE TABLE seat_lock (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '锁定ID',
    seat_id INT NOT NULL COMMENT '座位ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    reserve_date DATE NOT NULL COMMENT '预约日期',
    slot_id INT NOT NULL COMMENT '时段ID',
    expire_time DATETIME NOT NULL COMMENT '锁定过期时间',
    active_key TINYINT DEFAULT 1 COMMENT '有效锁唯一标记，释放后设为NULL',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    CONSTRAINT fk_lock_seat FOREIGN KEY(seat_id) REFERENCES library_seat(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_lock_reader FOREIGN KEY(reader_id) REFERENCES reader(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_lock_slot FOREIGN KEY(slot_id) REFERENCES seat_time_slot(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    UNIQUE KEY uk_lock_seat_slot(seat_id, reserve_date, slot_id, active_key),
    UNIQUE KEY uk_lock_reader_slot(reader_id, reserve_date, slot_id, active_key),
    INDEX idx_lock_expire_time(expire_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位临时锁定表';

-- =========================================================
-- 14. 座位预约记录表
-- =========================================================
CREATE TABLE seat_reservation (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '预约ID',
    seat_id INT NOT NULL COMMENT '座位ID',
    reader_id INT NOT NULL COMMENT '读者ID',
    reserve_date DATE NOT NULL COMMENT '预约日期',
    slot_id INT NOT NULL COMMENT '时段ID',

    status VARCHAR(20) NOT NULL DEFAULT 'RESERVED' COMMENT '状态：RESERVED已预约，CANCELED已取消，EXPIRED已过期',
    active_key TINYINT DEFAULT 1 COMMENT '有效预约唯一标记，取消或过期后设为NULL',

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

    CONSTRAINT fk_reservation_slot FOREIGN KEY(slot_id) REFERENCES seat_time_slot(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    UNIQUE KEY uk_reservation_seat_slot(seat_id, reserve_date, slot_id, active_key),
    UNIQUE KEY uk_reservation_reader_slot(reader_id, reserve_date, slot_id, active_key),

    INDEX idx_reservation_date_slot(reserve_date, slot_id),
    INDEX idx_reservation_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='座位预约记录表';

-- =========================================================
-- 初始化数据
-- =========================================================

INSERT INTO admin(username, password, real_name, role, phone, email, status)
VALUES
('admin', 'e10adc3949ba59abbe56e057f20f883e', '超级管理员', 'SUPER_ADMIN', '13800000000', 'admin@example.com', 1),
('libadmin', 'e10adc3949ba59abbe56e057f20f883e', '普通管理员', 'ADMIN', '13800000009', 'libadmin@example.com', 1);

INSERT INTO reader(
    reader_no, username, password,
    student_no, name, gender, college, major, class_name, department,
    phone, email, status
)
VALUES
('R2026001', 'R2026001', 'e10adc3949ba59abbe56e057f20f883e',
 '202401001', '王同学', '男', '计算机学院', '计算机科学与技术', '计科一班', '计算机学院',
 '13800000001', 'reader1@example.com', 1),

('R2026002', 'R2026002', 'e10adc3949ba59abbe56e057f20f883e',
 '202401002', '李同学', '女', '信息工程学院', '软件工程', '软工一班', '信息工程学院',
 '13800000002', 'reader2@example.com', 1);

INSERT INTO book_category(category_code, category_name, sort_order, remark, status)
VALUES
('CS', '计算机类', 1, '计算机、软件、网络、数据库等相关图书', 1),
('LIT', '文学类', 2, '小说、散文、诗歌等文学类图书', 1),
('ENG', '外语类', 3, '英语及其他语言学习图书', 1),
('MGT', '管理类', 4, '管理学、经济学相关图书', 1),
('SCI', '自然科学类', 5, '数学、物理、化学等自然科学图书', 1);

INSERT INTO book(
    book_no, isbn, book_name, author, publisher,
    category, category_id,
    total_count, available_count, location,
    cover_image, description, borrow_count, recommend_flag, status
)
VALUES
('B2026001', '9787300000011', 'Java Web程序设计', '张三', '清华大学出版社',
 '计算机类', 1,
 10, 10, 'A-01',
 NULL, '本书介绍 Java Web 开发基础知识，适合作为 Web 开发入门教材。', 0, 1, 1),

('B2026002', '9787300000028', '数据库系统概论', '王珊', '高等教育出版社',
 '计算机类', 1,
 8, 8, 'A-02',
 NULL, '本书系统介绍数据库基本概念、关系模型、SQL语言和数据库设计方法。', 0, 1, 1),

('B2026003', '9787300000035', '软件工程导论', '李四', '人民邮电出版社',
 '计算机类', 1,
 6, 6, 'A-03',
 NULL, '本书介绍软件工程的基本过程、需求分析、系统设计、测试与维护。', 0, 0, 1),

('B2026004', '9787300000042', '大学英语阅读', '赵五', '外语教学出版社',
 '外语类', 3,
 5, 5, 'B-01',
 NULL, '本书适合大学英语阅读训练使用，包含多种题材的阅读材料。', 0, 0, 1),

('B2026005', '9787300000059', '管理学基础', '周六', '机械工业出版社',
 '管理类', 4,
 7, 7, 'C-01',
 NULL, '本书介绍管理学基础理论、组织管理、计划控制等内容。', 0, 0, 1);

INSERT INTO notice(title, content, publisher_id, status)
VALUES
('图书馆系统试运行通知', '校园图书馆管理系统已进入试运行阶段，读者可登录系统查询图书、查看借阅记录并预约座位。', 1, 1),
('借阅规则提醒', '普通读者每次借阅期限默认为30天，请按时归还图书，逾期将产生罚款。', 1, 1);

INSERT INTO library_floor(floor_no, floor_name, seat_count, status)
VALUES
(1, '一楼阅览区', 100, 1),
(2, '二楼自习区', 100, 1),
(3, '三楼考研区', 100, 1);

INSERT INTO seat_time_slot(slot_name, start_time, end_time, status, sort_order)
VALUES
('08:00-10:00', '08:00:00', '10:00:00', 1, 1),
('10:00-12:00', '10:00:00', '12:00:00', 1, 2),
('12:00-14:00', '12:00:00', '14:00:00', 1, 3),
('14:00-16:00', '14:00:00', '16:00:00', 1, 4),
('16:00-18:00', '16:00:00', '18:00:00', 1, 5),
('18:00-20:00', '18:00:00', '20:00:00', 1, 6),
('20:00-22:00', '20:00:00', '22:00:00', 1, 7);

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

INSERT INTO operation_log(operator_type, operator_id, operator_name, module, action, description, ip, result)
VALUES
('ADMIN', 1, '超级管理员', '系统初始化', 'INIT_DATABASE', '初始化 SchoolLibrary v2.0 数据库结构和基础数据', '127.0.0.1', 'SUCCESS');

SET FOREIGN_KEY_CHECKS = 1;