package org.se.model.dao;

import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ScholarshipWorkflowDao {

    public boolean createDemocraticReview(String reviewID, String appID) {
        String sql = "INSERT INTO scholarship_democratic_review (review_id, app_id, status) VALUES (?, ?, 'pending')";
        return update(sql, reviewID, appID);
    }

    public boolean addVoter(String reviewID, String studentID) {
        String sql = "INSERT IGNORE INTO scholarship_review_vote (review_id, voter_student_id, agree, comment) VALUES (?, ?, NULL, NULL)";
        return update(sql, reviewID, studentID);
    }

    public boolean saveVote(String reviewID, String voterStudentID, Integer agree, String comment) {
        String sql = "UPDATE scholarship_review_vote SET agree = ?, comment = ? WHERE review_id = ? AND voter_student_id = ?";
        return update(sql, agree, comment, reviewID, voterStudentID);
    }

    public boolean updateApplicationStatus(String appID, String status) {
        String sql = "UPDATE scholarship_application SET status = ? WHERE app_id = ?";
        return update(sql, status, appID);
    }

    public boolean updateDemocraticReviewStatus(String reviewID, String status) {
        String sql = "UPDATE scholarship_democratic_review SET status = ? WHERE review_id = ?";
        return update(sql, status, reviewID);
    }

    public boolean createCounselorReview(String reviewID, String appID, String employeeID) {
        String sql = "INSERT INTO scholarship_counselor_review (review_id, app_id, employee_id, result, comment, status) VALUES (?, ?, ?, NULL, NULL, 'pending')";
        return update(sql, reviewID, appID, employeeID);
    }

    public boolean createTeacherReview(String reviewID, String appID, String employeeID) {
        String sql = "INSERT INTO scholarship_teacher_review (review_id, app_id, employee_id, result, comment, status) VALUES (?, ?, ?, NULL, NULL, 'pending')";
        return update(sql, reviewID, appID, employeeID);
    }

    public boolean completeCounselorReview(String reviewID, Boolean result, String comment) {
        String sql = "UPDATE scholarship_counselor_review SET result = ?, comment = ?, status = 'completed' WHERE review_id = ?";
        return update(sql, result, comment, reviewID);
    }

    public boolean completeTeacherReview(String reviewID, Boolean result, String comment) {
        String sql = "UPDATE scholarship_teacher_review SET result = ?, comment = ?, status = 'completed' WHERE review_id = ?";
        return update(sql, result, comment, reviewID);
    }

    public List<Map<String, Object>> findEligibleVoters(String appID) {
        String sql = "SELECT DISTINCT voter.student_id, voter.name " +
                "FROM scholarship_application sa " +
                "JOIN student_class applicant_class ON sa.student_id = applicant_class.student_id " +
                "JOIN student_class voter_class ON applicant_class.class_id = voter_class.class_id " +
                "JOIN student voter ON voter_class.student_id = voter.student_id " +
                "LEFT JOIN personal_info pi ON voter.student_id = pi.student_id " +
                "WHERE sa.app_id = ? AND voter.student_id <> sa.student_id " +
                "AND (voter.position IN ('班长', '学习委员') OR pi.political_status = '党员') " +
                "ORDER BY voter.student_id";
        return query(sql, appID);
    }

    public List<Map<String, Object>> findStudentVoteTasks(String studentID) {
        String sql = "SELECT srv.review_id, srv.voter_student_id, srv.agree, srv.comment, sdr.status AS review_status, " +
                "sa.app_id, sa.type_code, applicant.student_id AS applicant_id, applicant.name AS applicant_name, ce.class_name, " +
                "sad.requested_amount, sad.family_situation, sad.academic_score, sad.conduct_evaluation, sad.honors, sad.application_reason, sad.supporting_materials " +
                "FROM scholarship_review_vote srv " +
                "JOIN scholarship_democratic_review sdr ON srv.review_id = sdr.review_id " +
                "JOIN scholarship_application sa ON sdr.app_id = sa.app_id " +
                "JOIN student applicant ON sa.student_id = applicant.student_id " +
                "LEFT JOIN scholarship_application_detail sad ON sa.app_id = sad.app_id " +
                "LEFT JOIN student_class sc ON applicant.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE srv.voter_student_id = ? ORDER BY sdr.review_id DESC";
        return query(sql, studentID);
    }

    public Map<String, Object> findVoteSummary(String reviewID) {
        String sql = "SELECT COUNT(*) AS total_count, SUM(CASE WHEN agree IS NOT NULL THEN 1 ELSE 0 END) AS voted_count, " +
                "SUM(CASE WHEN agree = 1 THEN 1 ELSE 0 END) AS agree_count, " +
                "SUM(CASE WHEN agree = -1 THEN 1 ELSE 0 END) AS disagree_count, " +
                "SUM(CASE WHEN agree = 0 THEN 1 ELSE 0 END) AS abstain_count " +
                "FROM scholarship_review_vote WHERE review_id = ?";
        List<Map<String, Object>> rows = query(sql, reviewID);
        return rows.isEmpty() ? new HashMap<>() : rows.get(0);
    }

    public Map<String, Object> findReviewById(String reviewID) {
        List<Map<String, Object>> rows = query("SELECT * FROM scholarship_democratic_review WHERE review_id = ?", reviewID);
        return rows.isEmpty() ? null : rows.get(0);
    }

    public String findCounselorEmployeeByAppID(String appID) {
        String sql = "SELECT ce.counselor_id FROM scholarship_application sa " +
                "JOIN student_class sc ON sa.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id WHERE sa.app_id = ? LIMIT 1";
        return firstString(sql, appID);
    }

    public String findTeacherEmployeeByAppID(String appID) {
        String sql = "SELECT ce.teacher_id FROM scholarship_application sa " +
                "JOIN student_class sc ON sa.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id WHERE sa.app_id = ? LIMIT 1";
        return firstString(sql, appID);
    }

    public List<Map<String, Object>> findCounselorReviewTasks(String employeeID) {
        String sql = "SELECT scr.review_id, scr.app_id, scr.result, scr.comment, scr.status, s.name, s.student_id, ce.class_name, sa.type_code, " +
                "sad.requested_amount, sad.family_situation, sad.academic_score, sad.conduct_evaluation, sad.honors, sad.application_reason, sad.supporting_materials " +
                "FROM scholarship_counselor_review scr " +
                "JOIN scholarship_application sa ON scr.app_id = sa.app_id " +
                "JOIN student s ON sa.student_id = s.student_id " +
                "LEFT JOIN scholarship_application_detail sad ON sa.app_id = sad.app_id " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE scr.employee_id = ? ORDER BY scr.review_id DESC";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findTeacherReviewTasks(String employeeID) {
        String sql = "SELECT str.review_id, str.app_id, str.result, str.comment, str.status, s.name, s.student_id, ce.class_name, sa.type_code, " +
                "sad.requested_amount, sad.family_situation, sad.academic_score, sad.conduct_evaluation, sad.honors, sad.application_reason, sad.supporting_materials " +
                "FROM scholarship_teacher_review str " +
                "JOIN scholarship_application sa ON str.app_id = sa.app_id " +
                "JOIN student s ON sa.student_id = s.student_id " +
                "LEFT JOIN scholarship_application_detail sad ON sa.app_id = sad.app_id " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE str.employee_id = ? ORDER BY str.review_id DESC";
        return query(sql, employeeID);
    }

    private String firstString(String sql, Object... params) {
        List<Map<String, Object>> rows = query(sql, params);
        if (rows.isEmpty() || rows.get(0).isEmpty()) {
            return null;
        }
        Object value = rows.get(0).values().iterator().next();
        return value == null ? null : String.valueOf(value);
    }

    private boolean update(String sql, Object... params) {
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            return pstmt.executeUpdate() >= 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private List<Map<String, Object>> query(String sql, Object... params) {
        List<Map<String, Object>> rows = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                pstmt.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = pstmt.executeQuery()) {
                ResultSetMetaData metaData = rs.getMetaData();
                int columnCount = metaData.getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new HashMap<>();
                    for (int i = 1; i <= columnCount; i++) {
                        row.put(metaData.getColumnLabel(i), rs.getObject(i));
                    }
                    rows.add(row);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
