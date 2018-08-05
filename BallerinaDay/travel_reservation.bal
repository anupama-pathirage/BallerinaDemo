import ballerina/http;
import ballerina/log;
import ballerina/mysql;
import ballerina/config;

//Create http client endpoint with retry for hotel service
endpoint http:Client hotelEP {
    url: "http://localhost:8060/hotel",
    retryConfig: {
        interval: 3000,
        backOffFactor: 2,
        count: 5
    },
    timeoutMillis: 2000   
};

//Create http client endpoint with failover for taxi service
endpoint http:FailoverClient taxiEP {
    timeoutMillis: 2000,
    failoverCodes: [500, 501, 502, 503],
    targets: [
        { url: "http://localhost:8080/taxi" },
        { url: "http://localhost:8082/taxi" },
        { url: "http://localhost:8084/taxi" }
    ]
};

//Create http client endpoint with load balancing for flight service
endpoint http:LoadBalanceClient flightEP {
    targets: [
        { url : "http://localhost:8040/flight" },
        { url : "http://localhost:8042/flight" }
    ],
    algorithm: http:ROUND_ROBIN,
    timeoutMillis: 5000
};

//Create mysql client endpoint with config for travel db.
endpoint mysql:Client travelDB {
    host: config:getAsString("traveldb.host"),
    port: config:getAsInt("traveldb.port"),
    name: config:getAsString("traveldb.name"),
    username: config:getAsString("traveldb.user"),
    password: config:getAsString("traveldb.pass"),
    dbOptions: { useSSL: false }
};

//Travel reservation service
@http:ServiceConfig {
    basePath: "/travel"
}
service<http:Service> travelService bind { port: 9090 } {
    @http:ResourceConfig {
        methods: ["POST"],
        path: "/reservation"
    }
    reserve(endpoint caller, http:Request req) {
        //Call the backends and extract responses       
        var response = taxiEP->get("/");
        string taxi = extractBackendResponse(response);

        response = hotelEP->get("/");
        string hotel = extractBackendResponse(response);

        response = flightEP->get("/");
        string flight1 = extractBackendResponse(response);

        response = flightEP->get("/");
        string flight2 = extractBackendResponse(response);

        //Write the reservation data to the database tables
        int key = -1;
        transaction with retries = 2 {
            //Update first table and get the generated key
            (int, string[]) retWithKey = check travelDB->updateWithGeneratedKeys("INSERT INTO
                                Accommodation (hotel, taxi) VALUES (?,?)", (), hotel, taxi);
            var (count, ids) = retWithKey;
            string generatedKey = ids[0];            
            key = check <int>generatedKey;
            //Update the second table with previous key
            var ret = travelDB->update("INSERT INTO Flight (id, flight1, flight2) VALUES (?, ?, ?)",
                                    key, flight1, flight2);
        } onretry {
            log:printError("Transaction failed, retrying ...");
            key = -1;
        }

        //Extract the json input from the incoming payload
        var payload = req.getJsonPayload();
        http:Response res = new;
        match payload {
            error err => {
                res.statusCode = 500;
                res.setPayload(untaint err.message);
            }
            json value => {
                if (value.name != null) {
                    string name = value.name.toString();
                    //Check whether the name contains untrusted data
                    if (check name.matches("[a-zA-Z]+")) {
                        if (key == -1) {
                            res.setPayload("Hello " + untaint name + ", Booking Failed \n");
                        } else {
                            res.setPayload("Hello " + untaint name + ", Booking Successful. Reservation id:" 
                                + key + "\n");
                        }
                    } else {
                        res.statusCode = 400;
                        res.setPayload("JSON containted tainted data");
                    }
                } else {
                    res.statusCode = 400;
                    res.setPayload("JSON containted invalid data");
                }
            }
        }
        //Send the response back
        caller ->respond(res) but {
            error e => log:printError("Error in responding", err = e)
        };
    }
}

//Utility method to extract the backend response
function extractBackendResponse (http:Response|error response) returns string {
    match response {
        http:Response resp => {
            var payload = resp.getTextPayload();
            match payload {
                string data => {
                    log:printInfo(data);
                    return data;
                }
                error e => {
                    log:printError("Error in get text content", err = e);
                }
            }
        }
        error e => {
            log:printError("Error in extracting payload", err = e);
        }
    }
    return "";
}