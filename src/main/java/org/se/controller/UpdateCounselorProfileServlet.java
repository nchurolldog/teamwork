package org.se.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.CounselorDAO;
import org.se.model.entity.Counselor;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/updateCounselorProfile")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class UpdateCounselorProfileServlet extends HttpServlet {
    private final CounselorDAO counselorDAO = new CounselorDAO();
    private final ProfileImageSupport profileImageSupport = new ProfileImageSupport();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 2) {
            response.sendRedirect("index.jsp");
            return;
        }

        Counselor existingCounselor = counselorDAO.findByAccount(currentUser.getAccount());
        String employeeID = existingCounselor == null ? trimToNull(request.getParameter("employeeID")) : existingCounselor.getEmployeeID();
        String name = trimToNull(request.getParameter("name"));
        Integer gender = parseInteger(request.getParameter("gender"));

        if (employeeID == null || name == null) {
            response.sendRedirect("counselor.jsp?profile=failed");
            return;
        }

        Counselor counselor = new Counselor(employeeID, currentUser.getAccount(), name, gender);
        boolean profileSaved = existingCounselor == null ? counselorDAO.insert(counselor) : counselorDAO.update(counselor);
        boolean avatarSaved = profileImageSupport.saveAvatarIfPresent(request, currentUser.getUserType(), currentUser.getAccount());

        response.sendRedirect(profileSaved && avatarSaved ? "counselor.jsp?profile=saved" : "counselor.jsp?profile=failed");
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private Integer parseInteger(String value) {
        try {
            return value == null ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
