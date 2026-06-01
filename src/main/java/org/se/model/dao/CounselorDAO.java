package org.se.model.dao;

import org.se.model.entity.Counselor;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CounselorDAO {

    public boolean insert(Counselor counselor) {
        String sql = "INSERT INTO Counselor (EmployeeID, Account, Name, Gender) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, counselor.getEmployeeID());
            pstmt.setString(2, counselor.getAccount());
            pstmt.setString(3, counselor.getName());
            pstmt.setString(4, counselor.getGender());

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

    public boolean update(Counselor counselor) {
        String sql = "UPDATE Counselor SET Account = ?, Name = ?, Gender = ? WHERE EmployeeID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, counselor.getAccount());
            pstmt.setString(2, counselor.getName());
            pstmt.setString(3, counselor.getGender());
            pstmt.setString(4, counselor.getEmployeeID());

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
        String sql = "DELETE FROM Counselor WHERE EmployeeID = ?";
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

    public Counselor findById(String employeeID) {
        String sql = "SELECT * FROM Counselor WHERE EmployeeID = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, employeeID);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Counselor counselor = new Counselor();
                counselor.setEmployeeID(rs.getString("EmployeeID"));
                counselor.setAccount(rs.getString("Account"));
                counselor.setName(rs.getString("Name"));
                counselor.setGender(rs.getString("Gender"));
                return counselor;
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

    public Counselor findByAccount(String account) {
        String sql = "SELECT * FROM Counselor WHERE Account = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, account);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                Counselor counselor = new Counselor();
                counselor.setEmployeeID(rs.getString("EmployeeID"));
                counselor.setAccount(rs.getString("Account"));
                counselor.setName(rs.getString("Name"));
                counselor.setGender(rs.getString("Gender"));
                return counselor;
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

    public List<Counselor> findAll() {
        String sql = "SELECT * FROM Counselor";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            List<Counselor> list = new ArrayList<>();
            while (rs.next()) {
                Counselor counselor = new Counselor();
                counselor.setEmployeeID(rs.getString("EmployeeID"));
                counselor.setAccount(rs.getString("Account"));
                counselor.setName(rs.getString("Name"));
                counselor.setGender(rs.getString("Gender"));
                list.add(counselor);
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

    public List<Counselor> findByName(String name) {
        String sql = "SELECT * FROM Counselor WHERE Name LIKE ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + name + "%");
            rs = pstmt.executeQuery();

            List<Counselor> list = new ArrayList<>();
            while (rs.next()) {
                Counselor counselor = new Counselor();
                counselor.setEmployeeID(rs.getString("EmployeeID"));
                counselor.setAccount(rs.getString("Account"));
                counselor.setName(rs.getString("Name"));
                counselor.setGender(rs.getString("Gender"));
                list.add(counselor);
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
        String sql = "SELECT COUNT(*) FROM Counselor WHERE EmployeeID = ?";
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
        String sql = "SELECT COUNT(*) FROM Counselor WHERE Account = ?";
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
}
