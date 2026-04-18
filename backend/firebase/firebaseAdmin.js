const admin = require("firebase-admin");

// Try to initialize Firebase
if (!admin.apps.length) {
  try {
    // Try loading from serviceAccountKey.json if it exists locally
    const serviceAccount = require("./serviceAccountKey.json");
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log("✓ Firebase initialized with serviceAccountKey.json");
  } catch (err) {
    // If serviceAccountKey.json doesn't exist, use FIREBASE_CONFIG environment variable
    if (process.env.FIREBASE_CONFIG) {
      try {
        const serviceAccount = JSON.parse(process.env.FIREBASE_CONFIG);
        admin.initializeApp({
          credential: admin.credential.cert(serviceAccount),
        });
        console.log("✓ Firebase initialized with FIREBASE_CONFIG environment variable");
      } catch (parseErr) {
        console.error("✗ Failed to parse FIREBASE_CONFIG:", parseErr.message);
        throw new Error("Failed to initialize Firebase. Set FIREBASE_CONFIG environment variable.");
      }
    } else if (process.env.GOOGLE_APPLICATION_CREDENTIALS) {
      // Use Application Default Credentials
      admin.initializeApp();
      console.log("✓ Firebase initialized with Application Default Credentials");
    } else {
      console.error("✗ Firebase credentials not found");
      throw new Error(
        "Firebase credentials not found. Set FIREBASE_CONFIG environment variable with your service account key."
      );
    }
  }
}

module.exports = admin;