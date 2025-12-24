<%-- 
    Document   : adminMain
    Created on : Dec 13, 2025, 4:46:14 PM
    Author     : look4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Blue Rock Hotel</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
        /* Side by Side Layout for Chart and Calendar */
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
        /* Pie Chart */
        .chart-container {
            max-width: 400px;
            margin: 0 auto;
        }
        /* Calendar */
        .calendar table {
            width: 100%;
            border-collapse: collapse;
        }
        .calendar th, .calendar td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: center;
            font-size: 16px;
        }
        .calendar th {
            background: #0288D1; /* Different color: Light blue */
            color: white;
        }
        .calendar .current-day {
            background: #01579B; /* Different color: Darker blue */
            color: white;
            font-weight: bold;
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
            .chart-container {
                max-width: 100%;
            }
            .side-by-side {
                flex-direction: column;
                gap: 20px;
            }
        }
    </style>
</head>
<%
    int booked = (Integer) request.getAttribute("bookedRooms");
    int unbooked = (Integer) request.getAttribute("unbookedRooms");
%>
<body>
    <div class="header">
        <div class="header-left"></div>
        <h1>Admin Dashboard</h1>
    </div>
  
    <div class="container">
        <!-- Sidebar -->
        <div class="sidebar">
            <h2>Management Options</h2>
            <ul>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageRooms">Manage Rooms</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageBookings">Manage Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/AdminController?action=manageCustomer">Manage Customers</a></li>
            </ul>
        </div>
      
        <!-- Main Content -->
        <div class="main-content">
            <div class="side-by-side">
                <div class="dashboard-section">
                    <h2>Room Occupancy</h2>
                    <div class="chart-container">
                        <canvas id="roomPieChart"></canvas>
                    </div>
                </div>
               
                <div class="dashboard-section calendar">
                    <h2>December 2025</h2>
                    <table>
                        <thead>
                            <tr>
                                <th>Sun</th>
                                <th>Mon</th>
                                <th>Tue</th>
                                <th>Wed</th>
                                <th>Thu</th>
                                <th>Fri</th>
                                <th>Sat</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td></td>
                                <td>1</td>
                                <td>2</td>
                                <td>3</td>
                                <td>4</td>
                                <td>5</td>
                                <td>6</td>
                            </tr>
                            <tr>
                                <td>7</td>
                                <td>8</td>
                                <td>9</td>
                                <td>10</td>
                                <td>11</td>
                                <td>12</td>
                                <td>13</td>
                            </tr>
                            <tr>
                                <td>14</td>
                                <td>15</td>
                                <td>16</td>
                                <td>17</td>
                                <td>18</td>
                                <td class="current-day">19</td>
                                <td>20</td>
                            </tr>
                            <tr>
                                <td>21</td>
                                <td>22</td>
                                <td>23</td>
                                <td>24</td>
                                <td>25</td>
                                <td>26</td>
                                <td>27</td>
                            </tr>
                            <tr>
                                <td>28</td>
                                <td>29</td>
                                <td>30</td>
                                <td>31</td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
           
            <div class="dashboard-section">
                <h2>How to Use the Admin Dashboard</h2>

                <ul class="dashboard-guide">
                    <li>
                        <strong>View System Overview</strong>
                        <ul>
                            <li>Get a quick snapshot of recent system activity including bookings, rooms, and customers.</li>
                        </ul>
                    </li>

                    <li>
                        <strong>Monitor Recent Bookings</strong>
                        <ul>
                            <li>Review the latest bookings to stay updated on customer activity.</li>
                            <li>Track booking statuses such as <b>Confirmed</b>, <b>Cancelled</b>, <b>Checked In</b>, and <b>Checked Out</b>.</li>
                        </ul>
                    </li>

                    <li>
                        <strong>Manage Rooms</strong>
                        <ul>
                            <li>Add new rooms to the system.</li>
                            <li>Edit room details like room number, price, or availability.</li>
                            <li>Remove rooms that are no longer in service.</li>
                        </ul>
                    </li>

                    <li>
                        <strong>Handle Bookings</strong>
                        <ul>
                            <li>Confirm pending bookings after verification.</li>
                            <li>Cancel bookings when required.</li>
                            <li>Ensure booking status updates correctly in real time.</li>
                        </ul>
                    </li>

                    <li>
                        <strong>Customer Tracking</strong>
                        <ul>
                            <li>View customer-related booking information.</li>
                            <li>Use booking data to resolve customer queries efficiently.</li>
                        </ul>
                    </li>

                    <li>
                        <strong>Maintain System Accuracy</strong>
                        <ul>
                            <li>Regularly review records to ensure data consistency.</li>
                            <li>Perform quick actions directly from the dashboard.</li>
                        </ul>
                    </li>

                    <li>
                        <strong>Secure Admin Operations</strong>
                        <ul>
                            <li>Only authorized administrators can access the dashboard.</li>
                            <li>Always log out after completing administrative tasks.</li>
                        </ul>
                    </li>
                </ul>
            </div>

        </div>
    </div>
    <script>
        var booked = <%= booked %>;
        var unbooked = <%= unbooked %>;

        var ctx = document.getElementById('roomPieChart').getContext('2d');
        var myChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Booked', 'Unbooked'],
                datasets: [{
                    data: [booked, unbooked],
                    backgroundColor: ['#1565C0', '#BBDEFB'],
                    borderColor: ['#FFFFFF', '#FFFFFF'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            color: '#0D47A1'
                        }
                    }
                }
            }
        });
        
        var ctx = document.getElementById('roomPieChart').getContext('2d');
        var myChart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: ['Booked', 'Unbooked'],
                datasets: [{
                    data: [booked, unbooked],
                    backgroundColor: ['#1565C0', '#BBDEFB'], /* Different good-looking colors: Deep blue and light blue */
                    borderColor: ['#FFFFFF', '#FFFFFF'],
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'top',
                        labels: {
                            color: '#0D47A1'
                        }
                    }
                }
            }
        });
    </script>
</body>
</html>