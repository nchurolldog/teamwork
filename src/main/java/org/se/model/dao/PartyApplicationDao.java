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
        String sql = "INSERT INTO PartyApplication (ApplicationID, ApplicantStudentID, Reason, Status) VALUES (?, ?, ?, ?)";
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
        String sql = "UPDATE PartyApplication SET ApplicantStudentID = ?, Reason = ?, Status = ? WHERE ApplicationID = ?";
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
        String sql = "DELETE FROM PartyApplication WHERE ApplicationID = ?";
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
        String sql = "SELECT * FROM PartyApplication WHERE ApplicationID = ?";
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
                partyApplication.setApplicationID(rs.getString("ApplicationID"));
                partyApplication.setApplicantStudentID(rs.getString("ApplicantStudentID"));
                partyApplication.setReason(rs.getString("Reason"));
                partyApplication.setStatus(rs.getString("Status"));
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
        String sql = "SELECT * FROM PartyApplication";
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
                partyApplication.setApplicationID(rs.getString("ApplicationID"));
                partyApplication.setApplicantStudentID(rs.getString("ApplicantStudentID"));
                partyApplication.setReason(rs.getString("Reason"));
                partyApplication.setStatus(rs.getString("Status"));
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
        String sql = "SELECT * FROM PartyApplication WHERE ApplicantStudentID = ?";
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
                partyApplication.setApplicationID(rs.getString("ApplicationID"));
                partyApplication.setApplicantStudentID(rs.getString("ApplicantStudentID"));
                partyApplication.setReason(rs.getString("Reason"));
                partyApplication.setStatus(rs.getString("Status"));
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
        String sql = "SELECT * FROM PartyApplication WHERE Status = ?";
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
                partyApplication.setApplicationID(rs.getString("ApplicationID"));
                partyApplication.setApplicantStudentID(rs.getString("ApplicantStudentID"));
                partyApplication.setReason(rs.getString("Reason"));
                partyApplication.setStatus(rs.getString("Status"));
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
