<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="metrics">
          <article class="metric-card featured">
            <div class="metric-icon"><i class="fas fa-users"></i></div>
            <strong><%= studentCount %></strong>
            <span>学生总数</span>
          </article>
          <article class="metric-card">
            <div class="metric-icon"><i class="fas fa-compass"></i></div>
            <strong><%= teacherCount %></strong>
            <span>教师总数</span>
          </article>
          <article class="metric-card">
            <div class="metric-icon"><i class="fas fa-award"></i></div>
            <strong><%= counselorCount %></strong>
            <span>辅导员总数</span>
          </article>
          <article class="metric-card">
            <div class="metric-icon"><i class="fas fa-lightbulb"></i></div>
            <strong><%= classCount %></strong>
            <span>班级总数</span>
          </article>
        </div>
