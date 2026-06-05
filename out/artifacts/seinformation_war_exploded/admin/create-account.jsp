<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<section class="panel">
    <div class="panel-head">
        <div class="panel-title">创建员工账号</div>
        <span class="pill">仅管理员</span>
    </div>
    <form action="adminCreateUser" method="post" class="table-tools" style="flex-wrap: wrap;">
        <input type="text" name="account" placeholder="账号" required>
        <input type="password" name="password" placeholder="密码" required>
        <select name="userType" aria-label="User role" required>
            <option value="1">教师</option>
            <option value="2">辅导员</option>
            <option value="0">管理员</option>
        </select>
        <button class="add-student" type="submit">+ 创建账号</button>
    </form>
    <p style="margin: 12px 0 0; color: #708092; font-size: 12px;">学生可以从登录页面创建自己的账号。教师、辅导员和管理员账号只能在此处创建。</p>
</section>
