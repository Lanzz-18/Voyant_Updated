const path = require("path");
require("dotenv").config({ path: path.join(__dirname, ".env") });

// Fallback for development
process.env.MONGO_URI = process.env.MONGO_URI || 'mongodb+srv://voyantAdmin:1VfeLDAFCQU84yJ7@voyant.y7zwi17.mongodb.net/voyant';
process.env.PORT = process.env.PORT || '3000';

if (!process.env.MONGO_URI) {
  throw new Error("MONGO_URI missing. Put it in backend/.env (same folder as index.js).");
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
const mainQuestRoutes = require("./routes/mainQuestRoutes");
const questTriggerRoutes = require("./routes/questTriggerRoutes");

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
app.use("/api/main-quests", mainQuestRoutes);
app.use("/api/quest-triggers", questTriggerRoutes);

async function startApp() {
  await connectToDatabase();

  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

startApp();
