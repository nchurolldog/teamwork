package org.se.model.dao;

import org.se.model.entity.ScholarshipApplication;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ScholarshipApplicationDao {

    public boolean insert(ScholarshipApplication application) {
        String sql = "INSERT INTO scholarship_application (app_id, student_id, type_code, amount, reason, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, application.getAppID());
            pstmt.setString(2, application.getStudentID());
            pstmt.setString(3, application.getTypeCode());
            pstmt.setBigDecimal(4, application.getAmount());
            pstmt.setString(5, application.getReason());
            pstmt.setString(6, application.getStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ScholarshipApplication application) {
        String sql = "UPDATE scholarship_application SET student_id = ?, type_code = ?, amount = ?, reason = ?, status = ? WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, application.getStudentID());
            pstmt.setString(2, application.getTypeCode());
            pstmt.setBigDecimal(3, application.getAmount());
            pstmt.setString(4, application.getReason());
            pstmt.setString(5, application.getStatus());
            pstmt.setString(6, application.getAppID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String appID) {
        String sql = "DELETE FROM scholarship_application WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ScholarshipApplication findById(String appID) {
        String sql = "SELECT * FROM scholarship_application WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    ScholarshipApplication application = new ScholarshipApplication();
                    application.setAppID(rs.getString("app_id"));
                    application.setStudentID(rs.getString("student_id"));
                    application.setTypeCode(rs.getString("type_code"));
                    application.setAmount(rs.getBigDecimal("amount"));
                    application.setReason(rs.getString("reason"));
                    application.setStatus(rs.getString("status"));
                    return application;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<ScholarshipApplication> findAll() {
        String sql = "SELECT * FROM scholarship_application";
        List<ScholarshipApplication> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                ScholarshipApplication application = new ScholarshipApplication();
                application.setAppID(rs.getString("app_id"));
                application.setStudentID(rs.getString("student_id"));
                application.setTypeCode(rs.getString("type_code"));
                application.setAmount(rs.getBigDecimal("amount"));
                application.setReason(rs.getString("reason"));
                application.setStatus(rs.getString("status"));
                list.add(application);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ScholarshipApplication> findByStudentID(String studentID) {
        String sql = "SELECT * FROM scholarship_application WHERE student_id = ?";
        List<ScholarshipApplication> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ScholarshipApplication application = new ScholarshipApplication();
                    application.setAppID(rs.getString("app_id"));
                    application.setStudentID(rs.getString("student_id"));
                    application.setTypeCode(rs.getString("type_code"));
                    application.setAmount(rs.getBigDecimal("amount"));
                    application.setReason(rs.getString("reason"));
                    application.setStatus(rs.getString("status"));
                    list.add(application);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ScholarshipApplication> findByTypeCode(String typeCode) {
        String sql = "SELECT * FROM scholarship_application WHERE type_code = ?";
        List<ScholarshipApplication> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, typeCode);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ScholarshipApplication application = new ScholarshipApplication();
                    application.setAppID(rs.getString("app_id"));
                    application.setStudentID(rs.getString("student_id"));
                    application.setTypeCode(rs.getString("type_code"));
                    application.setAmount(rs.getBigDecimal("amount"));
                    application.setReason(rs.getString("reason"));
                    application.setStatus(rs.getString("status"));
                    list.add(application);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
