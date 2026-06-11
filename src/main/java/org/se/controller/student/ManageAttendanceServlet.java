package org.se.controller.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.AttendanceRecordDAO;
import org.se.model.dao.AttendancePublishDAO;
import org.se.model.dao.ClassMeetingDAO;
import org.se.model.entity.AttendancePublish;
import org.se.model.entity.AttendanceRecord;
import org.se.model.entity.ClassMeeting;
import org.se.model.entity.Users;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/manageAttendance")
public class ManageAttendanceServlet extends HttpServlet {
    private AttendanceRecordDAO recordDAO = new AttendanceRecordDAO();
    private AttendancePublishDAO publishDAO = new AttendancePublishDAO();
    private ClassMeetingDAO meetingDAO = new ClassMeetingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Integer userType = currentUser.getUserType();
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            handleDelete(request, response, currentUser);
        } else {
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=attendance");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=attendance");
            } else {
                response.sendRedirect("index.jsp");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        Integer userType = currentUser.getUserType();
        if (userType != 3 && userType != 2) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("submit".equals(action)) {
            handleSubmit(request, response, currentUser);
        } else {
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=attendance");
            } else {
                response.sendRedirect("counselor.jsp?view=attendance");
            }
        }
    }

    private void handleSubmit(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws IOException {
        String meetingID = request.getParameter("meetingID");

        ClassMeeting meeting = meetingDAO.findById(meetingID);
        if (meeting == null) {
            redirectWithStatus(request, response, currentUser, "error");
            return;
        }

        try {
            String attendanceDateStr = request.getParameter("attendanceDate");
            LocalDate attendanceDate = (attendanceDateStr != null && !attendanceDateStr.trim().isEmpty())
                    ? LocalDate.parse(attendanceDateStr)
                    : LocalDate.now();

            String[] studentIDs = request.getParameterValues("studentID");
            if (studentIDs == null || studentIDs.length == 0) {
                redirectWithStatus(request, response, currentUser, "noStudents");
                return;
            }

            publishDAO.deleteByMeetingId(meetingID);
            recordDAO.deleteByMeetingId(meetingID);

            for (String studentID : studentIDs) {
                String absentParam = request.getParameter("absent_" + studentID);
                boolean isAbsent = "1".equals(absentParam);

                int recordID = generateRecordID();

                AttendanceRecord record = new AttendanceRecord();
                record.setRecordID(recordID);
                record.setStudentID(studentID);
                record.setAttendanceDate(attendanceDate);
                record.setAbsent(isAbsent);
                recordDAO.insert(record);

                AttendancePublish publish = new AttendancePublish();
                publish.setRecordID(recordID);
                publish.setMeetingID(meetingID);
                publish.setStudentID(studentID);
                publishDAO.insert(publish);
            }

            redirectWithStatus(request, response, currentUser, "saved");
        } catch (Exception e) {
            e.printStackTrace();
            redirectWithStatus(request, response, currentUser, "error");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws IOException {
        String recordIDStr = request.getParameter("recordID");
        try {
            int recordID = Integer.parseInt(recordIDStr);
            publishDAO.delete(recordID);
            recordDAO.delete(recordID);
            redirectWithStatus(request, response, currentUser, "deleted");
        } catch (NumberFormatException e) {
            redirectWithStatus(request, response, currentUser, "error");
        }
    }

    private int generateRecordID() {
        List<AttendanceRecord> all = recordDAO.findAll();
        int maxID = 0;
        if (all != null) {
            for (AttendanceRecord r : all) {
                if (r.getRecordID() != null && r.getRecordID() > maxID) {
                    maxID = r.getRecordID();
                }
            }
        }
        return maxID + 1;
    }

    private void redirectWithStatus(HttpServletRequest request, HttpServletResponse response, Users currentUser, String status) throws IOException {
        Integer userType = currentUser.getUserType();
        if (userType == 3) {
            response.sendRedirect("student.jsp?view=attendance&attendanceStatus=" + status);
        } else if (userType == 2) {
            response.sendRedirect("counselor.jsp?view=attendance&attendanceStatus=" + status);
        } else {
            response.sendRedirect("index.jsp");
        }
    }
}