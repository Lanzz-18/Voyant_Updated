const QuestTrigger = require("../models/QuestTrigger");
const UserMainQuestProgress = require("../models/MainQuestProgress");
const SubQuest = require("../models/SubQuest");

//Checking for triggers near user location 
exports.checkNearbyTriggers = async (req, res) => {
  try {
    const { userId, lat, lng, radius = 100 } = req.query; 
    
    //convert to numbers for calculations 
    const userLat = parseFloat(lat);
    const userLng = parseFloat(lng);
    const searchRadius = parseInt(radius);
    
    //finding active nearby location triggers
    const nearbyTriggers = await QuestTrigger.find({
      triggerType: 'location',
      isActive: true,
      //triggers within a certain amount of radius within the user 
      'location.coordinates': {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: [userLng, userLat] // mongo uses lng and lat 
          },
          $maxDistance: searchRadius
        }
      }
    }).populate('subQuestId').sort({ priority: -1 });
    
    //filtering triggers based on user conditions
    const availableTriggers = [];
    
    for (const trigger of nearbyTriggers) {
      //trigger check 
      const alreadyTriggered = trigger.triggeredBy.some(
        t => t.userId === userId
      );
      
      //if trigger is one time and it's already triggered, skip
      if (trigger.triggerOnce && alreadyTriggered) {
        continue; 
      }
      
      //check for nessesary quest progress
      if (trigger.subQuestId) {
        const userProgress = await UserMainQuestProgress.findOne({
          userId,
          'subQuestProgress.subQuestId': trigger.subQuestId._id
        });
        
        //skip if quest is completed or locked or user has not started the quest yet
        if (!userProgress || 
            userProgress.status === 'completed' ||
            userProgress.status === 'locked') {
          continue;
        }
        
        //find the sub quest
        const subQuestProgress = userProgress.subQuestProgress.find(
          sq => sq.subQuestId.toString() === trigger.subQuestId._id.toString()
        );
        
        if (!subQuestProgress || subQuestProgress.status !== 'available') {
          continue;
        }
      }
      
      availableTriggers.push({
        triggerId: trigger._id,
        subQuestId: trigger.subQuestId._id,
        triggerType: trigger.triggerType,
        location: trigger.location,
        actions: trigger.actions,
        distance: calculateDistance(
          userLat, userLng,
          trigger.location.coordinates.lat,
          trigger.location.coordinates.lng
        )
      });
    }
    
    res.json({
      triggers: availableTriggers,
      userLocation: { lat: userLat, lng: userLng },
      searchRadius
    });
    
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

//triggering a quest when user enters the quest zone 
exports.activateTrigger = async (req, res) => {
  try {
    const { userId, triggerId, userLocation } = req.body;
    

    //finding the trigger
    const trigger = await QuestTrigger.findById(triggerId).populate('subQuestId');
    
    if (!trigger || !trigger.isActive) {
      return res.status(404).json({ message: "Trigger not found/innactive" });
    }
    const alreadyTriggered = trigger.triggeredBy.some(
      t => t.userId === userId
    );
    
    if (trigger.triggerOnce && alreadyTriggered) {
      return res.status(409).json({ message: "Trigger has been already activated" });
    }
    
    //saving trigger activation 
    trigger.triggeredBy.push({
      userId,
      triggeredAt: new Date()
    });
    
    await trigger.save();
    
    //execute it and enable frontend to work 
    const result = await executeTriggerActions(trigger, userId, userLocation);
    
    res.json({
      message: "Trigger has been activated",
      trigger: {
        id: trigger._id,
        type: trigger.triggerType,
        location: trigger.location
      },
      result
    });
    
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
};