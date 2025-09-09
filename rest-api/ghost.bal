// Ghost's module: view and filter assets

import ballerina/io;

// Return all assets stored in the `assets` table
public function listAssets() returns Asset[] {
    io:println("Listing all assets");
    return assets.toArray();
}

// Return assets that belong to the provided faculty
public function assetsByFaculty(string faculty) returns Asset[] {
    io:println("Filtering assets for faculty: " + faculty);
    return from var asset in assets
           where asset.faculty == faculty
           select asset;
}

