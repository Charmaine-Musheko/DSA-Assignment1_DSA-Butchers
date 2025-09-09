import ballerina/io;

// Charmaine's gRPC client: demonstrates end-to-end interactions with the server
public function main() returns error? {
        CarRentalClient rentalClient = check new ("http://localhost:9090");

        // TODO: Extend client with more test cases for all RPCs

        // Add car
        Response resp = check rentalClient->AddCar({ id: "1", make: "Toyota", model: "Corolla", price: 50.0, available: true });
        io:println(resp);

        // List available cars
        CarList cars = check rentalClient->ListAvailableCars({});
        io:println(cars);

        // Place reservation
        ReservationResponse reservation = check rentalClient->PlaceReservation({ userId: "u1", carIds: ["1"] });
        io:println(reservation);
}
