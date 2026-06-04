package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.CounselorDAO;
import org.se.model.dao.DevelopmentInspectionDao;
import org.se.model.dao.PartyApprovalDao;
import org.se.model.dao.PartyApplicationDao;
import org.se.model.entity.Counselor;
import org.se.model.entity.DevelopmentInspection;
import org.se.model.entity.PartyApproval;
import org.se.model.entity.PartyApplication;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/counselorDevelopmentInspection")
public class CounselorDevelopmentInspectionServlet extends HttpServlet {
    private final DevelopmentInspectionDao developmentInspectionDao = new DevelopmentInspectionDao();
    private final PartyApplicationDao partyApplicationDao = new PartyApplicationDao();
    private final PartyApprovalDao partyApprovalDao = new PartyApprovalDao();
    private final CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 2) {
            response.sendRedirect("index.jsp");
            return;
        }

        String inspectionID = trimToNull(request.getParameter("inspectionID"));
        String action = trimToNull(request.getParameter("action"));

        if (inspectionID == null || action == null) {
            response.sendRedirect("counselor.jsp?view=developmentInspection&status=failed");
            return;
        }

        DevelopmentInspection inspection = developmentInspectionDao.findById(inspectionID);
        if (inspection == null) {
            response.sendRedirect("counselor.jsp?view=developmentInspection&status=failed");
            return;
        }

        if ("approve".equals(action)) {
            inspection.setStatus("approved");
            developmentInspectionDao.update(inspection);

            PartyApplication application = partyApplicationDao.findById(inspection.getApplicationID());
            if (application != null) {
                application.setStatus("inspection_approved");
                partyApplicationDao.update(application);

                Counselor counselor = counselorDAO.findByAccount(currentUser.getAccount());
                String approverEmployeeID = counselor != null ? counselor.getEmployeeID() : currentUser.getAccount();

                String approvalID = "PA" + System.currentTimeMillis();
                PartyApproval approval = new PartyApproval(approvalID, application.getApplicationID(), approverEmployeeID, "pending");
                partyApprovalDao.insert(approval);
            }

            response.sendRedirect("counselor.jsp?view=developmentInspection&status=approved&inspectionId=" + inspectionID);
        } else if ("reject".equals(action)) {
            inspection.setStatus("rejected");
            developmentInspectionDao.update(inspection);

            PartyApplication application = partyApplicationDao.findById(inspection.getApplicationID());
            if (application != null) {
                application.setStatus("inspection_rejected");
                partyApplicationDao.update(application);
            }

            response.sendRedirect("counselor.jsp?view=developmentInspection&status=rejected&inspectionId=" + inspectionID);
        } else {
            response.sendRedirect("counselor.jsp?view=developmentInspection&status=failed");
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
