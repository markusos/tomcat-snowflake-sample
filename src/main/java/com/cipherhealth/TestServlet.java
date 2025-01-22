package com.cipherhealth;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;


public class TestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            DataSource ds = (DataSource) envContext.lookup("jdbc/snowflake");

            try (Connection connection = ds.getConnection();
                 Statement statement = connection.createStatement();
                 ResultSet resultSet = statement.executeQuery("SELECT 1")) {

                if (resultSet.next()) {
                    out.println("Snowflake connection successful!");
                    out.println("Result: " + resultSet.getInt(1)); // Example
                } else {
                    out.println("No data retrieved.");
                }


            }

        } catch (Exception e) {
            out.println("Error: " + e.getMessage());
            e.printStackTrace(out);  // Print stack trace for debugging.
        }
    }
}
