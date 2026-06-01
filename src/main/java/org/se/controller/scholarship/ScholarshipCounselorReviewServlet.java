package org.se.controller.scholarship;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.se.model.dao.ScholarshipWorkflowDao;

import java.io.IOException;

@WebServlet("/scholarshipCounselorReview")
public class ScholarshipCounselorReviewServlet extends HttpServlet {
    private final ScholarshipWorkflowDao workflowDao = new ScholarshipWorkflowDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String reviewID = trimToNull(request.getParameter("reviewID"));
        String appID = trimToNull(request.getParameter("appID"));
        String decision = trimToNull(request.getParameter("decision"));
        String comment = trimToNull(request.getParameter("comment"));
        if (reviewID == null || appID == null || decision == null) {
            response.sendRedirect("counselor.jsp?view=scholarshipReview&review=failed");
            return;
        }
        boolean agree = "agree".equals(decision);
        boolean success = workflowDao.completeCounselorReview(reviewID, agree, comment);
        if (success && agree) {
            String teacherID = workflowDao.findTeacherEmployeeByAppID(appID);
            success = teacherID != null
                    && workflowDao.updateApplicationStatus(appID, "teacher_review")
                    && workflowDao.createTeacherReview("STR" + System.currentTimeMillis(), appID, teacherID);
        } else if (success) {
            workflowDao.updateApplicationStatus(appID, "counselor_rejected");
        }
        response.sendRedirect("counselor.jsp?view=scholarshipReview&review=" + (success ? "saved" : "failed"));
    }

    private String trimToNull(String value) {
        if (value == null) return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
