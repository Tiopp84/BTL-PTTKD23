package com.example.dao;

import com.example.util.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

// Lớp cha duy nhất cho mọi DAO (đã gộp BaseDAO vào đây).
// Stateless: mỗi câu lệnh mở connection mới qua try-with-resources,
// an toàn đa luồng cho Servlet (không giữ conn trong field như bản UML cũ).
public abstract class DAO {
    // private Connection conn;
    protected Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }

    protected void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }

    // Helper set tham số chống SQL injection
    protected void setParams(PreparedStatement ps, Object... params) throws Exception {
        for (int i = 0; i < params.length; i++) {
            ps.setObject(i + 1, params[i]);
        }
    }

    // Đếm dòng tiện dùng cho test
    protected int count(String sql, Object... params) throws Exception {
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            setParams(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }
}
