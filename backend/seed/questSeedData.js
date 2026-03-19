const MainQuest = require("../models/MainQuest");
const SubQuest = require("../models/SubQuest");
const QuestTrigger = require("../models/QuestTrigger");


//main quest - Galle
const galleMainQuest = {
  title: "Galle Quest",
  description: "Explore the historic coastal city of Galle and uncover its mysteries with the Adventurer's Guild. ",
  location: "galle",
  isMainQuest: true,
  questOrder: 1,
  prerequisites: [],
  estimatedDuration: "3 -4 hours",
  totalSubQuests: 5,
  isAvailable: true,
  startingLocation: {
    name: "Galle Fort",
    coordinates: { lat: 6.0236, lng: 80.2172 }
  },
  rewards: {
    xp: 500,
    items: ["Established Membership Badge", "Mysterious Map Fragment"],
    //unlocks something else as well 
  }
};