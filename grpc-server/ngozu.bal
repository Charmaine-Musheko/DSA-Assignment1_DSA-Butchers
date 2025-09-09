// Ngozu's module: list/search cars and manage cart operations

import ballerina/io;

// Return all cars marked as available
public function listAvailableCars() returns CarList {
    io:println("Listing available cars");
    Car[] available = from var car in cars
                      where car.available
                      select car;
    return { cars: available };
}

// Search cars using a simple query string
public function searchCar(SearchRequest req) returns CarList {
    io:println("Searching cars for query: " + req.query);
    Car[] matched = from var car in cars
                    where car.make == req.query || car.model == req.query
                    select car;
    return { cars: matched };
}

// Add a car to a user's cart (cart storage not yet implemented)
map<string[]> carts = {};

public function addToCart(CartRequest req) returns Response {
    io:println("Adding car to cart for user: " + req.userId);
    string[] cart = carts[req.userId] ?: [];
    cart.push(req.carId);
    carts[req.userId] = cart;
    return { message: "Added to cart" };
}

