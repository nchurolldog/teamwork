<% if ("overview".equals(view)) { %>
<article class="card metric featured span-3"><strong><%= teacherCourseCount %></strong><span>课程数</span></article>
<article class="card metric span-3"><strong><%= teacherStudentRows.size() %></strong><span>我的学生</span></article>
<article class="card metric warning span-3"><strong><%= teacherClassRows.size() %></strong><span>班级数</span></article>
<article class="card metric span-3"><strong><%= teacherGradeCount %></strong><span>成绩项数</span></article>
<% } %>
