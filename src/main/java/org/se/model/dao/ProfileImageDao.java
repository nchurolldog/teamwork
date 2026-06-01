package org.se.model.dao;

import org.se.model.entity.ProfileImage;
import org.se.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class ProfileImageDao {

    public boolean saveOrUpdate(ProfileImage image) {
        ProfileImage existing = findByOwner(image.getOwnerType(), image.getOwnerAccount());
        return existing == null ? insert(image) : update(image);
    }

    public boolean insert(ProfileImage image) {
        String sql = "INSERT INTO profile_image (owner_type, owner_account, image_path, original_name, content_type, updated_at) VALUES (?, ?, ?, ?, ?, NOW())";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, image.getOwnerType());
            pstmt.setString(2, image.getOwnerAccount());
            pstmt.setString(3, image.getImagePath());
            pstmt.setString(4, image.getOriginalName());
            pstmt.setString(5, image.getContentType());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(ProfileImage image) {
        String sql = "UPDATE profile_image SET image_path = ?, original_name = ?, content_type = ?, updated_at = NOW() WHERE owner_type = ? AND owner_account = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, image.getImagePath());
            pstmt.setString(2, image.getOriginalName());
            pstmt.setString(3, image.getContentType());
            pstmt.setObject(4, image.getOwnerType());
            pstmt.setString(5, image.getOwnerAccount());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public ProfileImage findByOwner(Integer ownerType, String ownerAccount) {
        String sql = "SELECT * FROM profile_image WHERE owner_type = ? AND owner_account = ?";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setObject(1, ownerType);
            pstmt.setString(2, ownerAccount);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private ProfileImage mapRow(ResultSet rs) throws SQLException {
        ProfileImage image = new ProfileImage();
        image.setImageID(rs.getInt("image_id"));
        image.setOwnerType(rs.getInt("owner_type"));
        image.setOwnerAccount(rs.getString("owner_account"));
        image.setImagePath(rs.getString("image_path"));
        image.setOriginalName(rs.getString("original_name"));
        image.setContentType(rs.getString("content_type"));
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        image.setUpdatedAt(updatedAt == null ? null : updatedAt.toLocalDateTime());
        return image;
    }
}
