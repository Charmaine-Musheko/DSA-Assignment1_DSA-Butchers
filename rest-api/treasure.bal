// Treasure's module: manage components and maintenance schedules

import ballerina/http;
import ballerina/io;
import ballerina/time;

type ComponentReq record {string id; string component;};
type ScheduleReq record {string id; string description; string due;};

// Add or remove components for a given asset
public function addComponent(http:Request req) returns json {
    io:println("Adding component");
    json payload = checkpanic req.getJsonPayload();
    ComponentReq data = checkpanic payload.cloneWithType(ComponentReq);
    if assets.hasKey(data.id) {
        Asset asset = checkpanic assets.get(data.id);
        asset.components.push(data.component);
        _ = assets.put(asset);
        return { message: "Component added" };
    }
    return { message: "Asset not found" };
}

// Add or remove schedules for a given asset
public function addSchedule(http:Request req) returns json {
    io:println("Adding schedule");
    json payload = checkpanic req.getJsonPayload();
    ScheduleReq data = checkpanic payload.cloneWithType(ScheduleReq);
    time:Utc due = checkpanic time:utcFromString(data.due);
    if assets.hasKey(data.id) {
        Asset asset = checkpanic assets.get(data.id);
        asset.schedules.push({ description: data.description, due: due });
        _ = assets.put(asset);
        return { message: "Schedule added" };
    }
    return { message: "Asset not found" };
}

