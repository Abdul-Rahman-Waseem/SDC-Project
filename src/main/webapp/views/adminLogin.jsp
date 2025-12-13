<%--
    Document   : adminLogin
    Created on : Dec 13, 2025
    Author     : look4
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login - Blue Rock Hotel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: Arial, sans-serif;
            height: 100vh;
            overflow: hidden;
            position: relative;
            background: #E3F2FD;
        }
                
        /* Main Layout - Two Columns */
        .container {
            display: flex;
            height: 100vh;
            align-items: center;
            justify-content: center;
        }

        /* Left Side – Login Card */
        .left {
            flex: 1;
            display: flex;
            justify-content: flex-end;
            align-items: center;
            padding-right: 80px;
        }

        /* Right Side – Image */
        .right {
            flex: 1;
            display: flex;
            justify-content: flex-start;
            align-items: center;
            padding-left: 80px;
        }
        
        .login-box {
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            backdrop-filter: blur(12px);
            border-radius: 24px;
            padding: 60px 60px;
            width: 100%;
            max-width: 460px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.25);
            border: 1px solid rgba(255, 255, 255, 0.18);
            z-index: 10;
            position: relative;
        }

        h2 {
            color: white;
            font-size: 28px;
            margin-bottom: 40px;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 24px;
            text-align: left;
        }

        label {
            color: #E3F2FD;
            font-size: 15px;
            font-weight: 500;
            display: block;
            margin-bottom: 8px;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 18px 22px;
            border: none;
            border-radius: 16px;
            background: #FFFFFF;                    /* Pure white background */
            color: #0D47A1;                         /* Deep blue text – same as your brand */
            font-size: 16px;
            font-weight: 500;
            outline: none;
            box-shadow: 0 4px 15px rgba(13, 71, 161, 0.15);
            transition: all 0.3s ease;
        }

        input[type="text"]::placeholder,
        input[type="password"]::placeholder {
            color: #90A4AE;                         /* Soft grey placeholder */
            font-weight: 400;
        }

        .login-btn {
            width: 100%;
            padding: 20px;
            font-size: 20px;
            font-weight: bold;
            color: white;
            background: #0D4791; /* Deep blue */
            border: none;
            border-radius: 50px;
            cursor: pointer;
            margin-top: 10px;
            transition: all 0.4s ease;
        }

        .login-btn:hover {
            transform: translateY(-8px) scale(1.03);
            box-shadow: 0 20px 40px rgba(21, 101, 192, 0.5);
            background: linear-gradient(135deg, #1976D2, #64B5F6);
        }

        .back-home {
            margin-top: 30px;
        }

        .back-home a {
            color: #BBDEFB;
            text-decoration: none;
            font-size: 15px;
            opacity: 0.9;
            transition: all 0.3s;
        }

        .back-home a:hover {
            opacity: 1;
            text-decoration: underline;
        }        
        
        .hotel-image {
            width: 100%; 
            max-width: 100%; 
            height: 90%; 
            object-fit: cover;
        }
        
        /* Mobile */
        @media (max-width: 480px) {
            .login-box {
                padding: 50px 40px;
                margin: 20px;
                border-radius: 20px;
            }
        }
    </style>
</head>
<body>
    
    <div class="container">
        <!-- Left: Customer Portal -->
        <div class="left">
            <div class="login-box">
                <h2>Admin Login</h2>
                <form action="<%= request.getContextPath() %>/AdminController?action=loginAdmin" method="post">

                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" placeholder="Enter username" required autofocus>
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password" name="password" placeholder="Enter password" required>
                    </div>

                    <button type="submit" class="login-btn">
                        Login as Admin
                    </button>
                </form>
                <div class="back-home">
                    <a href="<%= request.getContextPath() %>/index.html">Back to Home</a>
                </div>
            </div>
        </div>

        <!-- Right: Image -->
        <div class="right">
            <img src="<%= request.getContextPath() %>/images/reception.png" alt="Hotel Image" class="hotel-image">
        </div>
    </div>

</body>
</html>