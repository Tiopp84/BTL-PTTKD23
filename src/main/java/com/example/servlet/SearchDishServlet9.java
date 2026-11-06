package com.example.servlet;

import com.example.dao.ComboDAO9;
import com.example.dao.DishDAO9;
import com.example.model.Combo9;
import com.example.model.Dish9;
import java.io.IOException;
import java.util.Collections;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/customer/search-dish"})
public class SearchDishServlet9 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        String itemId = req.getParameter("id");
        if (itemId == null) itemId = req.getParameter("itemId"); // Liên kết cũ.
        if ("detail".equals(action) || itemId != null) {
            final int id;
            try {
                id = Integer.parseInt(itemId);
                if (id <= 0) {
                    throw new NumberFormatException();
                }
            } catch (NumberFormatException e) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã món ăn không hợp lệ.");
                return;
            }

            try {
                String itemType = req.getParameter("type");
                if (itemType == null) itemType = req.getParameter("itemType");
                if ("combo".equals(itemType)) {
                    Combo9 combo = createComboDAO().getComboById(id);
                    if (combo == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy Combo.");
                        return;
                    }
                    req.setAttribute("combo", combo);
                } else if ("dish".equals(itemType)) {
                    Dish9 dish = createDishDAO().getDishById(id);
                    if (dish == null) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy món ăn.");
                        return;
                    }
                    req.setAttribute("dish", dish);
                } else {
                    resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Loại món ăn không hợp lệ.");
                    return;
                }
                req.getRequestDispatcher("/customer/ItemDetailView9.jsp").forward(req, resp);
            } catch (Exception e) {
                log("Không thể tải chi tiết món ăn", e);
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Không thể tải dữ liệu. Vui lòng thử lại sau.");
            }
            return;
        }

        String keyword = req.getParameter("keyword");
        // Lần đầu mở trang chỉ hiện form; chỉ tìm khi form đã được gửi.
        if (keyword == null) {
            req.setAttribute("listDish", Collections.emptyList());
            req.setAttribute("listCombo", Collections.emptyList());
        } else if (keyword.trim().isEmpty()) {
            req.setAttribute("listDish", Collections.emptyList());
            req.setAttribute("listCombo", Collections.emptyList());
            req.setAttribute("message", "Vui lòng nhập từ khóa cần tìm.");
        } else {
            try {
                req.setAttribute("listDish", createDishDAO().search(keyword));
                req.setAttribute("listCombo", createComboDAO().search(keyword));
                req.setAttribute("searched", true);
            } catch (Exception e) {
                log("Không thể tìm kiếm món ăn", e);
                req.setAttribute("listDish", Collections.emptyList());
                req.setAttribute("listCombo", Collections.emptyList());
                req.setAttribute("message", "Không thể tải dữ liệu. Vui lòng thử lại sau.");
            }
        }
        req.getRequestDispatcher("/customer/SearchDishView9.jsp").forward(req, resp);
    }

    protected DishDAO9 createDishDAO() { return new DishDAO9(); }

    protected ComboDAO9 createComboDAO() { return new ComboDAO9(); }
}
