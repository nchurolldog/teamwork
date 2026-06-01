package org.se.model.dao;

import org.se.model.entity.ScholarshipApplicationDetail;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ScholarshipApplicationDetailDao {

    public boolean insert(ScholarshipApplicationDetail detail) {
        String sql = "INSERT INTO scholarship_application_detail " +
                "(app_id, requested_amount, family_situation, academic_score, conduct_evaluation, honors, application_reason, supporting_materials, promise) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            fillStatement(pstmt, detail);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ScholarshipApplicationDetail detail) {
        String sql = "UPDATE scholarship_application_detail SET requested_amount = ?, family_situation = ?, academic_score = ?, " +
                "conduct_evaluation = ?, honors = ?, application_reason = ?, supporting_materials = ?, promise = ? WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBigDecimal(1, detail.getRequestedAmount());
            pstmt.setString(2, detail.getFamilySituation());
            pstmt.setString(3, detail.getAcademicScore());
            pstmt.setString(4, detail.getConductEvaluation());
            pstmt.setString(5, detail.getHonors());
            pstmt.setString(6, detail.getApplicationReason());
            pstmt.setString(7, detail.getSupportingMaterials());
            pstmt.setObject(8, detail.getPromise());
            pstmt.setString(9, detail.getAppID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean saveOrUpdate(ScholarshipApplicationDetail detail) {
        return findById(detail.getAppID()) == null ? insert(detail) : update(detail);
    }

    public ScholarshipApplicationDetail findById(String appID) {
        String sql = "SELECT * FROM scholarship_application_detail WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean delete(String appID) {
        String sql = "DELETE FROM scholarship_application_detail WHERE app_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, appID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void fillStatement(PreparedStatement pstmt, ScholarshipApplicationDetail detail) throws SQLException {
        pstmt.setString(1, detail.getAppID());
        pstmt.setBigDecimal(2, detail.getRequestedAmount());
        pstmt.setString(3, detail.getFamilySituation());
        pstmt.setString(4, detail.getAcademicScore());
        pstmt.setString(5, detail.getConductEvaluation());
        pstmt.setString(6, detail.getHonors());
        pstmt.setString(7, detail.getApplicationReason());
        pstmt.setString(8, detail.getSupportingMaterials());
        pstmt.setObject(9, detail.getPromise());
    }

    private ScholarshipApplicationDetail mapRow(ResultSet rs) throws SQLException {
        ScholarshipApplicationDetail detail = new ScholarshipApplicationDetail();
        detail.setAppID(rs.getString("app_id"));
        detail.setRequestedAmount(rs.getBigDecimal("requested_amount"));
        detail.setFamilySituation(rs.getString("family_situation"));
        detail.setAcademicScore(rs.getString("academic_score"));
        detail.setConductEvaluation(rs.getString("conduct_evaluation"));
        detail.setHonors(rs.getString("honors"));
        detail.setApplicationReason(rs.getString("application_reason"));
        detail.setSupportingMaterials(rs.getString("supporting_materials"));
        detail.setPromise((Boolean) rs.getObject("promise"));
        return detail;
    }
}
