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

    public List<Map<String, Object>> findAdminRoleSummary() {
        String sql = "SELECT CASE user_type WHEN 0 THEN '管理员' WHEN 1 THEN '教师' WHEN 2 THEN '辅导员' WHEN 3 THEN '学生' ELSE '未知' END AS role_name, " +
                "COUNT(*) AS total_count FROM users GROUP BY user_type ORDER BY user_type";
        return query(sql);
    }

    public List<Map<String, Object>> findAdminApplicationSummary() {
        String sql = "SELECT '奖学金' AS module_name, status, COUNT(*) AS total_count FROM scholarship_application GROUP BY status " +
                "UNION ALL " +
                "SELECT '入党' AS module_name, status, COUNT(*) AS total_count FROM party_application GROUP BY status " +
                "ORDER BY module_name, status";
        return query(sql);
    }

    public List<Map<String, Object>> findAdminClassSummary() {
        String sql = "SELECT ce.class_id, ce.class_name, t.name AS teacher_name, c.name AS counselor_name, COUNT(sc.student_id) AS student_count " +
                "FROM class_entity ce " +
                "LEFT JOIN teacher t ON ce.teacher_id = t.employee_id " +
                "LEFT JOIN counselor c ON ce.counselor_id = c.employee_id " +
                "LEFT JOIN student_class sc ON ce.class_id = sc.class_id " +
                "GROUP BY ce.class_id, ce.class_name, t.name, c.name " +
                "ORDER BY ce.class_id";
        return query(sql);
    }

    public List<Map<String, Object>> findAdminGradeSummary() {
        String sql = "SELECT co.course_name, COUNT(g.student_id) AS record_count, ROUND(AVG(g.total_grade), 2) AS avg_grade, " +
                "MIN(g.total_grade) AS min_grade, MAX(g.total_grade) AS max_grade " +
                "FROM course co LEFT JOIN grade g ON co.course_id = g.course_id " +
                "GROUP BY co.course_id, co.course_name ORDER BY co.course_name";
        return query(sql);
    }

    public List<Map<String, Object>> findAdminRecentScholarshipApplications(int limit) {
        String sql = "SELECT sa.app_id, s.student_id, s.name, ce.class_name, sa.type_code, sa.amount, sa.status " +
                "FROM scholarship_application sa " +
                "JOIN student s ON sa.student_id = s.student_id " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "ORDER BY sa.app_id DESC LIMIT ?";
        return query(sql, limit);
    }

    public List<Map<String, Object>> findAdminRecentPartyApplications(int limit) {
        String sql = "SELECT pa.application_id, s.student_id, s.name, ce.class_name, pa.status " +
                "FROM party_application pa " +
                "JOIN student s ON pa.applicant_student_id = s.student_id " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "ORDER BY pa.application_id DESC LIMIT ?";
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

    public List<Map<String, Object>> findTeacherCourseGrades(String employeeID) {
        String sql = "SELECT c.course_id, c.course_name, s.student_id, s.name AS student_name, " +
                "ce.class_name, g.regular_weight, g.regular_grade, g.final_grade, g.total_grade " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "JOIN enrollment e ON s.student_id = e.student_id " +
                "JOIN course c ON e.course_id = c.course_id " +
                "LEFT JOIN grade g ON s.student_id = g.student_id AND c.course_id = g.course_id " +
                "WHERE ce.teacher_id = ? " +
                "ORDER BY c.course_id, s.student_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findTeacherClassStudents(String employeeID) {
        String sql = "SELECT DISTINCT s.student_id, s.name, ce.class_id, ce.class_name " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "WHERE ce.teacher_id = ? " +
                "ORDER BY ce.class_name, s.student_id";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findTeacherCourses(String employeeID) {
        String sql = "SELECT DISTINCT c.course_id, c.course_name " +
                "FROM class_entity ce " +
                "JOIN student_class sc ON ce.class_id = sc.class_id " +
                "JOIN enrollment e ON sc.student_id = e.student_id " +
                "JOIN course c ON e.course_id = c.course_id " +
                "WHERE ce.teacher_id = ? " +
                "ORDER BY c.course_id";
        return query(sql, employeeID);
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

    public List<Map<String, Object>> findTeacherPartyReviews(String employeeID) {
        String sql = "SELECT dr.review_id, pa.application_id, s.student_id, s.name, ce.class_name, pa.reason, dr.status " +
                "FROM democratic_review dr " +
                "JOIN party_application pa ON dr.application_id = pa.application_id " +
                "JOIN student s ON pa.applicant_student_id = s.student_id " +
                "JOIN student_class sc ON s.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE dr.organizer_employee_id = ? ORDER BY dr.review_id DESC";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findCounselorDevelopmentInspections(String employeeID) {
        String sql = "SELECT di.inspection_id, pa.application_id, s.student_id, s.name, ce.class_name, pa.reason, di.status, di.inspector_employee_id " +
                "FROM development_inspection di " +
                "JOIN party_application pa ON di.application_id = pa.application_id " +
                "JOIN student s ON pa.applicant_student_id = s.student_id " +
                "LEFT JOIN student_class sc ON s.student_id = sc.student_id " +
                "LEFT JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE di.inspector_employee_id = ? ORDER BY di.inspection_id DESC";
        System.out.println("[DEBUG DashboardDao] Querying development inspections for employeeID: '" + employeeID + "'");
        List<Map<String, Object>> result = query(sql, employeeID);
        System.out.println("[DEBUG DashboardDao] Found " + (result != null ? result.size() : 0) + " records");
        return result;
    }


    public List<Map<String, Object>> findCounselorPartyApprovals(String employeeID) {
        String sql = "SELECT pa_approval.approval_id, pa_app.application_id, s.student_id, s.name, ce.class_name, pa_app.reason, pa_approval.status " +
                "FROM party_approval pa_approval " +
                "JOIN party_application pa_app ON pa_approval.application_id = pa_app.application_id " +
                "JOIN student s ON pa_app.applicant_student_id = s.student_id " +
                "JOIN student_class sc ON s.student_id = sc.student_id " +
                "JOIN class_entity ce ON sc.class_id = ce.class_id " +
                "WHERE pa_approval.approver_employee_id = ? ORDER BY pa_approval.approval_id DESC";
        return query(sql, employeeID);
    }

    public List<Map<String, Object>> findAttendanceByMeetingId(String meetingID) {
        String sql = "SELECT ar.record_id, ar.student_id, s.name AS student_name, " +
                "ar.attendance_date, ar.is_absent " +
                "FROM attendance_publish ap " +
                "JOIN attendance_record ar ON ap.record_id = ar.record_id " +
                "JOIN student s ON ar.student_id = s.student_id " +
                "WHERE ap.meeting_id = ? ORDER BY ar.student_id";
        return query(sql, meetingID);
    }

    public List<Map<String, Object>> findAttendanceByStudentId(String studentID) {
        String sql = "SELECT cm.meeting_id, cm.meeting_theme, ce.class_name, cm.classroom, " +
                "ar.attendance_date, ar.is_absent " +
                "FROM attendance_publish ap " +
                "JOIN attendance_record ar ON ap.record_id = ar.record_id " +
                "JOIN class_meeting cm ON ap.meeting_id = cm.meeting_id " +
                "JOIN class_entity ce ON cm.class_id = ce.class_id " +
                "WHERE ar.student_id = ? ORDER BY ar.attendance_date DESC";
        return query(sql, studentID);
    }

    public List<Map<String, Object>> findClassStudentsForAttendance(Integer classID) {
        String sql = "SELECT s.student_id, s.name " +
                "FROM student_class sc " +
                "JOIN student s ON sc.student_id = s.student_id " +
                "WHERE sc.class_id = ? ORDER BY s.student_id";
        return query(sql, classID);
    }

    public List<Map<String, Object>> findMeetingsByClassIdForAttendance(Integer classID) {
        String sql = "SELECT cm.meeting_id, cm.meeting_theme, ce.class_name, cm.classroom " +
                "FROM class_meeting cm " +
                "JOIN class_entity ce ON cm.class_id = ce.class_id " +
                "WHERE cm.class_id = ? ORDER BY cm.meeting_id DESC";
        return query(sql, classID);
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
