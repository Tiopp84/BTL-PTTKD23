package com.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// 100% đọc từ .env / env thật, không còn hằng hardcode.
// Keys bắt buộc: DB_URL, DB_USER, DB_PASSWORD (xem .env.example)
public class DBConnection {

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Missing MySQL driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        String url = EnvConfig.getRequired("DB_URL");
        String user = EnvConfig.getRequired("DB_USER");
        String pass = EnvConfig.getRequired("DB_PASSWORD");
        return DriverManager.getConnection(url, user, pass);
    }

    public static void main(String[] args) {
        try (Connection c = getConnection()) {
            System.out.println("Connect OK: " + c.getMetaData().getDatabaseProductVersion());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
