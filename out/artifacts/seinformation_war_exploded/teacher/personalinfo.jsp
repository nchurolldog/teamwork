<% if ("overview".equals(view) || "personal".equals(view)) { %>
<article class="card <%= "personal".equals(view) ? "span-12" : "span-4" %>">
    <div class="card-head">
        <h2>个人信息</h2>
        <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>编辑</span></button>
    </div>
    <div class="info-list">
        <div class="info-row"><span>教师ID</span><strong><%= textOrDash(employeeID) %></strong></div>
        <div class="info-row"><span>姓名</span><strong><%= teacher == null ? "等待教师个人资料" : textOrDash(teacher.getName()) %></strong></div>
        <div class="info-row"><span>性别</span><strong><%= teacher == null ? "-" : genderText(teacher.getGender()) %></strong></div>
        <div class="info-row"><span>角色</span><span class="pill">教师</span></div>
    </div>
</article>
<% } %>
