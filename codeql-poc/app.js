// ✅ Secure Version - CodeQL Alerts Fixed

const express = require("express");
const app = express();
const mysql = require("mysql2"); // Secure DB library

// Secret should NOT be hardcoded — use environment variable
const SECRET_KEY = process.env.APP_SECRET_KEY;

// Use parameterized DB connection
const db = mysql.createPool({
    host: "localhost",
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: "testdb"
});

// Secure XSS protection by escaping output
const escapeHtml = (unsafe) =>
    unsafe.replace(/</g, "&lt;").replace(/>/g, "&gt;");

app.get("/greet", (req, res) => {
    const name = req.query.name || "Guest";
    res.send(`<h1>Hello ${escapeHtml(name)}</h1>`);
    // ✔ XSS Mitigated
});

app.get("/user/:id", (req, res) => {
    const userId = req.params.id;

    const query = "SELECT * FROM users WHERE id = ?";
    db.query(query, [userId], (err, result) => {
        if (err) return res.status(500).send("DB Error");
        res.json(result);
    });
    // ✔ SQL Injection Prevented
});

app.listen(3000, () => {
    console.log("Secure server running on 3000");
});
