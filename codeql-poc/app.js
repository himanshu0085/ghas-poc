// ❌ Intentionally Vulnerable Code for CodeQL + Copilot PoC

const express = require("express");
const app = express();

const SECRET_KEY = "12345-SECRET-HARDCODED"; // Hardcoded secret (CodeQL will flag)

app.get("/greet", (req, res) => {
    const name = req.query.name;
    res.send("<h1>Hello " + name + "</h1>"); 
    // ❌ Cross-Site Scripting (XSS) risk
});

app.get("/user/:id", (req, res) => {
    const userId = req.params.id;
    const query = "SELECT * FROM users WHERE id = " + userId;
    // ❌ SQL Injection (CodeQL will flag)
    res.send("Query: " + query);
});

app.listen(3000, () => {
    console.log("Server running on 3000");
});
