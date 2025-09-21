import ballerina/io;
import ballerina/grpc;
import ballerina/time;
import car_rental_pb; // Generated from your .proto

// Create the gRPC client
final string SERVER_URL = "http://localhost:9090";
car_rental_pb:CarRentalClient carRentalClient = check new (SERVER_URL);

// --- Utility to read user input ---
function readLine(string prompt) returns string {
    io:println(prompt);
    string? input = io:readln();
    return input ?: "";
}

// --- Menu-driven client ---
public function main() returns error? {
    io:println("🚗 Car Rental Client Started 🚗\n");

    boolean running = true;
    while running {
        io:println("\n=== Main Menu ===");
        io:println("1. Add Car (Admin)");
        io:println("2. List Available Cars");
        io:println("3. Search Cars");
        io:println("4. Add to Cart");
        io:println("5. View Cart");
        io:println("6. Remove from Cart");
        io:println("7. Clear Cart");
        io:println("8. Place Reservation");
        io:println("9. List Reservations (Admin)");
        io:println("0. Exit");

        string choice = readLine("Enter choice: ");
        match choice {
            "1" => handleAddCar();
            "2" => handleListAvailableCars();
            "3" => handleSearchCar();
            "4" => handleAddToCart();
            "5" => handleGetCart();
            "6" => handleRemoveFromCart();
            "7" => handleClearCart();
            "8" => handlePlaceReservation();
            "9" => handleListReservations();
            "0" => {
                running = false;
                io:println("👋 Goodbye!");
            }
            _ => io:println("❌ Invalid choice, try again.");
        }
    }
}

// --- Handlers for each RPC ---
function handleAddCar() returns error? {
    string plate = readLine("Enter plate: ");
    string make = readLine("Enter make: ");
    string model = readLine("Enter model: ");
    string colour = readLine("Enter colour: ");
    int year = check int:fromString(readLine("Enter year: "));
    float dailyRate = check float:fromString(readLine("Enter daily rate: "));
    int mileage = check int:fromString(readLine("Enter mileage: "));

    car_rental_pb:Car car = {
        plate,
        make,
        model,
        year,
        daily_rate: dailyRate,
        mileage,
        status: car_rental_pb:CarStatus.AVAILABLE,
        colour
    };

    var resp = check carRentalClient->AddCar({car, request_by: "admin"});
    if resp.ok {
        io:println("✅ Car added: " + resp.car.make + " " + resp.car.model);
    } else {
        io:println("❌ Failed: " + resp.message);
    }
}

function handleListAvailableCars() returns error? {
    io:println("🔎 Listing available cars...");
    var carStream = check carRentalClient->ListAvailableCars({});
    error? e = carStream.forEach(function(car_rental_pb:Car c) {
        io:println("- " + c.plate + " | " + c.make + " " + c.model + " (" + c.colour + ") $" + c.daily_rate.toString());
    });
    if e is error {
        io:println("❌ Error streaming cars: " + e.toString());
    }
}

function handleSearchCar() returns error? {
    string plate = readLine("Enter plate (leave empty if unknown): ");
    string make = readLine("Enter make (optional): ");
    string model = readLine("Enter model (optional): ");
    string colour = readLine("Enter colour (optional): ");

    var resp = check carRentalClient->SearchCar({plate, make, model, colour});
    if resp.cars.length() == 0 {
        io:println("❌ No cars found.");
    } else {
        io:println("✅ Found " + resp.cars.length().toString() + " car(s):");
        foreach var c in resp.cars {
            io:println("- " + c.plate + " | " + c.make + " " + c.model + " (" + c.colour + ")");
        }
    }
}

function handleAddToCart() returns error? {
    string username = readLine("Enter username: ");
    string plate = readLine("Enter plate: ");
    string start = readLine("Enter start date (YYYY-MM-DD): ");
    string end = readLine("Enter end date (YYYY-MM-DD): ");

    time:Utc startUtc = check time:utcFromString(start + "T00:00:00Z");
    time:Utc endUtc = check time:utcFromString(end + "T00:00:00Z");

    car_rental_pb:AddToCartRequest req = {
        username,
        plate,
        start_date: { seconds: startUtc.seconds, nanos: 0 },
        end_date: { seconds: endUtc.seconds, nanos: 0 }
    };

    var resp = check carRentalClient->AddToCart(req);
    if resp.status.ok {
        io:println("✅ Added to cart. Estimate $" + resp.item.estimated_price.toString());
    } else {
        io:println("❌ Failed: " + resp.status.message);
    }
}

function handleGetCart() returns error? {
    string username = readLine("Enter username: ");
    var resp = check carRentalClient->GetCart({username});
    if resp.items.length() == 0 {
        io:println("🛒 Cart is empty.");
    } else {
        io:println("🛒 Cart items:");
        foreach var item in resp.items {
            io:println("- " + item.plate + " (" + item.estimated_price.toString() + ")");
        }
        io:println("Total: $" + resp.estimated_total.toString());
    }
}

function handleRemoveFromCart() returns error? {
    string username = readLine("Enter username: ");
    string plate = readLine("Enter plate to remove: ");
    var resp = check carRentalClient->RemoveFromCart({username, plate});
    io:println(resp.status.ok ? "✅ Removed. Remaining items: " + resp.items.length().toString()
                              : "❌ " + resp.status.message);
}

function handleClearCart() returns error? {
    string username = readLine("Enter username: ");
    var resp = check carRentalClient->ClearCart({username});
    io:println(resp.status.ok ? "✅ Cart cleared." : "❌ " + resp.status.message);
}

function handlePlaceReservation() returns error? {
    string username = readLine("Enter username: ");
    var resp = check carRentalClient->PlaceReservation({username});
    if resp.reservations.length() == 0 {
        io:println("❌ No reservations placed.");
    } else {
        io:println("✅ Reservations confirmed:");
        foreach var r in resp.reservations {
            io:println("- " + r.reservation_id + " | " + r.plate + " $" + r.total_price.toString());
        }
    }
}

function handleListReservations() returns error? {
    string username = readLine("Enter username filter (leave empty for all): ");
    var resStream = check carRentalClient->ListReservations({username});
    io:println("📋 Reservations:");
    error? e = resStream.forEach(function(car_rental_pb:ListReservationsReply r) {
        io:println("- " + r.reservation.reservation_id + " | " + r.reservation.username
            + " -> " + r.reservation.plate + " $" + r.reservation.total_price.toString());
    });
    if e is error {
        io:println("❌ Error streaming reservations: " + e.toString());
    }
}
