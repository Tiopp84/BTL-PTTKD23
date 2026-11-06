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
