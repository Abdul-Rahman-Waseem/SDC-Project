package com.mycompany.DAO;

import com.mycompany.db.DBConnection;
import com.mycompany.model.Booking;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * ADD THE NAME OF MEMBER FUNCTION YOU MADE AFTER YOUR NAME
 * @author ARW : confirmBooking(), getAllBookings()
 * @author hamza : 
 * @author asim :
 */
public class BookingDAO {
public List<Booking> getAllBookings() {

    List<Booking> bookings = new ArrayList<>();

    String sql = "SELECT * FROM booking ORDER BY bookingid DESC";

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

            // Temporary display
            b.setRoomNumber("Room ID " + rs.getInt("roomid"));

            bookings.add(b);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return bookings;
}


    public void confirmBooking(int bookingId) {

        String updateBooking =
            "UPDATE booking SET booking_status='CONFIRMED' WHERE bookingid=?";

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps1 = con.prepareStatement(updateBooking);
            ps1.setInt(1, bookingId);
            ps1.executeUpdate();


        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cancelBooking(int bookingId) {

        String updateBooking =
            "UPDATE booking SET booking_status='CANCELLED' WHERE bookingid=?";

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps1 = con.prepareStatement(updateBooking);
            ps1.setInt(1, bookingId);
            ps1.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
public boolean addBooking(Booking booking) {
    String sql = "INSERT INTO booking (customerid, roomid, booking_date, check_in, check_out, total_price, payment_method, booking_status) "
               + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, booking.getCustomerid());
        ps.setInt(2, booking.getRoomid());
        ps.setDate(3, booking.getBooking_date());
        ps.setDate(4, booking.getCheck_in());
        ps.setDate(5, booking.getCheck_out());
        ps.setDouble(6, booking.getTotal_price());
        ps.setString(7, booking.getPayment_method());
        ps.setString(8, booking.getBooking_status());

        int rows = ps.executeUpdate();
        return rows > 0;

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}


}
