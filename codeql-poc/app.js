const express = require("express");
const { exec } = require("child_process");
const mysql = require("mysql");

const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// ⚠️ VULNERABLE: Reflected XSS
app.get("/search", (req, res) => {
  const q = req.query.q;
  res.send(`You searched for: ${q}`); // ❌ unsanitized user input
});

// ⚠️ VULNERABLE: SQL Injection
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "",
  database: "test"
});

app.post("/login", (req, res) => {
  const { user, pass } = req.body;
  const query = `SELECT * FROM users WHERE user = '${user}' AND pass = '${pass}'`; // ❌ SQL injection
  db.query(query, (err, result) => {
    if (err) res.send("Error");
    else res.send("Login result: " + JSON.stringify(result));
  });
});

// ⚠️ VULNERABLE: Command Injection
app.get("/ping", (req, res) => {
  const host = req.query.host;
  exec(`ping -c 1 ${host}`, (err, stdout) => {  // ❌ user-controlled command
    if (err) res.send("Error");
    else res.send(stdout);
  });
});

app.listen(3000, () => console.log("🚀 App running on port 3000"));
