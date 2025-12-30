package SDC_Project;

import com.mycompany.DAO.AdminDAO;
import com.mycompany.model.Admin;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;
import org.junit.jupiter.api.Test;
/**
 *
 * @author look4
 */
public class adminLoginTest {

    @Test
    void testLoginWithCorrectCredentials() {
        AdminDAO dao = new AdminDAO();
        Admin admin = dao.login("admin", "1234");
        assertEquals("admin", admin.getUsername());
    }

    @Test
    void testLoginWithWrongPassword() {
        AdminDAO dao = new AdminDAO();
        Admin admin = dao.login("admin", "wrongpass");
        assertNull(admin, "Admin should be null for wrong password");
    }

    @Test
    void testLoginWithWrongUsername() {
        AdminDAO dao = new AdminDAO();
        Admin admin = dao.login("wronguser", "1234");
        assertNull(admin, "Admin should be null for wrong username");
    }   
}
