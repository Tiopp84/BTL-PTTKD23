package com.example.util;

import java.io.Console;
import java.sql.*;
import java.util.Arrays;

/** Tạo tài khoản quản lý từ terminal; không lưu mật khẩu thuần trong SQL. */
public final class CreateManager9 {
    public static void main(String[] args) throws Exception {
        if (args.length != 1 || args[0].isBlank() || args[0].length() > 255) {
            System.out.println("Cách dùng: CreateManager9 <username>");
            return;
        }
        Console console = System.console();
        if (console == null) {
            System.out.println("Hãy chạy trong terminal tương tác để nhập mật khẩu ẩn.");
            return;
        }
        char[] password = console.readPassword("Mật khẩu (ít nhất 8 ký tự): ");
        char[] confirm = console.readPassword("Nhập lại mật khẩu: ");
        try {
            if (password == null || confirm == null || password.length < 8
                    || password.length > 1024 || !Arrays.equals(password, confirm)) {
                System.out.println("Mật khẩu không hợp lệ hoặc không khớp.");
                return;
            }
            String hash = PasswordHash9.hash(password);
            try (Connection con = DBConnection.getConnection()) {
                con.setAutoCommit(false);
                try {
                    try (PreparedStatement ps = con.prepareStatement("SELECT id FROM tblMember9 WHERE userName = ?")) {
                        ps.setString(1, args[0].trim());
                        try (ResultSet rs = ps.executeQuery()) {
                            if (rs.next()) {
                                con.rollback();
                                System.out.println("Tên đăng nhập đã tồn tại. Không thay đổi tài khoản cũ.");
                                return;
                            }
                        }
                    }
                    int addressId;
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO tblAddress9(houseNumber, street, ward, city) VALUES ('', '', '', '')",
                            Statement.RETURN_GENERATED_KEYS)) {
                        ps.executeUpdate();
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (!rs.next()) throw new SQLException("Không tạo được địa chỉ.");
                            addressId = rs.getInt(1);
                        }
                    }
                    try (PreparedStatement ps = con.prepareStatement(
                            "INSERT INTO tblMember9(userName, password, createdAt, status, role, address) "
                                    + "VALUES (?, ?, CURRENT_DATE, 'active', 'Manager', ?)")) {
                        ps.setString(1, args[0].trim());
                        ps.setString(2, hash);
                        ps.setInt(3, addressId);
                        ps.executeUpdate();
                    }
                    con.commit();
                    System.out.println("Đã tạo tài khoản quản lý. Bạn có thể đăng nhập tại /login.");
                } catch (Exception e) {
                    con.rollback();
                    throw e;
                }
            }
        } finally {
            if (password != null) Arrays.fill(password, '\0');
            if (confirm != null) Arrays.fill(confirm, '\0');
        }
    }
}
