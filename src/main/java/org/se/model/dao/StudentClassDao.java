package org.se.model.dao;

import org.se.model.entity.StudentClass;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentClassDao {

    public boolean insert(StudentClass studentClass) {
        String sql = "INSERT INTO student_class (student_id, class_id) VALUES (?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentClass.getStudentID());
            pstmt.setInt(2, studentClass.getClassID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // 联合主键：student_id + class_id，update 需要先删除再插入
    public boolean update(StudentClass studentClass) {
        delete(studentClass.getStudentID(), studentClass.getClassID());
        return insert(studentClass);
    }

    public boolean delete(String studentID, int classID) {
        String sql = "DELETE FROM student_class WHERE student_id = ? AND class_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            pstmt.setInt(2, classID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public StudentClass findById(String studentID, int classID) {
        String sql = "SELECT * FROM student_class WHERE student_id = ? AND class_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            pstmt.setInt(2, classID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    StudentClass studentClass = new StudentClass();
                    studentClass.setStudentID(rs.getString("student_id"));
                    studentClass.setClassID(rs.getInt("class_id"));
                    return studentClass;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<StudentClass> findAll() {
        String sql = "SELECT * FROM student_class";
        List<StudentClass> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                StudentClass studentClass = new StudentClass();
                studentClass.setStudentID(rs.getString("student_id"));
                studentClass.setClassID(rs.getInt("class_id"));
                list.add(studentClass);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<StudentClass> findByStudentID(String studentID) {
        String sql = "SELECT * FROM student_class WHERE student_id = ?";
        List<StudentClass> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StudentClass studentClass = new StudentClass();
                    studentClass.setStudentID(rs.getString("student_id"));
                    studentClass.setClassID(rs.getInt("class_id"));
                    list.add(studentClass);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<StudentClass> findByClassID(int classID) {
        String sql = "SELECT * FROM student_class WHERE class_id = ?";
        List<StudentClass> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, classID);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    StudentClass studentClass = new StudentClass();
                    studentClass.setStudentID(rs.getString("student_id"));
                    studentClass.setClassID(rs.getInt("class_id"));
                    list.add(studentClass);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}