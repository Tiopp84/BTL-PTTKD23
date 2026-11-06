package com.example.dao;

import com.example.model.Fullname9;
import com.example.model.Manager9;
import com.example.util.PasswordHash9;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class MemberDAO9 extends DAO {
    /** Chỉ cho phép tài khoản Manager đang active vào module quản lý. */
    public Manager9 authenticateManager(String username, char[] password) throws Exception {
        String sql = "SELECT id, userName, password, status, role, firstName, lastName "
                + "FROM tblMember9 WHERE userName = ? LIMIT 2";
        try (Connection con = getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                String stored = rs.getString("password");
                Manager9 manager = new Manager9(rs.getInt("id"), rs.getString("userName"),
                        null, null, null, null, null, null,
                        new Fullname9(0, rs.getString("firstName"), rs.getString("lastName")),
                        null, rs.getString("status"), rs.getString("role"));
                // Không chấp nhận username trùng hoặc mật khẩu thuần từ bản demo cũ.
                if (rs.next() || !PasswordHash9.verify(password, stored)
                        || !"Manager".equalsIgnoreCase(manager.getRole())
                        || !"active".equalsIgnoreCase(manager.getStatus())) return null;
                return manager;
            }
        }
    }
}
