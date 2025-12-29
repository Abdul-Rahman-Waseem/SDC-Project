package com.mycompany.DAO;

import com.mycompany.db.DBConnection;
import com.mycompany.model.Customer;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 * CustomerDAO: Handles all DB operations related to Customer
 * @author ARW : addCustomer(), getAllCustomer()
 * @author hamza : 
 * @author asim :
 */
public class CustomerDAO {

    // Add a new customer
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO customer (name, email, password) VALUES (?, ?, ?)";
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

    // ✅ Get all customers
    public List<Customer> getAllCustomer() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customer ORDER BY customerid DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer c = new Customer();
                c.setId(rs.getInt("customerid")); // match model
                c.setName(rs.getString("name"));
                c.setEmail(rs.getString("email"));
                c.setPassword(rs.getString("password"));
                customers.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return customers;
    }

    // Remove a customer by ID
    public boolean removeCustomer(int customerId) {
        String sql = "DELETE FROM customer WHERE customerid=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public Customer getCustomerByEmail(String email) {
        Customer customer = null;
        String sql = "SELECT * FROM customer WHERE email=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = new Customer();
                    customer.setId(rs.getInt("customerid"));
                    customer.setName(rs.getString("name"));
                    customer.setEmail(rs.getString("email"));
                    customer.setPassword(rs.getString("password"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return customer;
    }

    // ✅ Validate login (email + password)
    public Customer validateLogin(String email, String password) {
        Customer customer = getCustomerByEmail(email);
        if (customer != null && customer.getPassword().equals(password)) {
            return customer;
        }
        return null;
    }
}
