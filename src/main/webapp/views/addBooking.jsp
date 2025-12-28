<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.mycompany.model.Room" %>
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
        .error { color: #dc3545; background: #f8d7da; padding: 15px; border-radius: 10px; text-align: center; margin-bottom: 20px; border: 1px solid #f5c6cb; }
        .success { color: #155724; background: #d4edda; padding: 15px; border-radius: 10px; text-align: center; margin-bottom: 20px; border: 1px solid #c3e6cb; }
        .no-rooms { background: #fff3cd; color: #856404; padding: 30px; border-radius: 15px; text-align: center; border: 2px solid #ffeaa7; }
        .no-rooms h3 { margin-bottom: 15px; font-size: 24px; }
        .no-rooms p { margin-bottom: 20px; font-size: 16px; }
        .available-badge { background: #28a745; color: white; padding: 5px 15px; border-radius: 20px; font-size: 14px; margin-left: 10px; }
        .room-info { background: #f8f9fa; padding: 15px; border-radius: 10px; margin-bottom: 15px; border-left: 4px solid #0D47A1; }
        .room-info strong { color: #0D47A1; }
        .price-display { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 12px; text-align: center; margin-top: 15px; }
        .price-display strong { font-size: 28px; display: block; margin: 10px 0; }
        .price-display small { opacity: 0.9; }
    </style>
    <script>
        let isSubmitting = false;
        
        function validateDates() {
            if (isSubmitting) {
                alert('Please wait, booking is being processed...');
                return false;
            }
            
            const checkIn = new Date(document.getElementById('checkIn').value);
            const checkOut = new Date(document.getElementById('checkOut').value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            
            if (checkIn < today) {
                alert('Check-in date cannot be before today');
                return false;
            }
            if (checkOut <= checkIn) {
                alert('Check-out date must be after check-in date');
                return false;
            }
            
            const roomSelect = document.getElementById('roomId');
            if (!roomSelect.value) {
                alert('Please select a room');
                return false;
            }
            
            isSubmitting = true;
            return true;
        }
        
        function calculatePrice() {
            const roomSelect = document.getElementById('roomId');
            const checkIn = document.getElementById('checkIn').value;
            const checkOut = document.getElementById('checkOut').value;
            
            if (roomSelect.value && checkIn && checkOut) {
                const pricePerNight = parseFloat(roomSelect.options[roomSelect.selectedIndex].dataset.price);
                const checkInDate = new Date(checkIn);
                const checkOutDate = new Date(checkOut);
                
                const nights = Math.ceil((checkOutDate - checkInDate) / (1000 * 60 * 60 * 24));
                
                if (nights > 0) {
                    const total = nights * pricePerNight;
                    document.getElementById('totalPrice').textContent = total.toFixed(2);
                    document.getElementById('nightsInfo').textContent = 
                        nights + ' night' + (nights > 1 ? 's' : '') + ' × ₨' + pricePerNight.toFixed(2);
                } else {
                    document.getElementById('totalPrice').textContent = '0.00';
                    document.getElementById('nightsInfo').textContent = 'Invalid dates';
                }
            }
        }
        
        function setMinDates() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('checkIn').setAttribute('min', today);
            document.getElementById('checkOut').setAttribute('min', today);
            
            document.getElementById('checkIn').addEventListener('change', function() {
                const nextDay = new Date(this.value);
                nextDay.setDate(nextDay.getDate() + 1);
                document.getElementById('checkOut').setAttribute('min', nextDay.toISOString().split('T')[0]);
                calculatePrice();
            });
            
            document.getElementById('checkOut').addEventListener('change', calculatePrice);
            document.getElementById('roomId').addEventListener('change', calculatePrice);
        }
        
        window.onload = function() {
            setMinDates();
            isSubmitting = false;
        };
    </script>
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
    <h2>
        Add New Booking
        <% 
            List<Room> availableRooms = (List<Room>) request.getAttribute("availableRooms");
            if (availableRooms != null && !availableRooms.isEmpty()) {
        %>
            <span class="available-badge"><%= availableRooms.size() %> Available</span>
        <% } %>
    </h2>

    <%-- Error Message --%>
    <% if(request.getAttribute("error") != null) { %>
        <div class="error">❌ <%= request.getAttribute("error") %></div>
    <% } %>

    <%-- Success Message --%>
    <% if(session.getAttribute("success") != null) { %>
        <div class="success">✅ <%= session.getAttribute("success") %></div>
        <% session.removeAttribute("success"); %>
    <% } %>

    <%-- Check if rooms are available --%>
    <% if (availableRooms == null || availableRooms.isEmpty()) { %>
        
        <%-- NO ROOMS AVAILABLE --%>
        <div class="no-rooms">
            <h3>⚠️ No Rooms Available</h3>
            <p>Sorry, there are currently no rooms available for booking.</p>
            <p>Please check back later or contact the hotel administration.</p>
            <a href="<%= request.getContextPath() %>/CustomerController?action=dashboard" class="btn btn-primary">
                ← Back to Dashboard
            </a>
        </div>
        
    <% } else { %>
        
        <%-- SHOW AVAILABLE ROOMS --%>
        <div style="margin-bottom: 20px;">
            <h3 style="color: #28a745; margin-bottom: 15px;">✓ Available Rooms</h3>
            <% for (Room room : availableRooms) { %>
                <div class="room-info">
                    <strong>Room <%= room.getRoomNumber() %></strong> - 
                    <%= room.getRoomType() %> 
                    <span style="color: #28a745; float: right; font-weight: bold;">
                        ₨ <%= String.format("%.2f", room.getPricePerNight()) %>/night
                    </span>
                    <br>
                    <small style="color: #666;">
                        <%= room.getDescription() != null ? room.getDescription() : "Comfortable room with modern amenities" %>
                    </small>
                </div>
            <% } %>
        </div>

        <%-- BOOKING FORM --%>
        <%-- BOOKING FORM --%>
<form action="<%= request.getContextPath() %>/CustomerController?action=addBooking" method="post" onsubmit="return validateDates()">

    <label for="roomId">Select Room *</label>
    <select name="roomId" id="roomId" required>
        <option value="">-- Choose a Room --</option>
        <% for (Room room : availableRooms) { %>
            <option value="<%= room.getRoomId() %>" 
                    data-price="<%= room.getPricePerNight() %>">
                Room <%= room.getRoomNumber() %> - <%= room.getRoomType() %> 
                (₨ <%= String.format("%.2f", room.getPricePerNight()) %>/night)
            </option>
        <% } %>
    </select>

    <label for="checkIn">Check In Date *</label>
    <input type="date" name="checkIn" id="checkIn" required>

    <label for="checkOut">Check Out Date *</label>
    <input type="date" name="checkOut" id="checkOut" required>

    <label for="paymentMethod">Payment Method *</label>
    <select name="paymentMethod" id="paymentMethod" required>
        <option value="">Select payment method</option>
        <option value="Cash">💵 Cash on Arrival</option>
        <option value="Online">💳 Online Payment</option>
    </select>

    <%-- Price Display --%>
    <div class="price-display">
        <div style="font-size: 16px;">Total Amount</div>
        <strong>₨ <span id="totalPrice">0.00</span></strong>
        <small id="nightsInfo">Select room and dates to calculate price</small>
    </div>

    <input type="submit" value="✓ Confirm Booking">
</form>

    <div class="back-link">
        <a href="<%= request.getContextPath() %>/CustomerController?action=bookingHistory">← Back to Booking History</a>
    </div>
    
<% } %>
