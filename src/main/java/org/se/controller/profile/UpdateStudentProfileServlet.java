package org.se.controller.profile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.FamilyInfoDao;
import org.se.model.dao.PersonalInfoDao;
import org.se.model.dao.StudentDAO;
import org.se.model.entity.FamilyInfo;
import org.se.model.entity.PersonalInfo;
import org.se.model.entity.Student;
import org.se.model.entity.Users;

import java.io.IOException;

@WebServlet("/updateStudentProfile")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024, maxRequestSize = 3 * 1024 * 1024)
public class UpdateStudentProfileServlet extends HttpServlet {
    private final StudentDAO studentDAO = new StudentDAO();
    private final PersonalInfoDao personalInfoDao = new PersonalInfoDao();
    private final FamilyInfoDao familyInfoDao = new FamilyInfoDao();
    private final ProfileImageSupport profileImageSupport = new ProfileImageSupport();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users currentUser = session == null ? null : (Users) session.getAttribute("currentUser");

        if (currentUser == null || currentUser.getUserType() == null || currentUser.getUserType() != 3) {
            response.sendRedirect("index.jsp");
            return;
        }

        String account = currentUser.getAccount();
        Student existingStudent = studentDAO.findByAccount(account);
        String studentID = existingStudent == null ? trimToNull(request.getParameter("studentID")) : existingStudent.getStudentID();
        String name = trimToNull(request.getParameter("name"));
        Integer gender = parseInteger(request.getParameter("gender"));
        String position = trimToNull(request.getParameter("position"));
        String originPlace = trimToNull(request.getParameter("originPlace"));
        String politicalStatus = trimToNull(request.getParameter("politicalStatus"));
        String homeAddress = trimToNull(request.getParameter("homeAddress"));
        Integer familySize = parseInteger(request.getParameter("familySize"));
        String familyPhone = trimToNull(request.getParameter("familyPhone"));

        if (studentID == null || name == null) {
            response.sendRedirect("student.jsp?profile=failed");
            return;
        }

        Student student = new Student(studentID, account, name, gender, position);
        boolean studentSaved = existingStudent == null ? studentDAO.insert(student) : studentDAO.update(student);

        PersonalInfo personalInfo = new PersonalInfo(studentID, originPlace, politicalStatus);
        boolean personalSaved = personalInfoDao.findById(studentID) == null
                ? personalInfoDao.insert(personalInfo)
                : personalInfoDao.update(personalInfo);

        FamilyInfo familyInfo = new FamilyInfo(studentID, homeAddress, familySize, familyPhone);
        boolean familySaved = familyInfoDao.findById(studentID) == null
                ? familyInfoDao.insert(familyInfo)
                : familyInfoDao.update(familyInfo);

        boolean avatarSaved = profileImageSupport.saveAvatarIfPresent(request, currentUser.getUserType(), currentUser.getAccount());

        response.sendRedirect(studentSaved && personalSaved && familySaved && avatarSaved
                ? "student.jsp?profile=saved"
                : "student.jsp?profile=failed");
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
