import ballerina/grpc;
import ballerina/protobuf;

public const string PATEMA_DESC = "0A0C706174656D612E70726F746F22730A03436172120E0A0269641801200128095202696412120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12140A05707269636518042001280152057072696365121C0A09617661696C61626C651805200128085209617661696C61626C6522170A054361724964120E0A0269641801200128095202696422070A05456D70747922230A074361724C69737412180A046361727318012003280B32042E43617252046361727322250A0D5365617263685265717565737412140A05717565727918012001280952057175657279223B0A0B436172745265717565737412140A0563617249641801200128095205636172496412160A06757365724964180220012809520675736572496422440A125265736572766174696F6E5265717565737412160A06757365724964180120012809520675736572496412160A066361724964731802200328095206636172496473224D0A135265736572766174696F6E526573706F6E736512160A067374617475731801200128095206737461747573121E0A0A746F74616C5072696365180220012801520A746F74616C507269636522240A08526573706F6E736512180A076D65737361676518012001280952076D6573736167653297020A0943617252656E74616C12190A0641646443617212042E4361721A092E526573706F6E7365121C0A0955706461746543617212042E4361721A092E526573706F6E7365121E0A0952656D6F766543617212062E43617249641A092E526573706F6E736512250A114C697374417661696C61626C654361727312062E456D7074791A082E4361724C69737412250A09536561726368436172120E2E536561726368526571756573741A082E4361724C69737412240A09416464546F43617274120C2E43617274526571756573741A092E526573706F6E7365123D0A10506C6163655265736572766174696F6E12132E5265736572766174696F6E526571756573741A142E5265736572766174696F6E526573706F6E7365620670726F746F33";

public isolated client class CarRentalClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, PATEMA_DESC);
    }

    isolated remote function AddCar(Car|ContextCar req) returns Response|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response>result;
    }

    isolated remote function AddCarContext(Car|ContextCar req) returns ContextResponse|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(Car|ContextCar req) returns Response|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response>result;
    }

    isolated remote function UpdateCarContext(Car|ContextCar req) returns ContextResponse|grpc:Error {
        map<string|string[]> headers = {};
        Car message;
        if req is ContextCar {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(CarId|ContextCarId req) returns Response|grpc:Error {
        map<string|string[]> headers = {};
        CarId message;
        if req is ContextCarId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response>result;
    }

    isolated remote function RemoveCarContext(CarId|ContextCarId req) returns ContextResponse|grpc:Error {
        map<string|string[]> headers = {};
        CarId message;
        if req is ContextCarId {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response>result, headers: respHeaders};
    }

    isolated remote function ListAvailableCars(Empty|ContextEmpty req) returns CarList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/ListAvailableCars", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarList>result;
    }

    isolated remote function ListAvailableCarsContext(Empty|ContextEmpty req) returns ContextCarList|grpc:Error {
        map<string|string[]> headers = {};
        Empty message;
        if req is ContextEmpty {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/ListAvailableCars", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarList>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchRequest|ContextSearchRequest req) returns CarList|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <CarList>result;
    }

    isolated remote function SearchCarContext(SearchRequest|ContextSearchRequest req) returns ContextCarList|grpc:Error {
        map<string|string[]> headers = {};
        SearchRequest message;
        if req is ContextSearchRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <CarList>result, headers: respHeaders};
    }

    isolated remote function AddToCart(CartRequest|ContextCartRequest req) returns Response|grpc:Error {
        map<string|string[]> headers = {};
        CartRequest message;
        if req is ContextCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <Response>result;
    }

    isolated remote function AddToCartContext(CartRequest|ContextCartRequest req) returns ContextResponse|grpc:Error {
        map<string|string[]> headers = {};
        CartRequest message;
        if req is ContextCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <Response>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(ReservationRequest|ContextReservationRequest req) returns ReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        ReservationRequest message;
        if req is ContextReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ReservationResponse>result;
    }

    isolated remote function PlaceReservationContext(ReservationRequest|ContextReservationRequest req) returns ContextReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        ReservationRequest message;
        if req is ContextReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ReservationResponse>result, headers: respHeaders};
    }
}

public type ContextResponse record {|
    Response content;
    map<string|string[]> headers;
|};

public type ContextCarList record {|
    CarList content;
    map<string|string[]> headers;
|};

public type ContextSearchRequest record {|
    SearchRequest content;
    map<string|string[]> headers;
|};

public type ContextCarId record {|
    CarId content;
    map<string|string[]> headers;
|};

public type ContextEmpty record {|
    Empty content;
    map<string|string[]> headers;
|};

public type ContextReservationResponse record {|
    ReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextCar record {|
    Car content;
    map<string|string[]> headers;
|};

public type ContextReservationRequest record {|
    ReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextCartRequest record {|
    CartRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type CarList record {|
    Car[] cars = [];
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type Response record {|
    string message = "";
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type SearchRequest record {|
    string query = "";
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type CarId record {|
    string id = "";
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type Empty record {|
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type ReservationResponse record {|
    string status = "";
    float totalPrice = 0.0;
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type Car record {|
    string id = "";
    string make = "";
    string model = "";
    float price = 0.0;
    boolean available = false;
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type ReservationRequest record {|
    string userId = "";
    string[] carIds = [];
|};

@protobuf:Descriptor {value: PATEMA_DESC}
public type CartRequest record {|
    string carId = "";
    string userId = "";
|};
