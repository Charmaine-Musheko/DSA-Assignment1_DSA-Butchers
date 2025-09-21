# gRPC Car Rental CLI Client

Command-line companion for the in-memory `CarRental` gRPC service. The client demonstrates a happy-path reservation flow using the stub generated from `patema.proto`.

## Layout

- `carrental_client.bal` - drives the sample scenario, calling every RPC exposed by the server
- `patema_pb.bal` - local copy of the protobuf descriptors and client stub shared with the server module

## Prerequisites

- Ballerina Swan Lake 2201.x on `PATH`
- Java 17+
- Server from `grpc-server/` running on `localhost:9000`

Verify tooling:

```powershell
bal version
java -version
```

## Run the scripted flow

```powershell
cd grpc-client
bal run
```

The client will:

1. Add a car (generating ids if none are supplied)
2. Immediately update the car with premium pricing
3. List all available cars
4. Search using the make/model
5. Add the car to a user cart
6. Place a reservation and print the confirmation id + total

Logs from `grpc-client` appear in the console and corresponding server logs show matching requests.

## Custom arguments

Override any of the defaults (up to five positional arguments):

```powershell
bal run -- <carId> <make> <model> <userId> <searchQuery>
```

Omitted trailing arguments fall back to defaults (generated IDs, `Nissan` / `Leaf`, search by make). For example, to reuse an existing car id while keeping other defaults:

```powershell
bal run -- car-123
```

## Build & tests

- `bal build` - compiles the module and produces `target/bin/grpc_client.jar`
- `bal test` - executes any tests you add under `tests/`

Stop the process with `Ctrl+C` after the sample sequence completes.
