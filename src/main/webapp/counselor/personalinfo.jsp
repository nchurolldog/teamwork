<% if ("overview".equals(view) || "personal".equals(view)) { %>
<article class="card <%= "personal".equals(view) ? "span-12" : "span-4" %>">
    <div class="card-head">
        <h2>个人信息</h2>
        <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>编辑</span></button>
    </div>
    <div class="info-list">
        <div class="info-row"><span>辅导员ID</span><strong><%= textOrDash(employeeID) %></strong></div>
        <div class="info-row"><span>姓名</span><strong><%= counselor == null ? "等待辅导员个人资料" : textOrDash(counselor.getName()) %></strong></div>
        <div class="info-row"><span>性别</span><strong><%= counselor == null ? "-" : genderText(counselor.getGender()) %></strong></div>
        <div class="info-row"><span>角色</span><span class="pill">辅导员</span></div>
    </div>
</article>
<% } %>
