package org.se.controller.auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.UsersDAO;
import org.se.model.entity.Users;
import org.se.util.OnlineUserManager;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final UsersDAO usersDAO = new UsersDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String account = request.getParameter("account");
        String password = request.getParameter("password");

        Users user = usersDAO.login(account, password);
        if (user == null) {
            response.sendRedirect("index.jsp?error=invalid");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("currentUser", user);
        OnlineUserManager.increaseOnlineCount(getServletContext());
        response.sendRedirect(resolveHome(user));
    }

    private String resolveHome(Users user) {
        Integer userType = user.getUserType();
        if (userType == null) {
            return "student.jsp";
        }
        return switch (userType) {
            case 0 -> "admin.jsp";
            case 1 -> "teacher.jsp";
            case 2 -> "counselor.jsp";
            default -> "student.jsp";
        };
    }
}
