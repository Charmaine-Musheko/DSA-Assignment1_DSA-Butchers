import ballerina/http;

// Common types for reuse
type Component record {|
    readonly string id;
    string name;
    string description;
    string model;
    string serialNumber;
    string status;
|};

type MaintenanceSchedule record {|
    readonly string scheduleId;
    string[] types; // REGULAR, QUARTERLY, ANNUAL
    string frequency;
    string[] requiredTasks;
    string lastPerformed;
    string nextDue;
|};

type WorkOrder record {|
    readonly string workOrderId;
    string status; // PENDING, IN_PROGRESS, COMPLETED
    string priority;
    string assignedTo;
    string[] tasks;
    string createdDate;
    string completedDate;
|};

type Task record {|
    readonly string taskId;
    string name;
    string description;
    string size; // SMALL, MEDIUM, LARGE
    int estimatedHours;
    string[] requiredTools;
|};

// Standalone tables for management
table<Component> key(id) components = table [];
table<MaintenanceSchedule> key(scheduleId) maintenanceSchedules = table [];
table<WorkOrder> key(workOrderId) workOrders = table [];
table<Task> key(taskId) tasks = table [];

// Asset type now references other entities
type Asset record {|
    readonly string tag;
    string name;
    string faculty;
    string department;
    string dateAcquired;
    string currentStatus; // ACTIVE, UNDER_REPAIR, DISPOSED
    string[] componentIds = [];
    string[] maintenanceScheduleIds = [];
    string[] workOrderIds = [];
|};

table<Asset> key(tag) assets = table [
    {tag: "A001", name: "Laptop", faculty: "Engineering", 
     department: "Computer Science", dateAcquired: "2022-01-15", currentStatus: "ACTIVE"},
    {tag: "A002", name: "Projector", faculty: "Business", 
     department: "Marketing", dateAcquired: "2021-09-10", currentStatus: "ACTIVE"}
];

// Album types (keeping your existing code)
type Album readonly & record {|
    string title;
    string artist;
|};

table<Album> key(title) albums = table [
    {title: "Blue Train", artist: "John Coltrane"},
    {title: "Jeru", artist: "Gerry Mulligan"}
];

service / on new http:Listener(9090) {

    // === Album Resources (existing) ===
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

    // === Asset Resources ===
    resource function post assets(Asset asset) returns Asset|http:Conflict {
        if assets.hasKey(asset.tag) {
            return http:CONFLICT;
        }
        assets.add(asset);
        return asset;
    }

    resource function get assets() returns Asset[] {
        return assets.toArray();
    }

    resource function get assets/[string tag]() returns Asset|http:NotFound {
        if assets.hasKey(tag) {
            return assets.get(tag);
        } else {
            return http:NOT_FOUND;
        }
    }

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

    resource function delete assets/[string tag]() returns http:Ok|http:NotFound {
        if assets.hasKey(tag) {
            _ = assets.remove(tag);
            return http:OK;
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Component Resources ===
    resource function post components(Component component) returns Component|http:Conflict {
        if components.hasKey(component.id) {
            return http:CONFLICT;
        }
        components.add(component);
        return component;
    }

    resource function get components() returns Component[] {
        return components.toArray();
    }

    resource function get components/[string id]() returns Component|http:NotFound {
        if components.hasKey(id) {
            return components.get(id);
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Maintenance Schedule Resources ===
    resource function post maintenanceSchedules(MaintenanceSchedule schedule) returns MaintenanceSchedule|http:Conflict {
        if maintenanceSchedules.hasKey(schedule.scheduleId) {
            return http:CONFLICT;
        }
        maintenanceSchedules.add(schedule);
        return schedule;
    }

    resource function get maintenanceSchedules() returns MaintenanceSchedule[] {
        return maintenanceSchedules.toArray();
    }

    resource function get maintenanceSchedules/[string scheduleId]() returns MaintenanceSchedule|http:NotFound {
        if maintenanceSchedules.hasKey(scheduleId) {
            return maintenanceSchedules.get(scheduleId);
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Work Order Resources ===
    resource function post workOrders(WorkOrder workOrder) returns WorkOrder|http:Conflict {
        if workOrders.hasKey(workOrder.workOrderId) {
            return http:CONFLICT;
        }
        workOrders.add(workOrder);
        return workOrder;
    }

    resource function get workOrders() returns WorkOrder[] {
        return workOrders.toArray();
    }

    resource function get workOrders/[string workOrderId]() returns WorkOrder|http:NotFound {
        if workOrders.hasKey(workOrderId) {
            return workOrders.get(workOrderId);
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Task Resources ===
    resource function post tasks(Task task) returns Task|http:Conflict {
        if tasks.hasKey(task.taskId) {
            return http:CONFLICT;
        }
        tasks.add(task);
        return task;
    }

    resource function get tasks() returns Task[] {
        return tasks.toArray();
    }

    resource function get tasks/[string taskId]() returns Task|http:NotFound {
        if tasks.hasKey(taskId) {
            return tasks.get(taskId);
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Utility endpoints to get related entities for an asset ===
    resource function get assets/[string tag]/components() returns Component[]|http:NotFound {
        if !assets.hasKey(tag) {
            return http:NOT_FOUND;
        }
        Asset asset = assets.get(tag);
        Component[] result = [];
        foreach string id in asset.componentIds {
            if components.hasKey(id) {
                result.push(components.get(id));
            }
        }
        return result;
    }

    resource function get assets/[string tag]/maintenanceSchedules() returns MaintenanceSchedule[]|http:NotFound {
        if !assets.hasKey(tag) {
            return http:NOT_FOUND;
        }
        Asset asset = assets.get(tag);
        MaintenanceSchedule[] result = [];
        foreach string id in asset.maintenanceScheduleIds {
            if maintenanceSchedules.hasKey(id) {
                result.push(maintenanceSchedules.get(id));
            }
        }
        return result;
    }

    resource function get assets/[string tag]/workOrders() returns WorkOrder[]|http:NotFound {
        if !assets.hasKey(tag) {
            return http:NOT_FOUND;
        }
        Asset asset = assets.get(tag);
        WorkOrder[] result = [];
        foreach string id in asset.workOrderIds {
            if workOrders.hasKey(id) {
                result.push(workOrders.get(id));
            }
        }
        return result;
    }
}