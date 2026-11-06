package com.example.dao;

import com.example.model.Fullname9;
import com.example.model.Address9;
import com.example.model.ImportDetail9;
import com.example.model.ImportInvoice9;
import com.example.model.Material9;
import com.example.model.Supplier9;
import com.example.model.WarehouseStaff9;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/** Truy vấn phiếu nhập phục vụ màn hình thống kê nhà cung cấp. */
public class ImportInvoiceDAO9 extends DAO {

    public List<ImportInvoice9> getListImport(Date start, Date end, int supplierId) throws Exception {
        String sql = baseInvoiceSql() + " WHERE ii.createdAt >= ? AND ii.createdAt < ? AND ii.supplierId = ? "
                + "ORDER BY ii.createdAt DESC, ii.id DESC";
        List<ImportInvoice9> result = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, start);
            ps.setDate(2, Date.valueOf(end.toLocalDate().plusDays(1)));
            ps.setInt(3, supplierId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(toInvoice(rs, Collections.emptyList()));
                }
            }
        }
        return result;
    }

    public ImportInvoice9 getById(int invoiceId) throws Exception {
        String sql = baseInvoiceSql() + " WHERE ii.id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ImportInvoice9 invoice = toInvoice(rs, new ArrayList<>());
                    // DAO tạo phiếu trước, sau đó đóng gói từng chi tiết và gắn vào phiếu.
                    invoice.getListImport().addAll(findDetails(con, invoiceId));
                    return invoice;
                }
            }
        }
        return null;
    }

    private String baseInvoiceSql() {
        return "SELECT ii.id AS invoiceId, ii.total, ii.createdAt, ii.note, "
                + "m.id AS staffId, m.userName, m.status AS staffStatus, m.role, "
                + "m.firstName, m.lastName, s.id AS supplierId, s.name AS supplierName, "
                + "s.phone AS supplierPhone, s.email AS supplierEmail, "
                + "s.description AS supplierDescription, a.id AS addressId, a.houseNumber, a.street, a.ward, a.city "
                + "FROM tblImportInvoice9 ii "
                + "JOIN tblMember9 m ON m.id = ii.staffId "
                + "JOIN tblSupplier9 s ON s.id = ii.supplierId "
                + "LEFT JOIN tblAddress9 a ON a.id = s.address ";
    }

    private ImportInvoice9 toInvoice(ResultSet rs, List<ImportDetail9> details) throws Exception {
        Fullname9 fullname = new Fullname9(0, rs.getString("firstName"), rs.getString("lastName"));
        WarehouseStaff9 staff = new WarehouseStaff9(rs.getInt("staffId"), rs.getString("userName"),
                null, null, null, null, null, null, fullname, null,
                rs.getString("staffStatus"), rs.getString("role"));
        Supplier9 supplier = new Supplier9(rs.getInt("supplierId"), rs.getString("supplierName"),
                rs.getString("supplierPhone"), rs.getString("supplierEmail"),
                rs.getString("supplierDescription"), rs.getObject("addressId") == null ? null
                        : new Address9(rs.getInt("addressId"), rs.getString("houseNumber"),
                                rs.getString("street"), rs.getString("ward"), rs.getString("city")));
        return new ImportInvoice9(rs.getInt("invoiceId"), rs.getDouble("total"),
                rs.getDate("createdAt"), rs.getString("note"), staff, supplier, details);
    }

    private List<ImportDetail9> findDetails(Connection con, int invoiceId) throws Exception {
        String sql = "SELECT d.id, d.price, d.qty, m.id AS materialId, m.name, m.unit, "
                + "m.description, m.stock FROM tblImportDetail9 d "
                + "JOIN tblMaterial9 m ON m.id = d.materialId WHERE d.invoiceId = ? ORDER BY d.id";
        List<ImportDetail9> result = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Material9 material = new Material9(rs.getInt("materialId"), rs.getString("name"),
                            rs.getString("unit"), rs.getString("description"), rs.getInt("stock"));
                    result.add(new ImportDetail9(rs.getInt("id"), rs.getDouble("price"),
                            rs.getInt("qty"), material));
                }
            }
        }
        return result;
    }
}
