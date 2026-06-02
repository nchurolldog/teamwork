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

public class DashboardDao {

    public List<Map<String, Object>> findStudentClasses(String studentID) {
        String sql = "SELECT ce.class_id, ce.class_name, t.name AS teacher_name, c.name AS counselor_name " +
                "FROM student_class sc " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "LEFT JOIN teacher t ON ce.teacher_id = t.employee_id " +
                "LEFT JOIN counselor c ON ce.counselor_id = c.employee_id " +
                "WHERE sc.student_id = ?";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findStudentGrades(String studentID) {
        String sql = "SELECT co.course_name, g.regular_grade, g.final_grade, g.total_grade " +
                "FROM grade g JOIN course co ON g.course_id = co.course_id " +
                "WHERE g.student_id = ? ORDER BY co.course_name";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findStudentMeetings(String studentID) {
        String sql = "SELECT cm.meeting_id, cm.meeting_theme, ce.class_name, cm.classroom, ce.class_id " +
                "FROM class_meeting_association cma " +
                "JOIN class_meeting cm ON cma.meeting_id = cm.meeting_id " +
                "JOIN class_entity ce ON cm.class_id = ce.class_id " +
                "WHERE cma.student_id = ? ORDER BY cm.meeting_id DESC";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findClassMeetingsByClassId(Integer classID) {
        String sql = "SELECT cm.meeting_id, cm.meeting_theme, ce.class_name, cm.classroom, s.name AS organizer_name " +
                "FROM class_meeting cm " +
                "JOIN class_entity ce ON cm.class_id = ce.class_id " +
                "LEFT JOIN class_meeting_association cma ON cm.meeting_id = cma.meeting_id " +
                "LEFT JOIN student s ON cma.student_id = s.student_id " +
                "WHERE cm.class_id = ? ORDER BY cm.meeting_id DESC";
        return query(sql, classID);
    }

    public List<Map<String, Object>> findAllClassMeetings() {
        String sql = "SELECT cm.meeting_id, cm.meeting_theme, ce.class_name, cm.classroom, s.name AS organizer_name, s.student_id AS organizer_id " +
                "FROM class_meeting cm " +
                "JOIN class_entity ce ON cm.class_id = ce.class_id " +
                "LEFT JOIN class_meeting_association cma ON cm.meeting_id = cma.meeting_id " +
                "LEFT JOIN student s ON cma.student_id = s.student_id " +
                "ORDER BY cm.meeting_id DESC";
        return query(sql);
    }

    public List<Map<String, Object>> findClassmates(String studentID) {
        String sql = "SELECT s.student_id, s.name, s.position, s.gender, ce.class_name " +
                "FROM student_class own " +
                "JOIN student_class sc ON own.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE own.student_id = ? ORDER BY ce.class_id, s.student_id";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findTeacherClasses(String employeeID) {
        String sql = "SELECT ce.class_id, ce.class_name, COUNT(sc.student_id) AS student_count " +
                "FROM class_entity ce LEFT JOIN student_class sc ON ce.class_id = sc.class_id " +
                "WHERE ce.teacher_id = ? GROUP BY ce.class_id, ce.class_name ORDER BY ce.class_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findTeacherStudents(String employeeID) {
        String sql = "SELECT s.student_id, s.name, s.position, ce.class_id, ce.class_name, ROUND(AVG(g.total_grade), 2) AS avg_grade " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "LEFT JOIN grade g ON s.student_id = g.student_id " +
                "WHERE ce.teacher_id = ? " +
                "GROUP BY s.student_id, s.name, s.position, ce.class_id, ce.class_name ORDER BY ce.class_id, s.student_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findTeacherStudentsPaged(String employeeID, String search, Integer classID, int offset, int limit) {
        String sql = "SELECT s.student_id, s.name, s.position, ce.class_id, ce.class_name, ROUND(AVG(g.total_grade), 2) AS avg_grade " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "LEFT JOIN grade g ON s.student_id = g.student_id " +
                "WHERE ce.teacher_id = ? AND (? IS NULL OR s.name LIKE ? OR s.student_id LIKE ?) " +
                "AND (? IS NULL OR ce.class_id = ?) " +
                "GROUP BY s.student_id, s.name, s.position, ce.class_id, ce.class_name " +
                "ORDER BY ce.class_id, s.student_id LIMIT ? OFFSET ?";
        String pattern = search == null || search.trim().isEmpty() ? null : "%" + search.trim() + "%";
        return query(sql, employeeID, pattern, pattern, pattern, classID, classID, limit, offset);
    }

    public int countTeacherStudentsFiltered(String employeeID, String search, Integer classID) {
        String sql = "SELECT COUNT(DISTINCT s.student_id) AS total_count " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "WHERE ce.teacher_id = ? AND (? IS NULL OR s.name LIKE ? OR s.student_id LIKE ?) " +
                "AND (? IS NULL OR ce.class_id = ?)";
        String pattern = search == null || search.trim().isEmpty() ? null : "%" + search.trim() + "%";
        return countQuery(sql, employeeID, pattern, pattern, pattern, classID, classID);
    }

    public List<Map<String, Object>> findCounselorClasses(String employeeID) {
        String sql = "SELECT ce.class_id, ce.class_name, COUNT(sc.student_id) AS student_count " +
                "FROM class_entity ce LEFT JOIN student_class sc ON ce.class_id = sc.class_id " +
                "WHERE ce.counselor_id = ? GROUP BY ce.class_id, ce.class_name ORDER BY ce.class_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findCounselorStudents(String employeeID) {
        String sql = "SELECT s.student_id, s.name, s.position, ce.class_id, ce.class_name, " +
                "COALESCE(pa.status, 'none') AS party_status, COALESCE(sa.status, 'none') AS scholarship_status " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "LEFT JOIN party_application pa ON s.student_id = pa.applicant_student_id " +
                "LEFT JOIN scholarship_application sa ON s.student_id = sa.student_id " +
                "WHERE ce.counselor_id = ? ORDER BY ce.class_id, s.student_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findCounselorStudentsPaged(String employeeID, String search, Integer classID, int offset, int limit) {
        String sql = "SELECT s.student_id, s.name, s.position, ce.class_id, ce.class_name, " +
                "COALESCE(pa.status, 'none') AS party_status, COALESCE(sa.status, 'none') AS scholarship_status " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "LEFT JOIN party_application pa ON s.student_id = pa.applicant_student_id " +
                "LEFT JOIN scholarship_application sa ON s.student_id = sa.student_id " +
                "WHERE ce.counselor_id = ? AND (? IS NULL OR s.name LIKE ? OR s.student_id LIKE ?) " +
                "AND (? IS NULL OR ce.class_id = ?) " +
                "ORDER BY ce.class_id, s.student_id LIMIT ? OFFSET ?";
        String pattern = search == null || search.trim().isEmpty() ? null : "%" + search.trim() + "%";
        return query(sql, employeeID, pattern, pattern, pattern, classID, classID, limit, offset);
    }

    public int countCounselorStudentsFiltered(String employeeID, String search, Integer classID) {
        String sql = "SELECT COUNT(DISTINCT s.student_id) AS total_count " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "WHERE ce.counselor_id = ? AND (? IS NULL OR s.name LIKE ? OR s.student_id LIKE ?) " +
                "AND (? IS NULL OR ce.class_id = ?)";
        String pattern = search == null || search.trim().isEmpty() ? null : "%" + search.trim() + "%";
        return countQuery(sql, employeeID, pattern, pattern, pattern, classID, classID);
    }

    public List<Map<String, Object>> findAvailableScholarships(String studentID) {
        String sql = "SELECT st.type_code, st.description " +
                "FROM scholarship_type st " +
                "WHERE NOT EXISTS (SELECT 1 FROM scholarship_application sa WHERE sa.type_code = st.type_code AND sa.student_id = ?) " +
                "ORDER BY st.type_code";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findStudentScholarshipApplications(String studentID) {
        String sql = "SELECT sa.app_id, sa.type_code, st.description, sa.amount, sa.reason, sa.status, " +
                "sad.requested_amount, sad.family_situation, sad.academic_score, sad.conduct_evaluation, " +
                "sad.honors, sad.application_reason, sad.supporting_materials, sad.promise " +
                "FROM scholarship_application sa " +
                "LEFT JOIN scholarship_type st ON sa.type_code = st.type_code " +
                "LEFT JOIN scholarship_application_detail sad ON sa.app_id = sad.app_id " +
                "WHERE sa.student_id = ? ORDER BY sa.app_id DESC";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findPublishedScholarships() {
        String sql = "SELECT sa.app_id, s.student_id, s.name, ce.class_name, sa.type_code, st.description, sa.amount, sa.status " +
                "FROM scholarship_application sa " +
                "JOIN student s ON sa.student_id = s.student_id " +
                "LEFT JOIN scholarship_type st ON sa.type_code = st.type_code " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE sa.status IN ('approved', 'published', '公示', '已公示') " +
                "ORDER BY sa.app_id DESC";
        return query(sql);
    }

    public List<Map<String, Object>> findCounselorMeetings(String employeeID) {
        String sql = "SELECT cm.meeting_theme, ce.class_name, cm.classroom " +
                "FROM class_meeting cm JOIN class_entity ce ON cm.class_id = ce.class_id " +
                "WHERE ce.counselor_id = ? ORDER BY cm.meeting_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findCounselorPartyApplications(String employeeID) {
        String sql = "SELECT pa.application_id, s.student_id, s.name, ce.class_name, pa.reason, pa.status " +
                "FROM party_application pa " +
                "JOIN student s ON pa.applicant_student_id = s.student_id " +
                "JOIN student_class sc ON s.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE ce.counselor_id = ? ORDER BY pa.application_id DESC";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findCounselorScholarshipApplications(String employeeID) {
        String sql = "SELECT sa.app_id, s.student_id, s.name, ce.class_name, sa.type_code, st.description, sa.amount, sa.reason, sa.status, " +
                "sad.requested_amount, sad.family_situation, sad.academic_score, sad.conduct_evaluation, sad.honors, sad.supporting_materials " +
                "FROM scholarship_application sa " +
                "JOIN student s ON sa.student_id = s.student_id " +
                "JOIN student_class sc ON s.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "LEFT JOIN scholarship_type st ON sa.type_code = st.type_code " +
                "LEFT JOIN scholarship_application_detail sad ON sa.app_id = sad.app_id " +
                "WHERE ce.counselor_id = ? ORDER BY sa.app_id DESC";
        return query(sql, employeeID);
    }

    public int countRows(String tableName) {
        String sql = "SELECT COUNT(*) AS total_count FROM " + tableName;
        List<Map<String, Object>> rows = query(sql);
        if (rows.isEmpty()) {
            return 0;
        }
        Object count = rows.get(0).get("total_count");
        return count instanceof Number ? ((Number) count).intValue() : 0;
    }

    public List<Map<String, Object>> findAdminStudents(int limit) {
        String sql = "SELECT s.student_id, s.name, s.position, ce.class_name, ROUND(AVG(g.total_grade), 2) AS avg_grade, " +
                "COALESCE(pi.image_path, 'static/img/maomao.jpg') AS avatar_path " +
                "FROM student s " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "LEFT JOIN grade g ON s.student_id = g.student_id " +
                "LEFT JOIN profile_image pi ON pi.owner_type = 3 AND pi.owner_account = s.account " +
                "GROUP BY s.student_id, s.name, s.position, ce.class_name, pi.image_path " +
                "ORDER BY s.student_id LIMIT ?";
        return query(sql, limit);
    }

    public List<Map<String, Object>> findAdminPrograms(int limit) {
        String sql = "SELECT s.student_id, s.name, ce.class_name, sa.type_code, sa.status, " +
                "COALESCE(pi.image_path, 'static/img/maomao.jpg') AS avatar_path " +
                "FROM scholarship_application sa " +
                "JOIN student s ON sa.student_id = s.student_id " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "LEFT JOIN profile_image pi ON pi.owner_type = 3 AND pi.owner_account = s.account " +
                "ORDER BY sa.app_id LIMIT ?";
        return query(sql, limit);
    }

    public int countAdminClasses() {
        return countRows("class_entity");
    }

    public int countAdminTeachers() {
        return countRows("teacher");
    }

    public int countAdminCounselors() {
        return countRows("counselor");
    }

    public int countTeacherCourses(String employeeID) {
        String sql = "SELECT COUNT(DISTINCT e.course_id) AS total_count " +
                "FROM class_entity ce JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN enrollment e ON sc.student_id = e.student_id WHERE ce.teacher_id = ?";
        return countQuery(sql, employeeID);
    }

    public int countTeacherGradeItems(String employeeID) {
        String sql = "SELECT COUNT(*) AS total_count FROM grade g " +
                "JOIN student_class sc ON g.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id WHERE ce.teacher_id = ?";
        return countQuery(sql, employeeID);
    }

    public int countCounselorPartyApplications(String employeeID) {
        String sql = "SELECT COUNT(*) AS total_count FROM party_application pa " +
                "JOIN student_class sc ON pa.applicant_student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id WHERE ce.counselor_id = ?";
        return countQuery(sql, employeeID);
    }

    public int countCounselorScholarshipApplications(String employeeID) {
        String sql = "SELECT COUNT(*) AS total_count FROM scholarship_application sa " +
                "JOIN student_class sc ON sa.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id WHERE ce.counselor_id = ?";
        return countQuery(sql, employeeID);
    }

    private int countQuery(String sql, Object... params) {
        List<Map<String, Object>> rows = query(sql, params);
        if (rows.isEmpty()) {
            return 0;
        }
        Object count = rows.get(0).get("total_count");
        return count instanceof Number ? ((Number) count).intValue() : 0;
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
