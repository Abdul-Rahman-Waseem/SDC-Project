<%-- 
    Document   : manageRooms
    Created on : Dec 18, 2025, 11:08:13 PM
    Author     : look4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.model.Room"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rooms - Blue Rock Hotel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
   
        body {
            font-family: Arial, sans-serif;
            height: 100vh;
            overflow: hidden;
            position: relative;
            background: #E3F2FD;
        }
   
        /* Header */
        .header {
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            color: white;
            padding: 10px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 100;
        }
        .header-left {
            flex: 1;
        }
        .header h1 {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
        }
        .header-right {
            flex: 1;
            display: flex;
            justify-content: flex-end;
        }
        .logout-btn {
            padding: 8px 20px;
            font-size: 14px;
            font-weight: bold;
            color: white;
            background: #0D4791;
            border: none;
            border-radius: 50px;
            cursor: pointer;
            transition: all 0.4s ease;
        }
        .logout-btn:hover {
            transform: translateY(-4px) scale(1.03);
            box-shadow: 0 10px 20px rgba(21, 101, 192, 0.5);
            background: linear-gradient(135deg, #1976D2, #64B5F6);
        }
   
        /* Main Layout */
        .container {
            display: flex;
            height: calc(100vh - 40px); /* Adjusted for reduced header */
            margin-top: 40px; /* Adjusted for reduced header */
        }
   
        /* Sidebar */
        .sidebar {
            width: 280px;
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            color: white;
            padding: 40px 20px;
            box-shadow: 10px 0 30px rgba(0, 0, 0, 0.15);
            position: fixed;
            height: calc(100vh - 40px); /* Adjusted for reduced header */
            overflow-y: auto;
            z-index: 50;
        }
        .sidebar h2 {
            font-size: 22px;
            margin-bottom: 30px;
            text-align: center;
        }
        .sidebar ul {
            list-style: none;
        }
        .sidebar li {
            margin-bottom: 20px;
        }
        .sidebar a {
            display: block;
            padding: 18px 24px;
            color: #E3F2FD;
            text-decoration: none;
            font-size: 18px;
            font-weight: 500;
            border-radius: 16px;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.1);
        }
        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.2);
            transform: translateX(10px);
            box-shadow: 0 4px 15px rgba(13, 71, 161, 0.2);
            color: white;
        }
   
        /* Main Content */
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 60px;
            overflow-y: auto;
            background-image: url('<%= request.getContextPath() %>/images/adminmain.jpg');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        .dashboard-section {
            background: rgba(255, 255, 255, 0.9); /* Semi-transparent white for readability over background image */
            border-radius: 24px;
            padding: 30px;
            margin-bottom: 40px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.15);
            border: 1px solid rgba(13, 71, 161, 0.1);
        }
        .dashboard-section h2 {
            color: #0D47A1;
            font-size: 24px;
            margin-bottom: 20px;
            text-align: center;
        }
        /* Form Styles */
        .add-room-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
            max-width: 600px;
            margin: 0 auto;
        }
        .add-room-form label {
            font-weight: bold;
            color: #0D47A1;
        }
        .add-room-form input, .add-room-form select, .add-room-form textarea {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        .add-room-form button {
            padding: 12px;
            background: #0D47A1;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .add-room-form button:hover {
            background: #1976D2;
            transform: translateY(-2px);
        }
        /* Table */
        .rooms-table {
            width: 100%;
            border-collapse: collapse;
        }
        .rooms-table th, .rooms-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .rooms-table th {
            background: #42A5F5;
            color: white;
        }
        .rooms-table tr:nth-child(even) {
            background: #E3F2FD;
        }
        .rooms-table .actions a {
            color: #0D47A1;
            text-decoration: none;
            margin-right: 10px;
            font-weight: bold;
        }
        .rooms-table .actions a:hover {
            color: #1976D2;
        }
   
        /* Mobile Responsiveness */
        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                padding: 20px;
            }
            .main-content {
                margin-left: 0;
                padding: 30px;
            }
            .side-by-side {
                flex-direction: column;
                gap: 20px;
            }
        }

        /* Side by Side Layout */
        .side-by-side {
            display: flex;
            justify-content: space-between;
            gap: 40px;
            margin-bottom: 40px;
        }
        .side-by-side .dashboard-section {
            flex: 1;
            margin-bottom: 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left"></div>
        <h1>Manage Rooms</h1>
        <div class="header-right">
            <form action="<%= request.getContextPath() %>/AdminController?action=logout" method="post">
                <button type="submit" class="logout-btn">Logout</button>
            </form>
        </div>
    </div>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Management Options</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/views/adminMain.jsp">Home Page</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageBookings">Manage Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageCustomer">Manage Customers</a></li>
                <li><a href="<%= request.getContextPath() %>/views/generateReports.jsp">Generate Reports</a></li>
            </ul>
        </div>
   
        <!-- Main Content -->
        <div class="main-content">
            
            <div class="side-by-side">
                <div class="dashboard-section">
                    <h2>Add New Room</h2>
                    <form class="add-room-form" action="<%= request.getContextPath() %>/AdminController?action=addRoom" method="post">
                        <label for="room_number">Room Number:</label>
                        <input type="text" id="room_number" name="room_number" required>
                       
                        <label for="room_type">Room Type:</label>
                        <select id="room_type" name="room_type" required>
                            <option value="Single">Single</option>
                            <option value="Double">Double</option>
                            <option value="Suite">Suite</option>
                            <option value="Deluxe">Deluxe</option>
                        </select>
                       
                        <label for="price">Price per Night:</label>
                        <input type="number" id="price" name="price" step="0.01" required>
                       
                        <label for="description">Description:</label>
                        <textarea id="description" name="description" rows="4" required></textarea>
                       
                        <label for="availability">Availability:</label>
                        <select id="availability" name="availability" required>
                            <option value="AVAILABLE">Available</option>
                            <option value="BOOKED">Booked</option>
                        </select>
                       
                        <button type="submit">Add Room</button>
                    </form>
                </div>

                <div class="dashboard-section">
                    <h2>Edit Room</h2>
                    <% 
                        Room room = (Room) request.getAttribute("roomToEdit");
                        if (room == null) {
                    %>
                        <form class="add-room-form" action="<%= request.getContextPath() %>/AdminController" method="get">
                            <input type="hidden" name="action" value="fetchRoomForEdit">

                            <label for="room_number">Room Number:</label>
                            <input type="text" id="room_number" name="room_number" required>
                            <button type="submit">Fetch Room</button>
                        </form>
                    <% 
                        } else {
                            String roomNumber = room.getRoomNumber();
                            String roomType = room.getRoomType();
                            double price = room.getPricePerNight();
                            String description = room.getDescription();
                            String availability = room.getStatus();
                    %>
                        <form class="add-room-form" action="<%= request.getContextPath() %>/AdminController?action=updateRoom" method="post">
                            <label for="room_number">Room Number:</label>
                            <input type="text" id="room_number" name="room_number" value="<%= roomNumber %>" readonly required>
                           
                            <label for="room_type">Room Type:</label>
                            <select id="room_type" name="room_type" required>
                                <option value="Single" <%= "Single".equals(roomType) ? "selected" : "" %>>Single</option>
                                <option value="Double" <%= "Double".equals(roomType) ? "selected" : "" %>>Double</option>
                                <option value="Suite" <%= "Suite".equals(roomType) ? "selected" : "" %>>Suite</option>
                                <option value="Deluxe" <%= "Deluxe".equals(roomType) ? "selected" : "" %>>Deluxe</option>
                            </select>
                           
                            <label for="price">Price per Night:</label>
                            <input type="number" id="price" name="price" step="0.01" value="<%= price %>" required>
                           
                            <label for="description">Description:</label>
                            <textarea id="description" name="description" rows="4" required><%= description %></textarea>
                           
                            <label for="availability">Availability:</label>
                            <select id="availability" name="availability" required>
                                <option value="AVAILABLE" <%= "AVAILABLE".equals(availability) ? "selected" : "" %>>AVAILABLE</option>
                                <option value="BOOKED" <%= "BOOKED".equals(availability) ? "selected" : "" %>>BOOKED</option>
                            </select>
                           
                            <button type="submit">Update Room</button>
                        </form>
                    <% 
                        } 
                    %>
                </div>
            </div>
        
            <div class="dashboard-section">
                <h2>All Rooms</h2>
                <table class="rooms-table">
                    <thead>
                        <tr>
                            <th>Room Number</th>
                            <th>Type</th>
                            <th>Price</th>
                            <th>Description</th>
                            <th>Availability</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Room> rooms = (List<Room>) request.getAttribute("rooms");

                            if (rooms != null && !rooms.isEmpty()) {
                                for (Room r : rooms) {
                        %>
                            <tr>
                                <td><%= r.getRoomNumber() %></td>
                                <td><%= r.getRoomType() %></td>
                                <td><%= r.getPricePerNight() %></td>
                                <td><%= r.getDescription() %></td>
                                <td><%= r.getStatus() %></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/AdminController?action=deleteRoom&roomId=<%= r.getRoomId() %>"
                                       onclick="return confirm('Are you sure?');">
                                        Delete
                                    </a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="6" style="text-align:center;">No rooms found</td>
                            </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>