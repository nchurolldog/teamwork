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
        String sql = "INSERT INTO ClassEntity (classID, className, TeacherID, CounselorID) VALUES (?, ?, ?, ?)";
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
        String sql = "UPDATE ClassEntity SET className = ?, TeacherID = ?, CounselorID = ? WHERE classID = ?";
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
        String sql = "DELETE FROM ClassEntity WHERE classID = ?";
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
        String sql = "SELECT * FROM ClassEntity WHERE classID = ?";
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
                classEntity.setClassID(rs.getInt("classID"));
                classEntity.setClassName(rs.getString("className"));
                classEntity.setTeacherID(rs.getString("TeacherID"));
                classEntity.setCounselorID(rs.getString("CounselorID"));
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
        String sql = "SELECT * FROM ClassEntity";
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
                classEntity.setClassID(rs.getInt("classID"));
                classEntity.setClassName(rs.getString("className"));
                classEntity.setTeacherID(rs.getString("TeacherID"));
                classEntity.setCounselorID(rs.getString("CounselorID"));
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

    public List<ClassEntity> findByTeacherId(String teacherID) {
        String sql = "SELECT * FROM ClassEntity WHERE TeacherID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teacherID);
            rs = pstmt.executeQuery();

            List<ClassEntity> list = new ArrayList<>();
            while (rs.next()) {
                ClassEntity classEntity = new ClassEntity();
                classEntity.setClassID(rs.getInt("classID"));
                classEntity.setClassName(rs.getString("className"));
                classEntity.setTeacherID(rs.getString("TeacherID"));
                classEntity.setCounselorID(rs.getString("CounselorID"));
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

    public List<ClassEntity> findByCounselorId(String counselorID) {
        String sql = "SELECT * FROM ClassEntity WHERE CounselorID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, counselorID);
            rs = pstmt.executeQuery();

            List<ClassEntity> list = new ArrayList<>();
            while (rs.next()) {
                ClassEntity classEntity = new ClassEntity();
                classEntity.setClassID(rs.getInt("classID"));
                classEntity.setClassName(rs.getString("className"));
                classEntity.setTeacherID(rs.getString("TeacherID"));
                classEntity.setCounselorID(rs.getString("CounselorID"));
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
        String sql = "SELECT COUNT(*) FROM ClassEntity WHERE classID = ?";
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
