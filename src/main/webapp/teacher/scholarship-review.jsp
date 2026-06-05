<% if ("scholarshipReview".equals(view)) { %>
<article class="card span-12">
  <h2>奖学金审核</h2>
  <table>
    <thead><tr><th>申请</th><th>学生</th><th>班级</th><th>类型</th><th>详情</th><th>状态</th><th>审核</th></tr></thead>
    <tbody>
    <% if (teacherScholarshipReviewRows.isEmpty()) { %>
    <tr><td colspan="7">无奖学金审核任务。</td></tr>
    <% } else {
      for (Map<String, Object> row : teacherScholarshipReviewRows) {
    %>
    <tr>
      <td><%= valueText(row.get("app_id")) %></td>
      <td><%= valueText(row.get("name")) %> (<%= valueText(row.get("student_id")) %>)</td>
      <td><%= valueText(row.get("class_name")) %></td>
      <td><%= valueText(row.get("type_code")) %></td>
      <td>
        <button class="small-btn js-detail" type="button"
                data-title="教师审核详情"
                data-application="<%= attrValue(row.get("app_id")) %>"
                data-applicant="<%= attrValue(row.get("name")) %> (<%= attrValue(row.get("student_id")) %>)"
                data-class="<%= attrValue(row.get("class_name")) %>"
                data-scholarship="<%= attrValue(row.get("type_code")) %>"
                data-status="<%= attrValue(row.get("status")) %>"
                data-amount="<%= attrValue(row.get("requested_amount")) %>"
                data-family="<%= attrValue(row.get("family_situation")) %>"
                data-score="<%= attrValue(row.get("academic_score")) %>"
                data-conduct="<%= attrValue(row.get("conduct_evaluation")) %>"
                data-honors="<%= attrValue(row.get("honors")) %>"
                data-reason="<%= attrValue(row.get("application_reason")) %>"
                data-materials="<%= attrValue(row.get("supporting_materials")) %>">查看详情</button>
      </td>
      <td><span class="pill"><%= valueText(row.get("status")) %></span></td>
      <td>
        <% if ("pending".equals(valueText(row.get("status")))) { %>
        <form class="inline-form" action="scholarshipTeacherReview" method="post">
          <input type="hidden" name="reviewID" value="<%= valueText(row.get("review_id")) %>">
          <input type="hidden" name="appID" value="<%= valueText(row.get("app_id")) %>">
          <input type="text" name="comment" placeholder="评语">
          <button class="small-btn" type="submit" name="decision" value="agree">同意</button>
          <button class="small-btn danger" type="submit" name="decision" value="disagree">拒绝</button>
        </form>
        <% } else { %>
        <span class="pill"><%= valueText(row.get("comment")) %></span>
        <% } %>
      </td>
    </tr>
    <% }} %>
    </tbody>
  </table>
</article>
<% } %>
