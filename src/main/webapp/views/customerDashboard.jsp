<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="com.mycompany.model.Customer"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Blue Rock Hotel</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #1565C0 0%, #42A5F5 100%);
            position: relative;
            overflow-x: hidden;
        }

        /* Animated Background Pattern */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: 
                radial-gradient(circle at 20% 50%, rgba(255, 255, 255, 0.1) 0%, transparent 50%),
                radial-gradient(circle at 80% 80%, rgba(255, 255, 255, 0.1) 0%, transparent 50%);
            animation: float 20s ease-in-out infinite;
        }

        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }

        /* Container */
        .container {
            position: relative;
            z-index: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            padding: 20px;
        }

        /* Dashboard Card */
        .dashboard-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: 50px 40px;
            border-radius: 30px;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.3),
                0 0 0 1px rgba(255, 255, 255, 0.5) inset;
            max-width: 900px;
            width: 100%;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        /* Header Section */
        .header {
            text-align: center;
            margin-bottom: 40px;
        }

        .hotel-logo {
            font-size: 48px;
            margin-bottom: 10px;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .hotel-name {
            font-size: 32px;
            font-weight: 700;
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 15px;
        }

        .welcome-text {
            font-size: 20px;
            color: #555;
            font-weight: 500;
        }

        .customer-name {
            color: #1565C0;
            font-weight: 700;
        }

        /* Divider */
        .divider {
            height: 3px;
            background: linear-gradient(90deg, transparent, #1565C0, transparent);
            margin: 30px 0;
        }

        /* Menu Grid */
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        /* Menu Item */
        .menu-item {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 30px 20px;
            background: linear-gradient(135deg, #1565C0 0%, #42A5F5 100%);
            color: white;
            text-decoration: none;
            border-radius: 20px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(21, 101, 192, 0.3);
            position: relative;
            overflow: hidden;
        }

        .menu-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s ease;
        }

        .menu-item:hover::before {
            left: 100%;
        }

        .menu-item:hover {
            transform: translateY(-8px) scale(1.03);
            box-shadow: 0 15px 35px rgba(21, 101, 192, 0.5);
        }

        .menu-icon {
            font-size: 48px;
            margin-bottom: 15px;
            filter: drop-shadow(0 4px 8px rgba(0, 0, 0, 0.2));
        }

        .menu-title {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .menu-description {
            font-size: 13px;
            opacity: 0.9;
            text-align: center;
        }

        /* Logout Button */
        .logout-section {
            text-align: center;
            margin-top: 30px;
        }

        .logout-btn {
            display: inline-block;
            padding: 15px 40px;
            background: linear-gradient(135deg, #64B5F6 0%, #1E88E5 100%);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-weight: 600;
            font-size: 16px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(30, 136, 229, 0.3);
        }

        .logout-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 30px rgba(30, 136, 229, 0.5);
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .dashboard-card {
                padding: 40px 25px;
            }

            .hotel-name {
                font-size: 26px;
            }

            .welcome-text {
                font-size: 18px;
            }

            .menu-grid {
                grid-template-columns: 1fr;
                gap: 15px;
            }

            .menu-item {
                padding: 25px 15px;
            }
        }

        /* Success/Error Messages */
        .alert {
            padding: 15px 20px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
            font-weight: 600;
            animation: slideDown 0.5s ease;
        }

        .alert-success {
            background: linear-gradient(135deg, #11998e 0%, #38ef7d 100%);
            color: white;
        }

        .alert-error {
            background: linear-gradient(135deg, #eb3349 0%, #f45c43 100%);
            color: white;
        }

        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="dashboard-card">
            <!-- Header -->
            <div class="header">
                <div class="hotel-logo">🏨</div>
                <h1 class="hotel-name">Blue Rock Hotel</h1>
                <%
                    Customer customer = (Customer) session.getAttribute("customer");
                    String customerName = (customer != null) ? customer.getName() : "Guest";
                %>
                <p class="welcome-text">
                    Welcome back, <span class="customer-name"><%= customerName %></span>! 👋
                </p>
            </div>

            <!-- Success/Error Messages -->
            <%
                String success = (String) session.getAttribute("success");
                String error = (String) session.getAttribute("error");

                if (success != null) {
                    session.removeAttribute("success");
            %>
                <div class="alert alert-success">
                    ✓ <%= success %>
                </div>
            <%
                }

                if (error != null) {
                    session.removeAttribute("error");
            %>
                <div class="alert alert-error">
                    ✗ <%= error %>
                </div>
            <%
                }
            %>

            <div class="divider"></div>

            <!-- Menu Grid -->
            <div class="menu-grid">
                <a href="<%= request.getContextPath() %>/CustomerController?action=searchRooms" class="menu-item">
                    <div class="menu-icon">🔍</div>
                    <div class="menu-title">Search Rooms</div>
                    <div class="menu-description">Browse available rooms</div>
                </a>

                <a href="<%= request.getContextPath() %>/CustomerController?action=showBookingForm" class="menu-item">
                    <div class="menu-icon">➕</div>
                    <div class="menu-title">New Booking</div>
                    <div class="menu-description">Reserve a room</div>
                </a>

                <a href="<%= request.getContextPath() %>/CustomerController?action=bookingHistory" class="menu-item">
                    <div class="menu-icon">📋</div>
                    <div class="menu-title">My Bookings</div>
                    <div class="menu-description">View booking history</div>
                </a>


            </div>

            <div class="divider"></div>

            <!-- Logout Section -->
            <div class="logout-section">
                <a href="<%= request.getContextPath() %>/CustomerController?action=logout" class="logout-btn">
                    🚪 Logout
                </a>
            </div>
        </div>
    </div>


</body>
</html>