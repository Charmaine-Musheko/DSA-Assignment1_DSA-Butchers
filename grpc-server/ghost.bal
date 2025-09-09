import ballerina/grpc;

// In-memory table to store cars
table<Car> key(id) cars = table [];

// Main gRPC service
@grpc:ServiceDescriptor { descriptor: PATEMA_DESC }
service "CarRental" on new grpc:Listener(9090) {

        // Ghost: add a new car to the table
        remote function AddCar(Car car) returns Response|error {
                check cars.add(car);
                return { message: "Car added" };
        }

        // Ghost: update an existing car entry
        remote function UpdateCar(Car car) returns Response|error {
                if cars.hasKey(car.id) {
                        check cars.put(car);
                        return { message: "Car updated" };
                }
                return { message: "Car not found" };
        }

        // Ghost: remove a car from the table
        remote function RemoveCar(CarId id) returns Response|error {
                if cars.hasKey(id.id) {
                        _ = cars.remove(id.id);
                        return { message: "Car removed" };
                }
                return { message: "Car not found" };
        }

        // Ngozu: list all currently available cars
        remote function ListAvailableCars(Empty req) returns CarList|error {
                // Delegate to Ngozu's implementation in ngozu.bal
                return listAvailableCars();
        }

        // Ngozu: search for cars matching the query
        remote function SearchCar(SearchRequest req) returns CarList|error {
                // Delegate to Ngozu's implementation in ngozu.bal
                return searchCar(req);
        }

        // Ngozu: add a selected car to a user's cart
        remote function AddToCart(CartRequest req) returns Response|error {
                // Delegate to Ngozu's implementation in ngozu.bal
                return addToCart(req);
        }

        // Treasure: place a reservation and calculate pricing
        remote function PlaceReservation(ReservationRequest req) returns ReservationResponse|error {
                // Delegate to Treasure's implementation in treasure.bal
                return placeReservation(req);
        }
}

