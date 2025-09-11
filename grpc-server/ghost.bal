import ballerina/grpc;
import ballerina/time;

// Define the types
type Car record {
    string id;
    string make;
    string model;
    int year;
    string color;
    decimal pricePerDay;
    boolean available;
};

type CarId record {
    string id;
};

type Response record {
    string message;
};

type Empty record {};

type CarList record {
    Car[] cars;
};

type SearchRequest record {
    string make;
    string model;
    int year;
    string color;
    decimal maxPrice;
};

type CartRequest record {
    string carId;
    string userId;
};

type ReservationRequest record {
    string carId;
    string userId;
    time:Utc startDate;
    time:Utc endDate;
};

type ReservationResponse record {
    string reservationId;
    decimal totalPrice;
    string message;
};

// In-memory tables to store data
table<Car> key(id) cars = table [];
table<CartRequest> key(carId, userId) cartItems = table [];
table<ReservationRequest> key(reservationId) reservations = table [];

// Counter for generating reservation IDs
int reservationIdCounter = 1;

// Main gRPC service
service "/CarRental" on new grpc:Listener(9090) {

    // Add a new car to the table
    remote function AddCar(Car car) returns Response|error {
        if cars.hasKey(car.id) {
            return {message: "Car with ID " + car.id + " already exists"};
        }
        
        cars.add(car);
        return {message: "Car added successfully"};
    }

    // Update an existing car entry
    remote function UpdateCar(Car car) returns Response|error {
        if !cars.hasKey(car.id) {
            return {message: "Car with ID " + car.id + " not found"};
        }
        
        _ = cars.remove(car.id);
        cars.add(car);
        return {message: "Car updated successfully"};
    }

    // Remove a car from the table
    remote function RemoveCar(CarId id) returns Response|error {
        if !cars.hasKey(id.id) {
            return {message: "Car with ID " + id.id + " not found"};
        }
        
        _ = cars.remove(id.id);
        return {message: "Car removed successfully"};
    }

    // List all currently available cars
    remote function ListAvailableCars(Empty req) returns CarList|error {
        Car[] availableCars = from var car in cars
            where car.available
            select car;
        
        return {cars: availableCars};
    }

    // Search for cars matching the query
    remote function SearchCar(SearchRequest req) returns CarList|error {
        Car[] matchingCars = from var car in cars
            where car.available && 
                (req.make == "" || car.make == req.make) &&
                (req.model == "" || car.model == req.model) &&
                (req.year == 0 || car.year == req.year) &&
                (req.color == "" || car.color == req.color) &&
                (req.maxPrice == 0 || car.pricePerDay <= req.maxPrice)
            select car;
        
        return {cars: matchingCars};
    }

    // Add a selected car to a user's cart
    remote function AddToCart(CartRequest req) returns Response|error {
        if !cars.hasKey(req.carId) {
            return {message: "Car with ID " + req.carId + " not found"};
        }
        
        // Check if car is already in user's cart
        if cartItems.hasKey(req.carId, req.userId) {
            return {message: "Car is already in your cart"};
        }
        
        cartItems.add(req);
        return {message: "Car added to cart successfully"};
    }

    // Place a reservation and calculate pricing
    remote function PlaceReservation(ReservationRequest req) returns ReservationResponse|error {
        // Check if car exists
        if !cars.hasKey(req.carId) {
            return {reservationId: "", totalPrice: 0, message: "Car not found"};
        }
        
        // Check if car is available
        Car car = cars.get(req.carId);
        if !car.available {
            return {reservationId: "", totalPrice: 0, message: "Car is not available"};
        }
        
        // Calculate number of days
        time:Utc start = req.startDate;
        time:Utc end = req.endDate;
        decimal days = <decimal>(time:utcDiffSeconds(end, start) / (24 * 60 * 60));
        
        if days <= 0 {
            return {reservationId: "", totalPrice: 0, message: "Invalid date range"};
        }
        
        // Calculate total price
        decimal totalPrice = car.pricePerDay * days;
        
        // Generate reservation ID
        string reservationId = "RES" + reservationIdCounter.toString();
        reservationIdCounter += 1;
        
        // Mark car as unavailable
        car.available = false;
        _ = cars.remove(req.carId);
        cars.add(car);
        
        // Add to reservations table
        reservations.add(req);
        
        return {
            reservationId: reservationId,
            totalPrice: totalPrice,
            message: "Reservation placed successfully"
        };
    }
}
