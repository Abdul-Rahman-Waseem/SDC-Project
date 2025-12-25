<%--
    Document   : bookingHistory
    Created on : Dec 24, 2025
    Author     : Customer Portal
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.model.Booking"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Booking History - Blue Rock Hotel</title>

    <!-- ✅ UI & CSS KEPT EXACTLY SAME -->
    <style>
        /* --- CSS UNCHANGED (same as yours) --- */
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        body { background: linear-gradient(135deg, #0D47A1, #42A5F5); min-height: 100vh; padding: 20px; }
        .header { background: white; padding: 20px 40px; border-radius: 20px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2); margin-bottom: 30px; }
        .header h1 { font-size: 28px; background: linear-gradient(135deg, #0D47A1, #42A5F5);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 700; }
        .header-buttons { display: flex; gap: 15px; }
        .btn { padding: 12px 24px; border: none; border-radius: 50px;
            font-size: 15px; font-weight: 600; cursor: pointer;
            transition: all 0.3s ease; text-decoration: none; display: inline-block; }
        .btn-primary { background: linear-gradient(135deg, #1565C0, #42A5F5); color: white; }
        .btn-secondary { background: white; color: #0D47A1; border: 2px solid #0D47A1; }
        .container { max-width: 1200px; margin: 0 auto; }
        .page-title { text-align: center; color: white; font-size: 32px; margin-bottom: 30px; }
        .bookings-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 25px; margin-bottom: 40px; }
        .booking-card { background: white; border-radius: 20px; padding: 25px;
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2); position: relative; }
        .booking-card::before { content: ''; position: absolute; top: 0; left: 0;
            width: 100%; height: 5px; background: linear-gradient(135deg, #0D47A1, #42A5F5); }
        .booking-header { display: flex; justify-content: space-between; margin-bottom: 20px; }
        .booking-id { font-size: 14px; color: #666; font-weight: 600; }
        .status-badge { padding: 6px 16px; border-radius: 20px; font-size: 13px;
            font-weight: 600; text-transform: uppercase; }
        .status-confirmed { background: #4CAF50; color: white; }
        .status-pending { background: #FF9800; color: white; }
        .status-cancelled { background: #F44336; color: white; }
        .status-completed { background: #2196F3; color: white; }
        .detail-row { display: flex; justify-content: space-between; padding: 10px 0; }
        .detail-label { color: #0D47A1; font-weight: 600; font-size: 14px; }
        .detail-value { font-size: 14px; }
        .room-number { font-size: 24px; font-weight: 700; color: #1565C0; text-align: center; }
        .total-price { font-size: 28px; font-weight: 700; color: #0D47A1; text-align: center; }
        .booking-actions { display: flex; gap: 10px; justify-content: center; }
        .action-btn { padding: 10px 20px; border-radius: 25px; font-weight: 600;
            text-decoration: none; color: white; }
        .action-cancel { background: #F44336; }
        .action-view { background: #42A5F5; }
        .empty-state { background: white; border-radius: 20px; padding: 60px; text-align: center; }
    </style>
</head>

<body>

<!-- Header -->
<div class="header">
    <h1>🏨 Blue Rock Hotel</h1>
    <div class="header-buttons">
        <a href="<%= request.getContextPath() %>/views/customerMain.jsp" class="btn btn-secondary">Dashboard</a>
        <a href="<%= request.getContextPath() %>/CustomerController?action=logout" class="btn btn-primary">Logout</a>
    </div>
</div>

<!-- Main -->
<div class="container">
    <h2 class="page-title">My Booking History</h2>

    <div class="bookings-grid">
        <%
            List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

            if (bookings != null && !bookings.isEmpty()) {
                for (Booking booking : bookings) {

                     String status = booking.getBooking_status();
                    String statusClass = "";

                    if ("CONFIRMED".equalsIgnoreCase(status)) statusClass = "status-confirmed";
                    else if ("PENDING".equalsIgnoreCase(status)) statusClass = "status-pending";
                    else if ("CANCELLED".equalsIgnoreCase(status)) statusClass = "status-cancelled";
                    else if ("COMPLETED".equalsIgnoreCase(status)) statusClass = "status-completed";
        %>

        <div class="booking-card">
            <div class="booking-header">
                <span class="booking-id">Booking #<%= booking.getBookingId() %></span>
                <span class="status-badge <%= statusClass %>"><%= status %></span>
            </div>

            <div class="room-number">Room <%= booking.getRoomNumber() %></div>

            <div class="detail-row">
                <span class="detail-label">Booking Date</span>
                <span class="detail-value"><%= booking.getBooking_date() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Check In</span>
                <span class="detail-value"><%= booking.getCheck_in() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Check Out</span>
                <span class="detail-value"><%= booking.getCheck_out() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">Payment</span>
                <span class="detail-value"><%= booking.getPayment_method() %></span>
            </div>

            <div class="total-price">$<%= booking.getTotal_price() %></div>

            <div class="booking-actions">
                <% if ("CONFIRMED".equalsIgnoreCase(status) || "PENDING".equalsIgnoreCase(status)) { %>
                <a class="action-btn action-cancel"
                   href="<%= request.getContextPath() %>/CustomerController?action=cancelBooking&bookingId=<%= booking.getBookingId() %>"
                   onclick="return confirm('Cancel this booking?');">
                   Cancel
                </a>
                <% } %>
            </div>
        </div>

        <%
                }
            } else {
        %>

        <div class="empty-state" style="grid-column: 1 / -1;">
            <h3>No Bookings Found</h3>
            <p>You haven’t made any bookings yet</p>
        </div>

        <%
            }
        %>
    </div>
</div>

</body>
</html>
