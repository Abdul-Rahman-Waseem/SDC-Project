package com.mycompany.controller;
/**
 *
 * @author look4
 */
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import com.mycompany.DAO.AdminDAO;
import com.mycompany.model.Admin;

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

        String username = request.getParameter("username").trim();
        String password = request.getParameter("password").trim();

        AdminDAO dao = new AdminDAO();
        Admin admin = dao.login(username, password);

        if (admin != null) {
            request.getSession().setAttribute("admin", admin);
            request.getRequestDispatcher("/views/adminMain.jsp")
                   .forward(request, response);
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/views/adminLogin.jsp")
                   .forward(request, response);
        }
    }
    
}
