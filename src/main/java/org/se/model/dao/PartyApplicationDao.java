package org.se.model.dao;

import org.se.model.entity.PartyApplication;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PartyApplicationDao {

    public boolean insert(PartyApplication partyApplication) {
        String sql = "INSERT INTO party_application (application_id, applicant_student_id, reason, status) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, partyApplication.getApplicationID());
            pstmt.setString(2, partyApplication.getApplicantStudentID());
            pstmt.setString(3, partyApplication.getReason());
            pstmt.setString(4, partyApplication.getStatus());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean update(PartyApplication partyApplication) {
        String sql = "UPDATE party_application SET applicant_student_id = ?, reason = ?, status = ? WHERE application_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, partyApplication.getApplicantStudentID());
            pstmt.setString(2, partyApplication.getReason());
            pstmt.setString(3, partyApplication.getStatus());
            pstmt.setString(4, partyApplication.getApplicationID());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public boolean delete(String applicationID) {
        String sql = "DELETE FROM party_application WHERE application_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, applicationID);
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public PartyApplication findById(String applicationID) {
        String sql = "SELECT * FROM party_application WHERE application_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, applicationID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                PartyApplication partyApplication = new PartyApplication();
                partyApplication.setApplicationID(rs.getString("application_id"));
                partyApplication.setApplicantStudentID(rs.getString("applicant_student_id"));
                partyApplication.setReason(rs.getString("reason"));
                partyApplication.setStatus(rs.getString("status"));
                return partyApplication;
            }
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<PartyApplication> findAll() {
        String sql = "SELECT * FROM party_application";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            List<PartyApplication> list = new ArrayList<>();
            while (rs.next()) {
                PartyApplication partyApplication = new PartyApplication();
                partyApplication.setApplicationID(rs.getString("application_id"));
                partyApplication.setApplicantStudentID(rs.getString("applicant_student_id"));
                partyApplication.setReason(rs.getString("reason"));
                partyApplication.setStatus(rs.getString("status"));
                list.add(partyApplication);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<PartyApplication> findByStudentId(String studentID) {
        String sql = "SELECT * FROM party_application WHERE applicant_student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();
            
            List<PartyApplication> list = new ArrayList<>();
            while (rs.next()) {
                PartyApplication partyApplication = new PartyApplication();
                partyApplication.setApplicationID(rs.getString("application_id"));
                partyApplication.setApplicantStudentID(rs.getString("applicant_student_id"));
                partyApplication.setReason(rs.getString("reason"));
                partyApplication.setStatus(rs.getString("status"));
                list.add(partyApplication);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public List<PartyApplication> findByStatus(String status) {
        String sql = "SELECT * FROM party_application WHERE status = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            List<PartyApplication> list = new ArrayList<>();
            while (rs.next()) {
                PartyApplication partyApplication = new PartyApplication();
                partyApplication.setApplicationID(rs.getString("application_id"));
                partyApplication.setApplicantStudentID(rs.getString("applicant_student_id"));
                partyApplication.setReason(rs.getString("reason"));
                partyApplication.setStatus(rs.getString("status"));
                list.add(partyApplication);
            }
            return list;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
