package SDC_Project;

import com.mycompany.DAO.RoomDAO;
import com.mycompany.model.Room;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

/**
 *
 * @author look4
 */
public class manageRoomTest {
    @Test
    void testAddRoomSuccess() {
        RoomDAO dao = new RoomDAO();
        Room room = new Room();
        room.setRoomNumber("1" + System.currentTimeMillis());
        room.setRoomType("Deluxe");
        room.setPricePerNight(5000.0);
        room.setDescription("JUnit test room");
        room.setStatus("Available");
        room.setAdminId(1);
        boolean result = dao.addRoom(room);
        assertTrue(result, "Room should be added successfully");
    }
}
