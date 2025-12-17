/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package com.mycompany.controller;

import com.mycompany.model.Customer;
import com.mycompany.model.Room;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;

@WebServlet("/CustomerController")
public class CustomerController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action.equals("register")) {
            registerCustomer(request, response);
        }
        else if (action.equals("login")) {
            loginCustomer(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action.equals("searchRooms")) {
            searchRooms(request, response);
        }
        else if (action.equals("viewRoom")) {
            viewRoomDetails(request, response);
        }
    }


    private void registerCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Customer customer = new Customer();
        customer.setName(name);
        customer.setEmail(email);
        customer.setPassword(password);

 
        response.sendRedirect("views/customerLogin.jsp");
    }

    private void loginCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

  
        if (email.equals("test@gmail.com") && password.equals("123")) {
           response.sendRedirect("views/customerDashboard.jsp");

        } else {
            request.setAttribute("error", "Invalid credentials");
            request.getRequestDispatcher("/views/customerLogin.jsp").forward(request, response);
        }
    }

    private void searchRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> rooms = new ArrayList<>();

        Room r1 = new Room();
        r1.setRoomNumber("101");
        r1.setRoomType("Deluxe");
        r1.setPricePerNight(5000);

        rooms.add(r1);

        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("views/searchRooms.jsp").forward(request, response);
    }

    private void viewRoomDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Room room = new Room();
        room.setRoomNumber("101");
        room.setRoomType("Deluxe");
        room.setDescription("Luxury room with sea view");

        request.setAttribute("room", room);
        request.getRequestDispatcher("views/roomDetails.jsp").forward(request, response);
    }
}
