package org.se.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.TeacherDAO;
import org.se.model.entity.Teacher;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/updateTeacherProfile")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class UpdateTeacherProfileServlet extends HttpServlet {
    private final TeacherDAO teacherDAO = new TeacherDAO();
    private final ProfileImageSupport profileImageSupport = new ProfileImageSupport();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 1) {
            response.sendRedirect("index.jsp");
            return;
        }

        Teacher existingTeacher = teacherDAO.findByAccount(currentUser.getAccount());
        String employeeID = existingTeacher == null ? trimToNull(request.getParameter("employeeID")) : existingTeacher.getEmployeeID();
        String name = trimToNull(request.getParameter("name"));
        Integer gender = parseInteger(request.getParameter("gender"));

        if (employeeID == null || name == null) {
            response.sendRedirect("teacher.jsp?profile=failed");
            return;
        }

        Teacher teacher = new Teacher(employeeID, currentUser.getAccount(), name, gender);
        boolean profileSaved = existingTeacher == null ? teacherDAO.insert(teacher) : teacherDAO.update(teacher);
        boolean avatarSaved = profileImageSupport.saveAvatarIfPresent(request, currentUser.getUserType(), currentUser.getAccount());

        response.sendRedirect(profileSaved && avatarSaved ? "teacher.jsp?profile=saved" : "teacher.jsp?profile=failed");
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
