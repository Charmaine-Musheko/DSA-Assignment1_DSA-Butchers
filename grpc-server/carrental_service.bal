import ballerina/grpc;

grpc:ListenerConfiguration listenerConfig = {
    maxInboundMessageSize: 16 * 1024 * 1024
};

listener grpc:Listener carRentalListener = new (9000, listenerConfig);

@grpc:ServiceDescriptor {
    descriptor: PATEMA_DESC
}
service "CarRental" on carRentalListener {
    remote function AddCar(Car value) returns Response|error {
        return addCarToInventory(value);
    }

    remote function UpdateCar(Car value) returns Response|error {
        return updateCarInInventory(value);
    }

    remote function RemoveCar(CarId value) returns Response|error {
        return removeCarFromInventory(value);
    }

    remote function ListAvailableCars(Empty value) returns CarList|error {
        return listAvailableCars();
    }

    remote function SearchCar(SearchRequest value) returns CarList|error {
        return searchCar(value);
    }

    remote function AddToCart(CartRequest value) returns Response|error {
        return addToCart(value);
    }

    remote function PlaceReservation(ReservationRequest value) returns ReservationResponse|error {
        return reserveCars(value);
    }
}