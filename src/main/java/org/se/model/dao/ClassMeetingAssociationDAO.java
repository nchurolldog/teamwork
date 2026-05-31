package org.se.model.dao;

import org.se.model.entity.ClassMeetingAssociation;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClassMeetingAssociationDAO {

    public boolean insert(ClassMeetingAssociation association) {
        String sql = "INSERT INTO ClassMeetingAssociation (meetingID, studentID) VALUES (?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, association.getMeetingID());
            pstmt.setString(2, association.getStudentID());

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

    public boolean delete(String meetingID, String studentID) {
        String sql = "DELETE FROM ClassMeetingAssociation WHERE meetingID = ? AND studentID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);
            pstmt.setString(2, studentID);

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

    public ClassMeetingAssociation findById(String meetingID, String studentID) {
        String sql = "SELECT * FROM ClassMeetingAssociation WHERE meetingID = ? AND studentID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);
            pstmt.setString(2, studentID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                ClassMeetingAssociation association = new ClassMeetingAssociation();
                association.setMeetingID(rs.getString("meetingID"));
                association.setStudentID(rs.getString("studentID"));
                return association;
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

    public List<ClassMeetingAssociation> findByMeetingId(String meetingID) {
        String sql = "SELECT * FROM ClassMeetingAssociation WHERE meetingID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);
            rs = pstmt.executeQuery();

            List<ClassMeetingAssociation> list = new ArrayList<>();
            while (rs.next()) {
                ClassMeetingAssociation association = new ClassMeetingAssociation();
                association.setMeetingID(rs.getString("meetingID"));
                association.setStudentID(rs.getString("studentID"));
                list.add(association);
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

    public List<ClassMeetingAssociation> findByStudentId(String studentID) {
        String sql = "SELECT * FROM ClassMeetingAssociation WHERE studentID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();

            List<ClassMeetingAssociation> list = new ArrayList<>();
            while (rs.next()) {
                ClassMeetingAssociation association = new ClassMeetingAssociation();
                association.setMeetingID(rs.getString("meetingID"));
                association.setStudentID(rs.getString("studentID"));
                list.add(association);
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

    public boolean deleteByMeetingId(String meetingID) {
        String sql = "DELETE FROM ClassMeetingAssociation WHERE meetingID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);

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

    public boolean exists(String meetingID, String studentID) {
        String sql = "SELECT COUNT(*) FROM ClassMeetingAssociation WHERE meetingID = ? AND studentID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);
            pstmt.setString(2, studentID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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
