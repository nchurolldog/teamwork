package org.se.model.dao;

import org.se.model.entity.Course;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CourseDao {

    public boolean insert(Course course) {
        String sql = "INSERT INTO course (course_id, course_name, credits) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, course.getCourseID());
            pstmt.setString(2, course.getCourseName());
            pstmt.setBigDecimal(3, course.getCredits());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Course course) {
        String sql = "UPDATE course SET course_name = ?, credits = ? WHERE course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, course.getCourseName());
            pstmt.setBigDecimal(2, course.getCredits());
            pstmt.setString(3, course.getCourseID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String courseID) {
        String sql = "DELETE FROM course WHERE course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, courseID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Course findById(String courseID) {
        String sql = "SELECT * FROM course WHERE course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getString("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setCredits(rs.getBigDecimal("credits"));
                    return course;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Course> findAll() {
        String sql = "SELECT * FROM course";
        List<Course> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Course course = new Course();
                course.setCourseID(rs.getString("course_id"));
                course.setCourseName(rs.getString("course_name"));
                course.setCredits(rs.getBigDecimal("credits"));
                list.add(course);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Course> findByCourseName(String courseName) {
        String sql = "SELECT * FROM course WHERE course_name LIKE ?";
        List<Course> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + courseName + "%");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Course course = new Course();
                    course.setCourseID(rs.getString("course_id"));
                    course.setCourseName(rs.getString("course_name"));
                    course.setCredits(rs.getBigDecimal("credits"));
                    list.add(course);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}