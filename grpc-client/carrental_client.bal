import ballerina/io;
import ballerina/uuid;

CarRentalClient ep = check new ("http://localhost:9000");

public function main() returns error? {
    string stamp = uuid:createType4AsString();

    string addCarId = "cli-add-" + stamp;
    Car addCarRequest = {
        id: addCarId,
        make: "Storm",
        model: "Coupe",
        price: 45.0,
        available: true
    };
    Response addCarResponse = check ep->AddCar(addCarRequest);
    io:println(string `AddCar(${addCarId}) -> ${addCarResponse.message}`);

    string updateCarId = "cli-update-" + stamp;
    Car createUpdateCar = {
        id: updateCarId,
        make: "Nimbus",
        model: "Hatch",
        price: 55.0,
        available: true
    };
    _ = check ep->AddCar(createUpdateCar);
    Car updateCarRequest = {
        id: updateCarId,
        make: "Nimbus",
        model: "Hatchback",
        price: 60.0,
        available: true
    };
    Response updateCarResponse = check ep->UpdateCar(updateCarRequest);
    io:println(string `UpdateCar(${updateCarId}) -> ${updateCarResponse.message}`);

    string removeCarId = "cli-remove-" + stamp;
    Car createRemoveCar = {
        id: removeCarId,
        make: "Bolt",
        model: "Sedan",
        price: 40.0,
        available: true
    };
    _ = check ep->AddCar(createRemoveCar);
    Response removeCarResponse = check ep->RemoveCar({id: removeCarId});
    io:println(string `RemoveCar(${removeCarId}) -> ${removeCarResponse.message}`);

    CarList listAvailableCarsResponse = check ep->ListAvailableCars({});
    io:println(string `ListAvailableCars -> ${listAvailableCarsResponse.cars.length()} cars available`);

    string searchCarId = updateCarId;
    CarList searchCarResponse = check ep->SearchCar({query: searchCarId});
    io:println(string `SearchCar(${searchCarId}) -> ${searchCarResponse.cars.length()} matches`);

    string userId = "cli-user-" + stamp;
    string cartCarId = "cli-cart-" + stamp;
    Car cartCar = {
        id: cartCarId,
        make: "Pulse",
        model: "SUV",
        price: 75.0,
        available: true
    };
    _ = check ep->AddCar(cartCar);
    Response addToCartResponse = check ep->AddToCart({carId: cartCarId, userId: userId});
    io:println(string `AddToCart(${cartCarId}) -> ${addToCartResponse.message}`);

    ReservationResponse placeReservationResponse = check ep->PlaceReservation({
        userId: userId,
        carIds: [cartCarId]
    });
    io:println(string `PlaceReservation(${cartCarId}) -> status: ${placeReservationResponse.status}, total: ${placeReservationResponse.totalPrice}`);
}