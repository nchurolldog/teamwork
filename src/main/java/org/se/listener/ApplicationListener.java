package org.se.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class ApplicationListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();

        context.setAttribute("appName", "SE Information System");
        context.setAttribute("version", "1.0.0");
        context.setAttribute("onlineCount", 0);

        System.out.println("===========================================");
        System.out.println("[ApplicationListener] 应用启动成功");
        System.out.println("[ApplicationListener] 应用名称: " + context.getAttribute("appName"));
        System.out.println("[ApplicationListener] 版本: " + context.getAttribute("version"));
        System.out.println("[ApplicationListener] 部署路径: " + context.getContextPath());
        System.out.println("===========================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("===========================================");
        System.out.println("[ApplicationListener] 应用关闭");
        System.out.println("===========================================");
    }
}
