package org.se.model.dao;

import org.se.model.entity.Teacher;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TeacherDAO {

    public boolean insert(Teacher teacher) {
        String sql = "INSERT INTO teacher (employee_id, account, name, gender) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teacher.getEmployeeID());
            pstmt.setString(2, teacher.getAccount());
            pstmt.setString(3, teacher.getName());
            pstmt.setObject(4, teacher.getGender());

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

    public boolean update(Teacher teacher) {
        String sql = "UPDATE teacher SET account = ?, name = ?, gender = ? WHERE employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, teacher.getAccount());
            pstmt.setString(2, teacher.getName());
            pstmt.setObject(3, teacher.getGender());
            pstmt.setString(4, teacher.getEmployeeID());

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

    public boolean delete(String employeeID) {
        String sql = "DELETE FROM teacher WHERE employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employeeID);

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

    public Teacher findById(String employeeID) {
        String sql = "SELECT * FROM teacher WHERE employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employeeID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setEmployeeID(rs.getString("employee_id"));
                teacher.setAccount(rs.getString("account"));
                teacher.setName(rs.getString("name"));
                teacher.setGender(rs.getInt("gender"));
                return teacher;
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

    public Teacher findByAccount(String account) {
        String sql = "SELECT * FROM teacher WHERE account = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, account);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setEmployeeID(rs.getString("employee_id"));
                teacher.setAccount(rs.getString("account"));
                teacher.setName(rs.getString("name"));
                teacher.setGender(rs.getInt("gender"));
                return teacher;
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

    public List<Teacher> findAll() {
        String sql = "SELECT * FROM teacher";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Teacher> list = new ArrayList<>();
            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setEmployeeID(rs.getString("employee_id"));
                teacher.setAccount(rs.getString("account"));
                teacher.setName(rs.getString("name"));
                teacher.setGender(rs.getInt("gender"));
                list.add(teacher);
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

    public List<Teacher> findByName(String name) {
        String sql = "SELECT * FROM teacher WHERE name LIKE ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + name + "%");
            rs = pstmt.executeQuery();

            List<Teacher> list = new ArrayList<>();
            while (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setEmployeeID(rs.getString("employee_id"));
                teacher.setAccount(rs.getString("account"));
                teacher.setName(rs.getString("name"));
                teacher.setGender(rs.getInt("gender"));
                list.add(teacher);
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

    public boolean exists(String employeeID) {
        String sql = "SELECT COUNT(*) FROM teacher WHERE employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employeeID);
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

    public boolean existsByAccount(String account) {
        String sql = "SELECT COUNT(*) FROM teacher WHERE account = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, account);
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

    public Teacher findByClassId(Integer classId) {
        String sql = "SELECT t.employee_id, t.account, t.name, t.gender FROM teacher t " +
                "JOIN class_entity ce ON t.employee_id = ce.teacher_id " +
                "WHERE ce.class_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, classId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Teacher teacher = new Teacher();
                teacher.setEmployeeID(rs.getString("employee_id"));
                teacher.setAccount(rs.getString("account"));
                teacher.setName(rs.getString("name"));
                teacher.setGender(rs.getInt("gender"));
                return teacher;
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
}
