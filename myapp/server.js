const express = require("express");
const app = express();
const port = process.env.PORT || 80;

app.get("/", (req, res) => {
  res.send(`
    <h1>Hello from Omoyele's App 🚀</h1>
    <p>This is a real-life demo running in Kubernetes.</p>
  `);
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});
