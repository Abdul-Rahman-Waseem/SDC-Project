<%--
    Document : manageCustomers
    Created on : Dec 21, 2025, 12:00:00 AM
    Author : look4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="com.mycompany.model.Customer"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Customers - Blue Rock Hotel</title>
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
        .add-customer-form {
            display: flex;
            flex-direction: column;
            gap: 15px;
            margin: 0 auto;
        }
        .add-customer-form label {
            font-weight: bold;
            color: #0D47A1;
        }
        .add-customer-form input, .add-customer-form select, .add-customer-form textarea {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
        }
        .add-customer-form button {
            padding: 12px;
            background: #0D47A1;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 16px;
            transition: all 0.3s ease;
        }
        .add-customer-form button:hover {
            background: #1976D2;
            transform: translateY(-2px);
        }
        /* Table */
        .customers-table {
            width: 100%;
            border-collapse: collapse;
        }
        .customers-table th, .customers-table td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        .customers-table th {
            background: #42A5F5;
            color: white;
        }
        .customers-table tr:nth-child(even) {
            background: #E3F2FD;
        }
        .customers-table .actions a {
            color: #0D47A1;
            text-decoration: none;
            margin-right: 10px;
            font-weight: bold;
        }
        .customers-table .actions a:hover {
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
        <h1>Manage Customers</h1>
    </div>
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Management Options</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=dashboard">Home Page</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageRooms">Manage Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageBookings">Manage Bookings</a></li>
            </ul>
        </div>
  
        <!-- Main Content -->
        <div class="main-content">
           
            <div class="side-by-side">
                <div class="dashboard-section">
                    <h2>Add New Customer</h2>
                    <form class="add-customer-form" action="<%= request.getContextPath() %>/AdminController?action=addCustomer" method="post">
                        <label for="name">Name:</label>
                        <input type="text" id="name" name="name" required>
                      
                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" required>
                      
                        <label for="password">Password:</label>
                        <input type="password" id="password" name="password" required>
                      
                        <button type="submit">Add Customer</button>
                    </form>
                </div>
            </div>
       
            <div class="dashboard-section">
                <h2>All Customers</h2>
                <table class="customers-table">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Email</th>
                            <th>Password</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            List<Customer> customers = (List<Customer>) request.getAttribute("customers");
                            if (customers != null && !customers.isEmpty()) {
                                for (Customer c : customers) {
                        %>
                            <tr>
                                <td><%= c.getName() %></td>
                                <td><%= c.getEmail() %></td>
                                <td><%= c.getPassword() %></td>
                                <td class="actions">
                                    <a href="<%= request.getContextPath() %>/AdminController?action=deleteCustomer&customerId=<%= c.getId() %>"
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
                                <td colspan="4" style="text-align:center;">No customers found</td>
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