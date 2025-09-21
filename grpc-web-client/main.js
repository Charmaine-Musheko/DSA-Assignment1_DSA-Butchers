const {CarRentalClient} = require('./gen/patema_grpc_web_pb.js');
const messages = require('./gen/patema_pb.js');

const client = new CarRentalClient('http://localhost:8080', null, null);

function setText(id, text) {
    const el = document.getElementById(id);
    if (el) {
        el.textContent = text;
    }
}

document.getElementById('addCarForm').addEventListener('submit', (event) => {
    event.preventDefault();
    const car = new messages.Car();
    car.setId(document.getElementById('addCarId').value.trim());
    car.setMake(document.getElementById('addCarMake').value.trim());
    car.setModel(document.getElementById('addCarModel').value.trim());
    car.setPrice(parseFloat(document.getElementById('addCarPrice').value));
    car.setAvailable(document.getElementById('addCarAvailable').checked);
    client.addCar(car, {}, (err, response) => {
        if (err) {
            setText('addCarResult', Error: );
            return;
        }
        setText('addCarResult', response.getMessage());
    });
});

document.getElementById('searchForm').addEventListener('submit', (event) => {
    event.preventDefault();
    const request = new messages.SearchRequest();
    request.setQuery(document.getElementById('searchQuery').value.trim());
    client.searchCar(request, {}, (err, response) => {
        if (err) {
            setText('searchResult', Error: );
            return;
        }
        const cars = response.getCarsList().map((car) => ({
            id: car.getId(),
            make: car.getMake(),
            model: car.getModel(),
            price: car.getPrice(),
            available: car.getAvailable(),
        }));
        setText('searchResult', JSON.stringify(cars, null, 2));
    });
});

document.getElementById('reserveForm').addEventListener('submit', (event) => {
    event.preventDefault();
    const request = new messages.ReservationRequest();
    const userId = document.getElementById('reserveUserId').value.trim();
    const ids = document.getElementById('reserveCarIds').value
        .split(',')
        .map((value) => value.trim())
        .filter((value) => value.length > 0);

    if (typeof request.setUserid === 'function') {
        request.setUserid(userId);
    } else {
        request.setUserId(userId);
    }

    if (typeof request.setCaridsList === 'function') {
        request.setCaridsList(ids);
    } else {
        request.setCarIdsList(ids);
    }

    client.placeReservation(request, {}, (err, response) => {
        if (err) {
            setText('reserveResult', Error: );
            return;
        }
        setText('reserveResult', JSON.stringify({
            status: response.getStatus(),
            totalPrice: response.getTotalprice(),
        }, null, 2));
    });
});
