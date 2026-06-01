package org.se.model.dao;

import org.se.model.entity.DemocraticReviewParticipant;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DemocraticReviewParticipantDao {

    public boolean insert(DemocraticReviewParticipant participant) {
        String sql = "INSERT INTO democratic_review_participant (review_id, participant_student_id, access) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, participant.getReviewID());
            pstmt.setString(2, participant.getParticipantStudentID());
            pstmt.setBoolean(3, Boolean.TRUE.equals(participant.getAccess()));
            
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

    public boolean update(DemocraticReviewParticipant participant) {
        String sql = "UPDATE democratic_review_participant SET access = ? WHERE review_id = ? AND participant_student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setBoolean(1, Boolean.TRUE.equals(participant.getAccess()));
            pstmt.setString(2, participant.getReviewID());
            pstmt.setString(3, participant.getParticipantStudentID());
            
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

    public boolean delete(String reviewID, String participantStudentID) {
        String sql = "DELETE FROM democratic_review_participant WHERE review_id = ? AND participant_student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reviewID);
            pstmt.setString(2, participantStudentID);
            
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

    public DemocraticReviewParticipant findById(String reviewID, String participantStudentID) {
        String sql = "SELECT * FROM democratic_review_participant WHERE review_id = ? AND participant_student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reviewID);
            pstmt.setString(2, participantStudentID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                DemocraticReviewParticipant participant = new DemocraticReviewParticipant();
                participant.setReviewID(rs.getString("review_id"));
                participant.setParticipantStudentID(rs.getString("participant_student_id"));
                participant.setAccess(rs.getBoolean("access"));
                return participant;
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

    public List<DemocraticReviewParticipant> findByReviewId(String reviewID) {
        String sql = "SELECT * FROM democratic_review_participant WHERE review_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reviewID);
            rs = pstmt.executeQuery();
            
            List<DemocraticReviewParticipant> list = new ArrayList<>();
            while (rs.next()) {
                DemocraticReviewParticipant participant = new DemocraticReviewParticipant();
                participant.setReviewID(rs.getString("review_id"));
                participant.setParticipantStudentID(rs.getString("participant_student_id"));
                participant.setAccess(rs.getBoolean("access"));
                list.add(participant);
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

    public List<DemocraticReviewParticipant> findByStudentId(String studentID) {
        String sql = "SELECT * FROM democratic_review_participant WHERE participant_student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();
            
            List<DemocraticReviewParticipant> list = new ArrayList<>();
            while (rs.next()) {
                DemocraticReviewParticipant participant = new DemocraticReviewParticipant();
                participant.setReviewID(rs.getString("review_id"));
                participant.setParticipantStudentID(rs.getString("participant_student_id"));
                participant.setAccess(rs.getBoolean("access"));
                list.add(participant);
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

    public boolean deleteByReviewId(String reviewID) {
        String sql = "DELETE FROM democratic_review_participant WHERE review_id = ?";
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
}
