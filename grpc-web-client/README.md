# gRPC-Web Browser Client

This folder contains a lightweight setup for calling the CarRental gRPC API from a browser using gRPC-Web. The browser cannot speak the native HTTP/2 gRPC protocol, so we introduce an Envoy proxy that translates between gRPC-Web and the backend gRPC service implemented in Ballerina.

## One-time tooling setup

1. Install the Protocol Buffers compiler **3.21.x** (newer releases omit the JS generator). Download `protoc-3.21.12-win64.zip` from the protobuf releases page, extract it (for example to `C:\protoc-3.21.12\bin`), and add that folder to your `PATH`.
2. Install the JavaScript code generator plugin from the protobuf-javascript project. Download `protoc-gen-js-3.21.2-windows-x86_64.exe`, rename it to `protoc-gen-js.exe`, and place it in the same folder as `protoc.exe` (or anywhere on `PATH`).
3. Install the gRPC-Web plugin by downloading `protoc-gen-grpc-web-2.0.2-windows-x86_64.exe` and placing it on `PATH` as `protoc-gen-grpc-web.exe`.
4. Install Node.js 18 LTS (or newer) so you can bundle the browser code.

After configuring the tools, open a new terminal and verify everything resolves:

```powershell
protoc --version
protoc-gen-js --version
protoc-gen-grpc-web --version
node --version
npm --version
```

## Generate browser stubs

```powershell
cd ..\grpc-web-client
npm run generate:stubs
```

The script wraps `protoc` and produces two files under `grpc-web-client/gen`: `patema_pb.js` (messages) and `patema_grpc_web_pb.js` (service client). Re-run the command whenever `patema.proto` changes.

## Install dependencies & bundle assets

```powershell
npm install
npm run build
```

- `npm install` pulls `esbuild`, `grpc-web`, `google-protobuf`, and `http-server` declared in `package.json`.
- `npm run build` bundles `main.js` into `dist/bundle.js`. It first checks that the generated stubs exist and exits with a clear error if they do not.

For local development, run `npm run build` whenever you change the UI or regenerate stubs. To serve the static files:

```powershell
npm run serve
```

By default `http-server` listens on <http://localhost:8081>. The command automatically bundles first; open the URL once the build completes.

## Start Envoy

In another terminal:

```powershell
envoy --config-path envoy.yaml
```

Envoy listens on <http://localhost:8080> and forwards calls to the Ballerina gRPC service at `localhost:9000`.

## Use the web UI

The page mirrors the updated CLI workflow:

- **Add Car** - enter details or click *Generate sample car* to pre-fill values. The car id propagates to the other forms so you can exercise the full flow quickly.
- **Update Car** - tweak price/model/availability for the same id. Leave a field blank to reuse the last value.
- **List/Search** - buttons to call `ListAvailableCars` and `SearchCar`, printing the raw JSON for easy inspection.
- **Add To Cart & Place Reservation** - provide (or reuse) a user id to add the car to the cart and reserve it. The script keeps the last user id so you don't have to retype it.

If you need to test multiple cars/users, just generate a new id and repeat the steps.

> **Note:** If you still see server logs containing the legacy value "ballerina", make sure the sample CLI client in `grpc-client/carrental_client.bal` is not running, or supply your own arguments when invoking it.

## Run the stack end-to-end

1. In **terminal A** (repo root):
   ```powershell
   cd grpc-server
   bal run
   ```
2. In **terminal B**: start Envoy as shown above.
3. In **terminal C**: run `npm run serve` inside `grpc-web-client` and keep it running.
4. Visit <http://localhost:8081/index.html>, use the forms, and watch the browser dev tools or gRPC server logs for responses.

## Cleaning up

- Stop the Envoy process and the static file server when you are done.
- `node_modules`, `dist/`, and `gen/` are ignored by `.gitignore`; delete them manually if you want a clean slate.
- Re-run code generation whenever `patema.proto` changes.