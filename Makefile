SHELL := /bin/bash

# Thư mục chứa docker-compose của CSDL
DB_DIR          ?= $(HOME)/my-databases
MYSQL_SERVICE   ?= mysql
MYSQL_CONTAINER ?= my-mysql

# Đọc cấu hình CSDL từ .env của dự án (không source cả file vì DB_URL chứa '&')
DB_NAME     := $(shell sed -n 's/^DB_NAME=//p' .env 2>/dev/null)
DB_PASSWORD := $(shell sed -n 's/^DB_PASSWORD=//p' .env 2>/dev/null)

# Mật khẩu root của container: ưu tiên .env trong DB_DIR, sau đó tới .env dự án
DB_ROOT_PASSWORD := $(or $(shell sed -n 's/^MYSQL_ROOT_PASSWORD=//p' $(DB_DIR)/.env 2>/dev/null),$(DB_PASSWORD))

# Tài khoản quản lý cần tạo
ADMIN_USER ?= admin

MAIN_CLASS := com.example.util.CreateManager9
CLASSPATH  := target/classes:target/servlet-jsp-demo/WEB-INF/lib/*

.DEFAULT_GOAL := help
.PHONY: help db-up db-down db-logs db-shell db-init create-admin build run clean

help:
	@printf 'Các lệnh:\n'
	@printf '  make db-up                 Khởi động MySQL bằng docker compose\n'
	@printf '  make db-down               Dừng MySQL\n'
	@printf '  make db-logs               Xem log MySQL\n'
	@printf '  make db-shell              Mở mysql client vào CSDL\n'
	@printf '  make db-init               Tạo bảng + dữ liệu mẫu từ createTable.sql (chỉ lần đầu)\n'
	@printf '  make create-admin ADMIN_USER=admin\n'
	@printf '                             Build rồi tạo tài khoản quản lý (hỏi mật khẩu)\n'
	@printf '  make build                 Build WAR (target/servlet-jsp-demo.war)\n'
	@printf '  make run                   Chạy app bằng Jetty tại http://localhost:8080\n'
	@printf '  make clean                 Xoá thư mục target\n'

# --- CSDL ---------------------------------------------------------------

db-up:
	cd $(DB_DIR) && docker compose up -d $(MYSQL_SERVICE)

db-down:
	cd $(DB_DIR) && docker compose stop $(MYSQL_SERVICE)

db-logs:
	cd $(DB_DIR) && docker compose logs -f $(MYSQL_SERVICE)

db-shell:
	docker exec -it $(MYSQL_CONTAINER) mysql -uroot -p'$(DB_ROOT_PASSWORD)' '$(DB_NAME)'

# Chờ MySQL sẵn sàng rồi nạp createTable.sql; bỏ qua nếu CSDL đã có bảng.
db-init: db-up
	@printf 'Chờ MySQL sẵn sàng'
	@for i in $$(seq 1 60); do \
		docker exec $(MYSQL_CONTAINER) mysqladmin ping -uroot -p'$(DB_ROOT_PASSWORD)' --silent >/dev/null 2>&1 && break; \
		printf '.'; sleep 1; \
	done; printf '\n'
	@if docker exec $(MYSQL_CONTAINER) mysql -uroot -p'$(DB_ROOT_PASSWORD)' -N -e \
		"SELECT 1 FROM information_schema.tables WHERE table_schema='$(DB_NAME)' AND table_name='tblMember9'" 2>/dev/null | grep -qx 1; then \
		echo "CSDL '$(DB_NAME)' đã có bảng, bỏ qua createTable.sql."; \
	else \
		echo "Đang nạp createTable.sql vào '$(DB_NAME)'..."; \
		docker exec -i $(MYSQL_CONTAINER) mysql -uroot -p'$(DB_ROOT_PASSWORD)' < createTable.sql; \
		echo "Xong."; \
	fi

# --- Ứng dụng ------------------------------------------------------------

build:
	mvn -q -DskipTests package

# Cần chạy trong terminal tương tác để nhập mật khẩu ẩn.
create-admin: build
	@java -cp '$(CLASSPATH)' $(MAIN_CLASS) '$(ADMIN_USER)'

run:
	mvn jetty:run

clean:
	mvn clean
