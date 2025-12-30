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

    <style>
        * { 
            margin: 0; 
            padding: 0; 
            box-sizing: border-box; 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body { 
            background: linear-gradient(135deg, #1565C0 0%, #42A5F5 100%);
            min-height: 100vh; 
            padding: 20px;
            position: relative;
        }

        /* Animated Background */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            animation: float 20s ease-in-out infinite;
            pointer-events: none;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        
        /* Header */
        .header { 
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 20px 40px; 
            border-radius: 25px;
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            box-shadow: 
                0 15px 40px rgba(0, 0, 0, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.5) inset;
            margin-bottom: 30px;
            position: relative;
            z-index: 10;
            animation: slideDown 0.6s ease-out;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .header h1 { 
            font-size: 28px; 
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            -webkit-background-clip: text; 
            -webkit-text-fill-color: transparent; 
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .logo-icon {
            font-size: 32px;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-5px); }
        }
        
        .header-buttons { 
            display: flex; 
            gap: 15px; 
        }
        
        .btn { 
            padding: 12px 28px; 
            border: none; 
            border-radius: 50px;
            font-size: 15px; 
            font-weight: 600; 
            cursor: pointer;
            transition: all 0.3s ease; 
            text-decoration: none; 
            display: inline-flex;
            align-items: center;
            gap: 8px;
            position: relative;
            overflow: hidden;
        }

        .btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .btn-primary { 
            background: linear-gradient(135deg, #1565C0 0%, #42A5F5 100%);
            color: white;
            box-shadow: 0 8px 20px rgba(21, 101, 192, 0.3);
        }
        
        .btn-secondary { 
            background: white; 
            color: #1565C0; 
            border: 2px solid #1565C0;
        }
        
        .btn:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3); 
        }
        
        .container { 
            max-width: 1400px; 
            margin: 0 auto;
            position: relative;
            z-index: 1;
        }
        
        .page-title { 
            text-align: center; 
            color: white; 
            font-size: 38px; 
            margin-bottom: 35px; 
            text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.3);
            font-weight: 700;
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: scale(0.9);
            }
            to {
                opacity: 1;
                transform: scale(1);
            }
        }
        
        /* Success/Error Messages */
        .alert { 
            padding: 18px 25px; 
            border-radius: 15px; 
            margin-bottom: 25px; 
            text-align: center; 
            max-width: 700px; 
            margin-left: auto; 
            margin-right: auto;
            font-weight: 600; 
            font-size: 16px; 
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.5s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .alert-success { 
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white; 
        }
        
        .alert-error { 
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white; 
        }
        
        @keyframes slideUp {
            from { 
                opacity: 0; 
                transform: translateY(20px); 
            }
            to { 
                opacity: 1; 
                transform: translateY(0); 
            }
        }
        
        /* Clear Cancelled Button */
        .clear-cancelled-container {
            text-align: center;
            margin-bottom: 25px;
        }

        .btn-clear-cancelled {
            background: linear-gradient(135deg, #ff6b6b, #ee5a6f);
            color: white;
            padding: 14px 32px;
            border-radius: 50px;
            font-size: 15px;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            cursor: pointer;
            border: none;
            box-shadow: 0 8px 20px rgba(255, 107, 107, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-clear-cancelled::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .btn-clear-cancelled:hover::before {
            width: 300px;
            height: 300px;
        }

        .btn-clear-cancelled:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(255, 107, 107, 0.4);
        }
        
        /* Bookings Grid */
        .bookings-grid { 
            display: grid; 
            grid-template-columns: repeat(auto-fill, minmax(380px, 1fr));
            gap: 30px; 
            margin-bottom: 40px; 
        }
        
        .booking-card { 
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 25px; 
            padding: 30px;
            box-shadow: 
                0 20px 50px rgba(0, 0, 0, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.5) inset;
            position: relative;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            animation: cardAppear 0.6s ease-out backwards;
        }

        @keyframes cardAppear {
            from {
                opacity: 0;
                transform: translateY(30px) scale(0.95);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }

        .booking-card:nth-child(1) { animation-delay: 0.1s; }
        .booking-card:nth-child(2) { animation-delay: 0.2s; }
        .booking-card:nth-child(3) { animation-delay: 0.3s; }
        .booking-card:nth-child(4) { animation-delay: 0.4s; }
        
        .booking-card:hover { 
            transform: translateY(-10px) scale(1.02); 
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.3); 
        }
        
        .booking-card::before { 
            content: ''; 
            position: absolute; 
            top: 0; 
            left: 0;
            width: 100%; 
            height: 6px; 
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            border-radius: 25px 25px 0 0; 
        }
        
        .booking-header { 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            margin-bottom: 25px; 
        }
        
        .booking-id { 
            font-size: 15px; 
            color: #666; 
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .status-badge { 
            padding: 8px 18px; 
            border-radius: 25px; 
            font-size: 12px;
            font-weight: 700; 
            text-transform: uppercase;
            letter-spacing: 0.5px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
        }
        
        .status-confirmed { background: linear-gradient(135deg, #11998e, #38ef7d); color: white; }
        .status-pending { background: linear-gradient(135deg, #f2994a, #f2c94c); color: white; }
        .status-cancelled { background: linear-gradient(135deg, #eb3349, #f45c43); color: white; }
        .status-completed { background: linear-gradient(135deg, #4facfe, #00f2fe); color: white; }
        
        .customer-name {
            font-size: 20px;
            font-weight: 700;
            color: #1565C0;
            text-align: center;
            margin-bottom: 15px;
            padding: 12px;
            background: linear-gradient(135deg, rgba(21, 101, 192, 0.08), rgba(66, 165, 245, 0.08));
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .detail-row { 
            display: flex; 
            justify-content: space-between; 
            padding: 12px 0;
            border-bottom: 1px solid rgba(21, 101, 192, 0.1);
        }
        
        .detail-row:last-of-type { border-bottom: none; }
        
        .detail-label { 
            color: #1565C0; 
            font-weight: 700; 
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .detail-value { 
            font-size: 14px; 
            color: #333;
            font-weight: 600;
        }
        
        .room-number { 
            font-size: 28px; 
            font-weight: 800; 
            color: #1565C0; 
            text-align: center;
            margin: 20px 0; 
            padding: 15px; 
            background: linear-gradient(135deg, rgba(21, 101, 192, 0.1), rgba(66, 165, 245, 0.1));
            border-radius: 15px;
            border: 2px dashed #1565C0;
        }
        
        .total-price { 
            font-size: 32px; 
            font-weight: 800; 
            color: #1565C0;
            text-align: center;
            margin: 25px 0; 
            padding: 20px; 
            background: linear-gradient(135deg, rgba(21, 101, 192, 0.1), rgba(66, 165, 245, 0.1));
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .booking-actions { 
            display: flex; 
            gap: 12px; 
            justify-content: center; 
            margin-top: 25px; 
        }
        
        .action-btn { 
            padding: 12px 25px; 
            border-radius: 50px; 
            font-weight: 700;
            text-decoration: none; 
            color: white; 
            border: none; 
            cursor: pointer;
            transition: all 0.3s ease; 
            font-size: 14px;
            position: relative;
            overflow: hidden;
        }

        .action-btn::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            width: 0;
            height: 0;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.3);
            transform: translate(-50%, -50%);
            transition: width 0.6s, height 0.6s;
        }

        .action-btn:hover::before {
            width: 300px;
            height: 300px;
        }
        
        .action-btn:hover { 
            transform: translateY(-3px) scale(1.05); 
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.3); 
        }
        
        .action-cancel { 
            background: linear-gradient(135deg, #eb3349, #f45c43);
            box-shadow: 0 6px 15px rgba(235, 51, 73, 0.3);
        }
        
        .action-cancel:hover { 
            box-shadow: 0 10px 25px rgba(235, 51, 73, 0.5);
        }
        
        /* Empty State */
        .empty-state { 
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 25px; 
            padding: 80px 40px; 
            text-align: center;
            box-shadow: 
                0 20px 50px rgba(0, 0, 0, 0.2),
                0 0 0 1px rgba(255, 255, 255, 0.5) inset;
            animation: fadeIn 0.8s ease-out;
        }
        
        .empty-state h3 { 
            color: #1565C0; 
            font-size: 32px; 
            margin-bottom: 15px;
            font-weight: 700;
        }
        
        .empty-state p { 
            color: #666; 
            font-size: 18px; 
            margin-bottom: 30px; 
        }
        
        .empty-state .btn { 
            margin-top: 10px; 
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                gap: 15px;
                padding: 20px;
            }

            .header-buttons {
                width: 100%;
                justify-content: center;
            }

            .page-title {
                font-size: 28px;
            }

            .bookings-grid {
                grid-template-columns: 1fr;
            }

            .booking-card {
                padding: 25px 20px;
            }
        }
    </style>
</head>

<body>

<!-- Header -->
<div class="header">
    <h1>
        <span class="logo-icon">🏨</span>
        Blue Rock Hotel
    </h1>
    <div class="header-buttons">
        <a href="<%= request.getContextPath() %>/CustomerController?action=dashboard" class="btn btn-secondary">
            <span>🏠</span> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/CustomerController?action=logout" class="btn btn-primary">
            <span>🚪</span> Logout
        </a>
    </div>
</div>

<!-- Main Content -->
<div class="container">
    <h2 class="page-title">📋 My Booking History</h2>

    <%-- Success/Error Messages --%>
    <% 
        String success = (String) session.getAttribute("success");
        String error = (String) session.getAttribute("error");
        
        if (success != null) {
            session.removeAttribute("success");
    %>
        <div class="alert alert-success">
            <span style="font-size: 24px;">✓</span>
            <%= success %>
        </div>
    <%
        }
        
        if (error != null) {
            session.removeAttribute("error");
    %>
        <div class="alert alert-error">
            <span style="font-size: 24px;">✗</span>
            <%= error %>
        </div>
    <%
        }
        
        // Get bookings list
        List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
        boolean hasCancelledBookings = false;
        
        // Check if there are any cancelled bookings
        if (bookings != null && !bookings.isEmpty()) {
            for (Booking b : bookings) {
                if ("CANCELLED".equalsIgnoreCase(b.getBooking_status())) {
                    hasCancelledBookings = true;
                    break;
                }
            }
        }
        
        // Show clear button if there are cancelled bookings
        if (hasCancelledBookings) {
    %>
        <div class="clear-cancelled-container">
            <a href="<%= request.getContextPath() %>/CustomerController?action=clearCancelledBookings" 
               class="btn-clear-cancelled"
               onclick="return confirm('Are you sure you want to permanently delete all cancelled bookings from your history? This action cannot be undone.');">
               🗑️ Clear All Cancelled Bookings
            </a>
        </div>
    <%
        }
    %>

    <div class="bookings-grid">
        <%
            if (bookings != null && !bookings.isEmpty()) {
                for (Booking booking : bookings) {
                    String status = booking.getBooking_status();
                    String statusClass = "";

                    if ("CONFIRMED".equalsIgnoreCase(status)) {
                        statusClass = "status-confirmed";
                    } else if ("PENDING".equalsIgnoreCase(status)) {
                        statusClass = "status-pending";
                    } else if ("CANCELLED".equalsIgnoreCase(status)) {
                        statusClass = "status-cancelled";
                    } else if ("COMPLETED".equalsIgnoreCase(status)) {
                        statusClass = "status-completed";
                    }
        %>

        <div class="booking-card">
            <div class="booking-header">
                <span class="booking-id">🔖 Booking #<%= booking.getBookingId() %></span>
                <span class="status-badge <%= statusClass %>"><%= status %></span>
            </div>

            <div class="customer-name">
                👤 <%= booking.getCustomerName() != null ? booking.getCustomerName() : "Guest" %>
            </div>

            <div class="room-number">🚪 Room <%= booking.getRoomNumber() %></div>

            <div class="detail-row">
                <span class="detail-label">📅 Booking Date</span>
                <span class="detail-value"><%= booking.getBooking_date() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">🛬 Check In</span>
                <span class="detail-value"><%= booking.getCheck_in() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">🛫 Check Out</span>
                <span class="detail-value"><%= booking.getCheck_out() %></span>
            </div>

            <div class="detail-row">
                <span class="detail-label">💳 Payment</span>
                <span class="detail-value"><%= booking.getPayment_method() %></span>
            </div>

            <div class="total-price">
                <span style="font-size: 28px;">💵</span>
                $<%= String.format("%.2f", booking.getTotal_price()) %>
            </div>

            <div class="booking-actions">
                <% if ("CONFIRMED".equalsIgnoreCase(status) || "PENDING".equalsIgnoreCase(status)) { %>
                <a class="action-btn action-cancel"
                   href="<%= request.getContextPath() %>/CustomerController?action=cancelBooking&bookingId=<%= booking.getBookingId() %>"
                   onclick="return confirm('Are you sure you want to cancel this booking?');">
                   ❌ Cancel Booking
                </a>
                <% } else if ("CANCELLED".equalsIgnoreCase(status)) { %>
                <a class="action-btn action-cancel"
                   href="<%= request.getContextPath() %>/CustomerController?action=deleteBooking&bookingId=<%= booking.getBookingId() %>"
                   onclick="return confirm('Are you sure you want to permanently delete this booking record?');">
                   🗑️ Delete Record
                </a>
                <% } %>
            </div>
        </div>

        <%
                }
            } else {
        %>

        <div class="empty-state" style="grid-column: 1 / -1;">
            <h3>📭 No Bookings Found</h3>
            <p>You haven't made any bookings yet</p>
            <a href="<%= request.getContextPath() %>/CustomerController?action=searchRooms" class="btn btn-primary">
                <span>🔍</span> Browse Available Rooms
            </a>
        </div>

        <%
            }
        %>
    </div>
</div>

</body>
</html>