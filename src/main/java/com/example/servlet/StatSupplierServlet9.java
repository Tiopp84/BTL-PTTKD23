package com.example.servlet;

import com.example.dao.ImportInvoiceDAO9;
import com.example.dao.SupplierStatisticDAO9;
import com.example.model.ImportInvoice9;
import java.sql.Date;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collections;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/stat-supplier"})
public class StatSupplierServlet9 extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String view = "/manager/statistic/SupplierStatisticView9.jsp";
        req.setAttribute("listSupplierStat", Collections.emptyList());
        req.setAttribute("listInvoice", Collections.emptyList());

        try {
            if (action == null || action.isBlank()) {
                // Mở form lần đầu hoặc Reset: chưa truy vấn dữ liệu.
            } else if ("stat".equals(action)) {
                Date[] range = readRange(req);
                req.setAttribute("listSupplierStat", createStatisticDAO().getStat(range[0], range[1]));
                req.setAttribute("searched", true);
            } else if ("listImport".equals(action)) {
                view = "/manager/statistic/SupplierListImportView9.jsp";
                Date[] range = readRange(req);
                int supplierId = positiveId(req, "supplierId");
                req.setAttribute("listInvoice", createInvoiceDAO().getListImport(range[0], range[1], supplierId));
            } else if ("detail".equals(action)) {
                view = "/manager/statistic/SupplierImportDetailView9.jsp";
                int invoiceId = positiveId(req, "invoiceId");
                ImportInvoice9 invoice = createInvoiceDAO().getById(invoiceId);
                if (invoice == null) {
                    resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy phiếu nhập.");
                    return;
                }
                // Khi đi từ bảng thống kê, giữ bộ lọc để Back quay đúng danh sách.
                if (req.getParameter("start") != null || req.getParameter("end") != null
                        || req.getParameter("supplierId") != null) {
                    Date[] range = readRange(req);
                    int supplierId = positiveId(req, "supplierId");
                    LocalDate invoiceDate = invoice.getCreatedAt() instanceof Date
                            ? ((Date) invoice.getCreatedAt()).toLocalDate()
                            : invoice.getCreatedAt().toInstant()
                                    .atZone(java.time.ZoneId.systemDefault()).toLocalDate();
                    if (invoice.getSupplier().getId() != supplierId
                            || invoiceDate.isBefore(range[0].toLocalDate())
                            || invoiceDate.isAfter(range[1].toLocalDate())) {
                        resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Phiếu nhập không thuộc bộ lọc đã chọn.");
                        return;
                    }
                }
                req.setAttribute("invoice", invoice);
            } else {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Chức năng không hợp lệ.");
                return;
            }
        } catch (IllegalArgumentException | DateTimeParseException e) {
            if ("detail".equals(action)) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
                return;
            }
            req.setAttribute("message", "Vui lòng nhập đầy đủ khoảng ngày hợp lệ và nhà cung cấp hợp lệ.");
        } catch (Exception e) {
            log("Không thể tải dữ liệu thống kê nhà cung cấp", e);
            if ("detail".equals(action)) {
                resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tải dữ liệu. Vui lòng thử lại sau.");
                return;
            }
            req.setAttribute("message", "Không thể tải dữ liệu. Vui lòng thử lại sau.");
        }
        req.getRequestDispatcher(view).forward(req, resp);
    }

    private Date[] readRange(HttpServletRequest req) {
        String startValue = req.getParameter("start");
        String endValue = req.getParameter("end");
        if (startValue == null || startValue.isBlank() || endValue == null || endValue.isBlank()) {
            throw new IllegalArgumentException("Vui lòng nhập ngày bắt đầu và kết thúc.");
        }
        LocalDate start = LocalDate.parse(startValue);
        LocalDate end = LocalDate.parse(endValue);
        if (start.isAfter(end)) throw new IllegalArgumentException("Ngày bắt đầu phải trước hoặc bằng ngày kết thúc.");
        req.setAttribute("start", start.toString());
        req.setAttribute("end", end.toString());
        return new Date[] {Date.valueOf(start), Date.valueOf(end)};
    }

    private int positiveId(HttpServletRequest req, String name) {
        try {
            int id = Integer.parseInt(req.getParameter(name));
            if (id > 0) return id;
        } catch (NumberFormatException ignored) {
        }
        throw new IllegalArgumentException("Mã đối tượng không hợp lệ.");
    }

    protected SupplierStatisticDAO9 createStatisticDAO() { return new SupplierStatisticDAO9(); }

    protected ImportInvoiceDAO9 createInvoiceDAO() { return new ImportInvoiceDAO9(); }
}
