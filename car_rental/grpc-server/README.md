# gRPC Car Rental Server

Implementation of the `CarRental` gRPC API defined in `patema.proto`. The module keeps all state in-memory so you can exercise the workflow without a database.

## Repository layout

- `carrental_service.bal` - wires the service to the `grpc:Listener` on port 9000 using the descriptor from `patema_pb.bal`
- `ghost.bal` - in-memory inventory, carts, and reservations helpers (`addCarToInventory`, `reserveCars`, and related logic)
- `ngozu.bal` - thin facade that validates requests, logs intent, and calls the helpers (list/search/cart operations)
- `patema_pb.bal` - Ballerina types and client stub generated from `../patema.proto`
- `car_rental.proto` / `car_rental_pb.bal` - alternate schema kept for reference; the running service still relies on `patema.proto`

## Service operations

```
CarRental/AddCar            -> addCarToInventory
CarRental/UpdateCar         -> updateCarInInventory
CarRental/RemoveCar         -> removeCarFromInventory
CarRental/ListAvailableCars -> listAvailableCars
CarRental/SearchCar         -> searchCar
CarRental/AddToCart         -> addToCart
CarRental/PlaceReservation  -> reserveCars
```

`ghost.bal` enforces business rules such as unique car ids, only reserving available cars, and clearing a user's cart after a reservation succeeds.

## Prerequisites

- Ballerina Swan Lake (2201.x) installed and on `PATH`
- Java 17 or newer (required by the Ballerina runtime)

Verify the tooling:

```powershell
bal version
java -version
```

## Run the server locally

```powershell
cd grpc-server
bal run
```

The service listens on `localhost:9000`. Keep the process running while you test with the CLI client, REST facade, or the gRPC-Web UI.

## Regenerating protobuf types

If you change `patema.proto`, regenerate `patema_pb.bal` with:

```powershell
bal grpc --input ../patema.proto --output .
```

Then rebuild the server and regenerate the corresponding client/browser stubs.

Stop the server with `Ctrl+C` when you are finished.