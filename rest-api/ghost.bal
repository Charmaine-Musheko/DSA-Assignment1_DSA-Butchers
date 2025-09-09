// Ghost's module: view and filter assets

import ballerina/io;

// Return all assets stored in the `assets` table
public function listAssets() returns Asset[] {
    // TODO: Ghost to return all assets from the in-memory table
    io:println("Listing all assets");
    return [];
}

// Return assets that belong to the provided faculty
public function assetsByFaculty(string faculty) returns Asset[] {
    // TODO: Ghost to filter assets in the table by `faculty`
    io:println("Filtering assets for faculty: " + faculty);
    return [];
}

