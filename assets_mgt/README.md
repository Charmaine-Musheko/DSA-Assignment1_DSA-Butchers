# Asset Management

`bal run asset_mgt.bal`


# Requests to access assets

1. **GET** all assets `curl -X GET http://localhost:9090/assets`

2. **GET** specific assets by tag `curl -X GET http://localhost:9090/assets/A001`  Non-existing asset (should return 404).

3. **POST** a new asset `curl -X POST http://localhost:9090/assets -H "Content-Type: application/json" -d '{"tag": "A003", "name": "Microscope","faculty": "Science","department": "Biology","dateAcquired": "2023-03-20"}'`

4. **UPDATE** an existing asset `curl -X PUT http://localhost:9090/assets/A001 \-H "Content-Type: application/json" \-d '{"tag": "A001","name": "Updated Laptop","faculty": "Engineering","department": "Computer Engineering","dateAcquired": "2022-01-15"}'`

5. **DELETE** an existing asset `curl -X POST http://localhost:9090/assets -H "Content-Type: application/json" -d '{"tag": "A004","name": "3D Printer","faculty": "Engineering","department": "Mechanical","dateAcquired": "2023-05-10","currentStatus": ["ACTIVE"],"components": ["nozzle", "bed", "filament"],"maintenanceSchedule": ["QUARTERLY"],"workOrder": ["PENDING"],"tasks": ["MEDIUM"]}'`
 