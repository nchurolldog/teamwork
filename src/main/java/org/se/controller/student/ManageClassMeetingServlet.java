package org.se.controller.student;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.dao.ClassEntityDAO;
import org.se.model.dao.ClassMeetingAssociationDAO;
import org.se.model.dao.ClassMeetingDAO;
import org.se.model.dao.StudentClassDao;
import org.se.model.entity.ClassMeeting;
import org.se.model.entity.ClassMeetingAssociation;
import org.se.model.entity.Student;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.List;

@WebServlet("/manageClassMeeting")
public class ManageClassMeetingServlet extends HttpServlet {
    private ClassMeetingDAO classMeetingDAO = new ClassMeetingDAO();
    private StudentClassDao studentClassDao = new StudentClassDao();
    private ClassEntityDAO classEntityDAO = new ClassEntityDAO();
    private ClassMeetingAssociationDAO associationDAO = new ClassMeetingAssociationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("currentUser");

        if (currentUser == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Allow students (3), counselors (2), and admins (0) to manage meetings
        Integer userType = currentUser.getUserType();
        if (userType != 3 && userType != 2 && userType != 0) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            handleDelete(request, response, currentUser);
        } else if ("edit".equals(action)) {
            handleEdit(request, response, currentUser);
        } else {
            // Redirect based on user type
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings");
            } else {
                response.sendRedirect("admin-class-meetings.jsp");
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

        // Allow students (3), counselors (2), and admins (0) to manage meetings
        Integer userType = currentUser.getUserType();
        if (userType != 3 && userType != 2 && userType != 0) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("create".equals(action)) {
            handleCreate(request, response, currentUser);
        } else if ("update".equals(action)) {
            handleUpdate(request, response, currentUser);
        } else {
            // Redirect based on user type
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings");
            } else {
                response.sendRedirect("admin-class-meetings.jsp");
            }
        }
    }

    private void handleCreate(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws IOException {
        String meetingID = request.getParameter("meetingID");
        Integer classID = Integer.parseInt(request.getParameter("classID"));
        String meetingTheme = request.getParameter("meetingTheme");
        String classroom = request.getParameter("classroom");

        ClassMeeting meeting = new ClassMeeting(meetingID, classID, meetingTheme, classroom);
        boolean success = classMeetingDAO.insert(meeting);

        if (success) {
            Integer userType = currentUser.getUserType();
            
            // 只有学生（如班长）才能作为班会组织者保存到关联表
            if (userType == 3) {
                // 需要从 student 表中查询学生的 student_id
                org.se.model.dao.StudentDAO studentDAO = new org.se.model.dao.StudentDAO();
                org.se.model.entity.Student student = studentDAO.findByAccount(currentUser.getAccount());
                
                if (student != null) {
                    ClassMeetingAssociation association = new ClassMeetingAssociation(meetingID, student.getStudentID());
                    associationDAO.insert(association);
                }
                
                response.sendRedirect("student.jsp?view=meetings&status=created");
            } else if (userType == 2) {
                // 辅导员创建会议，不保存关联记录
                response.sendRedirect("counselor.jsp?view=meetings&meetingStatus=created");
            } else {
                // 管理员创建会议，不保存关联记录
                response.sendRedirect("admin.jsp?meetingStatus=created");
            }
        } else {
            Integer userType = currentUser.getUserType();
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings&status=error");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings&meetingStatus=error");
            } else {
                response.sendRedirect("admin.jsp?meetingStatus=error");
            }
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws IOException {
        String meetingID = request.getParameter("meetingID");
        Integer classID = Integer.parseInt(request.getParameter("classID"));
        String meetingTheme = request.getParameter("meetingTheme");
        String classroom = request.getParameter("classroom");

        ClassMeeting meeting = new ClassMeeting(meetingID, classID, meetingTheme, classroom);
        boolean success = classMeetingDAO.update(meeting);

        if (success) {
            Integer userType = currentUser.getUserType();
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings&status=updated");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings&meetingStatus=updated");
            } else {
                response.sendRedirect("admin.jsp?meetingStatus=updated");
            }
        } else {
            Integer userType = currentUser.getUserType();
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings&status=error");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings&meetingStatus=error");
            } else {
                response.sendRedirect("admin.jsp?meetingStatus=error");
            }
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws IOException {
        String meetingID = request.getParameter("meetingID");
        boolean success = classMeetingDAO.delete(meetingID);

        if (success) {
            associationDAO.deleteByMeetingId(meetingID);
            
            Integer userType = currentUser.getUserType();
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings&status=deleted");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings&meetingStatus=deleted");
            } else {
                response.sendRedirect("admin.jsp?meetingStatus=deleted");
            }
        } else {
            Integer userType = currentUser.getUserType();
            if (userType == 3) {
                response.sendRedirect("student.jsp?view=meetings&status=error");
            } else if (userType == 2) {
                response.sendRedirect("counselor.jsp?view=meetings&meetingStatus=error");
            } else {
                response.sendRedirect("admin.jsp?meetingStatus=error");
            }
        }
    }

    private void handleEdit(HttpServletRequest request, HttpServletResponse response, Users currentUser) throws IOException {
        String meetingID = request.getParameter("meetingID");
    
        Integer userType = currentUser.getUserType();
        if (userType == 3) {
            response.sendRedirect("student.jsp?view=meetings&edit=" + meetingID);
        } else if (userType == 2) {
            response.sendRedirect("counselor.jsp?view=meetings&edit=" + meetingID);
        } else {
            response.sendRedirect("admin.jsp?edit=" + meetingID);
        }
    }
}
