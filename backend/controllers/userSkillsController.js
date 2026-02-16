const SkillData = require("../models/Destination.js");

exports.createSkill = async (req, res) => {
  try {
    // Creating destination
    const newDestination = await SkillData.create(req.body);
    res.status(201).json({
      status: "success",
      data: { destination: newDestination },
    });
  } catch (err) {
    res.status(400).json({
      status: "fail",
      message: err.message,
    });
  }
};

exports.getUserSkillData = async (req, res) => {
  try {
    // Reading the destnation
    const destination = await SkillData.findById(req.params.id);
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

exports.updateUserSkillData = async (req, res) => {
  try {
    // Updating destination
    const updatedDestination = await SkillData.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true },
    );

    // Checking if destination exists
    if (!updatedDestinationn) {
      return res.status(404).json({
        status: "fail",
        message: "Destination not found",
      });
    }
  } catch (err) {
    res.status(400).json({
      status: "fail",
      message: err.message,
    });
  }
};

exports.deleteUserSkillData = async (req, res) => {
  try {
    const destination = await SkillData.findById(req.params.id);
    // Checking if document exists before deleting
    if (!destination) {
      return res.status(404).json({
        status: "fail",
        message: "Destination not found",
      });
    }
    // Logging the data deleted
    console.log(destination);

    // Authentication check
    if (destination.createdBy.toString() !== req.user.id) {
      return res.status(403).json({
        status: "fail",
        message: "You do not have permission to delete this destination",
      });
    }

    // Deletion
    await destination.deleteOne();
    res.status(204).json({
      status: "success",
      data: null,
    });
  } catch (err) {
    res.status(400).json({
      status: "fail",
      message: err.message,
    });
  }
};

exports.getAllUserSkillData = async (req, res) => {
  const destinations = await SkillData.find({ active: { $ne: false } });
};
