package SDC_Project;

import com.mycompany.DAO.CustomerDAO;
import com.mycompany.model.Customer;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

/**
 *
 * @author look4
 */
public class manageCustomerTest {

    @Test
    void testAddCustomerSuccess() {
        CustomerDAO dao = new CustomerDAO();
        Customer customer = new Customer();
        customer.setName("JUnit User");
        customer.setEmail("junit"+ System.currentTimeMillis() +"@test.com");
        customer.setPassword("test123");
        boolean result = dao.addCustomer(customer);
        assertTrue(result, "Customer should be added successfully");
    }

    @Test
    void testRemoveCustomerFail_InvalidId() {
        CustomerDAO dao = new CustomerDAO();
        boolean result = dao.removeCustomer(99999);
        assertFalse(result, "Removing non-existing customer should return false");
    }
}
