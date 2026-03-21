// UNIFIED QUEST MODEL
// Handles ALL quest types: trip_quest, main_quest, location_quest, npc_quest

const mongoose = require("mongoose");
const taskSchema = require("./Task");

// 🎯 Unified Quest Schema (handles ALL quest types)
const questSchema = new mongoose.Schema({
  // Basic quest info
  title: { type: String, required: true },
  description: { type: String },
  difficulty: {
    type: String,
    enum: ["Easy", "Medium", "Hard"],
    default: "Easy",
  },
  totalXP: { type: Number, required: true },
  
  // Quest type identification
  questType: {
    type: String,
    enum: ["trip_quest", "main_quest", "location_quest", "npc_quest"],
    required: true,
  },
  
  // Location data (for all quest types)
  mapPosition: {
    type: { type: String, default: "Point", enum: ["Point"] },
    coordinates: [Number],
  },
  
  // Trip-specific fields
  tripId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Trip",
    required: function() {
      return this.questType === "trip_quest";
    },
  },
  destinationId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Destination",
    required: function() {
      return this.questType === "trip_quest";
    },
  },
  
  // Main quest specific fields
  mainQuestOrder: {
    type: Number,
    required: function() {
      return this.questType === "main_quest";
    },
  },
  prerequisites: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'UnifiedQuest',
    required: function() {
      return this.questType === "main_quest";
    },
  }],
  estimatedDuration: {
    type: String,
    required: function() {
      return this.questType === "main_quest";
    },
  },
  totalSubQuests: {
    type: Number,
    required: function() {
      return this.questType === "main_quest";
    },
  },
  startingLocation: {
    name: String,
    coordinates: {
      lat: Number,
      lng: Number
    },
    required: function() {
      return this.questType === "main_quest";
    },
  },
  
  // Location quest specific fields
  triggerLocation: {
    name: String,
    coordinates: {
      lat: Number,
      lng: Number
    },
    required: function() {
      return this.questType === "location_quest";
    },
  },
  triggerRadius: {
    type: Number,
    default: 50,
    required: function() {
      return this.questType === "location_quest";
    },
  },
  
  // NPC quest specific fields
  npcId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'NPC',
    required: function() {
      return this.questType === "npc_quest";
    },
  },
  
  // Common fields
  tasks: [taskSchema],
  isActive: {
    type: Boolean,
    default: true,
  },
  rewards: {
    xp: Number,
    items: [String],
    unlocks: [String],
    cosmetics: [String], // Unified rewards system
  },
  
  { timestamps: true },
});

// Indexes for performance
questSchema.index({ mapPosition: "2dsphere" });
questSchema.index({ questType: 1, isActive: 1 });
questSchema.index({ tripId: 1 });

const Quest = mongoose.model("Quest", questSchema);
module.exports = Quest;
