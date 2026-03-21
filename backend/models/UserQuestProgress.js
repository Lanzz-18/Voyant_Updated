// UNIFIED QUEST PROGRESS MODEL
// Handles progress for ALL quest types

const mongoose = require("mongoose");

// 🎯 Unified Quest Progress Schema
const userQuestProgressSchema = new mongoose.Schema({
  // User identification
  userId: {
    type: String,
    required: true,
    ref: 'User',
  },
  
  // Quest identification
  questId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'UnifiedQuest',
    required: true,
  },
  
  // Quest type for conditional fields
  questType: {
    type: String,
    enum: ["trip_quest", "main_quest", "location_quest", "npc_quest"],
    required: true,
  },
  
  // Progress tracking
  status: {
    type: String,
    enum: ["locked", "available", "in_progress", "completed"],
    default: "locked",
  },
  
  // Task progress (for all quest types)
  taskProgress: [{
    taskId: { type: mongoose.Schema.Types.ObjectId, required: true },
    isCompleted: { type: Boolean, default: false },
    completedAt: { type: Date },
    xpAwarded: { type: Number, default: 0 },
  }],
  
  // Main quest specific fields
  currentSubQuestIndex: {
    type: Number,
    default: 0,
    required: function() {
      return this.questType === "main_quest";
    },
  },
  subQuestProgress: [{
    subQuestId: { type: mongoose.Schema.Types.ObjectId, required: true },
    status: { 
      type: String, 
      enum: ["locked", "available", "in_progress", "completed"], 
      default: "locked" 
    },
    currentDialogueNodeId: String,
    completedDialogueNodes: [String],
    userChoices: [{
      dialogueNodeId: String,
      optionId: String,
      choice: String,
      timestamp: { type: Date, default: Date.now }
    }],
    flags: [String],
    xpEarned: { type: Number, default: 0 }
  }],
  
  // Common progress fields
  totalXPEarned: { type: Number, default: 0 },
  startedAt: { type: Date, default: Date.now },
  completedAt: { type: Date },
  lastPlayedAt: { type: Date, default: Date.now },
  
  { timestamps: true },
});

// Indexes for performance
userQuestProgressSchema.index({ userId: 1, status: 1 });
userQuestProgressSchema.index({ userId: 1, questId: 1 });

const UserQuestProgress = mongoose.model("UserQuestProgress", userQuestProgressSchema);
module.exports = UserQuestProgress;
