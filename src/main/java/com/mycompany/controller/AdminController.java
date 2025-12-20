package com.mycompany.controller;
/**
 * @author look4 : complete class
 */
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;

import com.mycompany.DAO.AdminDAO;
import com.mycompany.DAO.RoomDAO;
import com.mycompany.model.Admin;
import com.mycompany.model.Room;
import java.util.List;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("loginAdmin".equals(action)) {
            loginAdmin(request, response);
        }
        else if ("addRoom".equals(action)) {
            addRoom(request, response);
        }
        else if ("updateRoom".equals(action)) {
            updateRoom(request, response);
        }
    }
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("manageRooms".equals(action)) {
            manageRooms(request, response);
        } else if ("deleteRoom".equals(action)) {
            deleteRoom(request, response);
        } else if ("fetchRoomForEdit".equals(action)) {
            fetchRoomForEdit(request, response); 
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
    
    private void addRoom(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Admin admin = (Admin) session.getAttribute("admin");

        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/views/adminLogin.jsp");
            return;
        }

        Room room = new Room();
        room.setRoomNumber(request.getParameter("room_number"));
        room.setRoomType(request.getParameter("room_type"));
        room.setPricePerNight(Double.parseDouble(request.getParameter("price")));
        room.setDescription(request.getParameter("description"));
        room.setStatus(request.getParameter("availability").toUpperCase());
        room.setAdminId(admin.getId());

        RoomDAO dao = new RoomDAO();
        boolean success = dao.addRoom(room);

        if (success) {
            request.setAttribute("success", "Room added successfully!");
        } else {
            request.setAttribute("error", "Failed to add room. Try again.");
        }
        
        response.sendRedirect(
            request.getContextPath() + "/AdminController?action=manageRooms"
        );
    }

    private void manageRooms(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        RoomDAO dao = new RoomDAO();
        List<Room> roomList = dao.getAllRooms();

        request.setAttribute("rooms", roomList);
        request.getRequestDispatcher("/views/manageRooms.jsp")
               .forward(request, response);
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        
        RoomDAO dao = new RoomDAO();
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            boolean success = dao.removeRoom(roomId);
            if (success) {
                request.getSession().setAttribute("success", "Room deleted successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to delete room.");
            }

            response.sendRedirect(
                request.getContextPath() + "/AdminController?action=manageRooms"
            );
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/AdminController?action=manageRooms");
        }
    }
    
    private void fetchRoomForEdit(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomDAO dao = new RoomDAO();
        try {
            String roomNumber = request.getParameter("room_number");
            Room room = dao.getRoomByNumber(roomNumber);
            System.out.println(room.getRoomId());
            if (room != null) {
                request.setAttribute("roomToEdit", room);

                List<Room> roomList = dao.getAllRooms();
                request.setAttribute("rooms", roomList);

                request.getRequestDispatcher("/views/manageRooms.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("error", "Room not found.");
                response.sendRedirect(request.getContextPath() + "/AdminController?action=manageRooms");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/AdminController?action=manageRooms");
        }
    }
    
    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        
        HttpSession session = request.getSession(false);
        Admin admin = (Admin) session.getAttribute("admin");
        RoomDAO dao = new RoomDAO();    
        try {
                
            Room room = new Room();
            room.setRoomNumber(request.getParameter("room_number"));
            room.setPricePerNight(Double.parseDouble(request.getParameter("price")));
            room.setDescription(request.getParameter("description"));
            room.setRoomType(request.getParameter("room_type"));
            room.setStatus(request.getParameter("availability").toUpperCase());
            room.setAdminId(admin.getId());
                
            boolean updated = dao.updateRoom(room);

            if (updated) {
                request.getSession().setAttribute("success", "Room updated successfully!");
            } else {
                request.getSession().setAttribute("error", "Failed to update room.");
            }

            response.sendRedirect(request.getContextPath() + "/AdminController?action=manageRooms");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/AdminController?action=manageRooms");
        }
    }
}
