package org.se.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    private static final Map<String, Integer> ROLE_PATH_MAPPING = new HashMap<>();

    static {
        ROLE_PATH_MAPPING.put("/admin/", 0);
        ROLE_PATH_MAPPING.put("/admin.jsp", 0);
        ROLE_PATH_MAPPING.put("/teacher/", 1);
        ROLE_PATH_MAPPING.put("/teacher.jsp", 1);
        ROLE_PATH_MAPPING.put("/counselor/", 2);
        ROLE_PATH_MAPPING.put("/counselor.jsp", 2);
        ROLE_PATH_MAPPING.put("/student/", 3);
        ROLE_PATH_MAPPING.put("/student.jsp", 3);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AuthorizationFilter] 权限验证过滤器初始化");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        Integer requiredRole = getRequiredRole(path);

        if (requiredRole != null) {
            HttpSession session = httpRequest.getSession(false);
            Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;

            if (currentUser == null || currentUser.getUserType() == null) {
                httpResponse.sendRedirect(contextPath + "/index.jsp?error=access_denied");
                return;
            }

            if (!currentUser.getUserType().equals(requiredRole)) {
                httpResponse.sendRedirect(contextPath + "/index.jsp?error=insufficient_permissions");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    private Integer getRequiredRole(String path) {
        for (Map.Entry<String, Integer> entry : ROLE_PATH_MAPPING.entrySet()) {
            if (path.startsWith(entry.getKey()) || path.equals(entry.getKey())) {
                return entry.getValue();
            }
        }
        return null;
    }

    @Override
    public void destroy() {
        System.out.println("[AuthorizationFilter] 权限验证过滤器销毁");
    }
}
