package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.CounselorDAO;
import org.se.model.dao.DashboardDao;
import org.se.model.dao.DemocraticReviewDao;
import org.se.model.dao.DemocraticReviewParticipantDao;
import org.se.model.dao.DevelopmentInspectionDao;
import org.se.model.dao.PartyApplicationDao;
import org.se.model.dao.StudentClassDao;
import org.se.model.entity.Counselor;
import org.se.model.entity.DemocraticReview;
import org.se.model.entity.DemocraticReviewParticipant;
import org.se.model.entity.DevelopmentInspection;
import org.se.model.entity.PartyApplication;
import org.se.model.entity.StudentClass;
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
    private final CounselorDAO counselorDAO = new CounselorDAO();
    private final StudentClassDao studentClassDao = new StudentClassDao();

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
                participant.setAccess(null);
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
                    if (Integer.valueOf(1).equals(participant.getAccess())) {
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

                    String applicantStudentID = application.getApplicantStudentID();
                    String counselorID = findCounselorForStudent(applicantStudentID);

                    String inspectionID = "DI" + System.currentTimeMillis();
                    DevelopmentInspection inspection = new DevelopmentInspection(inspectionID, application.getApplicationID(), counselorID, "pending");
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

    private String findCounselorForStudent(String studentID) {
        try {
            List<StudentClass> studentClasses = studentClassDao.findByStudentID(studentID);
            if (!studentClasses.isEmpty()) {
                Integer classId = studentClasses.get(0).getClassID();
                Counselor counselor = counselorDAO.findByClassId(classId);
                if (counselor != null) {
                    String counselorEmployeeID = counselor.getEmployeeID();
                    System.out.println("[DEBUG] Found counselor for student " + studentID +
                            ", classId=" + classId +
                            ", counselor.employeeID=" + counselorEmployeeID +
                            ", counselor.account=" + counselor.getAccount());

                    if (counselorEmployeeID != null && !counselorEmployeeID.isEmpty()) {
                        return counselorEmployeeID;
                    }

                    System.out.println("[ERROR] Counselor employeeID is null or empty!");
                }
                System.out.println("[WARN] No counselor found for classId=" + classId);
            } else {
                System.out.println("[WARN] Student " + studentID + " is not in any class");
            }
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to find counselor for student: " + studentID);
            e.printStackTrace();
        }
        System.out.println("[WARN] Returning null counselor for student: " + studentID);
        return null;
    }


    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
