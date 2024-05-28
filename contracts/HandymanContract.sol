// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HandymanContract {
    struct Booking {
        string name;
        string email;
        string service;
        string date;
        string time;
        address contractor; // Address of the contractor assigned to the booking
    }

    Booking[] public bookings;
    uint256 public nextBookingId; // Track the next available booking ID

    mapping(uint256 => address) public bookingToContractor; // Mapping from booking ID to contractor address

    event BookingCreated(uint256 bookingId, string name, string email, string service, string date, string time);
    event BookingUpdated(uint256 bookingId, string name, string email, string service, string date, string time);
    event BookingDeleted(uint256 bookingId);
    event JobAssigned(uint256 bookingId, address contractor);
    event AssignmentCancelled(uint256 bookingId);

    // Function to book a service
    function bookService(string memory _name, string memory _email, string memory _service, string memory _date, string memory _time) public {
        bookings.push(Booking(_name, _email, _service, _date, _time, address(0)));
        emit BookingCreated(nextBookingId, _name, _email, _service, _date, _time);
        nextBookingId++; // Increment the next booking ID
    }

    // Function to get the list of bookings
    function getBookings() public view returns (Booking[] memory) {
        return bookings;
    }

    // Function to edit an existing booking
    function editBooking(uint256 _bookingId, string memory _name, string memory _email, string memory _service, string memory _date, string memory _time) public {
        require(_bookingId < nextBookingId, "Invalid booking ID");
        bookings[_bookingId] = Booking(_name, _email, _service, _date, _time, bookings[_bookingId].contractor);
        emit BookingUpdated(_bookingId, _name, _email, _service, _date, _time);
    }

    // Function to delete an existing booking
    function deleteBooking(uint256 _bookingId) public {
        require(_bookingId < nextBookingId, "Invalid booking ID");
        delete bookings[_bookingId];
        emit BookingDeleted(_bookingId);
    }

    // Function to assign a booking to a contractor
    function assignJob(uint256 _bookingId, address _contractor) public {
        require(_bookingId < nextBookingId, "Invalid booking ID");
        require(bookings[_bookingId].contractor == address(0), "Job already assigned");
        bookings[_bookingId].contractor = _contractor;
        bookingToContractor[_bookingId] = _contractor;
        emit JobAssigned(_bookingId, _contractor);
    }

    // Function to cancel the assignment of a booking
    function cancelAssignment(uint256 _bookingId) public {
        require(_bookingId < nextBookingId, "Invalid booking ID");
        require(bookings[_bookingId].contractor != address(0), "No contractor assigned");
        bookings[_bookingId].contractor = address(0);
        delete bookingToContractor[_bookingId];
        emit AssignmentCancelled(_bookingId);
    }

    // Function to get the list of bookings assigned to a contractor
    function getAssignedJobs(address _contractor) public view returns (Booking[] memory) {
        uint256 count = 0;
        for (uint256 i = 0; i < bookings.length; i++) {
            if (bookings[i].contractor == _contractor) {
                count++;
            }
        }

        Booking[] memory assignedJobs = new Booking[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < bookings.length; i++) {
            if (bookings[i].contractor == _contractor) {
                assignedJobs[index] = bookings[i];
                index++;
            }
        }

        return assignedJobs;
    }

    // Function to delete all bookings assigned to a contractor
    function deleteAllAssignedJobs(address _contractor) public {
        for (uint256 i = 0; i < bookings.length; i++) {
            if (bookings[i].contractor == _contractor) {
                delete bookings[i];
                emit BookingDeleted(i);
            }
        }
    }
}
