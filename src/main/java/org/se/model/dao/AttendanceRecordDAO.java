package org.se.model.dao;

import org.se.model.entity.AttendanceRecord;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class AttendanceRecordDAO {

    public boolean insert(AttendanceRecord attendanceRecord) {
        String sql = "INSERT INTO attendance_record (record_id, student_id, attendance_date, is_absent) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, attendanceRecord.getRecordID());
            pstmt.setString(2, attendanceRecord.getStudentID());
            pstmt.setDate(3, java.sql.Date.valueOf(attendanceRecord.getAttendanceDate()));
            pstmt.setBoolean(4, Boolean.TRUE.equals(attendanceRecord.getAbsent()));

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

    public boolean update(AttendanceRecord attendanceRecord) {
        String sql = "UPDATE attendance_record SET student_id = ?, attendance_date = ?, is_absent = ? WHERE record_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, attendanceRecord.getStudentID());
            pstmt.setDate(2, java.sql.Date.valueOf(attendanceRecord.getAttendanceDate()));
            pstmt.setBoolean(3, Boolean.TRUE.equals(attendanceRecord.getAbsent()));
            pstmt.setInt(4, attendanceRecord.getRecordID());

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
        String sql = "DELETE FROM attendance_record WHERE record_id = ?";
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

    public AttendanceRecord findById(int recordID) {
        String sql = "SELECT * FROM attendance_record WHERE record_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, recordID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                AttendanceRecord attendanceRecord = new AttendanceRecord();
                attendanceRecord.setRecordID(rs.getInt("record_id"));
                attendanceRecord.setStudentID(rs.getString("student_id"));
                attendanceRecord.setAttendanceDate(rs.getDate("attendance_date").toLocalDate());
                attendanceRecord.setAbsent(rs.getBoolean("is_absent"));
                return attendanceRecord;
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

    public List<AttendanceRecord> findByStudentId(String studentID) {
        String sql = "SELECT * FROM attendance_record WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, studentID);
            rs = pstmt.executeQuery();

            List<AttendanceRecord> list = new ArrayList<>();
            while (rs.next()) {
                AttendanceRecord attendanceRecord = new AttendanceRecord();
                attendanceRecord.setRecordID(rs.getInt("record_id"));
                attendanceRecord.setStudentID(rs.getString("student_id"));
                attendanceRecord.setAttendanceDate(rs.getDate("attendance_date").toLocalDate());
                attendanceRecord.setAbsent(rs.getBoolean("is_absent"));
                list.add(attendanceRecord);
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

    public List<AttendanceRecord> findByDate(Date attendanceDate) {
        String sql = "SELECT * FROM attendance_record WHERE attendance_date = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setDate(1, attendanceDate);
            rs = pstmt.executeQuery();

            List<AttendanceRecord> list = new ArrayList<>();
            while (rs.next()) {
                AttendanceRecord attendanceRecord = new AttendanceRecord();
                attendanceRecord.setRecordID(rs.getInt("record_id"));
                attendanceRecord.setStudentID(rs.getString("student_id"));
                attendanceRecord.setAttendanceDate(rs.getDate("attendance_date").toLocalDate());
                attendanceRecord.setAbsent(rs.getBoolean("is_absent"));
                list.add(attendanceRecord);
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

    public List<AttendanceRecord> findAll() {
        String sql = "SELECT * FROM attendance_record";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<AttendanceRecord> list = new ArrayList<>();
            while (rs.next()) {
                AttendanceRecord attendanceRecord = new AttendanceRecord();
                attendanceRecord.setRecordID(rs.getInt("record_id"));
                attendanceRecord.setStudentID(rs.getString("student_id"));
                attendanceRecord.setAttendanceDate(rs.getDate("attendance_date").toLocalDate());
                attendanceRecord.setAbsent(rs.getBoolean("is_absent"));
                list.add(attendanceRecord);
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
        String sql = "SELECT COUNT(*) FROM attendance_record WHERE record_id = ?";
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
