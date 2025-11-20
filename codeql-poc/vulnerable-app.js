const express = require("express");
const app = express();

app.get("/user/:id", (req, res) => {
    const userId = req.params.id;
    // SQL Injection risk
    const query = "SELECT * FROM users WHERE id = " + userId;
    res.send("Query executed: " + query);
});

app.listen(3000, () => {
    console.log("Server running on port 3000");
});
