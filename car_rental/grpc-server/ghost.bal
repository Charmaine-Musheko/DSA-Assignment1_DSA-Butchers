public type CartEntry record {| 
    string carId;
    string userId;
|};

public type Reservation record {| 
    string reservationId;
    string userId;
    string[] carIds;
    float totalPrice;
|};

final map<Car> cars = {};
final map<CartEntry[]> cartsByUser = {};
final map<Reservation> reservations = {};
int reservationIdCounter = 1;

public function addCarToInventory(Car car) returns Response {
    if car.id == "" {
        return {message: "Car id is required"};
    }

    if cars.hasKey(car.id) {
        return {message: "Car with ID " + car.id + " already exists"};
    }

    cars[car.id] = car;
    return {message: "Car added successfully"};
}

public function updateCarInInventory(Car car) returns Response {
    if !cars.hasKey(car.id) {
        return {message: "Car with ID " + car.id + " not found"};
    }

    cars[car.id] = car;
    return {message: "Car updated successfully"};
}

public function removeCarFromInventory(CarId id) returns Response {
    if !cars.hasKey(id.id) {
        return {message: "Car with ID " + id.id + " not found"};
    }

    _ = cars.remove(id.id);
    foreach var [userId, cartValue] in cartsByUser.entries() {
        CartEntry[] cartEntries = <CartEntry[]>cartValue;
        CartEntry[] filtered = [];
        foreach var entry in cartEntries {
            if entry.carId != id.id {
                filtered.push(entry);
            }
        }
        cartsByUser[userId] = filtered;
    }

    return {message: "Car removed successfully"};
}

public function listAvailableCarsFromInventory() returns CarList {
    Car[] availableCars = [];
    foreach var [_, car] in cars.entries() {
        if car.available {
            availableCars.push(car);
        }
    }
    return {cars: availableCars};
}

public function searchCarsInInventory(string query) returns CarList {
    string lowered = query.toLowerAscii();
    if lowered == "" {
        return listAvailableCarsFromInventory();
    }

    Car[] matches = [];
    foreach var [_, car] in cars.entries() {
        if !car.available {
            continue;
        }
        string make = car.make.toLowerAscii();
        string model = car.model.toLowerAscii();
        string idValue = car.id.toLowerAscii();
        if make == lowered || model == lowered || idValue == lowered {
            matches.push(car);
        }
    }
    return {cars: matches};
}

public function addItemToCart(CartRequest req) returns Response {
    if !cars.hasKey(req.carId) {
        return {message: "Car with ID " + req.carId + " not found"};
    }

    Car car = <Car>cars[req.carId];
    if !car.available {
        return {message: "Car with ID " + req.carId + " is not available"};
    }

    CartEntry[] userCart = [];
    if cartsByUser.hasKey(req.userId) {
        userCart = <CartEntry[]>cartsByUser[req.userId];
    }

    foreach var entry in userCart {
        if entry.carId == req.carId {
            return {message: "Car already in cart"};
        }
    }

    userCart.push({carId: req.carId, userId: req.userId});
    cartsByUser[req.userId] = userCart;
    return {message: "Car added to cart"};
}

public function reserveCars(ReservationRequest req) returns ReservationResponse {
    if req.carIds.length() == 0 {
        return {status: "FAILED", totalPrice: 0.0};
    }

    Car[] carsToReserve = [];
    float totalPrice = 0.0;
    foreach var carId in req.carIds {
        if !cars.hasKey(carId) {
            return {status: "FAILED", totalPrice: 0.0};
        }
        Car car = <Car>cars[carId];
        if !car.available {
            return {status: "FAILED", totalPrice: 0.0};
        }
        totalPrice += car.price;
        carsToReserve.push(car);
    }

    foreach var reservedCar in carsToReserve {
        reservedCar.available = false;
        cars[reservedCar.id] = reservedCar;
    }

    string reservationId = "RES-" + reservationIdCounter.toString();
    reservationIdCounter += 1;
    reservations[reservationId] = {
        reservationId: reservationId,
        userId: req.userId,
        carIds: req.carIds.clone(),
        totalPrice: totalPrice
    };

    _ = cartsByUser.remove(req.userId);
    return {status: reservationId, totalPrice: totalPrice};
}
