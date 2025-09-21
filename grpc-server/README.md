# gRPC Car Rental Server

This module hosts the `CarRental` gRPC API defined in `../patema.proto`. The implementation keeps inventory, carts, and reservations in memory so the full workflow can be exercised without external services.

## Layout & responsibilities

- `carrental_service.bal` - binds the service to a `grpc:Listener` on port `9000` and wires requests to helper functions
- `ghost.bal` - business logic: maintains the inventory map, user carts, and reservations, enforcing rules like unique car ids and availability checks
- `ngozu.bal` - thin facade that logs intent, extracts request fields, and delegates to the helpers
- `patema_pb.bal` - protobuf descriptors and the generated Ballerina client stub from `patema.proto`
- `car_rental.proto` / `car_rental_pb.bal` - older schema kept only for reference; the running service uses `patema.proto`

## RPC surface

Each gRPC method maps directly to a helper in `ghost.bal` or `ngozu.bal`:

```
AddCar            -> addCarToInventory
UpdateCar         -> updateCarInInventory
RemoveCar         -> removeCarFromInventory
ListAvailableCars -> listAvailableCars
SearchCar         -> searchCar (uses extractQuery)
AddToCart         -> addToCart (delegates to addItemToCart)
PlaceReservation  -> reserveCars
```

`reserveCars` also clears the caller's cart after a successful booking and marks cars unavailable so subsequent searches reflect the change.

## Prerequisites

- Ballerina Swan Lake 2201.x on `PATH`
- Java 17+ (required by the Ballerina runtime)

Check versions if unsure:

```powershell
bal version
java -version
```

## Running the server

```powershell
cd grpc-server
bal run
```

The listener starts on `localhost:9000`. Leave this terminal open while exercising the API from the CLI client, REST wrapper, or gRPC-Web UI. Stop the server with `Ctrl+C`.

## Regenerating protobuf bindings

If you update `patema.proto`, regenerate the Ballerina types and stub:

```powershell
bal grpc --input ../patema.proto --output .
```

After regeneration, rebuild the server and update any clients (CLI, REST, gRPC-Web) so their stubs stay in sync.
