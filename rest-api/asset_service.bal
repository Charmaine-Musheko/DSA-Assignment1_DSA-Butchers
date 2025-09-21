import ballerina/http;

// Define a map to act as the in-memory assets database
type Asset record {|
    string assetTag;
    string name?;
    string faculty?;
    string department?;
    string dateAcquired?;
    string status?; // Active/Under_Repair, Disposed
|};


//In-memory "database"
map<Asset> assetsDB = {};

//Asset service
service /assets on new http:Listener(8080) {
    //Add a new asset
    resource function post .(http:Caller caller, http:Request req) returns error? {
        json payload = check req.getJsonPayload();
        Asset newAsset = check payload.fromJsonWithType(Asset);

        //Prevent duplicate
        if assetsDB.hasKey(newAsset.assetTag) {
            http:Response res = new;
            res.statusCode = 409;
            res.setPayload("Asset already exists");
            check caller->respond(res);
            return;
        }

        assetsDB[newAsset.assetTag] = newAsset;

        http:Response res = new;
        res.statusCode = 201;
        res.setPayload(newAsset);
        check caller->respond(res);

    }
 
    //update existing asset
    resource function put [string assetTag](http:Caller caller, http:Request req) returns error? {
        if !assetsDB.hasKey(assetTag) {
            http:Response res = new;
            res.statusCode = 404;
            res.setPayload("Asset not found");
            check caller->respond(res);
            return;
        }
        json payload = check req.getJsonPayload();
        Asset updatedAsset = check payload.fromJsonWithType(Asset);
        assetsDB[assetTag] = updatedAsset;
        check caller->respond(updatedAsset);
    }

    //Get all assets
    resource function get .(http:Caller caller, http:Request req) returns error? {
        http:Response res = new;
        res.statusCode =200;
        res.setPayload(assetsDB);
        check caller->respond(res);
    }

    //Get a single asset by tag
    resource function get [string assetTag](http:Caller caller, http:Request req) returns error? {
        if assetsDB.hasKey(assetTag) {
            check caller->respond(assetsDB[assetTag]);
        } else {
            http:Response res = new;
            res.statusCode = 404;
            res.setPayload("Asset not found");
            check caller->respond(res);
        
        }

    }

    //Get assets by faculty
    resource function get faculty/[string facultyName](http:Caller caller, http:Request req) returns error? {
        map<Asset> result = {};

        foreach var [tag, asset] in assetsDB.entries() {
            if asset.faculty is string && (<string>asset.faculty).toLowerAscii() == facultyName.toLowerAscii() {
                result[tag] = asset;
            }
        }

        if result.length() == 0 {
            http:Response res = new;
            res.statusCode = 404;
            res.setPayload("No assets found for the specified faculty");
            check caller->respond(res);
        } else {
        
            check caller->respond(result);
        }
    
    }

    //Handle browser requests for favicon.ico
    resource function get favicon(http:Caller caller, http:Request req) returns error? {
        http:Response res = new;
        res.statusCode = 204; // No Content
        check caller->respond(res);
}

}