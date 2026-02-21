const express = require("express");
const router = express.Router();
const userGroupController = require("../controllers/userGroupController");

// Routes
router
  .route("/:id")
  .post(userGroupController.createGroup)
  .get(userGroupController.getAllGroups);

router.get("/", userGroupController.getGroupById);
router.get("/", userGroupController.getUserGroups);
