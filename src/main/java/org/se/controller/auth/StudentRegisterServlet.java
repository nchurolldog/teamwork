package org.se.controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.se.model.dao.UsersDAO;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/studentRegister")
public class StudentRegisterServlet extends HttpServlet {
    private static final int STUDENT_TYPE = 3;
    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String account = request.getParameter("account");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (account == null || password == null || !password.equals(confirmPassword)) {
            response.sendRedirect("index.jsp?error=registerFailed");
            return;
        }

        if (usersDAO.exists(account)) {
            response.sendRedirect("index.jsp?error=duplicate");
            return;
        }

        Users user = new Users(account.trim(), password, STUDENT_TYPE);
        if (usersDAO.insert(user)) {
            response.sendRedirect("index.jsp?success=studentRegistered");
        } else {
            response.sendRedirect("index.jsp?error=registerFailed");
        }
    }
}
