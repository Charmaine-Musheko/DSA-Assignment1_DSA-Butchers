import ballerina/grpc;
import ballerina/protobuf;
import ballerina/time;

public const string CAR_RENTAL_DESC = "0A106361725F72656E74616C2E70726F746F120A6361725F72656E74616C1A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22D9010A0343617212140A05706C6174651801200128095205706C61746512120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12120A0479656172180420012805520479656172121D0A0A6461696C795F7261746518052001280152096461696C795261746512180A076D696C6561676518062001280552076D696C65616765122D0A0673746174757318072001280E32152E6361725F72656E74616C2E436172537461747573520673746174757312160A06636F6C6F75721808200128095206636F6C6F7572227B0A0455736572121A0A08757365726E616D651801200128095208757365726E616D6512240A04726F6C6518022001280E32102E6361725F72656E74616C2E526F6C655204726F6C6512140A05656D61696C1803200128095205656D61696C121B0A0966756C6C5F6E616D65180420012809520866756C6C4E616D6522BB010A08436172744974656D12140A05706C6174651801200128095205706C61746512390A0A73746172745F6461746518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E644461746512270A0F657374696D617465645F7072696365180420012801520E657374696D61746564507269636522B4020A0B5265736572766174696F6E12250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E4964121A0A08757365726E616D651802200128095208757365726E616D6512140A05706C6174651803200128095205706C61746512390A0A73746172745F6461746518042001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518052001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E6444617465121F0A0B746F74616C5F7072696365180620012801520A746F74616C507269636512390A0A637265617465645F617418072001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705209637265617465644174224B0A0B5374617475735265706C79120E0A026F6B18012001280852026F6B12120A04636F64651802200128055204636F646512180A076D65737361676518032001280952076D65737361676522510A0D4164644361725265717565737412210A0363617218012001280B320F2E6361725F72656E74616C2E4361725203636172121D0A0A726571756573745F6279180220012809520972657175657374427922700A0B4164644361725265706C79120E0A026F6B18012001280852026F6B12140A05706C6174651802200128095205706C61746512210A0363617218032001280B320F2E6361725F72656E74616C2E436172520363617212180A076D65737361676518042001280952076D65737361676522390A11437265617465557365725265717565737412240A047573657218012001280B32102E6361725F72656E74616C2E5573657252047573657222620A1043726561746555736572735265706C7912230A0D637265617465645F636F756E74180120012805520C63726561746564436F756E7412290A106661696C65645F757365726E616D6573180220032809520F6661696C6564557365726E616D657322530A105570646174654361725265717565737412140A05706C6174651801200128095205706C61746512290A077570646174656418022001280B320F2E6361725F72656E74616C2E43617252077570646174656422640A0E5570646174654361725265706C7912210A0363617218012001280B320F2E6361725F72656E74616C2E4361725203636172122F0A0673746174757318022001280B32172E6361725F72656E74616C2E5374617475735265706C79520673746174757322280A1052656D6F76654361725265717565737412140A05706C6174651801200128095205706C61746522660A0E52656D6F76654361725265706C79122F0A0673746174757318012001280B32172E6361725F72656E74616C2E5374617475735265706C79520673746174757312230A046361727318022003280B320F2E6361725F72656E74616C2E4361725204636172732285010A184C697374417661696C61626C654361727352657175657374121F0A0B746578745F66696C746572180120012809520A7465787446696C74657212120A0479656172180220012805520479656172121B0A09796561725F66726F6D18032001280552087965617246726F6D12170A07796561725F746F180420012805520679656172546F226A0A105365617263684361725265717565737412140A05706C6174651801200128095205706C61746512120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12160A06636F6C6F75721804200128095206636F6C6F7572224F0A0E5365617263684361725265706C7912230A046361727318012003280B320F2E6361725F72656E74616C2E43617252046361727312180A076D65737361676518022001280952076D65737361676522B6010A10416464546F4361727452657175657374121A0A08757365726E616D651801200128095208757365726E616D6512140A05706C6174651802200128095205706C61746512390A0A73746172745F6461746518032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518042001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E6444617465226B0A0E416464546F436172745265706C79122F0A0673746174757318012001280B32172E6361725F72656E74616C2E5374617475735265706C79520673746174757312280A046974656D18022001280B32142E6361725F72656E74616C2E436172744974656D52046974656D222C0A0E4765744361727452657175657374121A0A08757365726E616D651801200128095208757365726E616D652294010A0C476574436172745265706C79122A0A056974656D7318012003280B32142E6361725F72656E74616C2E436172744974656D52056974656D7312270A0F657374696D617465645F746F74616C180220012801520E657374696D61746564546F74616C122F0A0673746174757318032001280B32172E6361725F72656E74616C2E5374617475735265706C79520673746174757322490A1552656D6F766546726F6D4361727452657175657374121A0A08757365726E616D651801200128095208757365726E616D6512140A05706C6174651802200128095205706C61746522720A1352656D6F766546726F6D436172745265706C79122F0A0673746174757318012001280B32172E6361725F72656E74616C2E5374617475735265706C795206737461747573122A0A056974656D7318022003280B32142E6361725F72656E74616C2E436172744974656D52056974656D73222E0A10436C6561724361727452657175657374121A0A08757365726E616D651801200128095208757365726E616D6522410A0E436C656172436172745265706C79122F0A0673746174757318012001280B32172E6361725F72656E74616C2E5374617475735265706C79520673746174757322350A17506C6163655265736572766174696F6E52657175657374121A0A08757365726E616D651801200128095208757365726E616D652285010A15506C6163655265736572766174696F6E5265706C79123B0A0C7265736572766174696F6E7318012003280B32172E6361725F72656E74616C2E5265736572766174696F6E520C7265736572766174696F6E73122F0A0673746174757318022001280B32172E6361725F72656E74616C2E5374617475735265706C7952067374617475732291010A174C6973745265736572766174696F6E7352657175657374121A0A08757365726E616D651801200128095208757365726E616D65122E0A0466726F6D18022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520466726F6D122A0A02746F18032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705202746F22520A154C6973745265736572766174696F6E735265706C7912390A0B7265736572766174696F6E18012001280B32172E6361725F72656E74616C2E5265736572766174696F6E520B7265736572766174696F6E2A3F0A04526F6C6512140A10524F4C455F554E535045434946494544100012110A0D524F4C455F435553544F4D45521001120E0A0A524F4C455F41444D494E10022A430A0943617253746174757312160A125354415455535F554E5350454349464945441000120D0A09415641494C41424C451001120F0A0B554E415641494C41424C4510023299070A0943617252656E74616C123C0A0641646443617212192E6361725F72656E74616C2E416464436172526571756573741A172E6361725F72656E74616C2E4164644361725265706C79124C0A0B4372656174655573657273121D2E6361725F72656E74616C2E43726561746555736572526571756573741A1C2E6361725F72656E74616C2E43726561746555736572735265706C79280112450A09557064617465436172121C2E6361725F72656E74616C2E557064617465436172526571756573741A1A2E6361725F72656E74616C2E5570646174654361725265706C7912450A0952656D6F7665436172121C2E6361725F72656E74616C2E52656D6F7665436172526571756573741A1A2E6361725F72656E74616C2E52656D6F76654361725265706C79124C0A114C697374417661696C61626C654361727312242E6361725F72656E74616C2E4C697374417661696C61626C6543617273526571756573741A0F2E6361725F72656E74616C2E436172300112450A09536561726368436172121C2E6361725F72656E74616C2E536561726368436172526571756573741A1A2E6361725F72656E74616C2E5365617263684361725265706C7912450A09416464546F43617274121C2E6361725F72656E74616C2E416464546F43617274526571756573741A1A2E6361725F72656E74616C2E416464546F436172745265706C79123F0A0747657443617274121A2E6361725F72656E74616C2E47657443617274526571756573741A182E6361725F72656E74616C2E476574436172745265706C7912540A0E52656D6F766546726F6D4361727412212E6361725F72656E74616C2E52656D6F766546726F6D43617274526571756573741A1F2E6361725F72656E74616C2E52656D6F766546726F6D436172745265706C7912450A09436C65617243617274121C2E6361725F72656E74616C2E436C65617243617274526571756573741A1A2E6361725F72656E74616C2E436C656172436172745265706C79125A0A10506C6163655265736572766174696F6E12232E6361725F72656E74616C2E506C6163655265736572766174696F6E526571756573741A212E6361725F72656E74616C2E506C6163655265736572766174696F6E5265706C79125C0A104C6973745265736572766174696F6E7312232E6361725F72656E74616C2E4C6973745265736572766174696F6E73526571756573741A212E6361725F72656E74616C2E4C6973745265736572766174696F6E735265706C793001420E5A0C6361725F72656E74616C7062620670726F746F33";

public isolated client class CarRentalClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CAR_RENTAL_DESC);
    }

    isolated remote function AddCar(AddCarRequest|ContextAddCarRequest req) returns AddCarReply|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddCarReply>result;
    }

    isolated remote function AddCarContext(AddCarRequest|ContextAddCarRequest req) returns ContextAddCarReply|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddCarReply>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(UpdateCarRequest|ContextUpdateCarRequest req) returns UpdateCarReply|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateCarReply>result;
    }

    isolated remote function UpdateCarContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextUpdateCarReply|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateCarReply>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(RemoveCarRequest|ContextRemoveCarRequest req) returns RemoveCarReply|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveCarReply>result;
    }

    isolated remote function RemoveCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextRemoveCarReply|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveCarReply>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchCarRequest|ContextSearchCarRequest req) returns SearchCarReply|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchCarReply>result;
    }

    isolated remote function SearchCarContext(SearchCarRequest|ContextSearchCarRequest req) returns ContextSearchCarReply|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchCarReply>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartReply|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartReply>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartReply|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartReply>result, headers: respHeaders};
    }

    isolated remote function GetCart(GetCartRequest|ContextGetCartRequest req) returns GetCartReply|grpc:Error {
        map<string|string[]> headers = {};
        GetCartRequest message;
        if req is ContextGetCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/GetCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <GetCartReply>result;
    }

    isolated remote function GetCartContext(GetCartRequest|ContextGetCartRequest req) returns ContextGetCartReply|grpc:Error {
        map<string|string[]> headers = {};
        GetCartRequest message;
        if req is ContextGetCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/GetCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <GetCartReply>result, headers: respHeaders};
    }

    isolated remote function RemoveFromCart(RemoveFromCartRequest|ContextRemoveFromCartRequest req) returns RemoveFromCartReply|grpc:Error {
        map<string|string[]> headers = {};
        RemoveFromCartRequest message;
        if req is ContextRemoveFromCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/RemoveFromCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveFromCartReply>result;
    }

    isolated remote function RemoveFromCartContext(RemoveFromCartRequest|ContextRemoveFromCartRequest req) returns ContextRemoveFromCartReply|grpc:Error {
        map<string|string[]> headers = {};
        RemoveFromCartRequest message;
        if req is ContextRemoveFromCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/RemoveFromCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveFromCartReply>result, headers: respHeaders};
    }

    isolated remote function ClearCart(ClearCartRequest|ContextClearCartRequest req) returns ClearCartReply|grpc:Error {
        map<string|string[]> headers = {};
        ClearCartRequest message;
        if req is ContextClearCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/ClearCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <ClearCartReply>result;
    }

    isolated remote function ClearCartContext(ClearCartRequest|ContextClearCartRequest req) returns ContextClearCartReply|grpc:Error {
        map<string|string[]> headers = {};
        ClearCartRequest message;
        if req is ContextClearCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/ClearCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <ClearCartReply>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns PlaceReservationReply|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceReservationReply>result;
    }

    isolated remote function PlaceReservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextPlaceReservationReply|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("car_rental.CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceReservationReply>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("car_rental.CarRental/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }

    isolated remote function ListAvailableCars(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns stream<Car, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRental/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        CarStream outputStream = new CarStream(result);
        return new stream<Car, grpc:Error?>(outputStream);
    }

    isolated remote function ListAvailableCarsContext(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns ContextCarStream|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRental/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        CarStream outputStream = new CarStream(result);
        return {content: new stream<Car, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function ListReservations(ListReservationsRequest|ContextListReservationsRequest req) returns stream<ListReservationsReply, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListReservationsRequest message;
        if req is ContextListReservationsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRental/ListReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ListReservationsReplyStream outputStream = new ListReservationsReplyStream(result);
        return new stream<ListReservationsReply, grpc:Error?>(outputStream);
    }

    isolated remote function ListReservationsContext(ListReservationsRequest|ContextListReservationsRequest req) returns ContextListReservationsReplyStream|grpc:Error {
        map<string|string[]> headers = {};
        ListReservationsRequest message;
        if req is ContextListReservationsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("car_rental.CarRental/ListReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ListReservationsReplyStream outputStream = new ListReservationsReplyStream(result);
        return {content: new stream<ListReservationsReply, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendCreateUserRequest(CreateUserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextCreateUserRequest(ContextCreateUserRequest message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersReply() returns CreateUsersReply|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersReply>payload;
        }
    }

    isolated remote function receiveContextCreateUsersReply() returns ContextCreateUsersReply|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersReply>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class CarStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Car value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Car value;|} nextRecord = {value: <Car>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class ListReservationsReplyStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|ListReservationsReply value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|ListReservationsReply value;|} nextRecord = {value: <ListReservationsReply>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public isolated client class CarRentalCarCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCar(Car response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCar(ContextCar response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalGetCartReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendGetCartReply(GetCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextGetCartReply(ContextGetCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalListReservationsReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendListReservationsReply(ListReservationsReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextListReservationsReply(ContextListReservationsReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalUpdateCarReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendUpdateCarReply(UpdateCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextUpdateCarReply(ContextUpdateCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalSearchCarReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendSearchCarReply(SearchCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextSearchCarReply(ContextSearchCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalPlaceReservationReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendPlaceReservationReply(PlaceReservationReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextPlaceReservationReply(ContextPlaceReservationReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalCreateUsersReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendCreateUsersReply(CreateUsersReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextCreateUsersReply(ContextCreateUsersReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalRemoveCarReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRemoveCarReply(RemoveCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRemoveCarReply(ContextRemoveCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalAddCarReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddCarReply(AddCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddCarReply(ContextAddCarReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalAddToCartReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendAddToCartReply(AddToCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextAddToCartReply(ContextAddToCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalClearCartReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendClearCartReply(ClearCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextClearCartReply(ContextClearCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public isolated client class CarRentalRemoveFromCartReplyCaller {
    private final grpc:Caller caller;

    public isolated function init(grpc:Caller caller) {
        self.caller = caller;
    }

    public isolated function getId() returns int {
        return self.caller.getId();
    }

    isolated remote function sendRemoveFromCartReply(RemoveFromCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendContextRemoveFromCartReply(ContextRemoveFromCartReply response) returns grpc:Error? {
        return self.caller->send(response);
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.caller->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.caller->complete();
    }

    public isolated function isCancelled() returns boolean {
        return self.caller.isCancelled();
    }
}

public type ContextListReservationsReplyStream record {|
    stream<ListReservationsReply, error?> content;
    map<string|string[]> headers;
|};

public type ContextCarStream record {|
    stream<Car, error?> content;
    map<string|string[]> headers;
|};

public type ContextCreateUserRequestStream record {|
    stream<CreateUserRequest, error?> content;
    map<string|string[]> headers;
|};

public type ContextRemoveFromCartReply record {|
    RemoveFromCartReply content;
    map<string|string[]> headers;
|};

public type ContextListReservationsRequest record {|
    ListReservationsRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartReply record {|
    AddToCartReply content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationReply record {|
    PlaceReservationReply content;
    map<string|string[]> headers;
|};

public type ContextSearchCarReply record {|
    SearchCarReply content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveFromCartRequest record {|
    RemoveFromCartRequest content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsRequest record {|
    ListAvailableCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarRequest record {|
    SearchCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarRequest record {|
    AddCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarReply record {|
    UpdateCarReply content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersReply record {|
    CreateUsersReply content;
    map<string|string[]> headers;
|};

public type ContextGetCartRequest record {|
    GetCartRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarReply record {|
    RemoveCarReply content;
    map<string|string[]> headers;
|};

public type ContextAddCarReply record {|
    AddCarReply content;
    map<string|string[]> headers;
|};

public type ContextListReservationsReply record {|
    ListReservationsReply content;
    map<string|string[]> headers;
|};

public type ContextCar record {|
    Car content;
    map<string|string[]> headers;
|};

public type ContextClearCartRequest record {|
    ClearCartRequest content;
    map<string|string[]> headers;
|};

public type ContextClearCartReply record {|
    ClearCartReply content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextGetCartReply record {|
    GetCartReply content;
    map<string|string[]> headers;
|};

public type ContextCreateUserRequest record {|
    CreateUserRequest content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveFromCartReply record {|
    StatusReply status = {};
    CartItem[] items = [];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddToCartReply record {|
    StatusReply status = {};
    CartItem item = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type User record {|
    string username = "";
    Role role = ROLE_UNSPECIFIED;
    string email = "";
    string full_name = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchCarReply record {|
    Car[] cars = [];
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UpdateCarRequest record {|
    string plate = "";
    Car updated = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CartItem record {|
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
    float estimated_price = 0.0;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddToCartRequest record {|
    string username = "";
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListAvailableCarsRequest record {|
    string text_filter = "";
    int year = 0;
    int year_from = 0;
    int year_to = 0;
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type SearchCarRequest record {|
    string plate = "";
    string make = "";
    string model = "";
    string colour = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddCarRequest record {|
    Car car = {};
    string request_by = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type UpdateCarReply record {|
    Car car = {};
    StatusReply status = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CreateUsersReply record {|
    int created_count = 0;
    string[] failed_usernames = [];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Reservation record {|
    string reservation_id = "";
    string username = "";
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
    float total_price = 0.0;
    time:Utc created_at = [0, 0.0d];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type GetCartRequest record {|
    string username = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListReservationsReply record {|
    Reservation reservation = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ClearCartRequest record {|
    string username = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ClearCartReply record {|
    StatusReply status = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type PlaceReservationRequest record {|
    string username = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type ListReservationsRequest record {|
    string username = "";
    time:Utc 'from = [0, 0.0d];
    time:Utc to = [0, 0.0d];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type PlaceReservationReply record {|
    Reservation[] reservations = [];
    StatusReply status = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveFromCartRequest record {|
    string username = "";
    string plate = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type RemoveCarReply record {|
    StatusReply status = {};
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type AddCarReply record {|
    boolean ok = false;
    string plate = "";
    Car car = {};
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type Car record {|
    string plate = "";
    string make = "";
    string model = "";
    int year = 0;
    float daily_rate = 0.0;
    int mileage = 0;
    CarStatus status = STATUS_UNSPECIFIED;
    string colour = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type StatusReply record {|
    boolean ok = false;
    int code = 0;
    string message = "";
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type GetCartReply record {|
    CartItem[] items = [];
    float estimated_total = 0.0;
    StatusReply status = {};
|};

@protobuf:Descriptor {value: CAR_RENTAL_DESC}
public type CreateUserRequest record {|
    User user = {};
|};

public enum Role {
    ROLE_UNSPECIFIED, ROLE_CUSTOMER, ROLE_ADMIN
}

public enum CarStatus {
    STATUS_UNSPECIFIED, AVAILABLE, UNAVAILABLE
}
