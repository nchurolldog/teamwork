package org.se.controller.scholarship;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.ScholarshipApplicationDao;
import org.se.model.dao.ScholarshipApplicationDetailDao;
import org.se.model.dao.ScholarshipTypeDao;
import org.se.model.dao.ScholarshipWorkflowDao;
import org.se.model.dao.StudentDAO;
import org.se.model.entity.ScholarshipApplication;
import org.se.model.entity.ScholarshipApplicationDetail;
import org.se.model.entity.Student;
import org.se.model.entity.Users;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet("/applyScholarship")
public class ApplyScholarshipServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final ScholarshipTypeDao scholarshipTypeDao = new ScholarshipTypeDao();
    private final ScholarshipApplicationDao scholarshipApplicationDao = new ScholarshipApplicationDao();
    private final ScholarshipApplicationDetailDao scholarshipApplicationDetailDao = new ScholarshipApplicationDetailDao();
    private final ScholarshipWorkflowDao scholarshipWorkflowDao = new ScholarshipWorkflowDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 3) {
            response.sendRedirect("index.jsp");
            return;
        }

        Student student = studentDAO.findByAccount(currentUser.getAccount());
        String typeCode = trimToNull(request.getParameter("typeCode"));
        String reason = trimToNull(request.getParameter("reason"));
        String familySituation = trimToNull(request.getParameter("familySituation"));
        String academicScore = trimToNull(request.getParameter("academicScore"));
        String conductEvaluation = trimToNull(request.getParameter("conductEvaluation"));
        String honors = trimToNull(request.getParameter("honors"));
        String materials = trimToNull(request.getParameter("materials"));
        String promise = trimToNull(request.getParameter("promise"));
        BigDecimal amount = parseBigDecimal(request.getParameter("amount"));

        if (student == null || typeCode == null || reason == null || familySituation == null
                || academicScore == null || conductEvaluation == null || !"true".equals(promise)
                || scholarshipTypeDao.findById(typeCode) == null) {
            response.sendRedirect("student.jsp?view=scholarship&scholarship=failed");
            return;
        }

        List<ScholarshipApplication> applications = scholarshipApplicationDao.findByStudentID(student.getStudentID());
        for (ScholarshipApplication application : applications) {
            if (typeCode.equals(application.getTypeCode())) {
                response.sendRedirect("student.jsp?view=scholarship&scholarship=duplicate&appId=" + application.getAppID());
                return;
            }
        }

        String appID = "SA" + System.currentTimeMillis();
        ScholarshipApplication application = new ScholarshipApplication(appID, student.getStudentID(), typeCode, amount, reason, "counselor_review");
        ScholarshipApplicationDetail detail = new ScholarshipApplicationDetail(
                appID,
                amount,
                familySituation,
                academicScore,
                conductEvaluation,
                honors,
                reason,
                materials,
                true
        );
        boolean success = scholarshipApplicationDao.insert(application) && scholarshipApplicationDetailDao.insert(detail);
        if (success) {
            String counselorID = scholarshipWorkflowDao.findCounselorEmployeeByAppID(appID);
            success = counselorID != null
                    && scholarshipWorkflowDao.createCounselorReview("SCR" + System.currentTimeMillis(), appID, counselorID);
        }
        response.sendRedirect("student.jsp?view=scholarship&scholarship=" + (success ? "saved" : "failed") + "&appId=" + appID);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private BigDecimal parseBigDecimal(String value) {
        try {
            String trimmed = trimToNull(value);
            return trimmed == null ? null : new BigDecimal(trimmed);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
