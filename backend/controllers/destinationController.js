const DestinationData = require("../models/Destination.js");

exports.createDestination = async (req, res) => {
  try {
    const newDestination = await DestinationData.create(req.body);

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

exports.getDestinationDetails = async (req, res) => {
  try {
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
