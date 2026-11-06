package com.example.servlet;

import com.example.dao.MemberDAO9;
import com.example.model.Manager9;
import java.io.IOException;
import java.util.Arrays;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet9 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        resp.setHeader("Cache-Control", "no-store");
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("manager") instanceof Manager9) {
            resp.sendRedirect(req.getContextPath() + "/manager/ManagerHomeView9.jsp");
            return;
        }
        req.getRequestDispatcher("/LoginView9.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        String username = req.getParameter("username");
        String rawPassword = req.getParameter("password");
        req.setAttribute("username", username);
        if (username == null || username.isBlank() || username.length() > 255
                || rawPassword == null || rawPassword.isEmpty() || rawPassword.length() > 1024) {
            req.setAttribute("message", "Vui lòng nhập tên đăng nhập và mật khẩu hợp lệ.");
            req.getRequestDispatcher("/LoginView9.jsp").forward(req, resp);
            return;
        }
        char[] password = rawPassword.toCharArray();
        try {
            Manager9 manager = new MemberDAO9().authenticateManager(username.trim(), password);
            if (manager == null) {
                req.setAttribute("message", "Tên đăng nhập hoặc mật khẩu không đúng, hoặc tài khoản không có quyền quản lý.");
                req.getRequestDispatcher("/LoginView9.jsp").forward(req, resp);
                return;
            }
            HttpSession oldSession = req.getSession(false);
            if (oldSession != null) oldSession.invalidate();
            HttpSession session = req.getSession(true);
            session.setMaxInactiveInterval(30 * 60);
            session.setAttribute("manager", manager);
            session.setAttribute("managerUsername", manager.getUserName());
            session.setAttribute("logoutToken", UUID.randomUUID().toString());
            resp.sendRedirect(req.getContextPath() + "/manager/ManagerHomeView9.jsp");
        } catch (Exception e) {
            log("Không thể xác thực tài khoản quản lý", e);
            req.setAttribute("message", "Không thể đăng nhập lúc này. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/LoginView9.jsp").forward(req, resp);
        } finally {
            Arrays.fill(password, '\0');
        }
    }
}
