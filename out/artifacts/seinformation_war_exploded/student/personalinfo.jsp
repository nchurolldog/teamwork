<% if ("personal".equals(view)) { %>
<article class="card span-12">
    <div class="card-head">
        <h2>个人信息</h2>
        <button class="edit-profile" type="button" id="openProfileEditor"><i class="fas fa-pen-to-square"></i><span>编辑</span></button>
    </div>
    <div class="info-list">
        <div class="info-row"><span>姓名</span><strong><%= student == null ? "等待个人资料数据" : textOrDash(student.getName()) %></strong></div>
        <div class="info-row"><span>学号</span><strong><%= textOrDash(studentID) %></strong></div>
        <div class="info-row"><span>性别</span><strong><%= student == null ? "-" : genderText(student.getGender()) %></strong></div>
        <div class="info-row"><span>职位</span><strong><%= student == null ? "-" : textOrDash(student.getPosition()) %></strong></div>
        <div class="info-row"><span>籍贯</span><strong><%= personalInfo == null ? "-" : textOrDash(personalInfo.getOriginPlace()) %></strong></div>
        <div class="info-row"><span>政治面貌</span><strong><%= personalInfo == null ? "-" : textOrDash(personalInfo.getPoliticalStatus()) %></strong></div>
    </div>
</article>
<% } %>
