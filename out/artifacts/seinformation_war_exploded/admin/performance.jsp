<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel">
    <div class="panel-head">
        <div class="panel-title">成绩统计</div>
        <select aria-label="Performance period">
            <option>全部课程</option>
        </select>
    </div>
    <table>
        <thead><tr><th>课程</th><th>记录数</th><th>平均分</th><th>最低分</th><th>最高分</th></tr></thead>
        <tbody>
        <% if (gradeSummaryRows.isEmpty()) { %>
        <tr><td colspan="5">无成绩统计数据。</td></tr>
        <% } else {
            for (Map<String, Object> row : gradeSummaryRows) {
        %>
        <tr>
            <td><%= valueText(row.get("course_name")) %></td>
            <td><%= valueText(row.get("record_count")) %></td>
            <td><span class="pill"><%= valueText(row.get("avg_grade")) %></span></td>
            <td><%= valueText(row.get("min_grade")) %></td>
            <td><%= valueText(row.get("max_grade")) %></td>
        </tr>
        <% }} %>
        </tbody>
    </table>
</section>
