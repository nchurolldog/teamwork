package org.se.model.dao;

import org.se.model.entity.Enrollment;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;


public class EnrollmentDao {

    public boolean insert(Enrollment enrollment) {
        String sql = "INSERT INTO enrollment (student_id, course_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, enrollment.getStudentID());
            pstmt.setString(2, enrollment.getCourseID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 鐎甸€涚艾閸欘亝婀侀懕鏂挎値娑撳鏁惃鍕€冮敍瀵€pdate 閹垮秳缍旂€圭偤妾弰顖氬帥閸掔娀娅庨崥搴㈠絻閸?
    public boolean update(Enrollment enrollment) {
        delete(enrollment.getStudentID(), enrollment.getCourseID());
        return insert(enrollment);
    }

    public boolean delete(String studentID, String courseID) {
        String sql = "DELETE FROM enrollment WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            pstmt.setString(2, courseID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Enrollment findById(String studentID, String courseID) {
        String sql = "SELECT * FROM enrollment WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            pstmt.setString(2, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setStudentID(rs.getString("student_id"));
                    enrollment.setCourseID(rs.getString("course_id"));
                    return enrollment;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Enrollment> findAll() {
        String sql = "SELECT * FROM enrollment";
        List<Enrollment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Enrollment enrollment = new Enrollment();
                enrollment.setStudentID(rs.getString("student_id"));
                enrollment.setCourseID(rs.getString("course_id"));
                list.add(enrollment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Enrollment> findByStudentID(String studentID) {
        String sql = "SELECT * FROM enrollment WHERE student_id = ?";
        List<Enrollment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setStudentID(rs.getString("student_id"));
                    enrollment.setCourseID(rs.getString("course_id"));
                    list.add(enrollment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Enrollment> findByCourseID(String courseID) {
        String sql = "SELECT * FROM enrollment WHERE course_id = ?";
        List<Enrollment> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Enrollment enrollment = new Enrollment();
                    enrollment.setStudentID(rs.getString("student_id"));
                    enrollment.setCourseID(rs.getString("course_id"));
                    list.add(enrollment);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}