package org.se.model.dao;

import org.se.model.entity.CounselorApproval;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CounselorApprovalDao {

    public boolean insert(CounselorApproval approval) {
        String sql = "INSERT INTO counselor_approval (app_id, employee_id, result) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, approval.getAppID());
            pstmt.setString(2, approval.getEmployeeID());
            pstmt.setBoolean(3, Boolean.TRUE.equals(approval.getResult()));
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(CounselorApproval approval) {
        String sql = "UPDATE counselor_approval SET employee_id = ?, result = ? WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, approval.getEmployeeID());
            pstmt.setBoolean(2, Boolean.TRUE.equals(approval.getResult()));
            pstmt.setString(3, approval.getAppID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String appID) {
        String sql = "DELETE FROM counselor_approval WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public CounselorApproval findById(String appID) {
        String sql = "SELECT * FROM counselor_approval WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    CounselorApproval approval = new CounselorApproval();
                    approval.setAppID(rs.getString("app_id"));
                    approval.setEmployeeID(rs.getString("employee_id"));
                    approval.setResult(rs.getBoolean("result"));
                    return approval;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CounselorApproval> findAll() {
        String sql = "SELECT * FROM counselor_approval";
        List<CounselorApproval> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                CounselorApproval approval = new CounselorApproval();
                approval.setAppID(rs.getString("app_id"));
                approval.setEmployeeID(rs.getString("employee_id"));
                approval.setResult(rs.getBoolean("result"));
                list.add(approval);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CounselorApproval> findByEmployeeID(String employeeID) {
        String sql = "SELECT * FROM counselor_approval WHERE employee_id = ?";
        List<CounselorApproval> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, employeeID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    CounselorApproval approval = new CounselorApproval();
                    approval.setAppID(rs.getString("app_id"));
                    approval.setEmployeeID(rs.getString("employee_id"));
                    approval.setResult(rs.getBoolean("result"));
                    list.add(approval);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
