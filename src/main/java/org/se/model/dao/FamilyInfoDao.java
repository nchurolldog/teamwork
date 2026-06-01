package org.se.model.dao;

import org.se.model.entity.FamilyInfo;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FamilyInfoDao {

    public boolean insert(FamilyInfo familyInfo) {
        String sql = "INSERT INTO family_info (student_id, home_address, family_size, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, familyInfo.getStudentID());
            pstmt.setString(2, familyInfo.getHomeAddress());
            pstmt.setInt(3, familyInfo.getFamilySize());
            pstmt.setString(4, familyInfo.getPhone());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(FamilyInfo familyInfo) {
        String sql = "UPDATE family_info SET home_address = ?, family_size = ?, phone = ? WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, familyInfo.getHomeAddress());
            pstmt.setInt(2, familyInfo.getFamilySize());
            pstmt.setString(3, familyInfo.getPhone());
            pstmt.setString(4, familyInfo.getStudentID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String studentID) {
        String sql = "DELETE FROM family_info WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public FamilyInfo findById(String studentID) {
        String sql = "SELECT * FROM family_info WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    FamilyInfo familyInfo = new FamilyInfo();
                    familyInfo.setStudentID(rs.getString("student_id"));
                    familyInfo.setHomeAddress(rs.getString("home_address"));
                    familyInfo.setFamilySize(rs.getInt("family_size"));
                    familyInfo.setPhone(rs.getString("phone"));
                    return familyInfo;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<FamilyInfo> findAll() {
        String sql = "SELECT * FROM family_info";
        List<FamilyInfo> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                FamilyInfo familyInfo = new FamilyInfo();
                familyInfo.setStudentID(rs.getString("student_id"));
                familyInfo.setHomeAddress(rs.getString("home_address"));
                familyInfo.setFamilySize(rs.getInt("family_size"));
                familyInfo.setPhone(rs.getString("phone"));
                list.add(familyInfo);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}