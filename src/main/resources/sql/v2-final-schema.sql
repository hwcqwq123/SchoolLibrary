/*
 【本次新增】SchoolLibrary v2 最终数据库补全脚本
 说明：
 1. 如果你已经执行过之前的完整 schema.sql，通常不需要执行本脚本。
 2. 如果进入 v2 页面时报某张表不存在，可执行本脚本补齐 v2 表。
 3. 本脚本不删除已有核心表 admin、reader、book、borrow_record。
*/
USE school_library;

CREATE TABLE IF NOT EXISTS book_category (
  id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100) NOT NULL UNIQUE,
  description VARCHAR(255),
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS notice (
  id INT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  publisher_id INT,
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS operation_log (
  id INT PRIMARY KEY AUTO_INCREMENT,
  operator_type VARCHAR(50),
  operator_id INT,
  operator_name VARCHAR(100),
  module VARCHAR(100),
  operation VARCHAR(255),
  request_url VARCHAR(255),
  ip VARCHAR(80),
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS renew_request (
  id INT PRIMARY KEY AUTO_INCREMENT,
  borrow_record_id INT NOT NULL,
  reader_id INT NOT NULL,
  reason VARCHAR(255),
  status VARCHAR(30) DEFAULT 'PENDING',
  apply_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  handler_id INT,
  handler_name VARCHAR(100),
  handle_time DATETIME DEFAULT NULL,
  remark VARCHAR(255),
  update_time DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS fine_record (
  id INT PRIMARY KEY AUTO_INCREMENT,
  borrow_record_id INT NOT NULL,
  reader_id INT NOT NULL,
  amount DECIMAL(10,2) DEFAULT 0.00,
  status VARCHAR(30) DEFAULT 'UNPAID',
  pay_time DATETIME DEFAULT NULL,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS library_floor (
  id INT PRIMARY KEY AUTO_INCREMENT,
  floor_no INT NOT NULL,
  floor_name VARCHAR(100) NOT NULL,
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS library_seat (
  id INT PRIMARY KEY AUTO_INCREMENT,
  floor_id INT NOT NULL,
  seat_no VARCHAR(30) NOT NULL,
  row_no INT NOT NULL,
  col_no INT NOT NULL,
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  update_time DATETIME DEFAULT NULL,
  UNIQUE KEY uk_floor_seat(floor_id, seat_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS seat_time_slot (
  id INT PRIMARY KEY AUTO_INCREMENT,
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS seat_lock (
  id INT PRIMARY KEY AUTO_INCREMENT,
  seat_id INT NOT NULL,
  reader_id INT NOT NULL,
  reservation_date DATE NOT NULL,
  time_slot_id INT NOT NULL,
  expire_time DATETIME NOT NULL,
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS seat_reservation (
  id INT PRIMARY KEY AUTO_INCREMENT,
  seat_id INT NOT NULL,
  reader_id INT NOT NULL,
  reservation_date DATE NOT NULL,
  time_slot_id INT NOT NULL,
  status TINYINT DEFAULT 1,
  create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  cancel_time DATETIME DEFAULT NULL,
  update_time DATETIME DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT IGNORE INTO book_category(id, category_name, description, status) VALUES
(1,'计算机类','计算机、软件、人工智能、网络相关图书',1),
(2,'文学类','文学、小说、散文相关图书',1),
(3,'外语类','英语、日语等外语学习图书',1),
(4,'管理类','管理学、经济学相关图书',1),
(5,'自然科学类','数学、物理、化学等自然科学图书',1);

INSERT IGNORE INTO notice(title, content, publisher_id, status) VALUES
('图书馆开放时间通知','图书馆开放时间为每天 08:00-22:00，请读者合理安排学习时间。',1,1),
('座位预约功能上线','读者可在系统中按楼层、日期和时段预约座位。',1,1);

INSERT IGNORE INTO library_floor(id, floor_no, floor_name, status) VALUES
(1,1,'一楼阅览区',1),(2,2,'二楼自习区',1),(3,3,'三楼考研区',1);

INSERT IGNORE INTO seat_time_slot(id, start_time, end_time, status) VALUES
(1,'08:00:00','10:00:00',1),(2,'10:00:00','12:00:00',1),(3,'12:00:00','14:00:00',1),
(4,'14:00:00','16:00:00',1),(5,'16:00:00','18:00:00',1),(6,'18:00:00','20:00:00',1),(7,'20:00:00','22:00:00',1);

DROP PROCEDURE IF EXISTS init_v2_seats;
DELIMITER $$
CREATE PROCEDURE init_v2_seats()
BEGIN
  DECLARE f INT DEFAULT 1;
  DECLARE r INT;
  DECLARE c INT;
  WHILE f <= 3 DO
    SET r = 1;
    WHILE r <= 10 DO
      SET c = 1;
      WHILE c <= 10 DO
        INSERT IGNORE INTO library_seat(floor_id, seat_no, row_no, col_no, status)
        VALUES(f, CONCAT(f, '-', LPAD((r-1)*10+c, 3, '0')), r, c, 1);
        SET c = c + 1;
      END WHILE;
      SET r = r + 1;
    END WHILE;
    SET f = f + 1;
  END WHILE;
END$$
DELIMITER ;
CALL init_v2_seats();
DROP PROCEDURE init_v2_seats;
