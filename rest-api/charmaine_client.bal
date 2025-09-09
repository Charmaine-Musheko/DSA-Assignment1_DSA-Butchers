import ballerina/http;

public function main() returns error? {
	http:Client assetClient = check new ("http://localhost:8080");
	// Add asset
	var resp = check assetClient->post("/assets/addAsset", { name: "Laptop", faculty: "Science" });
	io:println(resp);
	// List assets
	var assets = check assetClient->get("/assets/listAssets");
	io:println(assets);
	// Check overdue
	var overdue = check assetClient->get("/assets/overdue");
	io:println(overdue);
}
