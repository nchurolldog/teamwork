package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.DemocraticReviewDao;
import org.se.model.dao.DemocraticReviewParticipantDao;
import org.se.model.entity.DemocraticReview;
import org.se.model.entity.DemocraticReviewParticipant;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/studentPartyVote")
public class StudentPartyVoteServlet extends HttpServlet {
    private final DemocraticReviewDao democraticReviewDao = new DemocraticReviewDao();
    private final DemocraticReviewParticipantDao participantDao = new DemocraticReviewParticipantDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 3) {
            response.sendRedirect("index.jsp");
            return;
        }

        String reviewID = trimToNull(request.getParameter("reviewID"));
        String vote = trimToNull(request.getParameter("vote"));

        if (reviewID == null || vote == null || (!"agree".equals(vote) && !"disagree".equals(vote) && !"abstain".equals(vote))) {
            response.sendRedirect("student.jsp?view=party&status=failed");
            return;
        }

        String studentID = currentUser.getAccount();
        DemocraticReviewParticipant participant = participantDao.findById(reviewID, studentID);

        if (participant == null) {
            response.sendRedirect("student.jsp?view=party&status=failed");
            return;
        }

        DemocraticReview review = democraticReviewDao.findById(reviewID);
        if (review == null || !"voting".equals(review.getStatus())) {
            response.sendRedirect("student.jsp?view=party&status=failed");
            return;
        }

        if (participant.getAccess() != null) {
            response.sendRedirect("student.jsp?view=party&status=duplicate");
            return;
        }

        Integer voteValue;
        if ("agree".equals(vote)) {
            voteValue = 1;
        } else if ("disagree".equals(vote)) {
            voteValue = -1;
        } else {
            voteValue = 0;
        }

        participant.setAccess(voteValue);
        participantDao.update(participant);

        response.sendRedirect("student.jsp?view=party&status=voted&reviewId=" + reviewID);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}

