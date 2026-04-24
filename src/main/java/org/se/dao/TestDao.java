package org.se.dao;
import org.se.model.entity.Test;
import org.se.model.util.DbUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TestDao {
    public Test query() {
         String sql = "select * from test where id =1";
        try {
            Connection conn = DbUtil.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
            Test test = new Test();
            if (rs.next()) {
                test = new Test();
                test.setId(rs.getInt("id"));
                test.setName(rs.getString("name"));
            }
           return test;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
