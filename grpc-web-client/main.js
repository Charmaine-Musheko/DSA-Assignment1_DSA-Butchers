const { CarRentalClient } = require('./gen/patema_grpc_web_pb.js');
const messages = require('./gen/patema_pb.js');

const client = new CarRentalClient('http://localhost:8080', null, null);

function setText(id, text, isError = false) {
    if (typeof window !== 'undefined' && typeof window.grpcShowResult === 'function') {
        window.grpcShowResult(id, text, isError);
        return;
    }
    const el = document.getElementById(id);
    if (!el) {
        return;
    }
    el.textContent = text;
    el.classList.remove('hidden');
    if (isError) {
        el.classList.add('text-red-400');
        el.classList.remove('text-green-400');
    } else {
        el.classList.remove('text-red-400');
        el.classList.add('text-green-400');
    }
}

function parsePrice(value) {
    const parsed = parseFloat(value);
    return Number.isFinite(parsed) ? parsed : 0;
}

function assignValue(id, value) {
    const element = document.getElementById(id);
    if (element) {
        element.value = value;
    }
}

const addCarForm = document.getElementById('addCarForm');
if (addCarForm) {
    addCarForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const id = document.getElementById('addCarId').value.trim();
        const make = document.getElementById('addCarMake').value.trim();
        const model = document.getElementById('addCarModel').value.trim();
        const price = parsePrice(document.getElementById('addCarPrice').value);
        const available = document.getElementById('addCarAvailable').checked;

        if (!id || !make || !model) {
            setText('addCarResult', 'Error: Please provide car id, make, and model.', true);
            return;
        }

        const car = new messages.Car();
        car.setId(id);
        car.setMake(make);
        car.setModel(model);
        car.setPrice(price);
        car.setAvailable(available);

        client.addCar(car, {}, (err, response) => {
            if (err) {
                setText('addCarResult', `Error: ${err.message || err.code || 'Request failed'}`, true);
                return;
            }
            setText('addCarResult', response.getMessage());

            assignValue('updateCarId', id);
            assignValue('updateCarMake', make);
            assignValue('updateCarModel', model);
            assignValue('updateCarPrice', price.toString());
            const updateAvailable = document.getElementById('updateCarAvailable');
            if (updateAvailable) {
                updateAvailable.checked = available;
                updateAvailable.dispatchEvent(new Event('change'));
            }
            assignValue('cartCarId', id);
            assignValue('reserveCarIds', id);
        });
    });
}

const updateCarForm = document.getElementById('updateCarForm');
if (updateCarForm) {
    updateCarForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const id = document.getElementById('updateCarId').value.trim();
        const make = document.getElementById('updateCarMake').value.trim();
        const model = document.getElementById('updateCarModel').value.trim();
        const priceValue = document.getElementById('updateCarPrice').value;
        const available = document.getElementById('updateCarAvailable').checked;
        const price = priceValue ? parsePrice(priceValue) : NaN;

        if (!id || !make || !model || !Number.isFinite(price)) {
            setText('updateCarResult', 'Error: Complete all car fields before updating.', true);
            return;
        }

        const car = new messages.Car();
        car.setId(id);
        car.setMake(make);
        car.setModel(model);
        car.setPrice(price);
        car.setAvailable(available);

        client.updateCar(car, {}, (err, response) => {
            if (err) {
                setText('updateCarResult', `Error: ${err.message || err.code || 'Request failed'}`, true);
                return;
            }
            setText('updateCarResult', response.getMessage());
        });
    });
}

const addToCartForm = document.getElementById('addToCartForm');
if (addToCartForm) {
    addToCartForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const carId = document.getElementById('cartCarId').value.trim();
        const userId = document.getElementById('cartUserId').value.trim();

        if (!carId || !userId) {
            setText('addToCartResult', 'Error: Provide both car id and user id.', true);
            return;
        }

        const request = new messages.CartRequest();
        if (typeof request.setCarid === 'function') {
            request.setCarid(carId);
        } else if (typeof request.setCarId === 'function') {
            request.setCarId(carId);
        }
        if (typeof request.setUserid === 'function') {
            request.setUserid(userId);
        } else if (typeof request.setUserId === 'function') {
            request.setUserId(userId);
        }

        client.addToCart(request, {}, (err, response) => {
            if (err) {
                setText('addToCartResult', `Error: ${err.message || err.code || 'Request failed'}`, true);
                return;
            }
            setText('addToCartResult', response.getMessage());
            assignValue('reserveUserId', userId);
            if (!document.getElementById('reserveCarIds').value.trim()) {
                assignValue('reserveCarIds', carId);
            }
        });
    });
}

const reserveForm = document.getElementById('reserveForm');
if (reserveForm) {
    reserveForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const userId = document.getElementById('reserveUserId').value.trim();
        const ids = document.getElementById('reserveCarIds').value
            .split(',')
            .map((value) => value.trim())
            .filter((value) => value.length > 0);

        if (!userId || ids.length === 0) {
            setText('reserveResult', 'Error: Provide a user id and at least one car id.', true);
            return;
        }

        const request = new messages.ReservationRequest();
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
                setText('reserveResult', `Error: ${err.message || err.code || 'Request failed'}`, true);
                return;
            }
            setText('reserveResult', JSON.stringify({
                status: response.getStatus(),
                totalPrice: response.getTotalprice(),
            }, null, 2));
        });
    });
}

const searchForm = document.getElementById('searchForm');
if (searchForm) {
    searchForm.addEventListener('submit', (event) => {
        event.preventDefault();
        const queryField = document.getElementById('searchQuery');
        const query = queryField ? queryField.value.trim() : '';

        const request = new messages.SearchRequest();
        if (typeof request.setQuery === 'function') {
            request.setQuery(query);
        }

        client.searchCar(request, {}, (err, response) => {
            if (err) {
                setText('searchResult', `Error: ${err.message || err.code || 'Request failed'}`, true);
                return;
            }
            const cars = response.getCarsList().map((car) => ({
                id: car.getId(),
                make: car.getMake(),
                model: car.getModel(),
                price: car.getPrice(),
                available: car.getAvailable(),
            }));
            setText('searchResult', cars.length > 0 ? JSON.stringify(cars, null, 2) : 'No matches');
        });
    });
}