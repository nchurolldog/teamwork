        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Management Summary</div>
            <span class="pill">Live Data</span>
          </div>
          <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px;">
            <div>
              <div style="font-weight: 800; margin-bottom: 10px;">Account Roles</div>
              <div class="program-list">
                <% if (roleSummaryRows.isEmpty()) { %>
                  <article class="program-card"><div></div><div><strong>No account data</strong><span>-</span></div><div class="program-tag">0</div></article>
                <% } else {
                  for (Map<String, Object> row : roleSummaryRows) {
                %>
                  <article class="program-card">
                    <div class="metric-icon"><i class="fas fa-user-shield"></i></div>
                    <div><strong><%= valueText(row.get("role_name")) %></strong><span>System account role</span></div>
                    <div class="program-tag"><%= valueText(row.get("total_count")) %></div>
                  </article>
                <% }} %>
              </div>
            </div>
            <div>
              <div style="font-weight: 800; margin-bottom: 10px;">Application Status</div>
              <div class="program-list">
                <% if (applicationSummaryRows.isEmpty()) { %>
                  <article class="program-card"><div></div><div><strong>No application data</strong><span>-</span></div><div class="program-tag">0</div></article>
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
