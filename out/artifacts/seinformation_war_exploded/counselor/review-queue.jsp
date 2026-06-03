        <% if ("overview".equals(view)) { %>
        <article class="card span-6">
          <h2>Review Queue</h2>
          <div class="info-list">
            <div class="info-row"><span>Scholarship waiting</span><strong><%= scholarshipApplicationCount %></strong></div>
            <div class="info-row"><span>Party applications waiting</span><strong><%= partyApplicationCount %></strong></div>
            <div class="info-row"><span>Students needing attention</span><strong>
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
