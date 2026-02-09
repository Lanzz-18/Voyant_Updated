const { MongoClient } = require('mongodb');
require('dotenv').config();

const client = new MongoClient(process.env.MONGO_URI);

async function connectToDatabase() {
  try {
    await client.connect();
    console.log("Connected successfully to Atlas");
    return client.db(); 
  } catch (err) {
    console.error("Database connection failed:", err);
    process.exit(1);
  }
}

module.exports = connectToDatabase;