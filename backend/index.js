const path = require("path");
require("dotenv").config({ path: path.resolve(__dirname, ".env") });

console.log('Environment variables loaded:');
console.log('MONGO_URI:', process.env.MONGO_URI ? 'SET' : 'NOT SET');

if (!process.env.MONGO_URI) {
  throw new Error("MONGO_URI missing. Set it in environment variables");
}

// Imports
require("./firebase/firebaseAdmin");

const express = require("express");
const connectToDatabase = require("./db");
const avatarRoutes = require("./routes/avatarRoutes");
const destinationRoutes = require("./routes/destinationRoutes");
const questRoutes = require("./routes/questRoutes"); 
const skillRoutes = require("./routes/skillRoutes");
const userAccountDetailsRoutes = require("./routes/userAccountDetailsRoutes");
const userGroupRoutes = require("./routes/userGroupRoutes");
const userSkillRoutes = require("./routes/userSkillsRoutes");
const userTripRoutes = require("./routes/userTripRoutes");
const userRewardRoutes = require("./routes/userRewardRoutes");
const messageLogRoutes = require("./routes/messageLogRoutes");

const app = express();
const PORT = process.env.PORT || 3000;

// Routes
app.use(express.json());
app.use("/api/user-account-details", userAccountDetailsRoutes);
app.use("/api/avatars", avatarRoutes);
app.use("/api/destinations", destinationRoutes);
app.use("/api/quests", questRoutes); 
app.use("/api/skills", skillRoutes);
app.use("/api/user-groups", userGroupRoutes);
app.use("/api/user-skills", userSkillRoutes);
app.use("/api/user-trips", userTripRoutes);
app.use("/api/rewards", userRewardRoutes);
app.use("/api/messages", messageLogRoutes);

// For local development
if (process.env.NODE_ENV !== 'production') {
  async function startApp() {
    await connectToDatabase();

    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  }

  startApp();
}

// Export for Vercel serverless functions
module.exports = app;
