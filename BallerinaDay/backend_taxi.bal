import ballerina/http;
import ballerina/log;
import ballerina/io;
import ballerina/runtime;

@http:ServiceConfig { basePath: "/taxi" }
service<http:Service> mockTaxi1 bind { port: 8080 } {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    getTaxi(endpoint caller, http:Request req) {

        http:Response res = new;
        runtime:sleep(3000);
        res.setPayload("WP-CBA-8080");
        caller->respond(res) but {
            error e => log:printError("Error sending response from mockTaxi1 service", err = e)
        };
    }
}

@http:ServiceConfig { basePath: "/taxi" }
service<http:Service> mockTaxi2 bind { port: 8082 } {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    getTaxi(endpoint caller, http:Request req) {

        http:Response res = new;
        res.statusCode = 500;
        res.setPayload("Internal error occurred while processing the request.");
        caller->respond(res) but {
            error e => log:printError("Error sending response from mocmockTaxi2 service", err = e)
        };
    }
}

@http:ServiceConfig { basePath: "/taxi" }
service<http:Service> mockTaxi3 bind { port: 8084 } {
    @http:ResourceConfig {
        methods: ["GET"],
        path: "/"
    }
    getTaxi(endpoint caller, http:Request req) {

        http:Response res = new;
        res.setPayload("WP-CBA-8084");
        caller->respond(res) but {
            error e => log:printError("Error sending response from mockTaxi3 service", err = e)
        };
    }
}