import ballerina/http;
import ballerina/io;

type Added record {string id;};

// Charmaine's client: demonstrates interactions with the REST service
public function main() returns error? {
        http:Client assetClient = check new ("http://localhost:8080");

        // Add asset
        json resp = check assetClient->post("/assets/addAsset", { name: "Laptop", faculty: "Science" });
        io:println(resp);
        Added added = check resp.cloneWithType(Added);
        string id = added.id;

        // Update asset
        json updated = check assetClient->put("/assets/updateAsset", { id: id, name: "Laptop Pro", faculty: "Science" });
        io:println(updated);

        // List assets
        json assets = check assetClient->get("/assets/listAssets");
        io:println(assets);

        // Filter by faculty
        json filtered = check assetClient->get("/assets/assetsByFaculty/Science");
        io:println(filtered);

        // Check overdue assets
        json overdue = check assetClient->get("/assets/overdue");
        io:println(overdue);
}
