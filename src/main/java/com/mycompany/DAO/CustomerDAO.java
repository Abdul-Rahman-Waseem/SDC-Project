package com.mycompany.DAO;

import com.mycompany.db.DBConnection;
import com.mycompany.model.Customer;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * ADD THE NAME OF MEMBER FUNCTION YOU MADE AFTER YOUR NAME
 * @author ARW : addCustomer(), getAllCustomer()
 * @author hamza : 
 * @author asim :
 */
public class CustomerDAO {
    public boolean addCustomer(Customer customer) {

        String sql = "INSERT INTO customer " +
                     "(name, email, password) " +
                     "VALUES (?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, customer.getName());
                ps.setString(2, customer.getEmail());
                ps.setString(3, customer.getPassword());

                return ps.executeUpdate() > 0;

            } catch (Exception e) {
                e.printStackTrace();
            }
        return false;
    }
    
    public List<Customer> getAllCustomer() {

        List<Customer> customers = new ArrayList<>();

        String sql = "SELECT * FROM customer ORDER BY customerid DESC";

        try (Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    Customer r = new Customer();
                    r.setId(rs.getInt("customerid"));
                    r.setName(rs.getString("name"));
                    r.setEmail(rs.getString("email"));
                    r.setPassword(rs.getString("password"));

                    customers.add(r);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        return customers;
    }
    
    public boolean removeCustomer(int Id) {
        String sql = "DELETE FROM customer WHERE customerid=?";
        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);){
            
                ps.setInt(1, Id);
                int rows = ps.executeUpdate();
                return rows > 0;
                
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
