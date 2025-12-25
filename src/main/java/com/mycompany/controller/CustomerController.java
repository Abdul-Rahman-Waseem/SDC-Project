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
import com.mycompany.DAO.BookingDAO;
import com.mycompany.model.Booking;

@WebServlet("/CustomerController")
public class CustomerController extends HttpServlet {

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String action = request.getParameter("action");

    if ("addBooking".equals(action)) {
        addBooking(request, response);
    } else if ("register".equals(action)) {
        registerCustomer(request, response);
    } else if ("login".equals(action)) {
        loginCustomer(request, response);
    } else {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action: " + action);
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
      if ("bookingHistory".equals(action)) {
            showBookingHistory(request, response);
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
        request.getRequestDispatcher("views/viewRoomDetails.jsp").forward(request, response);
    }
    private void showBookingHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        BookingDAO dao = new BookingDAO();
        List<Booking> bookings = dao.getAllBookings();

        System.out.println("Bookings fetched = " + bookings.size()); // DEBUG

        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("views/bookingHistory.jsp")
               .forward(request, response);
    }
private void addBooking(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    try {
        // ---- Dummy values ----
        int customerId = 1;  // make sure this customer exists in your DB
        int roomId = 101;    // make sure this room exists in your DB
        java.sql.Date bookingDate = java.sql.Date.valueOf("2025-12-25");
        java.sql.Date checkIn = java.sql.Date.valueOf("2025-12-26");
        java.sql.Date checkOut = java.sql.Date.valueOf("2025-12-28");
        double totalPrice = 1000;
        String paymentMethod = "Cash";

        Booking booking = new Booking();
        booking.setCustomerid(customerId);
        booking.setRoomid(roomId);
        booking.setBooking_date(bookingDate);
        booking.setCheck_in(checkIn);
        booking.setCheck_out(checkOut);
        booking.setTotal_price(totalPrice);
        booking.setPayment_method(paymentMethod);
        booking.setBooking_status("PENDING"); // default

        BookingDAO dao = new BookingDAO();
        boolean inserted = dao.addBooking(booking);

        if (inserted) {
            System.out.println("Dummy booking inserted successfully!");
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=bookingHistory");
        } else {
            System.out.println("Failed to insert dummy booking.");
            request.setAttribute("error", "Failed to add booking.");
            request.getRequestDispatcher("/views/addBooking.jsp").forward(request, response);
        }

    } catch (Exception e) {
        e.printStackTrace(); // Important: See errors in server log
        request.setAttribute("error", "Error: " + e.getMessage());
        request.getRequestDispatcher("/views/addBooking.jsp").forward(request, response);
    }
}


}

