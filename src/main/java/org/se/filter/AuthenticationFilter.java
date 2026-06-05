package org.se.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.se.model.entity.Users;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    private static final List<String> EXCLUDED_PATHS = Arrays.asList(
            "/index.jsp",
            "/login",
            "/studentRegister",
            "/static/",
            ".css",
            ".js",
            ".png",
            ".jpg",
            ".jpeg",
            ".gif",
            ".ico"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[AuthenticationFilter] 登录验证过滤器初始化");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String uri = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = uri.substring(contextPath.length());

        if (isExcluded(path)) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = httpRequest.getSession(false);
        Users currentUser = (session != null) ? (Users) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            httpResponse.sendRedirect(contextPath + "/index.jsp?error=login_required");
            return;
        }

        chain.doFilter(request, response);
    }

    private boolean isExcluded(String path) {
        if (path.isEmpty() || path.equals("/")) {
            return false;
        }

        for (String excluded : EXCLUDED_PATHS) {
            if (path.startsWith(excluded) || path.endsWith(excluded)) {
                return true;
            }
        }

        return false;
    }

    @Override
    public void destroy() {
        System.out.println("[AuthenticationFilter] 登录验证过滤器销毁");
    }
}
