package org.se.model.dao;

import org.se.model.entity.DemocraticReview;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DemocraticReviewDao {

    public boolean insert(DemocraticReview democraticReview) {
        String sql = "INSERT INTO democratic_review (review_id, application_id, organizer_employee_id, status) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, democraticReview.getReviewID());
            pstmt.setString(2, democraticReview.getApplicationID());
            pstmt.setString(3, democraticReview.getOrganizerEmployeeID());
            pstmt.setString(4, democraticReview.getStatus());
            
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

    public boolean update(DemocraticReview democraticReview) {
        String sql = "UPDATE democratic_review SET application_id = ?, organizer_employee_id = ?, status = ? WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, democraticReview.getApplicationID());
            pstmt.setString(2, democraticReview.getOrganizerEmployeeID());
            pstmt.setString(3, democraticReview.getStatus());
            pstmt.setString(4, democraticReview.getReviewID());
            
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

    public boolean delete(String reviewID) {
        String sql = "DELETE FROM democratic_review WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reviewID);
            
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

    public DemocraticReview findById(String reviewID) {
        String sql = "SELECT * FROM democratic_review WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reviewID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                DemocraticReview democraticReview = new DemocraticReview();
                democraticReview.setReviewID(rs.getString("review_id"));
                democraticReview.setApplicationID(rs.getString("application_id"));
                democraticReview.setOrganizerEmployeeID(rs.getString("organizer_employee_id"));
                democraticReview.setStatus(rs.getString("status"));
                return democraticReview;
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

    public List<DemocraticReview> findAll() {
        String sql = "SELECT * FROM democratic_review";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            List<DemocraticReview> list = new ArrayList<>();
            while (rs.next()) {
                DemocraticReview democraticReview = new DemocraticReview();
                democraticReview.setReviewID(rs.getString("review_id"));
                democraticReview.setApplicationID(rs.getString("application_id"));
                democraticReview.setOrganizerEmployeeID(rs.getString("organizer_employee_id"));
                democraticReview.setStatus(rs.getString("status"));
                list.add(democraticReview);
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

    public List<DemocraticReview> findByApplicationId(String applicationID) {
        String sql = "SELECT * FROM democratic_review WHERE application_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, applicationID);
            rs = pstmt.executeQuery();
            
            List<DemocraticReview> list = new ArrayList<>();
            while (rs.next()) {
                DemocraticReview democraticReview = new DemocraticReview();
                democraticReview.setReviewID(rs.getString("review_id"));
                democraticReview.setApplicationID(rs.getString("application_id"));
                democraticReview.setOrganizerEmployeeID(rs.getString("organizer_employee_id"));
                democraticReview.setStatus(rs.getString("status"));
                list.add(democraticReview);
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

    public List<DemocraticReview> findByStatus(String status) {
        String sql = "SELECT * FROM democratic_review WHERE status = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            List<DemocraticReview> list = new ArrayList<>();
            while (rs.next()) {
                DemocraticReview democraticReview = new DemocraticReview();
                democraticReview.setReviewID(rs.getString("review_id"));
                democraticReview.setApplicationID(rs.getString("application_id"));
                democraticReview.setOrganizerEmployeeID(rs.getString("organizer_employee_id"));
                democraticReview.setStatus(rs.getString("status"));
                list.add(democraticReview);
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

    public List<DemocraticReview> findByOrganizerId(String organizerEmployeeID) {
        String sql = "SELECT * FROM democratic_review WHERE organizer_employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, organizerEmployeeID);
            rs = pstmt.executeQuery();
            
            List<DemocraticReview> list = new ArrayList<>();
            while (rs.next()) {
                DemocraticReview democraticReview = new DemocraticReview();
                democraticReview.setReviewID(rs.getString("review_id"));
                democraticReview.setApplicationID(rs.getString("application_id"));
                democraticReview.setOrganizerEmployeeID(rs.getString("organizer_employee_id"));
                democraticReview.setStatus(rs.getString("status"));
                list.add(democraticReview);
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
