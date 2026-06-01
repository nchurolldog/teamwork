package org.se.controller.scholarship;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.ScholarshipWorkflowDao;
import org.se.model.dao.StudentDAO;
import org.se.model.entity.Student;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.Map;

@WebServlet("/scholarshipVote")
public class ScholarshipVoteServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final ScholarshipWorkflowDao workflowDao = new ScholarshipWorkflowDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");
        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 3) {
            response.sendRedirect("index.jsp");
            return;
        }

        Student voter = studentDAO.findByAccount(currentUser.getAccount());
        String reviewID = trimToNull(request.getParameter("reviewID"));
        String vote = trimToNull(request.getParameter("vote"));
        String comment = trimToNull(request.getParameter("comment"));
        if (voter == null || reviewID == null || vote == null) {
            response.sendRedirect("student.jsp?view=scholarship&vote=failed");
            return;
        }

        boolean agree = "agree".equals(vote);
        boolean saved = workflowDao.saveVote(reviewID, voter.getStudentID(), agree, comment);
        if (saved) {
            evaluateReview(reviewID);
        }
        response.sendRedirect("student.jsp?view=scholarship&vote=" + (saved ? "saved" : "failed"));
    }

    private void evaluateReview(String reviewID) {
        Map<String, Object> summary = workflowDao.findVoteSummary(reviewID);
        int total = number(summary.get("total_count"));
        int voted = number(summary.get("voted_count"));
        if (total == 0 || voted < total) {
            return;
        }
        int agree = number(summary.get("agree_count"));
        int disagree = number(summary.get("disagree_count"));
        Map<String, Object> review = workflowDao.findReviewById(reviewID);
        if (review == null) {
            return;
        }
        String appID = String.valueOf(review.get("app_id"));
        if (agree > disagree) {
            String counselorID = workflowDao.findCounselorEmployeeByAppID(appID);
            if (counselorID != null) {
                workflowDao.updateDemocraticReviewStatus(reviewID, "passed");
                workflowDao.updateApplicationStatus(appID, "counselor_review");
                workflowDao.createCounselorReview("SCR" + System.currentTimeMillis(), appID, counselorID);
            }
        } else {
            workflowDao.updateDemocraticReviewStatus(reviewID, "rejected");
            workflowDao.updateApplicationStatus(appID, "democratic_rejected");
        }
    }

    private int number(Object value) {
        return value instanceof Number ? ((Number) value).intValue() : 0;
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
