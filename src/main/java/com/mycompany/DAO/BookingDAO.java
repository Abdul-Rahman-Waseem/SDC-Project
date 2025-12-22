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

        String sql = "    SELECT b.bookingid, b.booking_date, b.check_in, b.check_out,\n" + "           b.total_price, b.payment_method, b.booking_status,\n" + "           c.name AS customer_name,\n" + "           r.room_number\n" + "    FROM booking b\n" + "    JOIN customer c ON b.customerid = c.customerid\n" + "    JOIN room r ON b.roomid = r.roomid\n" + "    ORDER BY b.bookingid DESC\n";

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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookings;
    }
    public void confirmBooking(int bookingId) {

        String updateBooking =
            "UPDATE booking SET booking_status='CONFIRMED' WHERE bookingid=?";

        String updateRoom =
            "UPDATE room SET status='BOOKED' " +
            "WHERE roomid = (SELECT roomid FROM booking WHERE bookingid=?)";

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps1 = con.prepareStatement(updateBooking);
            ps1.setInt(1, bookingId);
            ps1.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement(updateRoom);
            ps2.setInt(1, bookingId);
            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void cancelBooking(int bookingId) {

        String updateBooking =
            "UPDATE booking SET booking_status='CANCELLED' WHERE bookingid=?";

        String updateRoom =
            "UPDATE room SET status='AVAILABLE' " +
            "WHERE roomid = (SELECT roomid FROM booking WHERE bookingid=?)";

        try (Connection con = DBConnection.getConnection()) {

            PreparedStatement ps1 = con.prepareStatement(updateBooking);
            ps1.setInt(1, bookingId);
            ps1.executeUpdate();

            PreparedStatement ps2 = con.prepareStatement(updateRoom);
            ps2.setInt(1, bookingId);
            ps2.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
