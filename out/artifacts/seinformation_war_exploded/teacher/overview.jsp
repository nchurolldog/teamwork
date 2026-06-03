        <% if ("overview".equals(view)) { %>
          <article class="card metric featured span-3"><strong><%= teacherCourseCount %></strong><span>Courses</span></article>
          <article class="card metric span-3"><strong><%= teacherStudentRows.size() %></strong><span>My Students</span></article>
          <article class="card metric warning span-3"><strong><%= teacherClassRows.size() %></strong><span>Classes</span></article>
          <article class="card metric span-3"><strong><%= teacherGradeCount %></strong><span>Grade Items</span></article>
        <% } %>
