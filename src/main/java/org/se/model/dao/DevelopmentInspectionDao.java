package org.se.model.dao;

import org.se.model.entity.DevelopmentInspection;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DevelopmentInspectionDao {

    public boolean insert(DevelopmentInspection inspection) {
        String sql = "INSERT INTO development_inspection (inspection_id, application_id, inspector_employee_id, status) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inspection.getInspectionID());
            pstmt.setString(2, inspection.getApplicationID());
            pstmt.setString(3, inspection.getInspectorEmployeeID());
            pstmt.setString(4, inspection.getStatus());
            
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

    public boolean update(DevelopmentInspection inspection) {
        String sql = "UPDATE development_inspection SET application_id = ?, inspector_employee_id = ?, status = ? WHERE inspection_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inspection.getApplicationID());
            pstmt.setString(2, inspection.getInspectorEmployeeID());
            pstmt.setString(3, inspection.getStatus());
            pstmt.setString(4, inspection.getInspectionID());
            
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

    public boolean delete(String inspectionID) {
        String sql = "DELETE FROM development_inspection WHERE inspection_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inspectionID);
            
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

    public DevelopmentInspection findById(String inspectionID) {
        String sql = "SELECT * FROM development_inspection WHERE inspection_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inspectionID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                DevelopmentInspection inspection = new DevelopmentInspection();
                inspection.setInspectionID(rs.getString("inspection_id"));
                inspection.setApplicationID(rs.getString("application_id"));
                inspection.setInspectorEmployeeID(rs.getString("inspector_employee_id"));
                inspection.setStatus(rs.getString("status"));
                return inspection;
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

    public List<DevelopmentInspection> findAll() {
        String sql = "SELECT * FROM development_inspection";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            List<DevelopmentInspection> list = new ArrayList<>();
            while (rs.next()) {
                DevelopmentInspection inspection = new DevelopmentInspection();
                inspection.setInspectionID(rs.getString("inspection_id"));
                inspection.setApplicationID(rs.getString("application_id"));
                inspection.setInspectorEmployeeID(rs.getString("inspector_employee_id"));
                inspection.setStatus(rs.getString("status"));
                list.add(inspection);
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

    public List<DevelopmentInspection> findByApplicationId(String applicationID) {
        String sql = "SELECT * FROM development_inspection WHERE application_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, applicationID);
            rs = pstmt.executeQuery();
            
            List<DevelopmentInspection> list = new ArrayList<>();
            while (rs.next()) {
                DevelopmentInspection inspection = new DevelopmentInspection();
                inspection.setInspectionID(rs.getString("inspection_id"));
                inspection.setApplicationID(rs.getString("application_id"));
                inspection.setInspectorEmployeeID(rs.getString("inspector_employee_id"));
                inspection.setStatus(rs.getString("status"));
                list.add(inspection);
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

    public List<DevelopmentInspection> findByInspectorId(String inspectorEmployeeID) {
        String sql = "SELECT * FROM development_inspection WHERE inspector_employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, inspectorEmployeeID);
            rs = pstmt.executeQuery();
            
            List<DevelopmentInspection> list = new ArrayList<>();
            while (rs.next()) {
                DevelopmentInspection inspection = new DevelopmentInspection();
                inspection.setInspectionID(rs.getString("inspection_id"));
                inspection.setApplicationID(rs.getString("application_id"));
                inspection.setInspectorEmployeeID(rs.getString("inspector_employee_id"));
                inspection.setStatus(rs.getString("status"));
                list.add(inspection);
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

    public List<DevelopmentInspection> findByStatus(String status) {
        String sql = "SELECT * FROM development_inspection WHERE status = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            List<DevelopmentInspection> list = new ArrayList<>();
            while (rs.next()) {
                DevelopmentInspection inspection = new DevelopmentInspection();
                inspection.setInspectionID(rs.getString("inspection_id"));
                inspection.setApplicationID(rs.getString("application_id"));
                inspection.setInspectorEmployeeID(rs.getString("inspector_employee_id"));
                inspection.setStatus(rs.getString("status"));
                list.add(inspection);
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
