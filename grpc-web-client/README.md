# gRPC-Web Browser Client

This folder contains a lightweight setup for calling the CarRental gRPC API from a browser using gRPC-Web. The browser cannot speak the native HTTP/2 gRPC protocol, so we introduce an Envoy proxy that translates between gRPC-Web and the backend gRPC service implemented in Ballerina.

## Overview

1. **Envoy proxy** terminates gRPC-Web requests (HTTP/1.1) from the browser and forwards native gRPC traffic to localhost:9000, where the Ballerina service is listening.
2. **Generated JavaScript stubs** (from patema.proto) handle protobuf serialization and expose strongly typed client methods.
3. **HTML/JS UI** loads the generated stubs, creates a CarRentalClient, and interacts with the service through the Envoy proxy.

## One-time tooling setup

1. Install the Protocol Buffers compiler (protoc). Download a prebuilt zip from <https://grpc.io/docs/protoc-installation/> and add the binary to your PATH.
2. Install the gRPC-Web codegen plugin (protoc-gen-grpc-web) from <https://github.com/grpc/grpc-web/releases>. Place the binary on PATH as well.
3. Install Node.js = 16 so you can bundle the browser code (any recent LTS works).

Verify the tools:

`powershell
protoc --version
protoc-gen-grpc-web --version
node --version
npm --version
`

## Generate browser stubs

`powershell
cd ..\grpc-web-client
protoc -I .. patema.proto ^
  --js_out=import_style=commonjs:./gen ^
  --grpc-web_out=import_style=commonjs,mode=grpcwebtext:./gen
`

The command produces two files in grpc-web-client/gen: patema_pb.js (messages) and patema_grpc_web_pb.js (service client).

## Install dependencies & bundle assets

`powershell
cd ..\grpc-web-client
npm install
npm run build
`

- 
pm install pulls esbuild, grpc-web, google-protobuf, and http-server declared in package.json.
- 
pm run build runs esbuild main.js --bundle --outfile=dist/bundle.js after checking that the generated stubs exist. The resulting dist/bundle.js is referenced by index.html.

For local development, you can keep running 
pm run build after changing main.js or the HTML. The build script fails fast if the generated stubs are missing.

To serve the static files during development:

`powershell
npm run serve
`

By default http-server listens on <http://localhost:8081>. The command automatically bundles first; open http://localhost:8081/index.html in a browser once the build completes.

## Start Envoy

In another terminal:

`powershell
cd ..\grpc-web-client
envoy --config-path envoy.yaml
`

Envoy listens on http://localhost:8080 and forwards calls to the Ballerina gRPC service at localhost:9000.

## Run the stack end-to-end

1. In **terminal A** (repo root):
   `powershell
   cd grpc-server
   bal run
   `
2. In **terminal B**: start Envoy as shown above.
3. In **terminal C**: run 
pm run serve inside grpc-web-client and keep it running.
4. Visit http://localhost:8081/index.html, submit the forms, and watch the console/network tabs. Successful calls will appear in the gRPC server logs with your actual input values.

> **Note:** If you still see requests referencing the hard-coded value "ballerina", you are probably running the sample CLI client in grpc-client/carrental_client.bal. Stop that process or update the constants before re-running it.

## Cleaning up

- Stop the Envoy process and the static file server when you are done.
- 
ode_modules, dist/, and gen/ are ignored by .gitignore; delete them manually if you want a clean slate.
- Re-run code generation whenever patema.proto changes.

