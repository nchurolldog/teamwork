package org.se.model.dao;

import org.se.model.entity.PartyApproval;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PartyApprovalDao {

    public boolean insert(PartyApproval approval) {
        String sql = "INSERT INTO party_approval (approval_id, application_id, approver_employee_id, status) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approval.getApprovalID());
            pstmt.setString(2, approval.getApplicationID());
            pstmt.setString(3, approval.getApproverEmployeeID());
            pstmt.setString(4, approval.getStatus());
            
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

    public boolean update(PartyApproval approval) {
        String sql = "UPDATE party_approval SET application_id = ?, approver_employee_id = ?, status = ? WHERE approval_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approval.getApplicationID());
            pstmt.setString(2, approval.getApproverEmployeeID());
            pstmt.setString(3, approval.getStatus());
            pstmt.setString(4, approval.getApprovalID());
            
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

    public boolean delete(String approvalID) {
        String sql = "DELETE FROM party_approval WHERE approval_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approvalID);
            
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

    public PartyApproval findById(String approvalID) {
        String sql = "SELECT * FROM party_approval WHERE approval_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approvalID);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                PartyApproval approval = new PartyApproval();
                approval.setApprovalID(rs.getString("approval_id"));
                approval.setApplicationID(rs.getString("application_id"));
                approval.setApproverEmployeeID(rs.getString("approver_employee_id"));
                approval.setStatus(rs.getString("status"));
                return approval;
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

    public List<PartyApproval> findAll() {
        String sql = "SELECT * FROM party_approval";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            List<PartyApproval> list = new ArrayList<>();
            while (rs.next()) {
                PartyApproval approval = new PartyApproval();
                approval.setApprovalID(rs.getString("approval_id"));
                approval.setApplicationID(rs.getString("application_id"));
                approval.setApproverEmployeeID(rs.getString("approver_employee_id"));
                approval.setStatus(rs.getString("status"));
                list.add(approval);
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

    public List<PartyApproval> findByApplicationId(String applicationID) {
        String sql = "SELECT * FROM party_approval WHERE application_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, applicationID);
            rs = pstmt.executeQuery();
            
            List<PartyApproval> list = new ArrayList<>();
            while (rs.next()) {
                PartyApproval approval = new PartyApproval();
                approval.setApprovalID(rs.getString("approval_id"));
                approval.setApplicationID(rs.getString("application_id"));
                approval.setApproverEmployeeID(rs.getString("approver_employee_id"));
                approval.setStatus(rs.getString("status"));
                list.add(approval);
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

    public List<PartyApproval> findByApproverId(String approverEmployeeID) {
        String sql = "SELECT * FROM party_approval WHERE approver_employee_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, approverEmployeeID);
            rs = pstmt.executeQuery();
            
            List<PartyApproval> list = new ArrayList<>();
            while (rs.next()) {
                PartyApproval approval = new PartyApproval();
                approval.setApprovalID(rs.getString("approval_id"));
                approval.setApplicationID(rs.getString("application_id"));
                approval.setApproverEmployeeID(rs.getString("approver_employee_id"));
                approval.setStatus(rs.getString("status"));
                list.add(approval);
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

    public List<PartyApproval> findByStatus(String status) {
        String sql = "SELECT * FROM party_approval WHERE status = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            rs = pstmt.executeQuery();
            
            List<PartyApproval> list = new ArrayList<>();
            while (rs.next()) {
                PartyApproval approval = new PartyApproval();
                approval.setApprovalID(rs.getString("approval_id"));
                approval.setApplicationID(rs.getString("application_id"));
                approval.setApproverEmployeeID(rs.getString("approver_employee_id"));
                approval.setStatus(rs.getString("status"));
                list.add(approval);
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
