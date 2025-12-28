<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Welcome | Blue Rock Hotel</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: url('<%= request.getContextPath() %>/images/adminmain.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .dashboard-box {
            background: rgba(255,255,255,0.25);
            backdrop-filter: blur(12px);
            padding: 40px;
            border-radius: 25px;
            text-align: center;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
        }
        .dashboard-box a {
            display: inline-block;
            margin: 15px;
            padding: 12px 25px;
            background: #1565C0;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.3s;
        }
        .dashboard-box a:hover {
            background: #42A5F5;
            transform: translateY(-3px);
        }
    </style>
</head>
<body>
    <div class="dashboard-box">
        <h2>Welcome, Customer!</h2>

        <a href="<%= request.getContextPath() %>/views/searchRooms.jsp">Search Rooms</a>

        <!-- ✅ ADD BOOKING BUTTON -->
        <a href="<%= request.getContextPath() %>/CustomerController?action=showBookingForm">Add Booking</a>


        <a href="<%= request.getContextPath() %>/CustomerController?action=viewBookings">
            My Bookings
        </a>

        <a href="<%= request.getContextPath() %>/CustomerController?action=logout">
            Logout
        </a>
    </div>
</body>
</html>
