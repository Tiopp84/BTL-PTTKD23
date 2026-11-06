package com.example.dao;

import com.example.model.Combo9;
import com.example.model.ComboDetail9;
import com.example.model.Dish9;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

// Theo UML: ComboDAO9() + search(keyword:String): Combo9[]
// Dùng List<Combo9> thay cho mảng [] cho tiện JSP/Servlet
public class ComboDAO9 extends DAO {

    public ComboDAO9() {
    }

    public List<Combo9> search(String keyword) throws Exception {
        String sql = "SELECT id, name, description, imageUrl, price FROM tblCombo9 "
            + "WHERE name LIKE ? ORDER BY name, id";
        List<Combo9> list = new ArrayList<>();
        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int id = rs.getInt("id");
                    Combo9 c = new Combo9(id, rs.getString("name"),
                        rs.getString("description"), rs.getString("imageUrl"),
                        rs.getDouble("price"), java.util.Collections.emptyList());
                    list.add(c);
                }
            }
        }
        return list;
    }

    /** Lấy Combo cùng danh sách món thành phần để hiển thị trang chi tiết. */
    public Combo9 getComboById(int id) throws Exception {
        String sql = "SELECT id, name, description, imageUrl, price FROM tblCombo9 WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                int comboId = rs.getInt("id");
                return new Combo9(comboId, rs.getString("name"),
                    rs.getString("description"), rs.getString("imageUrl"),
                    rs.getDouble("price"), findDetails(con, comboId));
            }
        }
    }

    private List<ComboDetail9> findDetails(Connection con, int comboId) throws Exception {
        String sql = "SELECT cd.id, cd.qty, d.id AS did, d.name, d.unit, "
            + "d.description, d.imageUrl, d.price "
            + "FROM tblComboDetail9 cd JOIN tblDish9 d ON cd.dishId=d.id "
            + "WHERE cd.comboId=?";
        List<ComboDetail9> list = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, comboId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Dish9 d = new Dish9(rs.getInt("did"), rs.getString("name"),
                        rs.getString("unit"), rs.getString("description"),
                        rs.getString("imageUrl"), rs.getDouble("price"));
                    list.add(new ComboDetail9(rs.getInt("id"), rs.getInt("qty"), d));
                }
            }
        }
        return list;
    }
}
