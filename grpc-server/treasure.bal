// Treasure's module: reservation placement, price calculation, validation

import ballerina/io;

// Place a reservation for the given user and list of car IDs
public function placeReservation(ReservationRequest req) returns ReservationResponse {
    io:println("Placing reservation for user: " + req.userId);
    float total = 0.0;
    foreach string id in req.carIds {
        Car? car = cars.get(id);
        if car is Car && car.available {
            total += car.price;
            car.available = false;
            _ = cars.put(car);
        } else {
            return { status: "Car unavailable: " + id, totalPrice: 0.0 };
        }
    }
    return { status: "Reserved", totalPrice: total };
}

