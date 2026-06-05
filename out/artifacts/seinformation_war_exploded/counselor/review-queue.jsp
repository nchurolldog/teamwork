<% if ("overview".equals(view)) { %>
<article class="card span-6">
  <h2>审核队列</h2>
  <div class="info-list">
    <div class="info-row"><span>待审核奖学金</span><strong><%= scholarshipApplicationCount %></strong></div>
    <div class="info-row"><span>待处理入党申请</span><strong><%= partyApplicationCount %></strong></div>
    <div class="info-row"><span>需要关注的学生</span><strong>
      <%
        int attentionCount = 0;
        for (Map<String, Object> row : counselorStudentRows) {
          if ("pending".equalsIgnoreCase(valueText(row.get("party_status")))
                  || "pending".equalsIgnoreCase(valueText(row.get("scholarship_status")))) {
            attentionCount++;
          }
        }
      %><%= attentionCount %>
    </strong></div>
  </div>
</article>
<% } %>
