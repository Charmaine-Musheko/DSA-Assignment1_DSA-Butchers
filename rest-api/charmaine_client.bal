import ballerina/http;
import ballerina/io;

// Charmaine's client: demonstrates interactions with the REST service
public function main() returns error? {
        http:Client assetClient = check new ("http://localhost:8080");

        // TODO: Extend client to read user input or test additional endpoints

        // Add asset
        json resp = check assetClient->post("/assets/addAsset", { name: "Laptop", faculty: "Science" });
        io:println(resp);

        // List assets
        json assets = check assetClient->get("/assets/listAssets");
        io:println(assets);

        // Check overdue assets
        json overdue = check assetClient->get("/assets/overdue");
        io:println(overdue);
}
