package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.DashboardDao;
import org.se.model.dao.DemocraticReviewDao;
import org.se.model.dao.DemocraticReviewParticipantDao;
import org.se.model.dao.DevelopmentInspectionDao;
import org.se.model.dao.PartyApplicationDao;
import org.se.model.entity.DemocraticReview;
import org.se.model.entity.DemocraticReviewParticipant;
import org.se.model.entity.DevelopmentInspection;
import org.se.model.entity.PartyApplication;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.List;

@WebServlet("/teacherPartyReview")
public class TeacherPartyReviewServlet extends HttpServlet {
    private final DemocraticReviewDao democraticReviewDao = new DemocraticReviewDao();
    private final DemocraticReviewParticipantDao participantDao = new DemocraticReviewParticipantDao();
    private final PartyApplicationDao partyApplicationDao = new PartyApplicationDao();
    private final DevelopmentInspectionDao developmentInspectionDao = new DevelopmentInspectionDao();
    private final DashboardDao dashboardDao = new DashboardDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 1) {
            response.sendRedirect("index.jsp");
            return;
        }

        String reviewID = trimToNull(request.getParameter("reviewID"));
        String action = trimToNull(request.getParameter("action"));

        if (reviewID == null || action == null) {
            response.sendRedirect("teacher.jsp?view=partyReview&status=failed");
            return;
        }

        DemocraticReview review = democraticReviewDao.findById(reviewID);
        if (review == null || !review.getOrganizerEmployeeID().equals(currentUser.getAccount())) {
            response.sendRedirect("teacher.jsp?view=partyReview&status=failed");
            return;
        }

        if ("start".equals(action)) {
            review.setStatus("voting");
            democraticReviewDao.update(review);

            List<DemocraticReviewParticipant> participants = participantDao.findByReviewId(reviewID);
            for (DemocraticReviewParticipant participant : participants) {
                participant.setAccess(true);
                participantDao.update(participant);
            }

            response.sendRedirect("teacher.jsp?view=partyReview&status=started&reviewId=" + reviewID);
        } else if ("finish".equals(action)) {
            List<DemocraticReviewParticipant> participants = participantDao.findByReviewId(reviewID);
            int totalParticipants = participants.size();
            int agreeCount = 0;
            int votedCount = 0;

            for (DemocraticReviewParticipant participant : participants) {
                if (participant.getAccess() != null) {
                    votedCount++;
                    if (Boolean.TRUE.equals(participant.getAccess())) {
                        agreeCount++;
                    }
                }
            }

            double agreeRate = totalParticipants > 0 ? (double) agreeCount / totalParticipants : 0;
            boolean passed = agreeRate >= 0.6;

            review.setStatus(passed ? "passed" : "failed");
            democraticReviewDao.update(review);

            PartyApplication application = partyApplicationDao.findById(review.getApplicationID());
            if (application != null) {
                if (passed) {
                    application.setStatus("review_passed");

                    String inspectionID = "DI" + System.currentTimeMillis();
                    DevelopmentInspection inspection = new DevelopmentInspection(inspectionID, application.getApplicationID(), currentUser.getAccount(), "pending");
                    developmentInspectionDao.insert(inspection);
                } else {
                    application.setStatus("review_failed");
                }
                partyApplicationDao.update(application);
            }

            response.sendRedirect("teacher.jsp?view=partyReview&status=" + (passed ? "passed" : "failed") + "&reviewId=" + reviewID + "&agreeRate=" + Math.round(agreeRate * 100) + "&votedCount=" + votedCount + "&totalParticipants=" + totalParticipants);
        } else {
            response.sendRedirect("teacher.jsp?view=partyReview&status=failed");
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
