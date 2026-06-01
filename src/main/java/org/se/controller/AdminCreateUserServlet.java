package org.se.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.UsersDAO;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.Set;

@WebServlet("/adminCreateUser")
public class AdminCreateUserServlet extends HttpServlet {
    private static final Set<Integer> ADMIN_CREATABLE_TYPES = Set.of(0, 1, 2);
    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 0) {
            response.sendRedirect("index.jsp?error=invalid");
            return;
        }

        String account = request.getParameter("account");
        String password = request.getParameter("password");
        int userType = Integer.parseInt(request.getParameter("userType"));

        if (!ADMIN_CREATABLE_TYPES.contains(userType) || account == null || password == null || usersDAO.exists(account)) {
            response.sendRedirect("admin.jsp?create=failed");
            return;
        }

        Users newUser = new Users(account.trim(), password, userType);
        response.sendRedirect(usersDAO.insert(newUser) ? "admin.jsp?create=success" : "admin.jsp?create=failed");
    }
}
