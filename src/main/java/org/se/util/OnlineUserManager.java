package org.se.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSession;

public class OnlineUserManager {

    public static void increaseOnlineCount(ServletContext context) {
        synchronized (context) {
            Integer count = (Integer) context.getAttribute("onlineCount");
            if (count == null) {
                count = 0;
            }
            context.setAttribute("onlineCount", count + 1);
        }
    }

    public static void decreaseOnlineCount(ServletContext context) {
        synchronized (context) {
            Integer count = (Integer) context.getAttribute("onlineCount");
            if (count != null && count > 0) {
                context.setAttribute("onlineCount", count - 1);
            }
        }
    }

    public static int getOnlineCount(ServletContext context) {
        Integer count = (Integer) context.getAttribute("onlineCount");
        return count != null ? count : 0;
    }
}
