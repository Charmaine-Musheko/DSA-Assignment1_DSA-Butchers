type Task record {
    string taskId;
    string description;
    string status; // e.g pending, completed
};

type WorkOrder record {
    string workOrderId;
    string status;
    string issueDescription;
    Task[] tasks;
};

type MaintenanceSchedule record {
    string scheduleId;
    string description;
    string frequency; // e.g weekly, monthly
    string nextDueDate;
};

type Component record {
    string componentId;
    string name;
    string description;
};

type Assets record {
    string assetTag;
    string name;
    string faculty;
    string department;
    string dateAcquired;
    string status; // e.g active, inactive
    Component[] components;
    MaintenanceSchedule[] maintenanceSchedules;
    WorkOrder[] workOrders;
};

//Shared in-memory database
map<Asset> assetDB = {};