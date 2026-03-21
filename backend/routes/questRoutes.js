// UNIFIED QUEST ROUTES
// Handles ALL quest types: trip quests, main quests, location quests

const express = require("express");
const router = express.Router();
const questController = require("../controllers/questController");
const protect = require("../middleware/authMiddleware");

// 🎯 Apply authentication middleware to all quest routes
router.use(protect);

// 🎯 Unified Quest Endpoints
router.get("/", questController.getAllUserQuests); // Get all user quests
router.get("/:id", questController.getQuestById); // Get specific quest
router.post("/:id/start", questController.startQuest); // Start any quest
router.post("/:id/tasks/:taskId/complete", questController.completeTask); // Complete task
router.get("/triggers/nearby", questController.checkNearbyTriggers); // Location triggers

module.exports = router;
