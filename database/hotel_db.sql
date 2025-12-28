-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 22, 2025 at 07:11 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `hotel_db`
--

-- --------------------------------------------------------
--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `username`, `password`) VALUES
(1, 'admin', '1234');

-- --------------------------------------------------------
--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `customerid` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customerid`, `name`, `email`, `password`) VALUES
(1, 'Abdul Rahman Waseem', 'look4rahman@gmail.com', 'test@123'),
(2, 'Rahman', 'lookrahman@gmail.com', 'test@123'),
(3, 'Abdul Rahman Waseem', 'look8rahman@gmail.com', 'test@123'),
(4, 'AbdulRahman', 'look5rahman@gmail.com', 'test@123');

-- --------------------------------------------------------
--
-- Table structure for table `room`
--

CREATE TABLE `room` (
  `roomid` int(11) NOT NULL,
  `room_number` varchar(20) NOT NULL,
  `room_type` varchar(50) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `status` enum('AVAILABLE','BOOKED') DEFAULT 'AVAILABLE',
  `adminid` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `room`
--

INSERT INTO `room` (`roomid`, `room_number`, `room_type`, `price`, `description`, `status`, `adminid`) VALUES
(2, '101', 'Single', 5000.00, 'Cozy single room with city view', 'AVAILABLE', 1),
(4, '303', 'Suite', 18000.00, 'Luxury suite with lounge and minibar', 'AVAILABLE', 1),
(5, '404', 'Family', 10000.00, 'Large family room with two beds', 'AVAILABLE', 1),
(24, '506', 'Single', 5000.00, 'Cozy single room with sea view', 'BOOKED', 1),
(26, '606', 'Deluxe', 12000.00, 'Sea view with balcony', 'AVAILABLE', 1),
(27, '103', 'Single', 5000.00, 'Cozy single room with city view', 'AVAILABLE', 1),
(28, '104', 'Double', 7500.00, 'Spacious double room with WiFi and AC', 'BOOKED', 1),
(29, '29', 'Suite', 19000.00, 'Luxury suite with lounge, minibar and balcony', 'AVAILABLE', 1);

-- --------------------------------------------------------
--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `bookingid` int(11) NOT NULL,
  `customerid` int(11) NOT NULL,
  `roomid` int(11) NOT NULL,
  `booking_date` date NOT NULL,
  `check_in` date NOT NULL,
  `check_out` date NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `payment_method` varchar(20) NOT NULL,
  `booking_status` enum('PENDING','CONFIRMED','CANCELLED') DEFAULT 'PENDING'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`bookingid`, `customerid`, `roomid`, `booking_date`, `check_in`, `check_out`, `total_price`, `payment_method`, `booking_status`) VALUES
(1, 1, 2, '2025-01-01', '2025-01-05', '2025-01-08', 15000.00, 'Cash', 'CONFIRMED'),
(2, 2, 4, '2025-01-03', '2025-01-10', '2025-01-12', 36000.00, 'Cash', 'CONFIRMED'),
(3, 3, 5, '2025-01-04', '2025-01-15', '2025-01-18', 30000.00, 'Online', 'CANCELLED'),
(4, 4, 26, '2025-01-06', '2025-01-20', '2025-01-22', 24000.00, 'Cash', 'CONFIRMED'),
(5, 1, 28, '2025-01-08', '2025-01-25', '2025-01-28', 22500.00, 'Online', 'CONFIRMED');

-- --------------------------------------------------------
-- Indexes
--

ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

ALTER TABLE `customer`
  ADD PRIMARY KEY (`customerid`),
  ADD UNIQUE KEY `email` (`email`);

ALTER TABLE `room`
  ADD PRIMARY KEY (`roomid`),
  ADD KEY `fk_room_admin` (`adminid`);

ALTER TABLE `booking`
  ADD PRIMARY KEY (`bookingid`),
  ADD KEY `fk_booking_customer` (`customerid`),
  ADD KEY `fk_booking_room` (`roomid`);

-- --------------------------------------------------------
-- AUTO_INCREMENT
--

ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

ALTER TABLE `customer`
  MODIFY `customerid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

ALTER TABLE `room`
  MODIFY `roomid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

ALTER TABLE `booking`
  MODIFY `bookingid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

-- --------------------------------------------------------
-- Constraints
--

ALTER TABLE `booking`
  ADD CONSTRAINT `fk_booking_customer` FOREIGN KEY (`customerid`) REFERENCES `customer` (`customerid`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_booking_room` FOREIGN KEY (`roomid`) REFERENCES `room` (`roomid`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE `room`
  ADD CONSTRAINT `fk_room_admin` FOREIGN KEY (`adminid`) REFERENCES `admin` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

COMMIT;
