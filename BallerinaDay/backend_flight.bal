import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/runtime;

@http:ServiceConfig { basePath: "/flight" }
service<http:Service> mockFlight1 bind { port: 8040 } {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    getFlight(endpoint caller, http:Request req) {

        http:Response res = new;
        runtime:sleep(3000);
        res.setPayload("UL 111");
        caller->respond(res) but {
            error e => log:printError("Error sending response from mockFlight1 service", err = e)
        };
    }
}

@http:ServiceConfig { basePath: "/flight" }
service<http:Service> mockFlight2 bind { port: 8042 } {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    getFlight(endpoint caller, http:Request req) {

        http:Response res = new;
        runtime:sleep(3000);
        res.setPayload("UL 222");
        caller->respond(res) but {
            error e => log:printError("Error sending response from mockFlight2 service", err = e)
        };
    }
}