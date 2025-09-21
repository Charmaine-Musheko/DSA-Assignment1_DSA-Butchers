import ballerina/http;

type Album readonly & record {|
    string title;
    string artist;
|};

table<Album> key(title) albums = table [
    {title: "Blue Train", artist: "John Coltrane"},
    {title: "Jeru", artist: "Gerry Mulligan"}
];

type Asset record {|
    readonly string tag;
    string name;
    string faculty;
    string department;
    string dateAcquired;
    string[] currentStatus = ["ACTIVE", "UNDER_REPAIR","DISPOSED"];
    string[] components = [];
    string[] maintenanceSchedule = ["REGULAR","QUARTERLY","ANNUAL"];
    string[] workOrder = ["PENDING","IN_PROGRESS","COMPLETED"];
    string[] tasks = ["SMALL","MEDIUM","LARGE"];
|};

table<Asset> key(tag) assets = table [
    {tag: "A001", name: "Laptop", faculty: "Engineering", department: "Computer Science", dateAcquired: "2022-01-15"},
    {tag: "A002", name: "Projector", faculty: "Business", department: "Marketing", dateAcquired: "2021-09-10"}
];

service / on new http:Listener(9090) {

    // The resource returns the `409 Conflict` status code as the error response status code using 
    // the `StatusCodeResponse` constants. This constant does not have a body or headers.
    resource function post albums(Album album) returns Album|http:Conflict {
        if albums.hasKey(album.title) {
            return http:CONFLICT;
        }
        albums.add(album);
        return album;
    }

    resource function get albums() returns Album[] {
        return albums.toArray();
    }

    // POST resource for creating new assets
    resource function post assets(Asset asset) returns Asset|http:Conflict {
        if assets.hasKey(asset.tag) {
            return http:CONFLICT;
        }
        assets.add(asset);
        return asset;
    }

    // GET resource for retrieving all assets
    resource function get assets() returns Asset[] {
        return assets.toArray();
    }

    // GET resource for retrieving a specific asset by tag
    resource function get assets/[string tag]() returns Asset|http:NotFound {
        if assets.hasKey(tag) {
            return assets.get(tag);
        } else {
            return http:NOT_FOUND;
        }
    }

    // PUT resource for updating an existing asset
    resource function put assets/[string tag](Asset asset) returns Asset|http:NotFound|http:BadRequest {
        if !assets.hasKey(tag) {
            return http:NOT_FOUND;
        }
        if tag != asset.tag {
            return http:BAD_REQUEST;
        }
        _ = assets.remove(tag);
        assets.add(asset);
        return asset;
    }

    // DELETE resource for removing an asset
    resource function delete assets/[string tag]() returns http:Ok|http:NotFound {
        if assets.hasKey(tag) {
            _ = assets.remove(tag);
            return http:OK;
        } else {
            return http:NOT_FOUND;
        }
    }
}