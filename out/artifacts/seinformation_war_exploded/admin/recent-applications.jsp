        <section class="panel">
          <div class="panel-head">
            <div class="panel-title">Recent Applications</div>
            <span class="pill">Scholarship / Party</span>
          </div>
          <div style="display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 14px;">
            <div>
              <div style="font-weight: 800; margin-bottom: 10px;">Scholarship</div>
              <div class="program-list">
                <% if (recentScholarshipRows.isEmpty()) { %>
                  <article class="program-card"><div></div><div><strong>No scholarship applications</strong><span>-</span></div><div class="program-tag">-</div></article>
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
              <div style="font-weight: 800; margin-bottom: 10px;">Party</div>
              <div class="program-list">
                <% if (recentPartyRows.isEmpty()) { %>
                  <article class="program-card"><div></div><div><strong>No party applications</strong><span>-</span></div><div class="program-tag">-</div></article>
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
