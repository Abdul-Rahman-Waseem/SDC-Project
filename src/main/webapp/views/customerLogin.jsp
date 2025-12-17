<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Login | Blue Rock Hotel</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: Arial, sans-serif;
        }

        body {
            
            height: 100vh;
            background: url('<%= request.getContextPath() %>/images/adminmain.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
        }

    .register-box {
    background: rgba(255, 255, 255, 0.25);
    -webkit-backdrop-filter: blur(10px); 
    padding: 40px 50px;
    border-radius: 20px;
    width: 420px;
    box-shadow: 0 8px 32px rgba(0,0,0,0.25);
    border: 1px solid rgba(255,255,255,0.3); 
    animation: fadeIn 1s ease-in-out; 
}


 @keyframes fadeIn {
    from { opacity: 0; transform: translateY(-20px); }
    to { opacity: 1; transform: translateY(0); }
}




        .register-box h2 {
            text-align: center;
            font-size: 32px;
            margin-bottom: 10px;
            background: linear-gradient(135deg, #0D47A1, #42A5F5);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
        }

        .register-box p {
            text-align: center;
            margin-bottom: 30px;
            color: #1A237E;
            font-size: 15px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #0D47A1;
        }

        .form-group input {
            width: 100%;
            padding: 14px;
            border-radius: 10px;
            border: 1px solid #BBDEFB;
            font-size: 15px;
            outline: none;
        }

        .form-group input:focus {
            border-color: #1E88E5;
            box-shadow: 0 0 8px rgba(30,136,229,0.3);
        }

        .register-btn {
            width: 100%;
            padding: 16px;
            border: none;
            border-radius: 50px;
            background: linear-gradient(135deg, #1565C0, #42A5F5);
            color: white;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }

        .register-btn:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(0,0,0,0.25);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #0D47A1;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        .error {
            color: red;
            text-align: center;
            margin-top: 15px;
            font-weight: 600;
        }
    </style>
</head>

<body>

    <div class="register-box">
        <h2>Blue Rock Hotel</h2>
        <p>Customer Login</p>

        <form action="../CustomerController" method="post">
            <input type="hidden" name="action" value="login">

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" required>
            </div>

            <button type="submit" class="register-btn">
                Login
            </button>
        </form>

        <p class="error">${error}</p>

        <a href="register.jsp" class="back-link">
            Don’t have an account? Register
        </a>
    </div>

</body>
</html>
