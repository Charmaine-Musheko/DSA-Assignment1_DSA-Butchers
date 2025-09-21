import ballerina/grpc;
import ballerina/log;
import ballerina/time;
import ballerina/uuid;

// Import the generated proto package (adjust the module name to match your project).
import car_rental_pb;

// In-memory data stores
map<car_rental_pb:Car> cars = {};
map<car_rental_pb:User> users = {};
map<car_rental_pb:CartItem[]> carts = {};
map<car_rental_pb:Reservation[]> reservations = {};

// Implement the CarRental service
service "CarRental" on new grpc:Listener(9090) {

    // --- Admin operations ---
    resource function AddCar(car_rental_pb:AddCarRequest request) returns car_rental_pb:AddCarReply|error {
        car_rental_pb:Car car = request.car;
        if cars.hasKey(car.plate) {
            return { ok: false, plate: car.plate, message: "Car already exists" };
        }
        cars[car.plate] = car;
        log:printInfo("Added car: " + car.plate);
        return { ok: true, plate: car.plate, car: car, message: "Car added successfully" };
    }

    remote function CreateUsers(stream<car_rental_pb:CreateUserRequest, error?> clientStream)
            returns car_rental_pb:CreateUsersReply|error {
        int createdCount = 0;
        string[] failed = [];

        check from var req in clientStream
            do {
                car_rental_pb:User user = req.user;
                if users.hasKey(user.username) {
                    failed.push(user.username);
                } else {
                    users[user.username] = user;
                    createdCount += 1;
                }
            };

        return { created_count: createdCount, failed_usernames: failed };
    }

    resource function UpdateCar(car_rental_pb:UpdateCarRequest request) returns car_rental_pb:UpdateCarReply|error {
        if !cars.hasKey(request.plate) {
            return { status: { ok: false, code: 404, message: "Car not found" } };
        }
        car_rental_pb:Car updatedCar = request.updated;
        // merge fields (simple overwrite for demo)
        cars[request.plate] = updatedCar;
        return { car: updatedCar, status: { ok: true, code: 200, message: "Car updated" } };
    }

    resource function RemoveCar(car_rental_pb:RemoveCarRequest request) returns car_rental_pb:RemoveCarReply|error {
        if !cars.hasKey(request.plate) {
            return { status: { ok: false, code: 404, message: "Car not found" }, cars: [] };
        }
        cars.remove(request.plate);
        return { status: { ok: true, code: 200, message: "Car removed" }, cars: cars.values() };
    }

    // --- Customer operations ---
    remote function ListAvailableCars(car_rental_pb:ListAvailableCarsRequest req)
            returns stream<car_rental_pb:Car, error?> {
        stream<car_rental_pb:Car, error?> carStream = new ({
            next: function () returns record {|car_rental_pb:Car value;|}?|error {
                foreach var c in cars.entries() {
                    if c.value.status == car_rental_pb:CarStatus.AVAILABLE {
                        // optional filter by make/model/colour/year
                        if req.text_filter != "" {
                            if !(c.value.make.toLowerAscii().contains(req.text_filter.toLowerAscii()) ||
                                 c.value.model.toLowerAscii().contains(req.text_filter.toLowerAscii()) ||
                                 c.value.colour.toLowerAscii().contains(req.text_filter.toLowerAscii())) {
                                continue;
                            }
                        }
                        return {value: c.value};
                    }
                }
                return ();
            }
        });
        return carStream;
    }

    resource function SearchCar(car_rental_pb:SearchCarRequest req) returns car_rental_pb:SearchCarReply|error {
        car_rental_pb:Car[] results = [];

        foreach var c in cars.values() {
            boolean match = false;

            if req.plate != "" && c.plate == req.plate {
                match = true;
            } else {
                if (req.make != "" && c.make.toLowerAscii().contains(req.make.toLowerAscii())) {
                    match = true;
                }
                if (req.model != "" && c.model.toLowerAscii().contains(req.model.toLowerAscii())) {
                    match = true;
                }
                if (req.colour != "" && c.colour.toLowerAscii().contains(req.colour.toLowerAscii())) {
                    match = true;
                }
            }

            if match {
                results.push(c);
            }
        }

        string msg = results.length() > 0 ? "Cars found" : "No matches";
        return { cars: results, message: msg };
    }

    // --- Cart operations ---
    resource function AddToCart(car_rental_pb:AddToCartRequest req) returns car_rental_pb:AddToCartReply|error {
        if !cars.hasKey(req.plate) {
            return { status: { ok: false, code: 404, message: "Car not found" } };
        }
        car_rental_pb:Car car = cars[req.plate];
        if car.status != car_rental_pb:CarStatus.AVAILABLE {
            return { status: { ok: false, code: 400, message: "Car unavailable" } };
        }

        // calculate estimate
        int64 start = req.start_date.seconds;
        int64 end = req.end_date.seconds;
        int days = <int>((end - start) / (24 * 60 * 60));
        float estimate = days > 0 ? days * car.daily_rate : 0.0;

        car_rental_pb:CartItem item = {
            plate: car.plate,
            start_date: req.start_date,
            end_date: req.end_date,
            estimated_price: estimate
        };

        if !carts.hasKey(req.username) {
            carts[req.username] = [];
        }
        carts[req.username].push(item);

        return { status: { ok: true, code: 200, message: "Added to cart" }, item: item };
    }

    resource function GetCart(car_rental_pb:GetCartRequest req) returns car_rental_pb:GetCartReply|error {
        car_rental_pb:CartItem[] userCart = carts[req.username] but [];
        float total = 0.0;
        foreach var item in userCart {
            total += item.estimated_price;
        }
        return { items: userCart, estimated_total: total, status: { ok: true, code: 200, message: "Cart fetched" } };
    }

    resource function RemoveFromCart(car_rental_pb:RemoveFromCartRequest req)
            returns car_rental_pb:RemoveFromCartReply|error {
        if !carts.hasKey(req.username) {
            return { status: { ok: false, code: 404, message: "Cart not found" } };
        }
        car_rental_pb:CartItem[] newCart = [];
        foreach var item in carts[req.username] {
            if item.plate != req.plate {
                newCart.push(item);
            }
        }
        carts[req.username] = newCart;
        return { status: { ok: true, code: 200, message: "Item removed" }, items: newCart };
    }

    resource function ClearCart(car_rental_pb:ClearCartRequest req) returns car_rental_pb:ClearCartReply|error {
        carts.remove(req.username);
        return { status: { ok: true, code: 200, message: "Cart cleared" } };
    }

    // --- Reservation operations ---
    resource function PlaceReservation(car_rental_pb:PlaceReservationRequest req)
            returns car_rental_pb:PlaceReservationReply|error {
        if !carts.hasKey(req.username) {
            return { status: { ok: false, code: 404, message: "No cart found" } };
        }

        car_rental_pb:Reservation[] confirmed = [];
        foreach var item in carts[req.username] {
            if cars.hasKey(item.plate) && cars[item.plate].status == car_rental_pb:CarStatus.AVAILABLE {
                string id = uuid:createType1AsString();
                car_rental_pb:Reservation res = {
                    reservation_id: id,
                    username: req.username,
                    plate: item.plate,
                    start_date: item.start_date,
                    end_date: item.end_date,
                    total_price: item.estimated_price,
                    created_at: time:currentTime()
                };
                confirmed.push(res);
                // mark car as unavailable
                cars[item.plate].status = car_rental_pb:CarStatus.UNAVAILABLE;
                if !reservations.hasKey(req.username) {
                    reservations[req.username] = [];
                }
                reservations[req.username].push(res);
            }
        }

        carts.remove(req.username);
        return { reservations: confirmed, status: { ok: true, code: 200, message: "Reservation confirmed" } };
    }

    remote function ListReservations(car_rental_pb:ListReservationsRequest req)
            returns stream<car_rental_pb:ListReservationsReply, error?> {
        stream<car_rental_pb:ListReservationsReply, error?> resStream = new ({
            next: function () returns record {|car_rental_pb:ListReservationsReply value;|}?|error {
                foreach var rs in reservations.entries() {
                    foreach var r in rs.value {
                        if req.username != "" && r.username != req.username {
                            continue;
                        }
                        return {value: {reservation: r}};
                    }
                }
                return ();
            }
        });
        return resStream;
    }
}
