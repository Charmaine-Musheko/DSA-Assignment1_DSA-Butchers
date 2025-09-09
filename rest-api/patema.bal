import ballerina/http;

// Basic record representing an asset in the system
public type Asset record {
    readonly string id;
    string name;
    string faculty;
    // Additional fields such as components and maintenance schedules can be
    // added by the team as required.
};

// In‑memory table acting as the database for assets
table<Asset> key(id) assets = table [];

// Service root for all asset management endpoints
service /assets on new http:Listener(8080) {

    // Patema: parse JSON payload and add a new asset to `assets`
    resource function post addAsset(http:Caller caller, http:Request req) returns error? {
        // TODO: Patema to implement add asset logic
        check caller->respond({ message: "Asset added" });
    }

    // Patema: update an existing asset in `assets`
    resource function put updateAsset(http:Caller caller, http:Request req) returns error? {
        // TODO: Patema to implement update asset logic
        check caller->respond({ message: "Asset updated" });
    }

    // Ghost: return all assets in the system
    resource function get listAssets(http:Caller caller) returns error? {
        // TODO: Ghost to implement listing logic in ghost.bal
        check caller->respond(listAssets());
    }

    // Ghost: filter assets by the given faculty
    resource function get assetsByFaculty(http:Caller caller, string faculty) returns error? {
        // TODO: Ghost to implement filtering logic in ghost.bal
        check caller->respond(assetsByFaculty(faculty));
    }

    // Ngozu: return assets that have overdue maintenance schedules
    resource function get overdue(http:Caller caller) returns error? {
        // TODO: Ngozu to implement overdue check in ngozu.bal
        check caller->respond(overdueAssets());
    }

    // Treasure: manage components linked to an asset
    resource function post addComponent(http:Caller caller, http:Request req) returns error? {
        // TODO: Treasure to implement component management in treasure.bal
        check caller->respond(addComponent(req));
    }

    // Treasure: manage maintenance schedules for an asset
    resource function post addSchedule(http:Caller caller, http:Request req) returns error? {
        // TODO: Treasure to implement schedule management in treasure.bal
        check caller->respond(addSchedule(req));
    }
}

