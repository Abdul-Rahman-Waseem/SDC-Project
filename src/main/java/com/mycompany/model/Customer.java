package com.mycompany.model;


public class Customer {

    public Customer() {}
    public Customer(String name, String email, String password) {
        this.name = name;
        this.email = email;
        this.password = password;
    }
    
    private int customerId;
    private String name;
    private String email;
    private String password;
    
    public int getId() { return customerId; }
    
    public String getName() { return name; }
    
    public String getPassword() { return password; }
    
    public String getEmail() { return email; }
    
    public void setId(int customerId) {
        this.customerId = customerId;
    }

    public void setName(String name) {
        this.name = name;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setPassword(String password) {
        this.password = password;
    }

   

}