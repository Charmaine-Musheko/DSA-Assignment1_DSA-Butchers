# gRPC Car Rental CLI Client

Ballerina client used to exercise the CarRental gRPC service end-to-end.

## Repository layout

- `carrental_client.bal` - orchestrates the sample flow using the generated stub
- `patema_pb.bal` - copied gRPC stub from `patema.proto` (shared with the server)

## Prerequisites

- Ballerina Swan Lake (2201.x) installed and on `PATH`
- Java 17 or newer (required by the Ballerina runtime)
- The gRPC server from `grpc-server/` running locally on `localhost:9000`

Verify the tooling:

```powershell
bal version
java -version
```

## Run the client

```powershell
cd grpc-client
bal run
```

The script hits the full happy-path flow: `AddCar`, `UpdateCar`, `ListAvailableCars`, `SearchCar`, `AddToCart`, and `PlaceReservation`. Each response is printed to the console so you can confirm the round trip.

### Supplying custom data

You can pass up to five arguments to override the defaults:

```powershell
bal run -- <carId> <make> <model> <userId> <searchQuery>
```

- `carId` defaults to a generated UUID (prefixed with `car-`)
- `make` defaults to `Nissan`
- `model` defaults to `Leaf`
- `userId` defaults to a generated UUID (prefixed with `user-`)
- `searchQuery` defaults to the `make`

Any omitted argument falls back to the default; for example, to reuse a known car id but keep other defaults:

```powershell
bal run -- car-123
```

### Build or test

- `bal build` - Compile the module and produce an executable JAR in `target/bin/`
- `bal test` - Execute the module test suite (add your own scenarios under `tests/`)

Stop the client with `Ctrl+C` once the sample flow completes.