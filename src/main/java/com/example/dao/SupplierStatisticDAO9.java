package com.example.dao;

import com.example.model.Address9;
import com.example.model.SupplierStatistic9;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/** Thống kê số lượng vật tư và tổng tiền nhập của từng nhà cung cấp. */
public class SupplierStatisticDAO9 extends DAO {

    public List<SupplierStatistic9> getStat(Date start, Date end) throws Exception {
        String sql = "SELECT s.id, s.name, s.phone, s.email, s.description, "
                + "a.id AS addressId, a.houseNumber, a.street, a.ward, a.city, "
                + "COALESCE(q.totalImport, 0) AS totalImport, "
                + "COALESCE(p.totalPayment, 0) AS totalPayment "
                + "FROM tblSupplier9 s "
                + "LEFT JOIN tblAddress9 a ON a.id = s.address "
                + "JOIN ( "
                + "  SELECT supplierId, SUM(total) AS totalPayment "
                + "  FROM tblImportInvoice9 WHERE createdAt >= ? AND createdAt < ? "
                + "  GROUP BY supplierId "
                + ") p ON p.supplierId = s.id "
                + "LEFT JOIN ( "
                + "  SELECT ii.supplierId, SUM(d.qty) AS totalImport "
                + "  FROM tblImportInvoice9 ii "
                + "  JOIN tblImportDetail9 d ON d.invoiceId = ii.id "
                + "  WHERE ii.createdAt >= ? AND createdAt < ? GROUP BY ii.supplierId "
                + ") q ON q.supplierId = s.id "
                + "ORDER BY totalImport DESC, totalPayment DESC, s.name";
        List<SupplierStatistic9> result = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setDate(1, start);
            ps.setDate(2, Date.valueOf(end.toLocalDate().plusDays(1)));
            ps.setDate(3, start);
            ps.setDate(4, Date.valueOf(end.toLocalDate().plusDays(1)));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Address9 address = new Address9(rs.getInt("addressId"),
                            rs.getString("houseNumber"), rs.getString("street"),
                            rs.getString("ward"), rs.getString("city"));
                    result.add(new SupplierStatistic9(rs.getInt("id"), rs.getString("name"),
                            rs.getString("phone"), rs.getString("email"),
                            rs.getString("description"), address,
                            rs.getInt("totalImport"), rs.getDouble("totalPayment")));
                }
            }
        }
        return result;
    }
}
