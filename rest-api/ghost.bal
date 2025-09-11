// Ghost's module: view and filter assets

import ballerina/io;

// Define the Asset record type
public type Asset record {
    string id;
    string name;
    string description;
    string faculty;
    string location;
    boolean available;
    decimal value;
};

// In-memory table to store assets
table<Asset> key(id) assets = table [
    {id: "AST001", name: "Projector", description: "HD Projector 1080p", faculty: "Engineering", location: "Room 101", available: true, value: 500.00},
    {id: "AST002", name: "Laptop", description: "Dell XPS 15", faculty: "Computer Science", location: "Lab A", available: true, value: 1200.00},
    {id: "AST003", name: "Microscope", description: "Digital Microscope", faculty: "Biology", location: "Lab B", available: false, value: 800.00},
    {id: "AST004", name: "3D Printer", description: "Creality Ender 3", faculty: "Engineering", location: "Maker Space", available: true, value: 300.00},
    {id: "AST005", name: "VR Headset", description: "Oculus Quest 2", faculty: "Computer Science", location: "VR Lab", available: true, value: 400.00}
];

// Return all assets stored in the `assets` table
public function listAssets() returns Asset[] {
    io:println("Listing all assets");
    
    Asset[] allAssets = from var asset in assets
        select asset;
    
    return allAssets;
}

// Return assets that belong to the provided faculty
public function assetsByFaculty(string faculty) returns Asset[] {
    io:println("Filtering assets for faculty: " + faculty);
    
    Asset[] facultyAssets = from var asset in assets
        where asset.faculty == faculty
        select asset;
    
    return facultyAssets;
}

// Additional utility functions that might be useful:

// Return assets by availability status
public function assetsByAvailability(boolean available) returns Asset[] {
    io:println("Filtering assets by availability: " + available.toString());
    
    Asset[] availableAssets = from var asset in assets
        where asset.available == available
        select asset;
    
    return availableAssets;
}

// Search assets by name or description
public function searchAssets(string query) returns Asset[] {
    io:println("Searching assets for: " + query);
    
    string searchQuery = query.lowerAscii();
    
    Asset[] foundAssets = from var asset in assets
        where asset.name.lowerAscii().includes(searchQuery) || 
              asset.description.lowerAscii().includes(searchQuery)
        select asset;
    
    return foundAssets;
}

// Get a specific asset by ID
public function getAssetById(string id) returns Asset? {
    io:println("Getting asset with ID: " + id);
    
    if assets.hasKey(id) {
        return assets.get(id);
    }
    
    return ();
}
