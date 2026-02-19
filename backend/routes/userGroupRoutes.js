const express = require("express");
const router = express.router;
const userGroupController = require("../controllers/userGroupController");

// Routes
router
  .route("/id:")
  .post(userGroupController.createGroup)
  .get(userGroupController.getAllGroups);

router
  .route("/")
  .get(userGroupController.getGroupById)
  .get(userGroupController.getUserGroups);
