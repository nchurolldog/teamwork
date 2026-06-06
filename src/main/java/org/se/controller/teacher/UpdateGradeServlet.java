package org.se.controller.teacher;

import org.se.model.dao.GradeDao;
import org.se.model.entity.Grade;
import org.se.model.entity.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;

@WebServlet("/updateGrade")
public class UpdateGradeServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");
        
        if (currentUser == null || currentUser.getUserType() != 1) {
            response.sendRedirect("index.jsp");
            return;
        }

        String studentID = request.getParameter("studentID");
        String courseID = request.getParameter("courseID");
        String regularWeightStr = request.getParameter("regularWeight");
        String regularGradeStr = request.getParameter("regularGrade");
        String finalGradeStr = request.getParameter("finalGrade");

        if (studentID == null || courseID == null || regularWeightStr == null || 
            regularGradeStr == null || finalGradeStr == null) {
            response.sendRedirect("teacher.jsp?view=grades&error=missing_fields");
            return;
        }

        try {
            BigDecimal regularWeight = new BigDecimal(regularWeightStr);
            BigDecimal regularGrade = new BigDecimal(regularGradeStr);
            BigDecimal finalGrade = new BigDecimal(finalGradeStr);

            if (regularWeight.compareTo(BigDecimal.ZERO) < 0 || regularWeight.compareTo(new BigDecimal("100")) > 0) {
                response.sendRedirect("teacher.jsp?view=grades&error=invalid_weight");
                return;
            }

            if (regularGrade.compareTo(BigDecimal.ZERO) < 0 || regularGrade.compareTo(new BigDecimal("100")) > 0) {
                response.sendRedirect("teacher.jsp?view=grades&error=invalid_regular");
                return;
            }

            if (finalGrade.compareTo(BigDecimal.ZERO) < 0 || finalGrade.compareTo(new BigDecimal("100")) > 0) {
                response.sendRedirect("teacher.jsp?view=grades&error=invalid_final");
                return;
            }

            BigDecimal finalWeight = new BigDecimal("100").subtract(regularWeight);
            BigDecimal totalGrade = regularWeight.multiply(regularGrade)
                    .add(finalWeight.multiply(finalGrade))
                    .divide(new BigDecimal("100"), 2, RoundingMode.HALF_UP);

            GradeDao gradeDao = new GradeDao();
            Grade existingGrade = gradeDao.findById(studentID, courseID);

            Grade grade = new Grade();
            grade.setStudentID(studentID);
            grade.setCourseID(courseID);
            grade.setRegularWeight(regularWeight);
            grade.setRegularGrade(regularGrade);
            grade.setFinalGrade(finalGrade);
            grade.setTotalGrade(totalGrade);

            boolean success;
            if (existingGrade != null) {
                success = gradeDao.update(grade);
            } else {
                success = gradeDao.insert(grade);
            }

            if (success) {
                response.sendRedirect("teacher.jsp?view=grades&status=success");
            } else {
                response.sendRedirect("teacher.jsp?view=grades&error=save_failed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("teacher.jsp?view=grades&error=invalid_number");
        }
    }
}