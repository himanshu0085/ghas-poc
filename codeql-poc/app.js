// 🚀 Fully Secure Version

const express = require("express");
const app = express();
const mysql = require("mysql2");
const rateLimit = require("express-rate-limit");

const SECRET_KEY = process.env.APP_SECRET_KEY;

const db = mysql.createPool({
    host: "localhost",
    user: process.env.DB_USER,
    password: process.env.DB_PASS,
    database: "testdb"
});

// Rate limiting middleware
const limiter = rateLimit({
    windowMs: 1 * 60 * 1000, // 1 minute
    max: 10,
    message: "Too many requests, slow down!"
});
app.use(limiter);

const escapeHtml = (unsafe) =>
    unsafe.replace(/</g, "&lt;").replace(/>/g, "&gt;");

// Safe XSS handling
app.get("/greet", (req, res) => {
    const name = req.query.name || "Guest";
    res.send(`<h1>Hello ${escapeHtml(name)}</h1>`);
});

// Safe SQL query
app.get("/user/:id", (req, res) => {
    const userId = req.params.id;
    const query = "SELECT * FROM users WHERE id = ?";
    db.query(query, [userId], (err, result) => {
        if (err) return res.status(500).send("DB Error");
        res.json(result);
    });
});

app.listen(3000, () => {
    console.log("Secure server running on 3000 with rate limiting");
});
