<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Available Rooms | Blue Rock Hotel</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            min-height: 100vh;
            background: url('<%= request.getContextPath() %>/images/adminmain.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            padding-top: 50px;
        }

        .container {
            background: rgba(255, 255, 255, 0.25);
            -webkit-backdrop-filter: blur(12px);
            backdrop-filter: blur(12px);
            padding: 30px 40px;
            border-radius: 25px;
            width: 90%;
            max-width: 1000px;
            box-shadow: 0 15px 40px rgba(0,0,0,0.3);
            border: 1px solid rgba(255,255,255,0.35);
        }

        h1 {
            text-align: center;
            margin-bottom: 20px;
            font-size: 36px;
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .search-btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background: linear-gradient(135deg, #1565C0, #42A5F5);
            color: white;
            font-weight: bold;
            border-radius: 8px;
            text-decoration: none;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .search-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.3);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
            border-radius: 12px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.8);
        }

        th, td {
            padding: 12px 15px;
            text-align: center;
        }

        th {
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            color: white;
        }

        tr:nth-child(even) {
            background-color: rgba(0,0,0,0.05);
        }

        a.view-btn {
            padding: 6px 12px;
            background: #42A5F5;
            color: white;
            border-radius: 6px;
            text-decoration: none;
            font-weight: bold;
            transition: transform 0.2s ease, background 0.2s ease;
        }

        a.view-btn:hover {
            transform: translateY(-2px);
            background: #1565C0;
        }

        @media screen and (max-width: 600px) {
            .container {
                width: 95%;
                padding: 20px;
            }

            th, td {
                font-size: 14px;
                padding: 10px;
            }

            h1 {
                font-size: 28px;
            }
        }
    </style>
</head>
<body>

<div class="container">
    <h1>Available Rooms</h1>

    <a href="../CustomerController?action=searchRooms" class="search-btn">Search Rooms</a>

    <table border="1">
        <tr>
            <th>Room No</th>
            <th>Type</th>
            <th>Price</th>
            <th>Action</th>
        </tr>

        <c:forEach var="room" items="${rooms}">
            <tr>
                <td>${room.roomNumber}</td>
                <td>${room.roomType}</td>
                <td>${room.pricePerNight}</td>
                <td>
                    <a href="../CustomerController?action=viewRoom&roomNumber=${room.roomNumber}" class="view-btn">
                        View Details
                    </a>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>

</body>
</html>
