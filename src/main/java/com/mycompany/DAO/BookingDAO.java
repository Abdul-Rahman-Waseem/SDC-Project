package com.mycompany.DAO;

import com.mycompany.db.DBConnection;
import com.mycompany.model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    /* =======================
       GET ALL BOOKINGS
       ======================= */
    public List<Booking> getAllBookings() {

        List<Booking> bookings = new ArrayList<>();

        String sql = "SELECT b.bookingid, b.booking_date, b.check_in, b.check_out, " +
                     "       b.total_price, b.payment_method, b.booking_status, " +
                     "       c.name AS customer_name, " +
                     "       r.room_number " +
                     "FROM booking b " +
                     "JOIN customer c ON b.customerid = c.customerid " +
                     "JOIN room r ON b.roomid = r.roomid " +
                     "ORDER BY b.bookingid DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();

                b.setBookingId(rs.getInt("bookingid"));
                b.setBooking_date(rs.getDate("booking_date"));
                b.setCheck_in(rs.getDate("check_in"));
                b.setCheck_out(rs.getDate("check_out"));
                b.setTotal_price(rs.getDouble("total_price"));
                b.setPayment_method(rs.getString("payment_method"));
                b.setBooking_status(rs.getString("booking_status"));
                // JOINED DATA
                b.setCustomerName(rs.getString("customer_name"));
                b.setRoomNumber(rs.getString("room_number"));

                bookings.add(b);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bookings;
    }

    /* =======================
       CHECK IF ROOM EXISTS
       ======================= */
    public boolean roomExists(int roomId) {

        String sql = "SELECT 1 FROM room WHERE roomid = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            return rs.next();

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* =======================
       ADD BOOKING (FIXED)
       ======================= */
    public boolean addBooking(Booking booking) {

        // Prevent FK violation
        if (!roomExists(booking.getRoomid())) {
            System.out.println("❌ Room ID does not exist: " + booking.getRoomid());
            return false;
        }

        String sql =
            "INSERT INTO booking " +
            "(customerid, roomid, booking_date, check_in, check_out, " +
            "total_price, payment_method, booking_status) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, booking.getCustomerid());
            ps.setInt(2, booking.getRoomid());
            ps.setDate(3, booking.getBooking_date());
            ps.setDate(4, booking.getCheck_in());
            ps.setDate(5, booking.getCheck_out());
            ps.setDouble(6, booking.getTotal_price());
            ps.setString(7, booking.getPayment_method());

            // Default status if not set
            ps.setString(8,
                booking.getBooking_status() == null
                    ? "PENDING"
                    : booking.getBooking_status()
            );

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            // SHOW REAL SQL ERROR
            e.printStackTrace();
        }
        return false;
    }

    /* =======================
       CONFIRM BOOKING
       ======================= */
    public boolean confirmBooking(int bookingId) {

        String sql =
            "UPDATE booking SET booking_status = 'CONFIRMED' WHERE bookingid = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* =======================
       CANCEL BOOKING
       ======================= */
    public boolean cancelBooking(int bookingId) {

        String sql =
            "UPDATE booking SET booking_status = 'CANCELLED' WHERE bookingid = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    /* =======================
       GET BOOKINGS BY CUSTOMER ID
       ======================= */
    public List<Booking> getBookingsByCustomerId(int customerId) {
        
        List<Booking> bookings = new ArrayList<>();
        
        String sql = "SELECT b.bookingid, b.booking_date, b.check_in, b.check_out, " +
                     "       b.total_price, b.payment_method, b.booking_status, " +
                     "       c.name AS customer_name, " +
                     "       r.room_number " +
                     "FROM booking b " +
                     "JOIN customer c ON b.customerid = c.customerid " +
                     "JOIN room r ON b.roomid = r.roomid " +
                     "WHERE b.customerid = ? " +
                     "ORDER BY b.bookingid DESC";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    
                    b.setBookingId(rs.getInt("bookingid"));
                    b.setBooking_date(rs.getDate("booking_date"));
                    b.setCheck_in(rs.getDate("check_in"));
                    b.setCheck_out(rs.getDate("check_out"));
                    b.setTotal_price(rs.getDouble("total_price"));
                    b.setPayment_method(rs.getString("payment_method"));
                    b.setBooking_status(rs.getString("booking_status"));
                    // JOINED DATA
                    b.setCustomerName(rs.getString("customer_name"));
                    b.setRoomNumber(rs.getString("room_number"));
                    
                    bookings.add(b);
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return bookings;
    }

    /* =======================
       DELETE SINGLE BOOKING
       (WITH CUSTOMER OWNERSHIP VERIFICATION)
       ======================= */
    public boolean deleteBooking(int bookingId, int customerId) {
        
        String sql = "DELETE FROM booking WHERE bookingid = ? AND customerid = ?";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            ps.setInt(2, customerId);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("✅ Booking " + bookingId + " deleted successfully");
                return true;
            } else {
                System.out.println("❌ Failed to delete booking " + bookingId + 
                                   " (either doesn't exist or doesn't belong to customer " + customerId + ")");
                return false;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Error while deleting booking:");
            e.printStackTrace();
            return false;
        }
    }

    /* =======================
       DELETE ALL CANCELLED BOOKINGS FOR A CUSTOMER
       ======================= */
    public int deleteCancelledBookings(int customerId) {
        
        String sql = "DELETE FROM booking WHERE customerid = ? AND booking_status = 'CANCELLED'";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            
            int rowsAffected = ps.executeUpdate();
            
            if (rowsAffected > 0) {
                System.out.println("✅ Deleted " + rowsAffected + " cancelled booking(s) for customer " + customerId);
            } else {
                System.out.println("ℹ️ No cancelled bookings found for customer " + customerId);
            }
            
            return rowsAffected;
            
        } catch (SQLException e) {
            System.err.println("❌ SQL Error while deleting cancelled bookings:");
            e.printStackTrace();
            return 0;
        }
    }
}