/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.controller;

/**
 *
 * @author look4
 */

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("loginAdmin".equals(action)) {
            loginAdmin(request, response);
        }
    }

    private void loginAdmin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // TEMPORARY check (replace with DB later)
        if ("admin".equals(username) && "123".equals(password)) {

            // forward to dashboard
            RequestDispatcher rd =
                    request.getRequestDispatcher("/views/adminMain.jsp");
            rd.forward(request, response);

        } else {
            request.setAttribute("error", "Invalid username or password");
            RequestDispatcher rd =
                    request.getRequestDispatcher("/views/adminLogin.jsp");
            rd.forward(request, response);
        }
    }
}
