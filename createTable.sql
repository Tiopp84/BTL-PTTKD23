CREATE DATABASE IF NOT EXISTS restaurant9
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restaurant9;

-- 1. Bảng độc lập
CREATE TABLE tblAddress9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  houseNumber VARCHAR(255) NOT NULL,
  street VARCHAR(255) NOT NULL,
  ward VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblTable9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  slot INT(10) NOT NULL,
  base_price FLOAT NOT NULL,
  status VARCHAR(50) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblTimeSlot9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  price_multiplier FLOAT NULL
) ENGINE=InnoDB;

CREATE TABLE tblMaterial9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  stock INT(10) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblDish9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  unit VARCHAR(50) NOT NULL,
  description VARCHAR(255) NULL,
  imageUrl VARCHAR(255) NULL,
  price FLOAT(10) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE tblCombo9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NULL,
  imageUrl VARCHAR(255) NULL,
  price FLOAT(10) NOT NULL
) ENGINE=InnoDB;

-- 2. Member + Supplier (phụ thuộc Address)
CREATE TABLE tblMember9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  userName VARCHAR(255) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  dob DATE NULL,
  email VARCHAR(255) NULL,
  phone VARCHAR(50) NULL,
  gender VARCHAR(20) NULL,
  createdAt DATE NOT NULL,
  firstName VARCHAR(255) NULL,
  lastName VARCHAR(255) NULL,
  status VARCHAR(50) NOT NULL,
  role VARCHAR(25) NULL,
  address INT(10) NOT NULL,
  CONSTRAINT fk_member_address FOREIGN KEY (address)
    REFERENCES tblAddress9(id)
) ENGINE=InnoDB;

CREATE TABLE tblSupplier9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(255) NULL UNIQUE,
  description VARCHAR(255) NULL,
  address INT(10) NOT NULL,
  CONSTRAINT fk_supplier_address FOREIGN KEY (address)
    REFERENCES tblAddress9(id)
) ENGINE=InnoDB;

-- 3. Order (phụ thuộc Member)
CREATE TABLE tblOrder9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  createdAt DATE NOT NULL,
  note VARCHAR(255) NULL,
  total FLOAT(10) NOT NULL,
  status VARCHAR(50) NULL,
  customerId INT(10) NOT NULL,
  staffId INT(10) NOT NULL,
  CONSTRAINT fk_order_customer FOREIGN KEY (customerId)
    REFERENCES tblMember9(id),
  CONSTRAINT fk_order_staff FOREIGN KEY (staffId)
    REFERENCES tblMember9(id)
) ENGINE=InnoDB;

-- 4. ImportInvoice
CREATE TABLE tblImportInvoice9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  total FLOAT(10) NOT NULL,
  createdAt DATE NOT NULL,
  note VARCHAR(255) NULL,
  supplierId INT(10) NOT NULL,
  staffId INT(10) NOT NULL,
  CONSTRAINT fk_import_supplier FOREIGN KEY (supplierId)
    REFERENCES tblSupplier9(id),
  CONSTRAINT fk_import_staff FOREIGN KEY (staffId)
    REFERENCES tblMember9(id)
) ENGINE=InnoDB;

CREATE TABLE tblImportDetail9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  price FLOAT(10) NOT NULL,
  qty INT(10) NOT NULL,
  invoiceId INT(10) NOT NULL,
  materialId INT(10) NOT NULL,
  CONSTRAINT fk_impdetail_invoice FOREIGN KEY (invoiceId)
    REFERENCES tblImportInvoice9(id) ON DELETE CASCADE,
  CONSTRAINT fk_impdetail_material FOREIGN KEY (materialId)
    REFERENCES tblMaterial9(id)
) ENGINE=InnoDB;

-- 5. OrderedItem + ComboDetail + ReservedTable
CREATE TABLE tblOrderedItem9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  createdAt DATE NOT NULL,
  qty INT(10) NOT NULL,
  price FLOAT(10) NOT NULL,
  status VARCHAR(50) NOT NULL,
  dishId INT(10) NULL,
  comboId INT(10) NULL,
  orderId INT(10) NOT NULL,
  CONSTRAINT fk_orderitem_dish FOREIGN KEY (dishId)
    REFERENCES tblDish9(id),
  CONSTRAINT fk_orderitem_combo FOREIGN KEY (comboId)
    REFERENCES tblCombo9(id),
  CONSTRAINT fk_orderitem_order FOREIGN KEY (orderId)
    REFERENCES tblOrder9(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblComboDetail9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  qty INT(10) NOT NULL,
  dishId INT(10) NOT NULL,
  comboId INT(10) NOT NULL,
  CONSTRAINT fk_combodetail_dish FOREIGN KEY (dishId)
    REFERENCES tblDish9(id),
  CONSTRAINT fk_combodetail_combo FOREIGN KEY (comboId)
    REFERENCES tblCombo9(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE tblReservedTable9 (
  id INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  tableId INT(10) NOT NULL,
  timeSlotId INT(10) NOT NULL,
  orderId INT(10) NOT NULL,
  CONSTRAINT fk_reserved_table FOREIGN KEY (tableId)
    REFERENCES tblTable9(id),
  CONSTRAINT fk_reserved_timeslot FOREIGN KEY (timeSlotId)
    REFERENCES tblTimeSlot9(id),
  CONSTRAINT fk_reserved_order FOREIGN KEY (orderId)
    REFERENCES tblOrder9(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ================================================================
-- DỮ LIỆU MẪU: Món ăn, Combo và các món thuộc Combo
-- Có thể chạy lại phần này: mỗi món/Combo chỉ được thêm nếu chưa có.
-- ================================================================
INSERT INTO tblDish9 (name, unit, description, imageUrl, price)
SELECT seed.name, seed.unit, seed.description, seed.imageUrl, seed.price
FROM (
  SELECT 'Gà chiên giòn' AS name, 'Đĩa' AS unit,
         'Gà chiên lớp vỏ giòn, dùng kèm tương ớt.' AS description,
         'https://images.unsplash.com/photo-1626645738196-c2a7c87a8f58?auto=format&fit=crop&w=600&q=80' AS imageUrl,
         85000 AS price
  UNION ALL SELECT 'Ếch rang muối', 'Đĩa', 'Ếch rang muối đậm vị, thơm sả.',
         'https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=600&q=80', 65000
  UNION ALL SELECT 'Gà nướng mật ong', 'Đĩa', 'Gà nướng mật ong vàng thơm.',
         'https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=600&q=80', 120000
  UNION ALL SELECT 'Cơm chiên hải sản', 'Đĩa', 'Cơm chiên cùng tôm, mực và rau củ.',
         'https://images.unsplash.com/photo-1603133872878-684f208fb84b?auto=format&fit=crop&w=600&q=80', 75000
  UNION ALL SELECT 'Cơm rang dưa bò', 'Đĩa', 'Cơm rang dưa chua với thịt bò mềm.',
         'https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=600&q=80', 70000
  UNION ALL SELECT 'Phở bò tái', 'Bát', 'Phở bò tái nước dùng trong, thơm quế hồi.',
         'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?auto=format&fit=crop&w=600&q=80', 55000
  UNION ALL SELECT 'Bún chả Hà Nội', 'Suất', 'Bún chả thịt nướng ăn kèm rau sống.',
         'https://images.unsplash.com/photo-1559314809-0d155014e29e?auto=format&fit=crop&w=600&q=80', 60000
  UNION ALL SELECT 'Nem rán', 'Đĩa', 'Nem rán nhân thịt và miến, 6 chiếc mỗi đĩa.',
         'https://images.unsplash.com/photo-1601050690597-df0568f70950?auto=format&fit=crop&w=600&q=80', 50000
  UNION ALL SELECT 'Canh chua cá', 'Tô', 'Canh chua cá với dứa, cà chua và bạc hà.',
         'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80', 70000
  UNION ALL SELECT 'Rau muống xào tỏi', 'Đĩa', 'Rau muống xào tỏi xanh giòn.',
         'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80', 35000
  UNION ALL SELECT 'Trà đào cam sả', 'Ly', 'Trà đào thanh mát, thơm cam và sả.',
         'https://images.unsplash.com/photo-1497534446932-c925b458314e?auto=format&fit=crop&w=600&q=80', 35000
  UNION ALL SELECT 'Nước chanh tươi', 'Ly', 'Nước chanh tươi giải khát.',
         'https://images.unsplash.com/photo-1523371054106-bbf80586c38c?auto=format&fit=crop&w=600&q=80', 25000
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM tblDish9 d WHERE d.name = seed.name);

INSERT INTO tblCombo9 (name, description, imageUrl, price)
SELECT seed.name, seed.description, seed.imageUrl, seed.price
FROM (
  SELECT 'Combo Gà Tứ Xuyên' AS name, 'Gà chiên giòn, cơm chiên hải sản và trà đào.' AS description,
         'https://images.unsplash.com/photo-1562967914-608f82629710?auto=format&fit=crop&w=600&q=80' AS imageUrl, 175000 AS price
  UNION ALL SELECT 'Combo Gia Đình', 'Gà nướng, canh chua cá, rau muống và nước chanh.',
         'https://images.unsplash.com/photo-1600891964092-4316c288032e?auto=format&fit=crop&w=600&q=80', 260000
  UNION ALL SELECT 'Combo Hà Nội', 'Phở bò tái, bún chả, nem rán và trà đào.',
         'https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=600&q=80', 210000
  UNION ALL SELECT 'Combo Trưa Văn Phòng', 'Cơm rang dưa bò, rau muống xào tỏi và nước chanh.',
         'https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=600&q=80', 120000
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM tblCombo9 c WHERE c.name = seed.name);

INSERT INTO tblComboDetail9 (qty, dishId, comboId)
SELECT seed.qty, d.id, c.id
FROM (
  SELECT 'Combo Gà Tứ Xuyên' AS comboName, 'Gà chiên giòn' AS dishName, 1 AS qty
  UNION ALL SELECT 'Combo Gà Tứ Xuyên', 'Cơm chiên hải sản', 1
  UNION ALL SELECT 'Combo Gà Tứ Xuyên', 'Trà đào cam sả', 2
  UNION ALL SELECT 'Combo Gia Đình', 'Gà nướng mật ong', 1
  UNION ALL SELECT 'Combo Gia Đình', 'Canh chua cá', 1
  UNION ALL SELECT 'Combo Gia Đình', 'Rau muống xào tỏi', 1
  UNION ALL SELECT 'Combo Gia Đình', 'Nước chanh tươi', 4
  UNION ALL SELECT 'Combo Hà Nội', 'Phở bò tái', 1
  UNION ALL SELECT 'Combo Hà Nội', 'Bún chả Hà Nội', 1
  UNION ALL SELECT 'Combo Hà Nội', 'Nem rán', 1
  UNION ALL SELECT 'Combo Hà Nội', 'Trà đào cam sả', 2
  UNION ALL SELECT 'Combo Trưa Văn Phòng', 'Cơm rang dưa bò', 1
  UNION ALL SELECT 'Combo Trưa Văn Phòng', 'Rau muống xào tỏi', 1
  UNION ALL SELECT 'Combo Trưa Văn Phòng', 'Nước chanh tươi', 1
) AS seed
JOIN tblDish9 d ON d.name = seed.dishName
JOIN tblCombo9 c ON c.name = seed.comboName
WHERE NOT EXISTS (
  SELECT 1 FROM tblComboDetail9 cd
  WHERE cd.comboId = c.id AND cd.dishId = d.id
);


-- ================================================================
-- DỮ LIỆU MẪU: Nhà cung cấp, nhân viên kho, nguyên liệu, phiếu nhập
-- Phục vụ module Thống kê nhà cung cấp.
-- Có thể chạy lại: mỗi bản ghi chỉ được thêm nếu chưa tồn tại.
-- Ngày phiếu nhập tính lùi từ CURRENT_DATE nên luôn có dữ liệu gần đây;
-- khi demo chọn khoảng "hôm nay - 90 ngày" đến "hôm nay".
-- ================================================================

-- Địa chỉ của nhà cung cấp và nhân viên kho
INSERT INTO tblAddress9 (houseNumber, street, ward, city)
SELECT seed.houseNumber, seed.street, seed.ward, seed.city
FROM (
  SELECT '12' AS houseNumber, 'Nguyễn Trãi' AS street,
         'Phường Bến Thành' AS ward, 'TP. Hồ Chí Minh' AS city
  UNION ALL SELECT '45', 'Lê Lợi', 'Phường 1', 'Đà Lạt'
  UNION ALL SELECT '88', 'Trần Phú', 'Phường 6', 'Nha Trang'
  UNION ALL SELECT '101', 'Nguyễn Văn Cừ', 'Phường 4', 'TP. Hồ Chí Minh'
  UNION ALL SELECT '22', 'Hai Bà Trưng', 'Phường Tân Định', 'TP. Hồ Chí Minh'
) AS seed
WHERE NOT EXISTS (
  SELECT 1 FROM tblAddress9 a
  WHERE a.houseNumber = seed.houseNumber AND a.street = seed.street
    AND a.ward = seed.ward AND a.city = seed.city
);

-- Nhà cung cấp
INSERT INTO tblSupplier9 (name, phone, email, description, address)
SELECT seed.name, seed.phone, seed.email, seed.description,
       (SELECT a.id FROM tblAddress9 a
        WHERE a.houseNumber = seed.houseNumber AND a.street = seed.street
          AND a.ward = seed.ward AND a.city = seed.city
        ORDER BY a.id LIMIT 1)
FROM (
  SELECT 'Công ty TNHH Thực phẩm Minh Anh' AS name, '0901234567' AS phone,
         'minhanh@food.vn' AS email,
         'Cung cấp thịt gà, thịt bò, trứng và gia vị.' AS description,
         '12' AS houseNumber, 'Nguyễn Trãi' AS street,
         'Phường Bến Thành' AS ward, 'TP. Hồ Chí Minh' AS city
  UNION ALL SELECT 'Công ty CP Nông sản Đồng Xanh', '0912345678', 'dongxanh@farm.vn',
         'Rau củ, gạo và trái cây tươi Đà Lạt.',
         '45', 'Lê Lợi', 'Phường 1', 'Đà Lạt'
  UNION ALL SELECT 'Cửa hàng Hải sản Biển Đông', '0987654321', 'biendong@seafood.vn',
         'Hải sản tươi sống: cá lóc, tôm sú.',
         '88', 'Trần Phú', 'Phường 6', 'Nha Trang'
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM tblSupplier9 s WHERE s.name = seed.name);

-- Nhân viên kho (dùng làm staffId của phiếu nhập).
-- Mật khẩu là hash PBKDF2 của một chuỗi ngẫu nhiên, không dùng để đăng nhập.
INSERT INTO tblMember9 (userName, password, email, phone, createdAt,
                        firstName, lastName, status, role, address)
SELECT seed.userName, seed.password, seed.email, seed.phone, CURRENT_DATE,
       seed.firstName, seed.lastName, 'active', 'WarehouseStaff',
       (SELECT a.id FROM tblAddress9 a
        WHERE a.houseNumber = seed.houseNumber AND a.street = seed.street
          AND a.ward = seed.ward AND a.city = seed.city
        ORDER BY a.id LIMIT 1)
FROM (
  SELECT 'khohang1' AS userName,
         'pbkdf2_sha256$600000$meE6/wxjfyhFwpK+LGjoLA==$8Lqf8NnMdC9Wo+Wrb2hDnYSweyPGLysv9GFTdteCFa8=' AS password,
         'khohang1@restman.vn' AS email, '0901111111' AS phone,
         'Nguyễn Văn' AS firstName, 'Kho' AS lastName,
         '101' AS houseNumber, 'Nguyễn Văn Cừ' AS street,
         'Phường 4' AS ward, 'TP. Hồ Chí Minh' AS city
  UNION ALL SELECT 'khohang2',
         'pbkdf2_sha256$600000$ChCMV4np56DsSqr2FPVCVg==$QTyAfO37dFWDe8BsJGEKO4gDXvMK+U7DOcoI1FdenKY=',
         'khohang2@restman.vn', '0902222222',
         'Trần Thị', 'Nhập',
         '22', 'Hai Bà Trưng', 'Phường Tân Định', 'TP. Hồ Chí Minh'
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM tblMember9 m WHERE m.userName = seed.userName);

-- Nguyên liệu nhập kho
INSERT INTO tblMaterial9 (name, unit, description, stock)
SELECT seed.name, seed.unit, seed.description, seed.stock
FROM (
  SELECT 'Thịt gà' AS name, 'kg' AS unit, 'Thịt gà tươi, bảo quản mát.' AS description, 120 AS stock
  UNION ALL SELECT 'Thịt bò', 'kg', 'Thịt bò nạc, dùng chế biến món xào.', 80
  UNION ALL SELECT 'Cá lóc', 'kg', 'Cá lóc tươi, làm sạch.', 45
  UNION ALL SELECT 'Tôm sú', 'kg', 'Tôm sú loại 1, còn sống.', 30
  UNION ALL SELECT 'Rau muống', 'kg', 'Rau muống tươi, hái trong ngày.', 60
  UNION ALL SELECT 'Cà chua', 'kg', 'Cà chua chín đỏ.', 40
  UNION ALL SELECT 'Gạo tẻ', 'kg', 'Gạo tẻ thơm, hạt dài.', 250
  UNION ALL SELECT 'Trứng gà', 'quả', 'Trứng gà công nghiệp.', 300
  UNION ALL SELECT 'Dầu ăn', 'lít', 'Dầu ăn tinh luyện.', 50
  UNION ALL SELECT 'Nước mắm', 'lít', 'Nước mắm cá cơm nguyên chất.', 35
  UNION ALL SELECT 'Bún tươi', 'kg', 'Bún tươi sản xuất trong ngày.', 25
  UNION ALL SELECT 'Chanh', 'kg', 'Chanh tươi, dùng pha nước.', 20
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM tblMaterial9 m WHERE m.name = seed.name);

-- Phiếu nhập (mỗi phiếu có note duy nhất để chạy lại không bị trùng)
INSERT INTO tblImportInvoice9 (total, createdAt, note, supplierId, staffId)
SELECT seed.total, DATE_SUB(CURRENT_DATE, INTERVAL seed.daysAgo DAY),
       seed.note,
       (SELECT s.id FROM tblSupplier9 s WHERE s.name = seed.supplierName ORDER BY s.id LIMIT 1),
       (SELECT m.id FROM tblMember9 m WHERE m.userName = seed.staffUserName ORDER BY m.id LIMIT 1)
FROM (
  SELECT 'SEED-NCC-MA-01' AS note, 'Công ty TNHH Thực phẩm Minh Anh' AS supplierName,
         'khohang1' AS staffUserName, 8 AS daysAgo,
         4200000 AS total
  UNION ALL SELECT 'SEED-NCC-MA-02', 'Công ty TNHH Thực phẩm Minh Anh',
         'khohang2', 42, 1810000
  UNION ALL SELECT 'SEED-NCC-DX-01', 'Công ty CP Nông sản Đồng Xanh',
         'khohang1', 25, 1750000
  UNION ALL SELECT 'SEED-NCC-DX-02', 'Công ty CP Nông sản Đồng Xanh',
         'khohang2', 3, 980000
  UNION ALL SELECT 'SEED-NCC-BD-01', 'Cửa hàng Hải sản Biển Đông',
         'khohang1', 60, 2720000
  UNION ALL SELECT 'SEED-NCC-BD-02', 'Cửa hàng Hải sản Biển Đông',
         'khohang2', 15, 2410000
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM tblImportInvoice9 ii WHERE ii.note = seed.note);

-- Chi tiết phiếu nhập (price là đơn giá, qty là số lượng)
INSERT INTO tblImportDetail9 (price, qty, invoiceId, materialId)
SELECT seed.price, seed.qty, i.id, m.id
FROM (
  SELECT 'SEED-NCC-MA-01' AS note, 'Thịt gà' AS materialName, 70000 AS price, 20 AS qty
  UNION ALL SELECT 'SEED-NCC-MA-01', 'Thịt bò', 250000, 10
  UNION ALL SELECT 'SEED-NCC-MA-01', 'Trứng gà', 3000, 100
  UNION ALL SELECT 'SEED-NCC-MA-02', 'Thịt gà', 72000, 15
  UNION ALL SELECT 'SEED-NCC-MA-02', 'Dầu ăn', 45000, 10
  UNION ALL SELECT 'SEED-NCC-MA-02', 'Nước mắm', 35000, 8
  UNION ALL SELECT 'SEED-NCC-DX-01', 'Rau muống', 15000, 30
  UNION ALL SELECT 'SEED-NCC-DX-01', 'Cà chua', 20000, 20
  UNION ALL SELECT 'SEED-NCC-DX-01', 'Gạo tẻ', 18000, 50
  UNION ALL SELECT 'SEED-NCC-DX-02', 'Rau muống', 16000, 25
  UNION ALL SELECT 'SEED-NCC-DX-02', 'Cà chua', 22000, 15
  UNION ALL SELECT 'SEED-NCC-DX-02', 'Chanh', 25000, 10
  UNION ALL SELECT 'SEED-NCC-BD-01', 'Cá lóc', 80000, 12
  UNION ALL SELECT 'SEED-NCC-BD-01', 'Tôm sú', 220000, 8
  UNION ALL SELECT 'SEED-NCC-BD-02', 'Cá lóc', 85000, 10
  UNION ALL SELECT 'SEED-NCC-BD-02', 'Tôm sú', 230000, 6
  UNION ALL SELECT 'SEED-NCC-BD-02', 'Nước mắm', 36000, 5
) AS seed
JOIN tblImportInvoice9 i ON i.note = seed.note
JOIN tblMaterial9 m ON m.name = seed.materialName
WHERE NOT EXISTS (
  SELECT 1 FROM tblImportDetail9 d
  WHERE d.invoiceId = i.id AND d.materialId = m.id
);

-- Kết quả kỳ vọng khi chọn khoảng 90 ngày gần nhất:
--   Minh Anh : 163 đơn vị, 6.010.000 đ
--   Đồng Xanh: 150 đơn vị, 2.730.000 đ
--   Biển Đông:  41 đơn vị, 5.130.000 đ
-- Thứ tự xếp hạng theo lượng nhập: Minh Anh > Đồng Xanh > Biển Đông.
