// Ngozu's module: list/search cars and manage cart operations

import ballerina/io;

// Return all cars marked as available
public function listAvailableCars() returns CarList {
    // TODO: Ngozu to filter `cars` table for available entries
    io:println("Listing available cars");
    return { cars: [] };
}

// Search cars using a simple query string
public function searchCar(SearchRequest req) returns CarList {
    // TODO: Ngozu to search `cars` table using request.query
    io:println("Searching cars for query: " + req.query);
    return { cars: [] };
}

// Add a car to a user's cart (cart storage not yet implemented)
public function addToCart(CartRequest req) returns Response {
    // TODO: Ngozu to manage user cart and add the specified car
    io:println("Adding car to cart for user: " + req.userId);
    return { message: "Added to cart" };
}

