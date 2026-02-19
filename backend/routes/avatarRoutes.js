const express = require("express");
const router = express.router;
const avatarController = require("../controllers/avatarController");

// Routes
router
  .route("/id:")
  .get(avatarController.getAvatar)
  .patch(avatarController.updateAvatar)
  .patch(avatarController.updateCosmetics)
  .delete(avatarController.deleteAvatar);

router
  .route("/")
  .post(avatarController.createAvatar)
  .get(avatarController.getAllAvatars);
