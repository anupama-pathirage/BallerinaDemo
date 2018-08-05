import ballerina/http;
import ballerina/log;
import ballerina/runtime;

public int counter = 0;

@http:ServiceConfig { basePath: "/hotel" }
service<http:Service> mockHotel bind { port: 8060 } {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    getHotel(endpoint caller, http:Request req) {
        counter = counter + 1;
        if (counter % 3 != 0) {
            runtime:sleep(60000);
        } 
        http:Response res = new;
        string hotelName = "Hotel-Paradise-" + counter;
        res.setPayload(hotelName);
        caller->respond(res) but {
            error e => log:printError("Error sending response from mockTaxi3 service", err = e)
        };
    }
}