package org.se.model.dao;

import org.se.model.entity.ClassMeeting;
import org.se.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClassMeetingDAO {

    public boolean insert(ClassMeeting meeting) {
        String sql = "INSERT INTO class_meeting (meeting_id, class_id, meeting_theme, classroom) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meeting.getMeetingID());
            pstmt.setInt(2, meeting.getClassID());
            pstmt.setString(3, meeting.getMeetingTheme());
            pstmt.setString(4, meeting.getClassroom());

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

    public boolean update(ClassMeeting meeting) {
        String sql = "UPDATE class_meeting SET meeting_theme = ?, classroom = ? WHERE meeting_id = ? AND class_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meeting.getMeetingTheme());
            pstmt.setString(2, meeting.getClassroom());
            pstmt.setString(3, meeting.getMeetingID());
            pstmt.setInt(4, meeting.getClassID());

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

    public boolean delete(String meetingID) {
        String sql = "DELETE FROM class_meeting WHERE meeting_id = ?";
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

    public ClassMeeting findById(String meetingID) {
        String sql = "SELECT * FROM class_meeting WHERE meeting_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, meetingID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                ClassMeeting meeting = new ClassMeeting();
                meeting.setMeetingID(rs.getString("meeting_id"));
                meeting.setClassID(rs.getInt("class_id"));
                meeting.setMeetingTheme(rs.getString("meeting_theme"));
                meeting.setClassroom(rs.getString("classroom"));
                return meeting;
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

    public List<ClassMeeting> findByClassId(Integer classID) {
        String sql = "SELECT * FROM class_meeting WHERE class_id = ? ORDER BY meeting_id DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, classID);
            rs = pstmt.executeQuery();

            List<ClassMeeting> list = new ArrayList<>();
            while (rs.next()) {
                ClassMeeting meeting = new ClassMeeting();
                meeting.setMeetingID(rs.getString("meeting_id"));
                meeting.setClassID(rs.getInt("class_id"));
                meeting.setMeetingTheme(rs.getString("meeting_theme"));
                meeting.setClassroom(rs.getString("classroom"));
                list.add(meeting);
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

    public List<ClassMeeting> findAll() {
        String sql = "SELECT * FROM class_meeting ORDER BY meeting_id DESC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<ClassMeeting> list = new ArrayList<>();
            while (rs.next()) {
                ClassMeeting meeting = new ClassMeeting();
                meeting.setMeetingID(rs.getString("meeting_id"));
                meeting.setClassID(rs.getInt("class_id"));
                meeting.setMeetingTheme(rs.getString("meeting_theme"));
                meeting.setClassroom(rs.getString("classroom"));
                list.add(meeting);
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
