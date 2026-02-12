const express = require('express');
const connectToDatabase = require('./db');
const userAccountDetailsRoutes = require('./routes/userAccountDetailsRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use('/api/user-account-details', userAccountDetailsRoutes);

async function startApp() {
  await connectToDatabase();

  app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
  });
}

startApp();