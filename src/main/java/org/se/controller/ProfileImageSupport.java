package org.se.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import org.se.model.dao.ProfileImageDao;
import org.se.model.entity.ProfileImage;

import java.io.File;
import java.io.IOException;
import java.util.Locale;
import java.util.UUID;

class ProfileImageSupport {
    private static final String DEFAULT_AVATAR = "static/img/maomao.jpg";
    private final ProfileImageDao profileImageDao = new ProfileImageDao();

    String resolveAvatarPath(Integer ownerType, String ownerAccount) {
        ProfileImage image = profileImageDao.findByOwner(ownerType, ownerAccount);
        return image == null || image.getImagePath() == null || image.getImagePath().trim().isEmpty()
                ? DEFAULT_AVATAR
                : image.getImagePath();
    }

    boolean saveAvatarIfPresent(HttpServletRequest request, Integer ownerType, String ownerAccount) throws IOException, ServletException {
        Part avatar = request.getPart("avatar");
        if (avatar == null || avatar.getSize() == 0) {
            return true;
        }

        String contentType = avatar.getContentType();
        if (contentType == null || !contentType.toLowerCase(Locale.ROOT).startsWith("image/")) {
            return false;
        }

        String submittedName = new File(avatar.getSubmittedFileName()).getName();
        String extension = extensionOf(submittedName);
        String fileName = ownerType + "_" + ownerAccount + "_" + UUID.randomUUID() + extension;
        String relativePath = "static/upload/avatars/" + fileName;
        String uploadDirPath = request.getServletContext().getRealPath("/static/upload/avatars");
        if (uploadDirPath == null) {
            return false;
        }

        File uploadDir = new File(uploadDirPath);
        if (!uploadDir.exists() && !uploadDir.mkdirs()) {
            return false;
        }

        avatar.write(new File(uploadDir, fileName).getAbsolutePath());
        ProfileImage image = new ProfileImage(null, ownerType, ownerAccount, relativePath, submittedName, contentType, null);
        return profileImageDao.saveOrUpdate(image);
    }

    private String extensionOf(String fileName) {
        if (fileName == null) {
            return ".jpg";
        }
        int dotIndex = fileName.lastIndexOf('.');
        if (dotIndex < 0 || dotIndex == fileName.length() - 1) {
            return ".jpg";
        }
        return fileName.substring(dotIndex).toLowerCase(Locale.ROOT);
    }
}
