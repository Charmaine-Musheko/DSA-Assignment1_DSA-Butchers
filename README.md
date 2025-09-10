# DSA Project: Asset Management & Car Rental System

## Overview
This project contains two main parts:
- **RESTful API Asset Management System** (Ballerina)
- **gRPC Car Rental System** (Ballerina)

## Structure
- `rest-api/` — Asset management REST API (Ballerina)
- `grpc-server/` — Car rental gRPC server (Ballerina)
- `grpc-client/` — Car rental gRPC client (Ballerina)
- `.github/` — Workflow and instructions

## Group Members & Roles
- Patema: Database, add/update assets (REST), proto (gRPC)
- Ghost: View/filter assets (REST), add/update/remove car (gRPC)
- Ngozu: Overdue check (REST), list/search/add to cart (gRPC)
- Treasure: Components/schedules (REST), reservation/price/validation (gRPC)
- Charmaine: Client (REST & gRPC)
- Ndhlovu: (REST & gRPC)

## Workflow
- Each member works on their branch
- Merge to `main` after testing

---

## Setup
- Requires [Ballerina](https://ballerina.io/) installed
- See each folder for specific instructions

# Resources

1. [ballerina-getting-started](https://ballerina.io/learn/get-started/) : Essential to properly run and or setup the project

2. [structuring-your-code](https://ballerina.io/learn/organize-ballerina-code/)

3. [sending-requests](https://ballerina.io/learn/by-example/http-client-send-request-receive-response/) : Useful for passing data through a `POST` request

4. [basic-RESTApi-setup](https://ballerina.io/learn/by-example/http-basic-rest-service/) : useful for understanding http and RESTApi setup

5. [basic-grpc-setup](https://ballerina.io/learn/by-example/grpc-service-simple/) : Useful to understand the code for the grpc code


