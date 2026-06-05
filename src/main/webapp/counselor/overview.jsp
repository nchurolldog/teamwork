<% if ("overview".equals(view)) { %>
<article class="card metric featured span-3"><strong><%= counselorClassRows.size() %></strong><span>管理的班级</span></article>
<article class="card metric span-3"><strong><%= counselorStudentRows.size() %></strong><span>我的学生</span></article>
<article class="card metric warning span-3"><strong><%= partyApplicationCount %></strong><span>入党申请</span></article>
<article class="card metric span-3"><strong><%= scholarshipApplicationCount %></strong><span>奖学金审核</span></article>
<% } %>
