import java.sql.*;
import spark.*;

public class Vuln {
    public static void main(String[] args) {
        Spark.get("/user", (req, res) -> {
            String user = req.queryParams("name");
            Connection c = DriverManager.getConnection("jdbc:mysql://localhost/test", "root", "");
            Statement stmt = c.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM users WHERE name = '" + user + "'"); // 🚨 SQL injection
            return "OK";
        });
    }
}
