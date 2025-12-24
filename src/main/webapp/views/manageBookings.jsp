<%--
    Document : manageBookings
    Created on : Dec 22, 2025, 12:00:00 AM
    Author : look4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.model.Booking"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings - Blue Rock Hotel</title>
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
            justify-content: center;
            align-items: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            position: fixed;
            width: 100%;
            top: 0;
            z-index: 100;
        }
        .header h1 {
            font-size: 20px;
            font-weight: 600;
            margin: 0;
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
            padding: 20px;
            padding-top: 60px;
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
        /* Table */
        .bookings-table {
            width: 100%;
            border-collapse: collapse;
        }
        .bookings-table th, .bookings-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .bookings-table th {
            background: #42A5F5;
            color: white;
        }
        .bookings-table tr:nth-child(even) {
            background: #E3F2FD;
        }
        .bookings-table .actions a {
            color: #0D47A1;
            text-decoration: none;
            margin-right: 10px;
            font-weight: bold;
        }
        .bookings-table .actions a:hover {
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
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="header-left"></div>
        <h1>Manage Bookings</h1>
    </div>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Management Options</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=dashboard">Home Page</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageRooms">Manage Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageCustomer">Manage Customers</a></li>
            </ul>
        </div>
  
        <!-- Main Content -->
        <div class="main-content">
            <div class="dashboard-section">
                <h2>All Bookings</h2>
                <table class="bookings-table">
                    <thead>
                        <tr>
                            <th>Customer Name</th>
                            <th>Room Number</th>
                            <th>Booking Date</th>
                            <th>Check-in Date</th>
                            <th>Check-out Date</th>
                            <th>Total Price</th>
                            <th>Payment Method</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
                            if (bookings != null && !bookings.isEmpty()) {
                                for (Booking b : bookings) {
                        %>
                            <tr>
                                <td><%= b.getCustomerName() %></td>
                                <td><%= b.getRoomNumber() %></td>
                                <td><%= b.getBooking_date() %></td>
                                <td><%= b.getCheck_in() %></td>
                                <td><%= b.getCheck_out() %></td>
                                <td><%= b.getTotal_price() %></td>
                                <td><%= b.getPayment_method() %></td>
                                <td><%= b.getBooking_status() %></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/AdminController?action=confirmBooking&bookingId=<%= b.getBookingId() %>"
                                       onclick="return confirm('Are you sure you want to confirm this booking?');">
                                        Confirm
                                    </a>
                                    <a href="<%= request.getContextPath() %>/AdminController?action=cancelBooking&bookingId=<%= b.getBookingId() %>"
                                       onclick="return confirm('Are you sure you want to cancel this booking?');">
                                        Cancel
                                    </a>
                                </td>
                            </tr>
                        <%
                                }
                            } else {
                        %>
                            <tr>
                                <td colspan="10" style="text-align:center;">No bookings found</td>
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