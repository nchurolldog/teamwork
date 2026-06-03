        <% if ("overview".equals(view)) { %>
          <article class="card metric featured span-3"><strong><%= counselorClassRows.size() %></strong><span>Managed Classes</span></article>
          <article class="card metric span-3"><strong><%= counselorStudentRows.size() %></strong><span>My Students</span></article>
          <article class="card metric warning span-3"><strong><%= partyApplicationCount %></strong><span>Party Applications</span></article>
          <article class="card metric span-3"><strong><%= scholarshipApplicationCount %></strong><span>Scholarship Reviews</span></article>
        <% } %>
