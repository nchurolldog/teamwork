<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel">
  <div class="panel-head">
    <div class="panel-title">管理概览</div>
    <span class="pill">实时数据</span>
  </div>
  <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px;">
    <div>
      <div style="font-weight: 800; margin-bottom: 10px;">账号角色</div>
      <div class="program-list">
        <% if (roleSummaryRows.isEmpty()) { %>
        <article class="program-card"><div></div><div><strong>无账号数据</strong><span>-</span></div><div class="program-tag">0</div></article>
        <% } else {
          for (Map<String, Object> row : roleSummaryRows) {
        %>
        <article class="program-card">
          <div class="metric-icon"><i class="fas fa-user-shield"></i></div>
          <div><strong><%= valueText(row.get("role_name")) %></strong><span>系统账号角色</span></div>
          <div class="program-tag"><%= valueText(row.get("total_count")) %></div>
        </article>
        <% }} %>
      </div>
    </div>
    <div>
      <div style="font-weight: 800; margin-bottom: 10px;">申请状态</div>
      <div class="program-list">
        <% if (applicationSummaryRows.isEmpty()) { %>
        <article class="program-card"><div></div><div><strong>无申请数据</strong><span>-</span></div><div class="program-tag">0</div></article>
        <% } else {
          for (Map<String, Object> row : applicationSummaryRows) {
        %>
        <article class="program-card">
          <div class="metric-icon"><i class="fas fa-clipboard-check"></i></div>
          <div><strong><%= valueText(row.get("module_name")) %></strong><span><%= valueText(row.get("status")) %></span></div>
          <div class="program-tag"><%= valueText(row.get("total_count")) %></div>
        </article>
        <% }} %>
      </div>
    </div>
  </div>
</section>
