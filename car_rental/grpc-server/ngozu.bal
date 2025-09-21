import ballerina/io;

// Return all cars marked as available
public function listAvailableCars() returns CarList {
    io:println("Listing available cars");
    return listAvailableCarsFromInventory();
}

// Search cars using a simple query string
public function searchCar(SearchRequest req) returns CarList {
    string query = extractQuery(req);
    io:println("Searching cars for query: " + query);
    return searchCarsInInventory(query);
}

// Add a car to a user's cart
public function addToCart(CartRequest req) returns Response {
    io:println("Adding car to cart for user: " + req.userId);
    return addItemToCart(req);
}

public function extractQuery(SearchRequest req) returns string {
    anydata value = req["query"];
    if value is string {
        return value;
    }
    return "";
}
