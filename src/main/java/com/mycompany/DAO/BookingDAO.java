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

        String sql =
            "SELECT b.bookingid, b.customerid, b.roomid, b.booking_date, " +
            "b.check_in, b.check_out, b.total_price, b.payment_method, " +
            "b.booking_status, r.room_number " +
            "FROM booking b " +
            "LEFT JOIN room r ON b.roomid = r.roomid " +
            "ORDER BY b.bookingid DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Booking b = new Booking();
                b.setBookingId(rs.getInt("bookingid"));
                b.setCustomerid(rs.getInt("customerid"));
                b.setRoomid(rs.getInt("roomid"));
                b.setBooking_date(rs.getDate("booking_date"));
                b.setCheck_in(rs.getDate("check_in"));
                b.setCheck_out(rs.getDate("check_out"));
                b.setTotal_price(rs.getDouble("total_price"));
                b.setPayment_method(rs.getString("payment_method"));
                b.setBooking_status(rs.getString("booking_status"));
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
}
