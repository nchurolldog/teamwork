package org.se.model.dao;

import org.se.model.entity.ScholarshipType;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ScholarshipTypeDao {

    public boolean insert(ScholarshipType type) {
        String sql = "INSERT INTO scholarship_type (type_code, description) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, type.getTypeCode());
            pstmt.setString(2, type.getDescription());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ScholarshipType type) {
        String sql = "UPDATE scholarship_type SET description = ? WHERE type_code = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, type.getDescription());
            pstmt.setString(2, type.getTypeCode());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String typeCode) {
        String sql = "DELETE FROM scholarship_type WHERE type_code = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, typeCode);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ScholarshipType findById(String typeCode) {
        String sql = "SELECT * FROM scholarship_type WHERE type_code = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, typeCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ScholarshipType type = new ScholarshipType();
                    type.setTypeCode(rs.getString("type_code"));
                    type.setDescription(rs.getString("description"));
                    return type;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ScholarshipType> findAll() {
        String sql = "SELECT * FROM scholarship_type";
        List<ScholarshipType> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                ScholarshipType type = new ScholarshipType();
                type.setTypeCode(rs.getString("type_code"));
                type.setDescription(rs.getString("description"));
                list.add(type);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ScholarshipType> findByDescriptionContaining(String keyword) {
        String sql = "SELECT * FROM scholarship_type WHERE description LIKE ?";
        List<ScholarshipType> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + keyword + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ScholarshipType type = new ScholarshipType();
                    type.setTypeCode(rs.getString("type_code"));
                    type.setDescription(rs.getString("description"));
                    list.add(type);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}