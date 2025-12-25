<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Booking - Blue Rock Hotel</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: Arial, sans-serif; }
        body { background: linear-gradient(135deg, #0D47A1, #42A5F5); min-height: 100vh; padding: 20px; }
        .header { background: white; padding: 20px 40px; border-radius: 20px;
            display: flex; justify-content: space-between; align-items: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2); margin-bottom: 30px; }
        .header h1 { font-size: 28px; background: linear-gradient(135deg,#0D47A1,#42A5F5);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 700; }
        .btn { padding: 12px 24px; border: none; border-radius: 50px;
            font-size: 15px; font-weight: 600; cursor: pointer;
            transition: all 0.3s ease; text-decoration: none; display: inline-block; }
        .btn-primary { background: linear-gradient(135deg,#1565C0,#42A5F5); color: white; }
        .btn-secondary { background: white; color: #0D47A1; border: 2px solid #0D47A1; }
        .container { max-width: 600px; margin: 0 auto; background: white; border-radius: 20px;
            padding: 40px; box-shadow: 0 15px 40px rgba(0,0,0,0.2); }
        h2 { text-align: center; color: #0D47A1; margin-bottom: 30px; font-size: 28px; }
        form { display: flex; flex-direction: column; gap: 20px; }
        label { font-weight: 600; color: #0D47A1; }
        input, select { padding: 12px 15px; border-radius: 12px; border: 1px solid #ccc; font-size: 14px; width: 100%; }
        input[type="submit"] { cursor: pointer; font-weight: 700; font-size: 16px; background: linear-gradient(135deg,#1565C0,#42A5F5); color: white; border: none; }
        input[type="submit"]:hover { opacity: 0.9; }
        .back-link { text-align: center; margin-top: 20px; }
        .back-link a { text-decoration: none; color: #1565C0; font-weight: 600; }
    </style>
</head>
<body>

<div class="header">
    <h1>🏨 Blue Rock Hotel</h1>
    <div>
        <a href="<%= request.getContextPath() %>/CustomerController?action=bookingHistory" class="btn btn-secondary">Booking History</a>
        <a href="<%= request.getContextPath() %>/CustomerController?action=logout" class="btn btn-primary">Logout</a>
    </div>
</div>

<div class="container">
    <h2>Add New Booking</h2>

<form action="<%= request.getContextPath() %>/CustomerController" method="post">
      <input type="hidden" name="action" value="addBooking">

        <label for="customerId">Customer ID</label>
        <input type="number" name="customerId" id="customerId" placeholder="Enter your customer ID" required>

        <label for="roomId">Room ID</label>
        <input type="number" name="roomId" id="roomId" placeholder="Enter room ID" required>

        <label for="bookingDate">Booking Date</label>
        <input type="date" name="bookingDate" id="bookingDate" required>

        <label for="checkIn">Check In Date</label>
        <input type="date" name="checkIn" id="checkIn" required>

        <label for="checkOut">Check Out Date</label>
        <input type="date" name="checkOut" id="checkOut" required>

        <label for="totalPrice">Total Price</label>
        <input type="number" name="totalPrice" id="totalPrice" placeholder="Enter total price" required>

        <label for="paymentMethod">Payment Method</label>
        <select name="paymentMethod" id="paymentMethod" required>
            <option value="">Select payment method</option>
            <option value="Credit Card">Credit Card</option>
            <option value="Cash">Cash</option>
            <option value="PayPal">PayPal</option>
        </select>

        <input type="submit" value="Add Booking">
    </form>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/CustomerController?action=bookingHistory">← Back to Booking History</a>
    </div>
</div>

</body>
</html>
