<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel">
  <div class="panel-head">
    <div class="panel-title">最近申请</div>
    <span class="pill">奖学金 / 入党</span>
  </div>
  <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px;">
    <div>
      <div style="font-weight: 800; margin-bottom: 10px;">奖学金</div>
      <div class="program-list">
        <% if (recentScholarshipRows.isEmpty()) { %>
        <article class="program-card"><div></div><div><strong>无奖学金申请</strong><span>-</span></div><div class="program-tag">-</div></article>
        <% } else {
          for (Map<String, Object> row : recentScholarshipRows) {
        %>
        <article class="program-card">
          <div class="metric-icon"><i class="fas fa-award"></i></div>
          <div><strong><%= valueText(row.get("name")) %></strong><span><%= valueText(row.get("student_id")) %> / <%= valueText(row.get("class_name")) %></span><span><%= valueText(row.get("type_code")) %> - <%= valueText(row.get("amount")) %></span></div>
          <div class="program-tag"><%= valueText(row.get("status")) %></div>
        </article>
        <% }} %>
      </div>
    </div>
    <div>
      <div style="font-weight: 800; margin-bottom: 10px;">入党</div>
      <div class="program-list">
        <% if (recentPartyRows.isEmpty()) { %>
        <article class="program-card"><div></div><div><strong>无入党申请</strong><span>-</span></div><div class="program-tag">-</div></article>
        <% } else {
          for (Map<String, Object> row : recentPartyRows) {
        %>
        <article class="program-card">
          <div class="metric-icon"><i class="fas fa-flag"></i></div>
          <div><strong><%= valueText(row.get("name")) %></strong><span><%= valueText(row.get("student_id")) %> / <%= valueText(row.get("class_name")) %></span><span><%= valueText(row.get("application_id")) %></span></div>
          <div class="program-tag"><%= valueText(row.get("status")) %></div>
        </article>
        <% }} %>
      </div>
    </div>
  </div>
</section>
