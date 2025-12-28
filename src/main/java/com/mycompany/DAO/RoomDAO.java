package com.mycompany.DAO;

import com.mycompany.model.Room;
import com.mycompany.db.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * ADD THE NAME OF MEMBER FUNCTION YOU MADE AFTER YOUR NAME
 * @author ARW : addRoom(), getAllRooms(), removeRoom(), getRoomByNumber(), updateRoom(), getTotalRooms(), getBookedRooms()
 * @author hamza : getAvailableRooms(), getAvailableRoomsByDateRange(), getRoomById()
 * @author asim :
 */
public class RoomDAO {
    
    public boolean addRoom(Room room) {

        String sql = "INSERT INTO room " +
                     "(room_number, room_type, price, description, status, adminid) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, room.getRoomNumber());
                ps.setString(2, room.getRoomType());
                ps.setDouble(3, room.getPricePerNight());
                ps.setString(4, room.getDescription());
                ps.setString(5, room.getStatus());
                ps.setInt(6, room.getAdminId());

                return ps.executeUpdate() > 0;

            } catch (Exception e) {
                e.printStackTrace();
            }
        return false;
    }
    
    public List<Room> getAllRooms() {

        List<Room> rooms = new ArrayList<>();

        String sql = "SELECT * FROM room ORDER BY roomid DESC";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Room r = new Room();
                    r.setRoomId(rs.getInt("roomid"));
                    r.setRoomNumber(rs.getString("room_number"));
                    r.setRoomType(rs.getString("room_type"));
                    r.setPricePerNight(rs.getDouble("price"));
                    r.setDescription(rs.getString("description"));
                    r.setStatus(rs.getString("status"));

                    rooms.add(r);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        return rooms;
    }
    
    public boolean removeRoom(int roomId) {
        String sql = "DELETE FROM room WHERE roomid=?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);){
            
                ps.setInt(1, roomId);
                int rows = ps.executeUpdate();
                return rows > 0;
                
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Room getRoomByNumber(String roomNumber) {
        String sql = "SELECT * FROM room WHERE room_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, roomNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getInt("roomid"));
                room.setRoomType(rs.getString("room_type"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setPricePerNight(rs.getDouble("price"));
                room.setDescription(rs.getString("description"));
                room.setStatus(rs.getString("status").toUpperCase());
                room.setAdminId(rs.getInt("adminid"));
                return room;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
        
    public boolean updateRoom(Room room) {
        String sql = "UPDATE room SET room_type=?, price=?, description=?, status=? WHERE room_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomType());
            ps.setDouble(2, room.getPricePerNight());
            ps.setString(3, room.getDescription());
            ps.setString(4, room.getStatus());
            ps.setString(5, room.getRoomNumber());

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public int getTotalRooms() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM room";
        
        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        System.out.println(count);
        return count;
        
    }

    public int getBookedRooms() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM room WHERE status = 'BOOKED'";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        System.out.println(count);
        return count;
    }

    // ✅ NEW METHOD: Get all available rooms
  public List<Room> getAvailableRooms() {
    List<Room> rooms = new ArrayList<>();
    String sql = "SELECT * FROM room WHERE TRIM(UPPER(status)) = 'AVAILABLE' ORDER BY roomid";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            Room room = new Room();
            room.setRoomId(rs.getInt("roomid"));
            room.setRoomNumber(rs.getString("room_number"));
            room.setRoomType(rs.getString("room_type"));
            room.setPricePerNight(rs.getDouble("price"));
            room.setStatus(rs.getString("status"));
            room.setDescription(rs.getString("description"));
            room.setAdminId(rs.getInt("adminid"));
            rooms.add(room);
        }

        System.out.println("DAO: Available rooms fetched = " + rooms.size());
    } catch (Exception e) {
        e.printStackTrace();
    }
    return rooms;
}

    // ✅ NEW METHOD: Get room by ID
    public Room getRoomById(int roomId) {
        Room room = null;
        String sql = "SELECT * FROM room WHERE roomid = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    room = new Room();
                    room.setRoomId(rs.getInt("roomid"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setRoomType(rs.getString("room_type"));
                    room.setPricePerNight(rs.getDouble("price"));
                    room.setStatus(rs.getString("status"));
                    room.setDescription(rs.getString("description"));
                    room.setAdminId(rs.getInt("adminid"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return room;
    }

}