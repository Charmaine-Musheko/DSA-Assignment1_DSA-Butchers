import ballerina/io;

CarRentalClient ep = check new ("http://localhost:9000");

public function main() returns error? {
    Car addCarRequest = {id: "ballerina", make: "ballerina", model: "ballerina", price: 1, available: true};
    Response addCarResponse = check ep->AddCar(addCarRequest);
    io:println(addCarResponse);

    Car updateCarRequest = {id: "ballerina", make: "ballerina", model: "ballerina", price: 1, available: true};
    Response updateCarResponse = check ep->UpdateCar(updateCarRequest);
    io:println(updateCarResponse);

    CarId removeCarRequest = {id: "ballerina"};
    Response removeCarResponse = check ep->RemoveCar(removeCarRequest);
    io:println(removeCarResponse);

    Empty listAvailableCarsRequest = {};
    CarList listAvailableCarsResponse = check ep->ListAvailableCars(listAvailableCarsRequest);
    io:println(listAvailableCarsResponse);

    SearchRequest searchCarRequest = {query: "ballerina"};
    CarList searchCarResponse = check ep->SearchCar(searchCarRequest);
    io:println(searchCarResponse);

    CartRequest addToCartRequest = {carId: "ballerina", userId: "ballerina"};
    Response addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println(addToCartResponse);

    ReservationRequest placeReservationRequest = {userId: "ballerina", carIds: ["ballerina"]};
    ReservationResponse placeReservationResponse = check ep->PlaceReservation(placeReservationRequest);
    io:println(placeReservationResponse);
}
