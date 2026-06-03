        <% if ("overview".equals(view) || "grades".equals(view)) { %>
        <article class="card <%= "grades".equals(view) ? "span-12" : "span-6" %>" id="grade-work">
          <h2>Grade Work</h2>
          <div class="info-list">
            <div class="info-row"><span>Grade records</span><strong><%= teacherGradeCount %></strong></div>
            <div class="info-row"><span>Courses with updates</span><strong><%= teacherCourseCount %></strong></div>
            <div class="info-row"><span>Students needing attention</span><strong>
              <%
                int supportCount = 0;
                for (Map<String, Object> row : teacherStudentRows) {
                  Object avgGrade = row.get("avg_grade");
                  if (avgGrade instanceof Number && ((Number) avgGrade).doubleValue() < 75) {
                    supportCount++;
                  }
                }
              %><%= supportCount %>
            </strong></div>
          </div>
        </article>
        <% } %>
