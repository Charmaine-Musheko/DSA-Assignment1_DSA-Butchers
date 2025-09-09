import ballerina/grpc;

public function main() returns error? {
	CarRentalClient client = check new ("http://localhost:9090");
	// Add car
	var resp = check client->AddCar({ id: "1", make: "Toyota", model: "Corolla", price: 50.0, available: true });
	io:println(resp);
	// List available cars
	var cars = check client->ListAvailableCars({});
	io:println(cars);
	// Place reservation
	var reservation = check client->PlaceReservation({ userId: "u1", carIds: ["1"] });
	io:println(reservation);
}
