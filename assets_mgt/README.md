# RESTAPI ASSET MANAGEMENT

## Authors

- Tinomudaishe Ndhlovu (218122187)
- 
- 

## RESTAPI Service Running

1. ```shellbal run asset_mgt.bal```

2. Copy one of the below curl requests to get it to run or alternatively use postman to get it to work

## Immidiate Asset Relationship Endpoints

1. **GET** Asset Components
```shell
curl -X GET http://localhost:9090/assets/A001/components
```

2. **GET** Asset Maintenance Schedules
```shell
curl -X GET http://localhost:9090/assets/A001/maintenanceSchedules
```

3. **GET** Asset Maintenance Schedules
```shell
curl -X GET http://localhost:9090/assets/A001/workOrders
```

## COMBINED TESTING SCENARIOS

### 1. Create components
```shell
curl -X POST http://localhost:9090/components -H "Content-Type: application/json" -d '{"id":"COMP001","name":"Battery","description":"Laptop battery","model":"LB-5000","serialNumber":"BAT123456","status":"ACTIVE"}'
```

### 2. Create maintenance schedule
```shell
curl -X POST http://localhost:9090/maintenanceSchedules -H "Content-Type: application/json" -d '{"scheduleId":"MS001","types":"QUARTERLY","frequency":"Every 3 months","requiredTasks":["Clean fans","Check battery"],"lastPerformed":"2023-12-01","nextDue":"2024-03-01"}'
```

### 3. Create task
```shell
curl -X POST http://localhost:9090/tasks -H "Content-Type: application/json" -d '{"taskId":"TASK001","name":"Clean Device","description":"Thorough cleaning","size":"MEDIUM","estimatedHours":2,"requiredTools":["Compressed air"]}'
```

### 3. Create the Asset with the Linked Relation
```shell
curl -X POST http://localhost:9090/assets -H "Content-Type: application/json" -d '{"tag":"A003","name":"Server","faculty":"IT","department":"Infrastructure","dateAcquired":"2023-01-15","currentStatus":"ACTIVE","componentIds":["COMP001"],"maintenanceScheduleIds":["MS001"],"workOrderIds":["WO001"]}'
```

### Testing Final EndPoint Relationships

```shell
curl -X GET http://localhost:9090/assets/A003/components
```

```shell
curl -X GET http://localhost:9090/assets/A003/maintenanceSchedules
```

```shell
curl -X GET http://localhost:9090/assets/A003/workOrders
```


### Create work order
```shell
curl -X POST http://localhost:9090/workOrders -H "Content-Type: application/json" -d '{"workOrderId":"WO001","status":"PENDING","priority":"HIGH","assignedTo":"John Doe","tasks":["TASK001"],"createdDate":"2024-01-15"}'
```


## Requests using the terminal

Below this are the much more detailed work arounds of the API Endpoints


###  RESTAPI Requests for the Assets/


1. **GET** all assets 
```shell
curl -X GET http://localhost:9090/assets
```

2. **GET** specific assets by tag 
```shell
curl -X GET http://localhost:9090/assets/A001
```
Non-existing asset (should return 404).

3. **POST** a new asset '
```shell
curl -X POST http://localhost:9090/assets \
  -H "Content-Type: application/json" \
  -d '{
    "tag": "A003",
    "name": "Server",
    "faculty": "IT",
    "department": "Infrastructure",
    "dateAcquired": "2023-01-15",
    "currentStatus": "ACTIVE",
    "componentIds": ["COMP001"],
    "maintenanceScheduleIds": ["MS001"],
    "workOrderIds": []
  }'
```

4. **UPDATE** an existing asset 
```shell
curl -X PUT http://localhost:9090/assets/A001 \
  -H "Content-Type: application/json" \
  -d '{
    "tag": "A001",
    "name": "Updated Laptop Pro",
    "faculty": "Engineering",
    "department": "Computer Engineering",
    "dateAcquired": "2022-01-15",
    "currentStatus": "ACTIVE",
    "componentIds": ["COMP001", "COMP002"],
    "maintenanceScheduleIds": ["MS001"],
    "workOrderIds": ["WO001"]
  }'
```

5. **DELETE** an existing asset 
```shell
curl -X POST http://localhost:9090/assets -H "Content-Type: application/json" -d '{"tag": "A004","name": "3D Printer","faculty": "Engineering","department": "Mechanical","dateAcquired": "2023-05-10","currentStatus": ["ACTIVE"],"components": ["nozzle", "bed", "filament"],"maintenanceSchedule": ["QUARTERLY"],"workOrder": ["PENDING"],"tasks": ["MEDIUM"]}'
```



### RESTAPI Requests for the Components/



1. **GET** all components 
```shell
curl -X GET http://localhost:9090/components
```

2. **GET** a specific component
```shell
curl -X GET http://localhost:9090/components/COMP001
```
Non-existing asset (should return 404).

3. **POST** a new component '
```shell
curl -X POST http://localhost:9090/components -H "Content-Type: application/json" -d '{
    "id": "COMP001",
    "name": "Battery",
    "description": "Laptop battery 5000mAh",
    "model": "LB-5000",
    "serialNumber": "BAT123456789",
    "status": "ACTIVE"
  }'
```

4. **UPDATE** an existing component 
```shell
curl -X PUT http://localhost:9090/components/COMP001 \
  -H "Content-Type: application/json" \
  -d '{
    "id": "COMP001",
    "name": "Updated Battery",
    "description": "Laptop battery 6000mAh",
    "model": "LB-6000",
    "serialNumber": "BAT123456789",
    "status": "UNDER_MAINTENANCE"
  }'
```

5. **DELETE** an existing asset 
```shell
curl -X DELETE http://localhost:9090/components/COMP001
```



### RESTAPI Requests for the Maintenance Schedule 


1. **GET** all maintainance schedules 
```shell
curl -X GET http://localhost:9090/maintenanceSchedules
```

2. **GET** a specific maintainance schedules
```shell
curl -X GET http://localhost:9090/maintenanceSchedules/MS001
```
Non-existing asset (should return 404).

3. **POST** a new component '
```shell
curl -X POST http://localhost:9090/maintenanceSchedules \
  -H "Content-Type: application/json" \
  -d '{
    "scheduleId": "MS001",
    "types": "QUARTERLY",
    "frequency": "Every 3 months",
    "requiredTasks": ["Clean fans", "Check battery health", "Update software"],
    "lastPerformed": "2023-12-01",
    "nextDue": "2024-03-01"
  }'
```

4. **UPDATE** an existing mainantance schedule 
```shell
curl -X PUT http://localhost:9090/maintenanceSchedules/MS001 \
  -H "Content-Type: application/json" \
  -d '{
    "scheduleId": "MS001",
    "types": "ANNUAL",
    "frequency": "Every year",
    "requiredTasks": ["Full inspection", "Component replacement", "Software update"],
    "lastPerformed": "2023-12-15",
    "nextDue": "2024-12-15"
  }'
```

5. **DELETE** an existing mainantance 
```shell
curl -X DELETE http://localhost:9090/maintenanceSchedules/MS001
```



### RESTAPI Requests for the Work Order




1. **GET** all Work Orders
```shell
curl -X GET http://localhost:9090/workOrders
```

2. **GET** a specific Work Orders
```shell
curl -X GET http://localhost:9090/workOrders/WO001
```
Non-existing asset (should return 404).

3. **POST** a new component '
```shell
curl -X POST http://localhost:9090/workOrders \
  -H "Content-Type: application/json" \
  -d '{
    "workOrderId": "WO001",
    "status": "PENDING",
    "priority": "HIGH",
    "assignedTo": "Tino Ndhlovu",
    "tasks": ["TASK001", "TASK002"],
    "createdDate": "2024-01-15",
    "completedDate": ""
  }'
```

4. **UPDATE** an existing component 
```shell
curl -X PUT http://localhost:9090/workOrders/WO001 \
  -H "Content-Type: application/json" \
  -d '{
    "workOrderId": "WO001",
    "status": "IN_PROGRESS",
    "priority": "HIGH",
    "assignedTo": "Jane Smith",
    "tasks": ["TASK001", "TASK002", "TASK003"],
    "createdDate": "2024-01-15",
    "completedDate": ""
  }'
```

5. **DELETE** an existing asset 
```shell
curl -X DELETE http://localhost:9090/workOrders/WO001
```



### RESTAPI Requests for the Tasks


1. **GET** all Tasks
```shell
curl -X GET http://localhost:9090/tasks
```

2. **GET** a specific Tasks
```shell
curl -X GET http://localhost:9090/tasks/TASK001
```
Non-existing asset (should return 404).

3. **POST** a new Task '
```shell
curl -X POST http://localhost:9090/tasks \
  -H "Content-Type: application/json" \
  -d '{
    "taskId": "TASK001",
    "name": "Clean Device",
    "description": "Thorough cleaning of internal components",
    "size": "MEDIUM",
    "estimatedHours": 2,
    "requiredTools": ["Compressed air", "Soft brush", "Cleaning solution"]
  }'
```

4. **UPDATE** an existing Tasks 
```shell
curl -X PUT http://localhost:9090/tasks/TASK001 \
  -H "Content-Type: application/json" \
  -d '{
    "taskId": "TASK001",
    "name": "Deep Cleaning",
    "description": "Comprehensive cleaning and maintenance",
    "size": "LARGE",
    "estimatedHours": 4,
    "requiredTools": ["Compressed air", "Soft brush", "Cleaning solution", "Screwdriver set"]
  }'
```

5. **DELETE** an existing Task 
```shell
curl -X DELETE http://localhost:9090/tasks/TASK001
```





