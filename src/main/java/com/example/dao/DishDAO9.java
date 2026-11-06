package com.example.dao;

import com.example.model.Dish9;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

// Theo UML: DishDAO9() + search(keyword:String)
// Sơ đồ ghi trả Dish9 số ít, thực tế search ra nhiều dòng nên trả List<Dish9>
public class DishDAO9 extends DAO {

    public DishDAO9() {
    }

    public List<Dish9> search(String keyword) throws Exception {
        String sql = "SELECT id, name, unit, description, imageUrl, price FROM tblDish9 "
            + "WHERE name LIKE ? ORDER BY name, id";
        List<Dish9> list = new ArrayList<>();
        String kw = "%" + (keyword == null ? "" : keyword.trim()) + "%";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            setParams(ps, kw);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Dish9(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("unit"),
                        rs.getString("description"),
                        rs.getString("imageUrl"),
                        rs.getDouble("price")
                    ));
                }
            }
        }
        return list;
    }

    /** Lấy một món ăn để hiển thị trang chi tiết. */
    public Dish9 getDishById(int id) throws Exception {
        String sql = "SELECT id, name, unit, description, imageUrl, price "
            + "FROM tblDish9 WHERE id = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Dish9(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("unit"),
                        rs.getString("description"),
                        rs.getString("imageUrl"),
                        rs.getDouble("price")
                    );
                }
            }
        }
        return null;
    }
    
}
