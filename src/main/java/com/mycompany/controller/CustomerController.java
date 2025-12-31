package com.mycompany.controller;

import com.mycompany.DAO.BookingDAO;
import com.mycompany.DAO.CustomerDAO;
import com.mycompany.DAO.RoomDAO;
import com.mycompany.model.Booking;
import com.mycompany.model.Customer;
import com.mycompany.model.Room;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/CustomerController")
public class CustomerController extends HttpServlet {

    private final CustomerDAO customerDAO = new CustomerDAO();
    private final BookingDAO bookingDAO = new BookingDAO();
    private final RoomDAO roomDAO = new RoomDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {
            case "login":
                handleLogin(request, response);
                break;
            case "register":
                registerCustomer(request, response);
                break;
            case "addBooking":
                addBooking(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }

        switch (action) {
            case "dashboard":
                showDashboard(request, response);
                break;
            case "searchRooms":
                searchRooms(request, response);
                break;
            case "viewRoom":
                viewRoomDetails(request, response);
                break;
            case "bookingHistory":
                viewBookingHistory(request, response);
                break;
            case "showBookingForm":
                showBookingForm(request, response);
                break;
            case "cancelBooking":
                cancelBooking(request, response);
                break;
            case "deleteBooking":
                deleteBooking(request, response);
                break;
            case "clearCancelledBookings":
                clearCancelledBookings(request, response);
                break;
            case "logout":
                request.getSession().invalidate();
                response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
                break;
            default:
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    // ======= Customer Registration =======
    private void registerCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Customer customer = new Customer(name, email, password);
        boolean success = customerDAO.addCustomer(customer);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
        } else {
            request.setAttribute("error", "Registration failed. Try again.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }

    // ======= Customer Login =======
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Customer customer = customerDAO.validateLogin(email, password);

        if (customer != null) {
            HttpSession session = request.getSession();
            session.setAttribute("customer", customer);
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=dashboard");
        } else {
            request.setAttribute("error", "Invalid email or password");
            request.getRequestDispatcher("/views/customerLogin.jsp").forward(request, response);
        }
    }

    // ======= Dashboard =======
    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }
        request.getRequestDispatcher("/views/customerDashboard.jsp").forward(request, response);
    }

    // ======= Search Rooms =======
    private void searchRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> rooms = roomDAO.getAvailableRooms();
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/views/searchRooms.jsp").forward(request, response);
    }

    // ======= View Room Details =======
    private void viewRoomDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Room room = roomDAO.getRoomById(roomId);
            
            if (room != null) {
                request.setAttribute("room", room);
                request.getRequestDispatcher("/views/viewRoomDetails.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Room not found");
                response.sendRedirect(request.getContextPath() + "/CustomerController?action=searchRooms");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/CustomerController?action=searchRooms");
        }
    }

    // ======= Booking History =======
    private void viewBookingHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }

        // Get logged-in customer from session
        Customer loggedInCustomer = (Customer) session.getAttribute("customer");
        int customerId = loggedInCustomer.getId();
        
        // Fetch only THIS customer's bookings
        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
        
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("/views/bookingHistory.jsp").forward(request, response);
    }

    // ======= Cancel Booking =======
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }

        try {
            // Get booking ID from request
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            
            // Get logged-in customer
            Customer loggedInCustomer = (Customer) session.getAttribute("customer");
            int customerId = loggedInCustomer.getId();
            
            // Verify this booking belongs to the logged-in customer (security check)
            if (isBookingOwnedByCustomer(bookingId, customerId)) {
                // Cancel the booking (calls BookingDAO method)
                boolean cancelled = bookingDAO.cancelBooking(bookingId);
                
                if (cancelled) {
                    session.setAttribute("success", "Booking cancelled successfully! Room is now available for rebooking.");
                } else {
                    session.setAttribute("error", "Failed to cancel booking. Please try again.");
                }
            } else {
                session.setAttribute("error", "You can only cancel your own bookings.");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid booking ID.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while cancelling the booking.");
        }
        
        // Redirect back to booking history
        response.sendRedirect(request.getContextPath() + "/CustomerController?action=bookingHistory");
    }

    // ======= Delete Single Booking =======
    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }

        try {
            // Get booking ID from request
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            
            // Get logged-in customer
            Customer loggedInCustomer = (Customer) session.getAttribute("customer");
            int customerId = loggedInCustomer.getId();
            
            // Delete the booking (DAO method verifies ownership)
            boolean deleted = bookingDAO.deleteBooking(bookingId, customerId);
            
            if (deleted) {
                session.setAttribute("success", "Booking deleted successfully!");
            } else {
                session.setAttribute("error", "Failed to delete booking. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Invalid booking ID.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while deleting the booking.");
        }
        
        // Redirect back to booking history
        response.sendRedirect(request.getContextPath() + "/CustomerController?action=bookingHistory");
    }

    // ======= Clear All Cancelled Bookings =======
    private void clearCancelledBookings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }

        try {
            // Get logged-in customer
            Customer loggedInCustomer = (Customer) session.getAttribute("customer");
            int customerId = loggedInCustomer.getId();
            
            // Delete all cancelled bookings for this customer
            int deletedCount = bookingDAO.deleteCancelledBookings(customerId);
            
            if (deletedCount > 0) {
                session.setAttribute("success", deletedCount + " cancelled booking(s) cleared successfully!");
            } else {
                session.setAttribute("error", "No cancelled bookings found to delete.");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred while clearing cancelled bookings.");
        }
        
        // Redirect back to booking history
        response.sendRedirect(request.getContextPath() + "/CustomerController?action=bookingHistory");
    }

    // ======= Helper: Check if booking belongs to customer =======
    private boolean isBookingOwnedByCustomer(int bookingId, int customerId) {
        // Get customer's bookings and check if this booking ID exists
        List<Booking> customerBookings = bookingDAO.getBookingsByCustomerId(customerId);
        
        for (Booking booking : customerBookings) {
            if (booking.getBookingId() == bookingId) {
                return true;
            }
        }
        return false;
    }

    // ======= Show Booking Form =======
    private void showBookingForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }

        System.out.println("✅ showBookingForm() called");
        
        // Get all available rooms from database
        List<Room> availableRooms = roomDAO.getAvailableRooms();
        
        System.out.println("✅ Available rooms count: " + availableRooms.size());
        
        request.setAttribute("availableRooms", availableRooms);
        request.getRequestDispatcher("/views/addBooking.jsp").forward(request, response);
    }

    // ======= Add Booking =======
    private void addBooking(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer") == null) {
            response.sendRedirect(request.getContextPath() + "/views/customerLogin.jsp");
            return;
        }
        
        try {
            // Get logged-in customer ID from session
            Customer loggedInCustomer = (Customer) session.getAttribute("customer");
            int customerId = loggedInCustomer.getId();
            
            // Get booking parameters from form
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String paymentMethod = request.getParameter("paymentMethod");
            
            // Validate payment method
            if (!paymentMethod.equals("Online") && !paymentMethod.equals("Cash")) {
                throw new Exception("Invalid payment method");
            }
            
            // Parse dates
            java.sql.Date bookingDate = new java.sql.Date(System.currentTimeMillis());
            java.sql.Date checkIn = java.sql.Date.valueOf(request.getParameter("checkIn"));
            java.sql.Date checkOut = java.sql.Date.valueOf(request.getParameter("checkOut"));
            
            // Date validation
            if (checkIn.before(bookingDate)) {
                throw new Exception("Check-in date cannot be before today");
            }
            if (checkOut.before(checkIn) || checkOut.equals(checkIn)) {
                throw new Exception("Check-out date must be after check-in date");
            }
            
            // Fetch room to get price and validate availability
            Room room = roomDAO.getRoomById(roomId);
            if (room == null) {
                throw new Exception("Selected room does not exist");
            }
            if (!room.getStatus().equals("AVAILABLE")) {
                throw new Exception("Selected room is no longer available");
            }
            
            // Calculate total price
            long days = (checkOut.getTime() - checkIn.getTime()) / (1000 * 60 * 60 * 24);
            double totalPrice = days * room.getPricePerNight();
            
            // Create booking object
            Booking booking = new Booking();
            booking.setCustomerid(customerId);
            booking.setRoomid(roomId);
            booking.setBooking_date(bookingDate);
            booking.setCheck_in(checkIn);
            booking.setCheck_out(checkOut);
            booking.setTotal_price(totalPrice);
            booking.setPayment_method(paymentMethod);
            booking.setBooking_status("PENDING");
            
            // Insert booking into database (this now also updates room status to BOOKED)
            boolean inserted = bookingDAO.addBooking(booking);
            
            if (inserted) {
                session.setAttribute("success", "Booking created successfully! Room has been reserved.");
                response.sendRedirect(request.getContextPath() + "/CustomerController?action=bookingHistory");
            } else {
                throw new Exception("Failed to create booking. The room may no longer be available. Please try again.");
            }
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            List<Room> availableRooms = roomDAO.getAvailableRooms();
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("error", "Invalid input format. Please check all fields.");
            request.getRequestDispatcher("/views/addBooking.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            List<Room> availableRooms = roomDAO.getAvailableRooms();
            request.setAttribute("availableRooms", availableRooms);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/views/addBooking.jsp").forward(request, response);
        }
    }
}