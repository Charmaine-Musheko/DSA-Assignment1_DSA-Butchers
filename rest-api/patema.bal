import ballerina/http;
import ballerina/time;

// Basic record representing an asset in the system
public type Schedule record {
    string description;
    time:Utc due;
};

type AssetIn record {string name; string faculty;};
type AssetUpdate record {string id; string name?; string faculty?;};

public type Asset record {
    readonly string id;
    string name;
    string faculty;
    string[] components = [];
    Schedule[] schedules = [];
};

// In‑memory table acting as the database for assets
table<Asset> key(id) assets = table [];
int nextId = 1;

// Service root for all asset management endpoints
service /assets on new http:Listener(8080) {

    // Patema: parse JSON payload and add a new asset to `assets`
    resource function post addAsset(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        AssetIn assetIn = check payload.cloneWithType(AssetIn);
        Asset asset = {
            id: nextId.toString(),
            name: assetIn.name,
            faculty: assetIn.faculty
        };
        nextId += 1;
        check assets.add(asset);
        check caller->respond(asset);
    }

    // Patema: update an existing asset in `assets`
    resource function put updateAsset(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        AssetUpdate upd = check payload.cloneWithType(AssetUpdate);
        if assets.hasKey(upd.id) {
            Asset asset = check assets.get(upd.id);
            if upd.name is string {
                string name = <string>upd.name;
                asset.name = name;
            }
            if upd.faculty is string {
                string fac = <string>upd.faculty;
                asset.faculty = fac;
            }
            check assets.put(asset);
            check caller->respond(asset);
        } else {
            check caller->respond({ message: "Asset not found" });
        }
    }

    // Ghost: return all assets in the system
    resource function get listAssets(http:Caller caller) returns error? {
        check caller->respond(listAssets());
    }

    // Ghost: filter assets by the given faculty
    resource function get assetsByFaculty(http:Caller caller, string faculty) returns error? {
        check caller->respond(assetsByFaculty(faculty));
    }

    // Ngozu: return assets that have overdue maintenance schedules
    resource function get overdue(http:Caller caller) returns error? {
        check caller->respond(overdueAssets());
    }

    // Treasure: manage components linked to an asset
    resource function post addComponent(http:Caller caller, http:Request req) returns error? {
        check caller->respond(addComponent(req));
    }

    // Treasure: manage maintenance schedules for an asset
    resource function post addSchedule(http:Caller caller, http:Request req) returns error? {
        check caller->respond(addSchedule(req));
    }
}

