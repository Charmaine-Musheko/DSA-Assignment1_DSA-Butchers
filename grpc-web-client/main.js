const { CarRentalClient } = require('./gen/patema_grpc_web_pb.js');
const messages = require('./gen/patema_pb.js');

const client = new CarRentalClient('http://localhost:8080', null, null);
const state = {
    lastCar: undefined,
    lastUserId: undefined,
};

function setText(id, content) {
    const el = document.getElementById(id);
    if (el) {
        el.textContent = content;
    }
}

function formatJson(data) {
    return JSON.stringify(data, null, 2);
}

function extractCar(carMessage) {
    return {
        id: carMessage.getId(),
        make: carMessage.getMake(),
        model: carMessage.getModel(),
        price: carMessage.getPrice(),
        available: carMessage.getAvailable(),
    };
}

function ensureStub(methodName) {
    if (typeof client[methodName] !== 'function') {
        throw new Error(${methodName} is not available on the generated client. Regenerate gRPC-Web stubs.);
    }
}

function updateDerivedFields() {
    if (state.lastCar) {
        document.getElementById('updateCarId').value = state.lastCar.id;
        document.getElementById('cartCarId').value = state.lastCar.id;
        const carIds = document.getElementById('reserveCarIds');
        if (carIds.value.trim().length === 0) {
            carIds.value = state.lastCar.id;
        }
        if (!document.getElementById('searchQuery').value) {
            document.getElementById('searchQuery').value = state.lastCar.make;
        }
    }
    if (state.lastUserId) {
        document.getElementById('cartUserId').value = state.lastUserId;
        document.getElementById('reserveUserId').value = state.lastUserId;
    }
}

function randomSuffix() {
    return Math.random().toString(36).substring(2, 8);
}

document.getElementById('generateCarId').addEventListener('click', () => {
    const timePart = new Date().getTime().toString().slice(-4);
    const carId = car--;
    const make = 'Nissan';
    const model = 'Leaf';
    const price = 4800;
    document.getElementById('addCarId').value = carId;
    document.getElementById('addCarMake').value = make;
    document.getElementById('addCarModel').value = model;
    document.getElementById('addCarPrice').value = price;
    document.getElementById('addCarAvailable').checked = true;
    setText('addCarResult', 'Sample car generated. Submit the form to add it.');
});

document.getElementById('addCarForm').addEventListener('submit', (event) => {
    event.preventDefault();
    try {
        ensureStub('addCar');
        const car = new messages.Car();
        const id = document.getElementById('addCarId').value.trim();
        const make = document.getElementById('addCarMake').value.trim();
        const model = document.getElementById('addCarModel').value.trim();
        const price = parseFloat(document.getElementById('addCarPrice').value);
        car.setId(id);
        car.setMake(make);
        car.setModel(model);
        car.setPrice(price);
        car.setAvailable(document.getElementById('addCarAvailable').checked);

        client.addCar(car, {}, (err, res) => {
            if (err) {
                setText('addCarResult', Error: );
                return;
            }
            state.lastCar = { id, make, model, price, available: car.getAvailable() };
            setText('addCarResult', res.getMessage());
            updateDerivedFields();
        });
    } catch (error) {
        setText('addCarResult', Error: );
    }
});

document.getElementById('updateCarForm').addEventListener('submit', (event) => {
    event.preventDefault();
    try {
        ensureStub('updateCar');
        const id = document.getElementById('updateCarId').value.trim();
        const makeField = document.getElementById('updateCarMake').value.trim();
        const modelField = document.getElementById('updateCarModel').value.trim();
        const priceField = document.getElementById('updateCarPrice').value;
        const available = document.getElementById('updateCarAvailable').checked;

        if (!state.lastCar && (!makeField || !modelField || !priceField)) {
            throw new Error('Provide full details the first time you update a car.');
        }

        const car = new messages.Car();
        car.setId(id);
        const make = makeField || (state.lastCar ? state.lastCar.make : '');
        const model = modelField || (state.lastCar ? state.lastCar.model : '');
        const price = priceField ? parseFloat(priceField) : (state.lastCar ? state.lastCar.price : 0);
        car.setMake(make);
        car.setModel(model);
        car.setPrice(price);
        car.setAvailable(available);

        client.updateCar(car, {}, (err, res) => {
            if (err) {
                setText('updateCarResult', Error: );
                return;
            }
            state.lastCar = { id, make, model, price, available };
            setText('updateCarResult', res.getMessage());
            updateDerivedFields();
        });
    } catch (error) {
        setText('updateCarResult', Error: );
    }
});

document.getElementById('listCarsBtn').addEventListener('click', () => {
    try {
        ensureStub('listAvailableCars');
        const req = new messages.Empty();
        client.listAvailableCars(req, {}, (err, res) => {
            if (err) {
                setText('listCarsResult', Error: );
                return;
            }
            const cars = res.getCarsList().map(extractCar);
            setText('listCarsResult', formatJson(cars));
        });
    } catch (error) {
        setText('listCarsResult', Error: );
    }
});

document.getElementById('searchForm').addEventListener('submit', (event) => {
    event.preventDefault();
    try {
        ensureStub('searchCar');
        const req = new messages.SearchRequest();
        req.setQuery(document.getElementById('searchQuery').value.trim());
        client.searchCar(req, {}, (err, res) => {
            if (err) {
                setText('searchResult', Error: );
                return;
            }
            const cars = res.getCarsList().map(extractCar);
            setText('searchResult', formatJson(cars));
        });
    } catch (error) {
        setText('searchResult', Error: );
    }
});

document.getElementById('addToCartForm').addEventListener('submit', (event) => {
    event.preventDefault();
    try {
        ensureStub('addToCart');
        const req = new messages.CartRequest();
        const carId = document.getElementById('cartCarId').value.trim();
        const userId = document.getElementById('cartUserId').value.trim() || user-;
        req.setCarid(carId);
        if (typeof req.setUserid === 'function') {
            req.setUserid(userId);
        } else if (typeof req.setUserId === 'function') {
            req.setUserId(userId);
        }
        client.addToCart(req, {}, (err, res) => {
            if (err) {
                setText('addToCartResult', Error: );
                return;
            }
            state.lastUserId = userId;
            setText('addToCartResult', res.getMessage());
            updateDerivedFields();
        });
    } catch (error) {
        setText('addToCartResult', Error: );
    }
});

document.getElementById('reserveForm').addEventListener('submit', (event) => {
    event.preventDefault();
    try {
        ensureStub('placeReservation');
        const req = new messages.ReservationRequest();
        const userIdValue = document.getElementById('reserveUserId').value.trim();
        const carIds = document.getElementById('reserveCarIds').value
            .split(',')
            .map((value) => value.trim())
            .filter((value) => value.length > 0);

        if (carIds.length === 0) {
            throw new Error('Provide at least one car id.');
        }

        if (typeof req.setUserid === 'function') {
            req.setUserid(userIdValue);
        } else if (typeof req.setUserId === 'function') {
            req.setUserId(userIdValue);
        }

        if (typeof req.setCaridsList === 'function') {
            req.setCaridsList(carIds);
        } else if (typeof req.setCarIdsList === 'function') {
            req.setCarIdsList(carIds);
        }

        client.placeReservation(req, {}, (err, res) => {
            if (err) {
                setText('reserveResult', Error: );
                return;
            }
            state.lastUserId = userIdValue;
            const result = {
                status: res.getStatus(),
                totalPrice: typeof res.getTotalprice === 'function' ? res.getTotalprice() : res.getTotalPrice(),
            };
            setText('reserveResult', formatJson(result));
            updateDerivedFields();
        });
    } catch (error) {
        setText('reserveResult', Error: );
    }
});

updateDerivedFields();
