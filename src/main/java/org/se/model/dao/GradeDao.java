package org.se.model.dao;

import org.se.model.entity.Grade;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class GradeDao {

    public boolean insert(Grade grade) {
        String sql = "INSERT INTO grade (student_id, course_id, regular_weight, regular_grade, final_grade, total_grade) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, grade.getStudentID());
            pstmt.setString(2, grade.getCourseID());
            pstmt.setBigDecimal(3, grade.getRegularWeight());
            pstmt.setBigDecimal(4, grade.getRegularGrade());
            pstmt.setBigDecimal(5, grade.getFinalGrade());
            pstmt.setBigDecimal(6, grade.getTotalGrade());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Grade grade) {
        String sql = "UPDATE grade SET regular_weight = ?, regular_grade = ?, final_grade = ?, total_grade = ? WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setBigDecimal(1, grade.getRegularWeight());
            pstmt.setBigDecimal(2, grade.getRegularGrade());
            pstmt.setBigDecimal(3, grade.getFinalGrade());
            pstmt.setBigDecimal(4, grade.getTotalGrade());
            pstmt.setString(5, grade.getStudentID());
            pstmt.setString(6, grade.getCourseID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String studentID, String courseID) {
        String sql = "DELETE FROM grade WHERE student_id = ? AND course_id = ?";
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

    public Grade findById(String studentID, String courseID) {
        String sql = "SELECT * FROM grade WHERE student_id = ? AND course_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            pstmt.setString(2, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    Grade grade = new Grade();
                    grade.setStudentID(rs.getString("student_id"));
                    grade.setCourseID(rs.getString("course_id"));
                    grade.setRegularWeight(rs.getBigDecimal("regular_weight"));
                    grade.setRegularGrade(rs.getBigDecimal("regular_grade"));
                    grade.setFinalGrade(rs.getBigDecimal("final_grade"));
                    grade.setTotalGrade(rs.getBigDecimal("total_grade"));
                    return grade;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Grade> findAll() {
        String sql = "SELECT * FROM grade";
        List<Grade> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Grade grade = new Grade();
                grade.setStudentID(rs.getString("student_id"));
                grade.setCourseID(rs.getString("course_id"));
                grade.setRegularWeight(rs.getBigDecimal("regular_weight"));
                grade.setRegularGrade(rs.getBigDecimal("regular_grade"));
                grade.setFinalGrade(rs.getBigDecimal("final_grade"));
                grade.setTotalGrade(rs.getBigDecimal("total_grade"));
                list.add(grade);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Grade> findByStudentID(String studentID) {
        String sql = "SELECT * FROM grade WHERE student_id = ?";
        List<Grade> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Grade grade = new Grade();
                    grade.setStudentID(rs.getString("student_id"));
                    grade.setCourseID(rs.getString("course_id"));
                    grade.setRegularWeight(rs.getBigDecimal("regular_weight"));
                    grade.setRegularGrade(rs.getBigDecimal("regular_grade"));
                    grade.setFinalGrade(rs.getBigDecimal("final_grade"));
                    grade.setTotalGrade(rs.getBigDecimal("total_grade"));
                    list.add(grade);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Grade> findByCourseID(String courseID) {
        String sql = "SELECT * FROM grade WHERE course_id = ?";
        List<Grade> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, courseID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Grade grade = new Grade();
                    grade.setStudentID(rs.getString("student_id"));
                    grade.setCourseID(rs.getString("course_id"));
                    grade.setRegularWeight(rs.getBigDecimal("regular_weight"));
                    grade.setRegularGrade(rs.getBigDecimal("regular_grade"));
                    grade.setFinalGrade(rs.getBigDecimal("final_grade"));
                    grade.setTotalGrade(rs.getBigDecimal("total_grade"));
                    list.add(grade);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}