package org.se.controller.party;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.PartyApplicationDao;
import org.se.model.dao.StudentDAO;
import org.se.model.entity.PartyApplication;
import org.se.model.entity.Student;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.List;

@WebServlet("/applyParty")
public class ApplyPartyServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final PartyApplicationDao partyApplicationDao = new PartyApplicationDao();

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
        String reason = trimToNull(request.getParameter("reason"));
        String promise = trimToNull(request.getParameter("promise"));

        if (student == null || reason == null || !"true".equals(promise)) {
            response.sendRedirect("student.jsp?view=party&status=failed");
            return;
        }

        List<PartyApplication> applications = partyApplicationDao.findByStudentId(student.getStudentID());
        for (PartyApplication application : applications) {
            if ("pending".equals(application.getStatus()) || "counselor_review".equals(application.getStatus())) {
                response.sendRedirect("student.jsp?view=party&status=duplicate&appId=" + application.getApplicationID());
                return;
            }
        }

        String applicationID = "PA" + System.currentTimeMillis();
        PartyApplication application = new PartyApplication(applicationID, student.getStudentID(), reason, "pending");

        boolean success = partyApplicationDao.insert(application);

        if (success) {
            response.sendRedirect("student.jsp?view=party&status=saved&appId=" + applicationID);
        } else {
            response.sendRedirect("student.jsp?view=party&status=failed");
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
