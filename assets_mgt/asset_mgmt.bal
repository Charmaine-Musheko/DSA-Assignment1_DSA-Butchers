import ballerina/http;

// Common types for reuse
type Faculty record {|
    readonly string facultyId;
    string name;
    string description;
    string dean;
    string[] departmentIds = [];
|};

type Department record {|
    readonly string departmentId;
    string name;
    string description;
    string head;
    string facultyId;
|};

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
    string types; // REGULAR, QUARTERLY, ANNUAL
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
table<Faculty> key(facultyId) faculties = table [];
table<Department> key(departmentId) departments = table [];
table<Component> key(id) components = table [];
table<MaintenanceSchedule> key(scheduleId) maintenanceSchedules = table [];
table<WorkOrder> key(workOrderId) workOrders = table [];
table<Task> key(taskId) tasks = table [];

// Asset type now references other entities by ID
type Asset record {|
    readonly string tag;
    string name;
    string facultyId;
    string departmentId;
    string dateAcquired;
    string currentStatus; // ACTIVE, UNDER_REPAIR, DISPOSED
    string[] componentIds = [];
    string[] maintenanceScheduleIds = [];
    string[] workOrderIds = [];
|};

table<Asset> key(tag) assets = table [
    {tag: "A001", name: "Laptop", facultyId: "F001", 
     departmentId: "D001", dateAcquired: "2022-01-15", currentStatus: "ACTIVE"},
    {tag: "A002", name: "Projector", facultyId: "F002", 
     departmentId: "D002", dateAcquired: "2021-09-10", currentStatus: "ACTIVE"}
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
    resource function post assets(Asset asset) returns Asset|http:Conflict|http:NotFound {
        if assets.hasKey(asset.tag) {
            return http:CONFLICT;
        }
        // Validate that faculty and department exist
        if !faculties.hasKey(asset.facultyId) {
            return http:NOT_FOUND;
        }
        if !departments.hasKey(asset.departmentId) {
            return http:NOT_FOUND;
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
        // Validate that faculty and department exist
        if !faculties.hasKey(asset.facultyId) {
            return http:NOT_FOUND;
        }
        if !departments.hasKey(asset.departmentId) {
            return http:NOT_FOUND;
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

    // === Faculty Resources ===
    resource function post faculties(Faculty faculty) returns Faculty|http:Conflict {
        if faculties.hasKey(faculty.facultyId) {
            return http:CONFLICT;
        }
        faculties.add(faculty);
        return faculty;
    }

    resource function get faculties() returns Faculty[] {
        return faculties.toArray();
    }

    resource function get faculties/[string facultyId]() returns Faculty|http:NotFound {
        if faculties.hasKey(facultyId) {
            return faculties.get(facultyId);
        } else {
            return http:NOT_FOUND;
        }
    }

    resource function put faculties/[string facultyId](Faculty faculty) returns Faculty|http:NotFound|http:BadRequest {
        if !faculties.hasKey(facultyId) {
            return http:NOT_FOUND;
        }
        if facultyId != faculty.facultyId {
            return http:BAD_REQUEST;
        }
        _ = faculties.remove(facultyId);
        faculties.add(faculty);
        return faculty;
    }

    resource function delete faculties/[string facultyId]() returns http:Ok|http:NotFound {
        if faculties.hasKey(facultyId) {
            _ = faculties.remove(facultyId);
            return http:OK;
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Department Resources ===
    resource function post departments(Department department) returns Department|http:Conflict|http:NotFound {
        if departments.hasKey(department.departmentId) {
            return http:CONFLICT;
        }
        // Validate that faculty exists
        if !faculties.hasKey(department.facultyId) {
            return http:NOT_FOUND;
        }
        departments.add(department);
        return department;
    }

    resource function get departments() returns Department[] {
        return departments.toArray();
    }

    resource function get departments/[string departmentId]() returns Department|http:NotFound {
        if departments.hasKey(departmentId) {
            return departments.get(departmentId);
        } else {
            return http:NOT_FOUND;
        }
    }

    resource function put departments/[string departmentId](Department department) returns Department|http:NotFound|http:BadRequest {
        if !departments.hasKey(departmentId) {
            return http:NOT_FOUND;
        }
        if departmentId != department.departmentId {
            return http:BAD_REQUEST;
        }
        // Validate that faculty exists
        if !faculties.hasKey(department.facultyId) {
            return http:NOT_FOUND;
        }
        _ = departments.remove(departmentId);
        departments.add(department);
        return department;
    }

    resource function delete departments/[string departmentId]() returns http:Ok|http:NotFound {
        if departments.hasKey(departmentId) {
            _ = departments.remove(departmentId);
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

    resource function put components/[string id](Component component) returns Component|http:NotFound|http:BadRequest {
        if !components.hasKey(id) {
            return http:NOT_FOUND;
        }
        if id != component.id {
            return http:BAD_REQUEST;
        }
        _ = components.remove(id);
        components.add(component);
        return component;
    }

    resource function delete components/[string id]() returns http:Ok|http:NotFound {
        if components.hasKey(id) {
            _ = components.remove(id);
            return http:OK;
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

    resource function put maintenanceSchedules/[string scheduleId](MaintenanceSchedule schedule) returns MaintenanceSchedule|http:NotFound|http:BadRequest {
        if !maintenanceSchedules.hasKey(scheduleId) {
            return http:NOT_FOUND;
        }
        if scheduleId != schedule.scheduleId {
            return http:BAD_REQUEST;
        }
        _ = maintenanceSchedules.remove(scheduleId);
        maintenanceSchedules.add(schedule);
        return schedule;
    }

    resource function delete maintenanceSchedules/[string scheduleId]() returns http:Ok|http:NotFound {
        if maintenanceSchedules.hasKey(scheduleId) {
            _ = maintenanceSchedules.remove(scheduleId);
            return http:OK;
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

    resource function put workOrders/[string workOrderId](WorkOrder workOrder) returns WorkOrder|http:NotFound|http:BadRequest {
        if !workOrders.hasKey(workOrderId) {
            return http:NOT_FOUND;
        }
        if workOrderId != workOrder.workOrderId {
            return http:BAD_REQUEST;
        }
        _ = workOrders.remove(workOrderId);
        workOrders.add(workOrder);
        return workOrder;
    }

    resource function delete workOrders/[string workOrderId]() returns http:Ok|http:NotFound {
        if workOrders.hasKey(workOrderId) {
            _ = workOrders.remove(workOrderId);
            return http:OK;
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

    resource function put tasks/[string taskId](Task task) returns Task|http:NotFound|http:BadRequest {
        if !tasks.hasKey(taskId) {
            return http:NOT_FOUND;
        }
        if taskId != task.taskId {
            return http:BAD_REQUEST;
        }
        _ = tasks.remove(taskId);
        tasks.add(task);
        return task;
    }

    resource function delete tasks/[string taskId]() returns http:Ok|http:NotFound {
        if tasks.hasKey(taskId) {
            _ = tasks.remove(taskId);
            return http:OK;
        } else {
            return http:NOT_FOUND;
        }
    }

    // === Utility endpoints to get related entities ===
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

    resource function get assets/[string tag]/faculty() returns Faculty|http:NotFound {
        if !assets.hasKey(tag) {
            return http:NOT_FOUND;
        }
        Asset asset = assets.get(tag);
        if faculties.hasKey(asset.facultyId) {
            return faculties.get(asset.facultyId);
        } else {
            return http:NOT_FOUND;
        }
    }

    resource function get assets/[string tag]/department() returns Department|http:NotFound {
        if !assets.hasKey(tag) {
            return http:NOT_FOUND;
        }
        Asset asset = assets.get(tag);
        if departments.hasKey(asset.departmentId) {
            return departments.get(asset.departmentId);
        } else {
            return http:NOT_FOUND;
        }
    }

    resource function get faculties/[string facultyId]/departments() returns Department[]|http:NotFound {
        if !faculties.hasKey(facultyId) {
            return http:NOT_FOUND;
        }
        Faculty faculty = faculties.get(facultyId);
        Department[] result = [];
        foreach string id in faculty.departmentIds {
            if departments.hasKey(id) {
                result.push(departments.get(id));
            }
        }
        return result;
    }

    resource function get faculties/[string facultyId]/assets() returns Asset[]|http:NotFound {
        if !faculties.hasKey(facultyId) {
            return http:NOT_FOUND;
        }
        Asset[] result = [];
        foreach Asset asset in assets {
            if asset.facultyId == facultyId {
                result.push(asset);
            }
        }
        return result;
    }

    resource function get departments/[string departmentId]/assets() returns Asset[]|http:NotFound {
        if !departments.hasKey(departmentId) {
            return http:NOT_FOUND;
        }
        Asset[] result = [];
        foreach Asset asset in assets {
            if asset.departmentId == departmentId {
                result.push(asset);
            }
        }
        return result;
    }
}