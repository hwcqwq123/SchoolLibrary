SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS borrow_record;
DROP TABLE IF EXISTS book;
DROP TABLE IF EXISTS reader;
DROP TABLE IF EXISTS admin;

CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '管理员账号',
    password VARCHAR(64) NOT NULL COMMENT 'MD5加密后的密码',
    real_name VARCHAR(50) NOT NULL COMMENT '管理员姓名',
    role VARCHAR(20) NOT NULL DEFAULT 'ADMIN' COMMENT '角色',
    phone VARCHAR(20) DEFAULT NULL COMMENT '联系电话',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='管理员表';

CREATE TABLE reader (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    reader_no VARCHAR(50) NOT NULL UNIQUE COMMENT '读者编号',
    username VARCHAR(50) NOT NULL COMMENT '登录账号，默认等于读者编号',
    password VARCHAR(64) NOT NULL COMMENT 'MD5加密后的密码',
    name VARCHAR(50) NOT NULL COMMENT '读者姓名',
    gender VARCHAR(10) DEFAULT NULL COMMENT '性别',
    phone VARCHAR(20) DEFAULT NULL COMMENT '电话',
    email VARCHAR(100) DEFAULT NULL COMMENT '邮箱',
    department VARCHAR(100) DEFAULT NULL COMMENT '院系/部门',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1正常，0禁用',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='读者表';

CREATE TABLE book (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    book_no VARCHAR(50) NOT NULL UNIQUE COMMENT '图书编号',
    book_name VARCHAR(100) NOT NULL COMMENT '书名',
    author VARCHAR(100) DEFAULT NULL COMMENT '作者',
    publisher VARCHAR(100) DEFAULT NULL COMMENT '出版社',
    category VARCHAR(50) DEFAULT NULL COMMENT '图书分类',
    total_count INT NOT NULL DEFAULT 0 COMMENT '总库存',
    available_count INT NOT NULL DEFAULT 0 COMMENT '可借库存',
    location VARCHAR(50) DEFAULT NULL COMMENT '馆藏位置/书架',
    status TINYINT NOT NULL DEFAULT 1 COMMENT '状态：1上架，0下架',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='图书信息表';

CREATE TABLE borrow_record (
    id INT PRIMARY KEY AUTO_INCREMENT COMMENT '主键',
    reader_id INT NOT NULL COMMENT '读者ID',
    book_id INT NOT NULL COMMENT '图书ID',
    borrow_time DATETIME NOT NULL COMMENT '借阅时间',
    due_time DATETIME NOT NULL COMMENT '应还时间',
    return_time DATETIME DEFAULT NULL COMMENT '实际归还时间',
    status VARCHAR(20) NOT NULL DEFAULT 'BORROWED' COMMENT '状态：BORROWED借阅中，RETURNED已归还，OVERDUE逾期归还',
    overdue_days INT NOT NULL DEFAULT 0 COMMENT '逾期天数',
    fine DECIMAL(10,2) NOT NULL DEFAULT 0.00 COMMENT '逾期罚款',
    create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    CONSTRAINT fk_borrow_reader FOREIGN KEY(reader_id) REFERENCES reader(id),
    CONSTRAINT fk_borrow_book FOREIGN KEY(book_id) REFERENCES book(id),
    INDEX idx_reader_id(reader_id),
    INDEX idx_book_id(book_id),
    INDEX idx_status(status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='借阅记录表';

-- 默认密码均为 123456，MD5 值为 e10adc3949ba59abbe56e057f20f883e
INSERT INTO admin(username, password, real_name, role, phone, status)
VALUES('admin', 'e10adc3949ba59abbe56e057f20f883e', '系统管理员', 'ADMIN', '13800000000', 1);

INSERT INTO reader(reader_no, username, password, name, gender, phone, email, department, status)
VALUES
('R2026001', 'R2026001', 'e10adc3949ba59abbe56e057f20f883e', '王同学', '男', '13800000001', 'reader1@example.com', '计算机学院', 1),
('R2026002', 'R2026002', 'e10adc3949ba59abbe56e057f20f883e', '李同学', '女', '13800000002', 'reader2@example.com', '信息工程学院', 1);

INSERT INTO book(book_no, book_name, author, publisher, category, total_count, available_count, location, status)
VALUES
('B2026001', 'Java Web程序设计', '张三', '清华大学出版社', '计算机类', 10, 10, 'A-01', 1),
('B2026002', '数据库系统概论', '王珊', '高等教育出版社', '计算机类', 8, 8, 'A-02', 1),
('B2026003', '软件工程导论', '李四', '人民邮电出版社', '计算机类', 6, 6, 'A-03', 1),
('B2026004', '大学英语阅读', '赵五', '外语教学出版社', '外语类', 5, 5, 'B-01', 1),
('B2026005', '管理学基础', '周六', '机械工业出版社', '管理类', 7, 7, 'C-01', 1);

SET FOREIGN_KEY_CHECKS = 1;