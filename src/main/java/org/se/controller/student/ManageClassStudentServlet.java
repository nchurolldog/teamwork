package org.se.controller.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.ClassEntityDAO;
import org.se.model.dao.CounselorDAO;
import org.se.model.dao.StudentClassDao;
import org.se.model.dao.StudentDAO;
import org.se.model.dao.TeacherDAO;
import org.se.model.entity.ClassEntity;
import org.se.model.entity.Counselor;
import org.se.model.entity.Student;
import org.se.model.entity.StudentClass;
import org.se.model.entity.Teacher;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/manageClassStudent")
public class ManageClassStudentServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final StudentClassDao studentClassDao = new StudentClassDao();
    private final ClassEntityDAO classEntityDAO = new ClassEntityDAO();
    private final TeacherDAO teacherDAO = new TeacherDAO();
    private final CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null
                || (currentUser.getUserType() != 1 && currentUser.getUserType() != 2)) {
            response.sendRedirect("index.jsp");
            return;
        }

        String redirectPage = currentUser.getUserType() == 1 ? "teacher.jsp?view=students" : "counselor.jsp?view=students";
        String action = trimToNull(request.getParameter("action"));
        Integer classID = parseInteger(request.getParameter("classId"));
        String studentID = trimToNull(request.getParameter("studentID"));
        String position = trimToNull(request.getParameter("position"));

        if (action == null || classID == null || studentID == null || !ownsClass(currentUser, classID)) {
            response.sendRedirect(redirectPage + "&manage=failed");
            return;
        }

        boolean success = false;
        if ("add".equals(action)) {
            success = studentDAO.findById(studentID) != null
                    && (studentClassDao.findById(studentID, classID) != null
                    || studentClassDao.insert(new StudentClass(studentID, classID)));
            if (success && position != null) {
                updateStudentPosition(studentID, position);
            }
        } else if ("delete".equals(action)) {
            success = studentClassDao.delete(studentID, classID);
        } else if ("position".equals(action)) {
            success = updateStudentPosition(studentID, position);
        }

        response.sendRedirect(redirectPage + (success ? "&manage=saved" : "&manage=failed"));
    }

    private boolean ownsClass(Users currentUser, Integer classID) {
        ClassEntity classEntity = classEntityDAO.findById(classID);
        if (classEntity == null) {
            return false;
        }
        if (currentUser.getUserType() == 1) {
            Teacher teacher = teacherDAO.findByAccount(currentUser.getAccount());
            return teacher != null && teacher.getEmployeeID().equals(classEntity.getTeacherID());
        }
        Counselor counselor = counselorDAO.findByAccount(currentUser.getAccount());
        return counselor != null && counselor.getEmployeeID().equals(classEntity.getCounselorID());
    }

    private boolean updateStudentPosition(String studentID, String position) {
        Student student = studentDAO.findById(studentID);
        if (student == null || position == null) {
            return false;
        }
        student.setPosition(position);
        return studentDAO.update(student);
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
            return value == null || value.trim().isEmpty() ? null : Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
