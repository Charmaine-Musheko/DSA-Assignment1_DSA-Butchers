import ballerina/io;
import ballerina/uuid;

CarRentalClient ep = check new ("http://localhost:9000");

public function main(string... args) returns error? {
    string carId = args.length() > 0 ? args[0] : "car-" + uuid:createType1AsString();
    string carMake = args.length() > 1 ? args[1] : "Nissan";
    string carModel = args.length() > 2 ? args[2] : "Leaf";
    string userId = args.length() > 3 ? args[3] : "user-" + uuid:createType4AsString();
    string searchQuery = args.length() > 4 ? args[4] : carMake;

    Car addCarRequest = {id: carId, make: carMake, model: carModel, price: 4500, available: true};
    Response addCarResponse = check ep->AddCar(addCarRequest);
    io:println("AddCar => " + addCarResponse.message);

    Car updateCarRequest = {id: carId, make: carMake, model: carModel + " Premium", price: 4800, available: true};
    Response updateCarResponse = check ep->UpdateCar(updateCarRequest);
    io:println("UpdateCar => " + updateCarResponse.message);

    CarList listAvailableCarsResponse = check ep->ListAvailableCars({});
    io:println("ListAvailableCars => " + listAvailableCarsResponse.cars.toString());

    SearchRequest searchCarRequest = {query: searchQuery};
    CarList searchCarResponse = check ep->SearchCar(searchCarRequest);
    io:println("SearchCar => " + searchCarResponse.cars.toString());

    CartRequest addToCartRequest = {carId: carId, userId: userId};
    Response addToCartResponse = check ep->AddToCart(addToCartRequest);
    io:println("AddToCart => " + addToCartResponse.message);

    ReservationRequest placeReservationRequest = {userId: userId, carIds: [carId]};
    ReservationResponse placeReservationResponse = check ep->PlaceReservation(placeReservationRequest);
    io:println("PlaceReservation => status:" + placeReservationResponse.status + ", totalPrice:" + placeReservationResponse.totalPrice.toString());
}
