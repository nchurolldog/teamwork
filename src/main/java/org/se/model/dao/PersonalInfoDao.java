package org.se.model.dao;

import org.se.model.entity.PersonalInfo;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class PersonalInfoDao {

    public boolean insert(PersonalInfo info) {
        String sql = "INSERT INTO personal_info (student_id, origin_place, political_status) VALUES (?, ?, ?)";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, info.getStudentID());
            pstmt.setString(2, info.getOriginPlace());
            pstmt.setString(3, info.getPoliticalStatus());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(PersonalInfo info) {
        String sql = "UPDATE personal_info SET origin_place = ?, political_status = ? WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, info.getOriginPlace());
            pstmt.setString(2, info.getPoliticalStatus());
            pstmt.setString(3, info.getStudentID());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean delete(String studentID) {
        String sql = "DELETE FROM personal_info WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public PersonalInfo findById(String studentID) {
        String sql = "SELECT * FROM personal_info WHERE student_id = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, studentID);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    PersonalInfo info = new PersonalInfo();
                    info.setStudentID(rs.getString("student_id"));
                    info.setOriginPlace(rs.getString("origin_place"));
                    info.setPoliticalStatus(rs.getString("political_status"));
                    return info;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<PersonalInfo> findAll() {
        String sql = "SELECT * FROM personal_info";
        List<PersonalInfo> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                PersonalInfo info = new PersonalInfo();
                info.setStudentID(rs.getString("student_id"));
                info.setOriginPlace(rs.getString("origin_place"));
                info.setPoliticalStatus(rs.getString("political_status"));
                list.add(info);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PersonalInfo> findByPoliticalStatus(String politicalStatus) {
        String sql = "SELECT * FROM personal_info WHERE political_status = ?";
        List<PersonalInfo> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, politicalStatus);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    PersonalInfo info = new PersonalInfo();
                    info.setStudentID(rs.getString("student_id"));
                    info.setOriginPlace(rs.getString("origin_place"));
                    info.setPoliticalStatus(rs.getString("political_status"));
                    list.add(info);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}