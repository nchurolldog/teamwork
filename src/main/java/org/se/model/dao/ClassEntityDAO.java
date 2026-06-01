package org.se.model.dao;

import org.se.model.entity.ClassEntity;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ClassEntityDAO {

    public boolean insert(ClassEntity classEntity) {
        String sql = "INSERT INTO class_entity (class_id, class_name, teacher_id, counselor_id) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, classEntity.getClassID());
            pstmt.setString(2, classEntity.getClassName());
            pstmt.setString(3, classEntity.getTeacherID());
            pstmt.setString(4, classEntity.getCounselorID());

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

    public boolean update(ClassEntity classEntity) {
        String sql = "UPDATE class_entity SET class_name = ?, teacher_id = ?, counselor_id = ? WHERE class_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, classEntity.getClassName());
            pstmt.setString(2, classEntity.getTeacherID());
            pstmt.setString(3, classEntity.getCounselorID());
            pstmt.setInt(4, classEntity.getClassID());

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

    public boolean delete(int classID) {
        String sql = "DELETE FROM class_entity WHERE class_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, classID);

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

    public ClassEntity findById(int classID) {
        String sql = "SELECT * FROM class_entity WHERE class_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, classID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                ClassEntity classEntity = new ClassEntity();
                classEntity.setClassID(rs.getInt("class_id"));
                classEntity.setClassName(rs.getString("class_name"));
                classEntity.setTeacherID(rs.getString("teacher_id"));
                classEntity.setCounselorID(rs.getString("counselor_id"));
                return classEntity;
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

    public List<ClassEntity> findAll() {
        String sql = "SELECT * FROM class_entity";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<ClassEntity> list = new ArrayList<>();
            while (rs.next()) {
                ClassEntity classEntity = new ClassEntity();
                classEntity.setClassID(rs.getInt("class_id"));
                classEntity.setClassName(rs.getString("class_name"));
                classEntity.setTeacherID(rs.getString("teacher_id"));
                classEntity.setCounselorID(rs.getString("counselor_id"));
                list.add(classEntity);
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

    public List<ClassEntity> findByTeacherId(String teacher_id) {
        String sql = "SELECT * FROM class_entity WHERE teacher_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teacher_id);
            rs = pstmt.executeQuery();

            List<ClassEntity> list = new ArrayList<>();
            while (rs.next()) {
                ClassEntity classEntity = new ClassEntity();
                classEntity.setClassID(rs.getInt("class_id"));
                classEntity.setClassName(rs.getString("class_name"));
                classEntity.setTeacherID(rs.getString("teacher_id"));
                classEntity.setCounselorID(rs.getString("counselor_id"));
                list.add(classEntity);
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

    public List<ClassEntity> findByCounselorId(String counselor_id) {
        String sql = "SELECT * FROM class_entity WHERE counselor_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, counselor_id);
            rs = pstmt.executeQuery();

            List<ClassEntity> list = new ArrayList<>();
            while (rs.next()) {
                ClassEntity classEntity = new ClassEntity();
                classEntity.setClassID(rs.getInt("class_id"));
                classEntity.setClassName(rs.getString("class_name"));
                classEntity.setTeacherID(rs.getString("teacher_id"));
                classEntity.setCounselorID(rs.getString("counselor_id"));
                list.add(classEntity);
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

    public boolean exists(int classID) {
        String sql = "SELECT COUNT(*) FROM class_entity WHERE class_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, classID);
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
