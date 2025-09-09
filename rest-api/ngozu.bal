// Ngozu's module: check for overdue assets

import ballerina/io;
import ballerina/time;

// Identify assets with overdue maintenance schedules
public function overdueAssets() returns Asset[] {
    io:println("Checking for overdue assets");
    time:Utc now = time:utcNow();
    Asset[] overdue = [];
    foreach var asset in assets {
        foreach var sched in asset.schedules {
            if sched.due < now {
                overdue.push(asset);
                break;
            }
        }
    }
    return overdue;
}

