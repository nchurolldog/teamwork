package org.se.model.dao;

import org.se.model.entity.AttendancePublish;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendancePublishDAO {

    public boolean insert(AttendancePublish attendancePublish) {
        String sql = "INSERT INTO AttendancePublish (recordID, meetingID, studentID) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, attendancePublish.getRecordID());
            pstmt.setString(2, attendancePublish.getMeetingID());
            pstmt.setString(3, attendancePublish.getStudentID());

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

    public boolean update(AttendancePublish attendancePublish) {
        String sql = "UPDATE AttendancePublish SET meetingID = ?, studentID = ? WHERE recordID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, attendancePublish.getMeetingID());
            pstmt.setString(2, attendancePublish.getStudentID());
            pstmt.setInt(3, attendancePublish.getRecordID());

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

    public boolean delete(int recordID) {
        String sql = "DELETE FROM AttendancePublish WHERE recordID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordID);

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

    public AttendancePublish findById(int recordID) {
        String sql = "SELECT * FROM AttendancePublish WHERE recordID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                AttendancePublish attendancePublish = new AttendancePublish();
                attendancePublish.setRecordID(rs.getInt("recordID"));
                attendancePublish.setMeetingID(rs.getString("meetingID"));
                attendancePublish.setStudentID(rs.getString("studentID"));
                return attendancePublish;
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

    public List<AttendancePublish> findByMeetingId(String meetingID) {
        String sql = "SELECT * FROM AttendancePublish WHERE meetingID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);
            rs = pstmt.executeQuery();

            List<AttendancePublish> list = new ArrayList<>();
            while (rs.next()) {
                AttendancePublish attendancePublish = new AttendancePublish();
                attendancePublish.setRecordID(rs.getInt("recordID"));
                attendancePublish.setMeetingID(rs.getString("meetingID"));
                attendancePublish.setStudentID(rs.getString("studentID"));
                list.add(attendancePublish);
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

    public List<AttendancePublish> findByStudentId(String studentID) {
        String sql = "SELECT * FROM AttendancePublish WHERE studentID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();

            List<AttendancePublish> list = new ArrayList<>();
            while (rs.next()) {
                AttendancePublish attendancePublish = new AttendancePublish();
                attendancePublish.setRecordID(rs.getInt("recordID"));
                attendancePublish.setMeetingID(rs.getString("meetingID"));
                attendancePublish.setStudentID(rs.getString("studentID"));
                list.add(attendancePublish);
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

    public List<AttendancePublish> findAll() {
        String sql = "SELECT * FROM AttendancePublish";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<AttendancePublish> list = new ArrayList<>();
            while (rs.next()) {
                AttendancePublish attendancePublish = new AttendancePublish();
                attendancePublish.setRecordID(rs.getInt("recordID"));
                attendancePublish.setMeetingID(rs.getString("meetingID"));
                attendancePublish.setStudentID(rs.getString("studentID"));
                list.add(attendancePublish);
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

    public boolean exists(int recordID) {
        String sql = "SELECT COUNT(*) FROM AttendancePublish WHERE recordID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordID);
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
