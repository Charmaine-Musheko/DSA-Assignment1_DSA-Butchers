import ballerina/grpc;

service "/CarRental" on new grpc:Listener(9090) {
	remote function AddCar(Car car) returns Response|error {
		// TODO: Add car logic
		return { message: "Car added" };
	}
	remote function UpdateCar(Car car) returns Response|error {
		// TODO: Update car logic
		return { message: "Car updated" };
	}
	remote function RemoveCar(CarId id) returns Response|error {
		// TODO: Remove car logic
		return { message: "Car removed" };
	}
	remote function ListAvailableCars(Empty req) returns CarList|error {
		// TODO: List available cars
		return { cars: [] };
	}
	remote function SearchCar(SearchRequest req) returns CarList|error {
		// TODO: Search cars
		return { cars: [] };
	}
	remote function AddToCart(CartRequest req) returns Response|error {
		// TODO: Add to cart
		return { message: "Added to cart" };
	}
	remote function PlaceReservation(ReservationRequest req) returns ReservationResponse|error {
		// TODO: Place reservation, calculate price, validate
		return { status: "Reserved", totalPrice: 0.0 };
	}
}
