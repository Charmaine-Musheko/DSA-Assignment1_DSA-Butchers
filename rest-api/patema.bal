import ballerina/http;

service /assets on new http:Listener(8080) {
	resource function post addAsset(http:Caller caller, http:Request req) returns error? {
		// TODO: Parse JSON and add asset
		check caller->respond({ message: "Asset added" });
	}
	resource function get listAssets(http:Caller caller) returns error? {
		// TODO: Return all assets
		check caller->respond([]);
	}
	resource function get assetsByFaculty(http:Caller caller, string faculty) returns error? {
		// TODO: Filter assets by faculty
		check caller->respond([]);
	}
	resource function get overdue(http:Caller caller) returns error? {
		// TODO: Return overdue assets
		check caller->respond([]);
	}
	resource function post addComponent(http:Caller caller, http:Request req) returns error? {
		// TODO: Add component
		check caller->respond({ message: "Component added" });
	}
	resource function post addSchedule(http:Caller caller, http:Request req) returns error? {
		// TODO: Add schedule
		check caller->respond({ message: "Schedule added" });
	}
}
