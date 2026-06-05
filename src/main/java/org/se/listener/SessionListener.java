package org.se.listener;

import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import org.se.model.entity.Users;

@WebListener
public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        System.out.println("[SessionListener] 新会话创建: " + session.getId());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        if (user != null) {
            decreaseOnlineCount(session);
            System.out.println("[SessionListener] 用户登出: " + user.getAccount());
        }

        System.out.println("[SessionListener] 会话销毁: " + session.getId());
    }

    private void decreaseOnlineCount(HttpSession session) {
        Integer onlineCount = (Integer) session.getServletContext().getAttribute("onlineCount");
        if (onlineCount != null && onlineCount > 0) {
            session.getServletContext().setAttribute("onlineCount", onlineCount - 1);
        }
    }
}
