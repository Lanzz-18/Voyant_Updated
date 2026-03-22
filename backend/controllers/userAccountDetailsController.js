// controllers/userAccountDetailsController.js
const UserAccountDetails = require("../models/UserAccountDetails");

exports.createUserAccountDetails = async (req, res) => {
  try {
    const doc = await UserAccountDetails.create(req.body);
    return res.status(201).json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

exports.getUserAccountDetails = async (req, res) => {
  try {
    const doc = await UserAccountDetails.findById(req.params.id);
    if (!doc) return res.status(404).json({ message: "Not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

exports.getUserAccountDetailsList = async (_req, res) => {
  try {
    const docs = await UserAccountDetails.find();
    return res.json(docs);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

exports.updateUserAccountDetails = async (req, res) => {
  try {
    const doc = await UserAccountDetails.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true, runValidators: true },
    );
    if (!doc) return res.status(404).json({ message: "Not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

exports.deleteUserAccountDetails = async (req, res) => {
  try {
    const doc = await UserAccountDetails.findByIdAndDelete(req.params.id);
    if (!doc) return res.status(404).json({ message: "Not found" });
    return res.status(204).send();
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// ============ NEW ENDPOINTS FOR ACCOUNT SETTINGS ============

// Update user profile information
exports.updateProfile = async (req, res) => {
  try {
    const { uid } = req.params;
    const { displayName, bio, location } = req.body;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      {
        displayName,
        bio,
        location,
      },
      { new: true, runValidators: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Update location sharing preference
exports.updateLocationSharing = async (req, res) => {
  try {
    const { uid } = req.params;
    const { enabled } = req.body;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      { locationSharingEnabled: enabled },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Update two-factor authentication setting
exports.updateTwoFA = async (req, res) => {
  try {
    const { uid } = req.params;
    const { enabled } = req.body;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      { twoFactorEnabled: enabled },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Update biometric login setting
exports.updateBiometric = async (req, res) => {
  try {
    const { uid } = req.params;
    const { enabled } = req.body;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      { biometricLoginEnabled: enabled },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Get login sessions
exports.getLoginSessions = async (req, res) => {
  try {
    const { uid } = req.params;

    const doc = await UserAccountDetails.findOne({ uid });
    if (!doc) return res.status(404).json({ message: "User not found" });

    return res.json(doc.loginSessions || []);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Add login session
exports.addLoginSession = async (req, res) => {
  try {
    const { uid } = req.params;
    const { device, ip } = req.body;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      {
        $push: {
          loginSessions: {
            device,
            ip,
            lastActivity: new Date(),
          },
        },
      },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Link social account
exports.linkSocialAccount = async (req, res) => {
  try {
    const { uid } = req.params;
    const { provider, email } = req.body;

    if (!['google', 'facebook'].includes(provider)) {
      return res.status(400).json({ message: "Invalid provider" });
    }

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      {
        [`connectedAccounts.${provider}`]: {
          linkedAt: new Date(),
          email,
        },
      },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Unlink social account
exports.unlinkSocialAccount = async (req, res) => {
  try {
    const { uid } = req.params;
    const { provider } = req.body;

    if (!['google', 'facebook'].includes(provider)) {
      return res.status(400).json({ message: "Invalid provider" });
    }

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      {
        [`connectedAccounts.${provider}`]: null,
      },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Export user personal data (GDPR compliance)
exports.downloadPersonalData = async (req, res) => {
  try {
    const { uid } = req.params;

    const doc = await UserAccountDetails.findOne({ uid });
    if (!doc) return res.status(404).json({ message: "User not found" });

    // Update the dataDownloadedAt timestamp
    doc.dataDownloadedAt = new Date();
    await doc.save();

    // Create data export object
    const personalData = {
      exportedAt: new Date().toISOString(),
      userProfile: {
        uid: doc.uid,
        name: doc.name,
        username: doc.username,
        email: doc.email,
        displayName: doc.displayName,
        bio: doc.bio,
        location: doc.location,
        level: doc.level,
        xp: doc.xp,
        profileImageUrl: doc.profileImageUrl,
      },
      preferences: {
        locationSharingEnabled: doc.locationSharingEnabled,
      },
      security: {
        twoFactorEnabled: doc.twoFactorEnabled,
        biometricLoginEnabled: doc.biometricLoginEnabled,
      },
      connectedAccounts: doc.connectedAccounts || {},
      activityData: {
        lastLoginAt: doc.lastLoginAt,
        createdDate: doc.created_date,
      },
    };

    return res.json(personalData);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Update profile image URL
exports.updateProfileImage = async (req, res) => {
  try {
    const { uid } = req.params;
    const { profileImageUrl } = req.body;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      { profileImageUrl },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

// Update last login
exports.updateLastLogin = async (req, res) => {
  try {
    const { uid } = req.params;

    const doc = await UserAccountDetails.findOneAndUpdate(
      { uid },
      {
        lastLoginAt: new Date(),
        last_login: new Date(),
      },
      { new: true }
    );

    if (!doc) return res.status(404).json({ message: "User not found" });
    return res.json(doc);
  } catch (err) {
    return res.status(400).json({ message: err.message });
  }
};

