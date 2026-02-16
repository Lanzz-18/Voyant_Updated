const DestinationData = require("../models/Destination.js");
const SkillData = require("../models/Destination.js");

// Destination
exports.getDestinationDetails = async (req, res) => {
  try {
    // Reading the destnation
    const destination = await DestinationData.findById(req.params.id);
    if (!destination) {
      return res.status(404).json({
        status: "fail",
        message: "Destination not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: { destination },
    });
  } catch (err) {
    res.status(400).json({
      status: "fail",
      message: err.message,
    });
  }
};

exports.getAllDestinations = async (req, res) => {
  const destinations = await DestinationData.find({ active: { $ne: false } });
};

// Skills
exports.getSkillsDetails = async (req, res) => {
  try {
    // Reading the skill
    const skillData = await skillData.findById(req.params.id);
    if (!skillData) {
      return res.status(404).json({
        status: "fail",
        message: "Skill not found",
      });
    }

    res.status(200).json({
      status: "success",
      data: { skillData },
    });
  } catch (err) {
    res.status(400).json({
      status: "fail",
      message: err.message,
    });
  }
};

exports.getAllSkills = async (req, res) => {
  const skillsData = await SkillData.find({ active: { $ne: false } });
};
