package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.PartyApprovalDao;
import org.se.model.dao.PartyApplicationDao;
import org.se.model.dao.PersonalInfoDao;
import org.se.model.dao.StudentDAO;
import org.se.model.entity.PartyApproval;
import org.se.model.entity.PartyApplication;
import org.se.model.entity.PersonalInfo;
import org.se.model.entity.Student;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/counselorPartyApproval")
public class CounselorPartyApprovalServlet extends HttpServlet {
    private final PartyApprovalDao partyApprovalDao = new PartyApprovalDao();
    private final PartyApplicationDao partyApplicationDao = new PartyApplicationDao();
    private final StudentDAO studentDAO = new StudentDAO();
    private final PersonalInfoDao personalInfoDao = new PersonalInfoDao();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 2) {
            response.sendRedirect("index.jsp");
            return;
        }

        String approvalID = trimToNull(request.getParameter("approvalID"));
        String action = trimToNull(request.getParameter("action"));

        if (approvalID == null || action == null) {
            response.sendRedirect("counselor.jsp?view=partyApproval&status=failed");
            return;
        }

        PartyApproval approval = partyApprovalDao.findById(approvalID);
        if (approval == null) {
            response.sendRedirect("counselor.jsp?view=partyApproval&status=failed");
            return;
        }

        if ("approve".equals(action)) {
            approval.setStatus("approved");
            partyApprovalDao.update(approval);

            PartyApplication application = partyApplicationDao.findById(approval.getApplicationID());
            if (application != null) {
                application.setStatus("approved");
                partyApplicationDao.update(application);

                Student student = studentDAO.findById(application.getApplicantStudentID());
                if (student != null) {
                    PersonalInfo personalInfo = personalInfoDao.findById(student.getStudentID());
                    if (personalInfo != null) {
                        personalInfo.setPoliticalStatus("党员");
                        personalInfoDao.update(personalInfo);
                    }
                }
            }

            response.sendRedirect("counselor.jsp?view=partyApproval&status=approved&approvalId=" + approvalID);
        } else if ("reject".equals(action)) {
            approval.setStatus("rejected");
            partyApprovalDao.update(approval);

            PartyApplication application = partyApplicationDao.findById(approval.getApplicationID());
            if (application != null) {
                application.setStatus("approval_rejected");
                partyApplicationDao.update(application);
            }

            response.sendRedirect("counselor.jsp?view=partyApproval&status=rejected&approvalId=" + approvalID);
        } else {
            response.sendRedirect("counselor.jsp?view=partyApproval&status=failed");
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
