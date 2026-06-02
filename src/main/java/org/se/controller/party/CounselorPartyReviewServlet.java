package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.*;
import org.se.model.entity.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/counselorPartyReview")
public class CounselorPartyReviewServlet extends HttpServlet {
    private final PartyApplicationDao partyApplicationDao = new PartyApplicationDao();
    private final CounselorApprovalDao counselorApprovalDao = new CounselorApprovalDao();
    private final DemocraticReviewDao democraticReviewDao = new DemocraticReviewDao();
    private final DemocraticReviewParticipantDao participantDao = new DemocraticReviewParticipantDao();
    private final DashboardDao dashboardDao = new DashboardDao();
    private final StudentClassDao studentClassDao = new StudentClassDao();
    private final TeacherDAO teacherDAO = new TeacherDAO();
    private final StudentDAO studentDAO = new StudentDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 2) {
            response.sendRedirect("index.jsp");
            return;
        }

        String applicationID = trimToNull(request.getParameter("applicationID"));
        String action = trimToNull(request.getParameter("action"));

        if (applicationID == null || action == null) {
            response.sendRedirect("counselor.jsp?view=partyReview&status=failed");
            return;
        }

        PartyApplication application = partyApplicationDao.findById(applicationID);
        if (application == null) {
            response.sendRedirect("counselor.jsp?view=partyReview&status=failed");
            return;
        }

        String counselorID = currentUser.getAccount();

        if ("approve".equals(action)) {
            application.setStatus("counselor_approved");
            partyApplicationDao.update(application);

            CounselorApproval approval = new CounselorApproval(applicationID, counselorID, true);
            counselorApprovalDao.insert(approval);

            Student applicant = studentDAO.findById(application.getApplicantStudentID());
            if (applicant != null) {
                List<StudentClass> studentClasses = studentClassDao.findByStudentID(applicant.getStudentID());
                if (!studentClasses.isEmpty()) {
                    Integer classId = studentClasses.get(0).getClassID();
                    Teacher teacher = teacherDAO.findByClassId(classId);

                    if (teacher != null) {
                        String reviewID = "DR" + System.currentTimeMillis();
                        DemocraticReview review = new DemocraticReview(reviewID, applicationID, teacher.getEmployeeID(), "pending");
                        democraticReviewDao.insert(review);

                        List<Map<String, Object>> classmates = dashboardDao.findClassmates(applicant.getStudentID());
                        for (Map<String, Object> classmate : classmates) {
                            String classmateID = String.valueOf(classmate.get("student_id"));
                            if (!classmateID.equals(applicant.getStudentID())) {
                                DemocraticReviewParticipant participant = new DemocraticReviewParticipant(reviewID, classmateID, false);
                                participantDao.insert(participant);
                            }
                        }
                    }
                }
            }

            response.sendRedirect("counselor.jsp?view=partyReview&status=approved&appId=" + applicationID);
        } else if ("reject".equals(action)) {
            application.setStatus("rejected");
            partyApplicationDao.update(application);

            CounselorApproval approval = new CounselorApproval(applicationID, counselorID, false);
            counselorApprovalDao.insert(approval);

            response.sendRedirect("counselor.jsp?view=partyReview&status=rejected&appId=" + applicationID);
        } else {
            response.sendRedirect("counselor.jsp?view=partyReview&status=failed");
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
