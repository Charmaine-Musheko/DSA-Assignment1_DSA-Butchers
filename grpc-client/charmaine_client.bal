import ballerina/io;

// Charmaine's gRPC client: demonstrates end-to-end interactions with the server
public function main() returns error? {
        CarRentalClient rentalClient = check new ("http://localhost:9090");

        // Add car
        Response resp = check rentalClient->AddCar({ id: "1", make: "Toyota", model: "Corolla", price: 50.0, available: true });
        io:println(resp);

        // Update car
        resp = check rentalClient->UpdateCar({ id: "1", make: "Toyota", model: "Corolla", price: 55.0, available: true });
        io:println(resp);

        // Search car
        CarList cars = check rentalClient->SearchCar({ query: "Toyota" });
        io:println(cars);

        // Add to cart
        resp = check rentalClient->AddToCart({ carId: "1", userId: "u1" });
        io:println(resp);

        // List available cars
        cars = check rentalClient->ListAvailableCars({});
        io:println(cars);

        // Place reservation
        ReservationResponse reservation = check rentalClient->PlaceReservation({ userId: "u1", carIds: ["1"] });
        io:println(reservation);

        // Remove car
        resp = check rentalClient->RemoveCar({ id: "1" });
        io:println(resp);
}
