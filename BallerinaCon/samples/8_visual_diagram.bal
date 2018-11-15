import ballerina/config;
import ballerina/http;
import ballerina/log;
import ballerina/mysql;

endpoint mysql:Client employeeDB {
    host: config:getAsString("DATABASE_HOST"),
    port: config:getAsInt("DATABASE_PORT"),
    name: config:getAsString("DATABASE_NAME"),
    username: config:getAsString("DATABASE_USER"),
    password: config:getAsString("DATABASE_PASSWORD"),
    dbOptions: { useSSL: false}
};

endpoint mysql:Client salaryDB {
    host: config:getAsString("DATABASE_HOST"),
    port: config:getAsInt("DATABASE_PORT"),
    name: config:getAsString("DATABASE_NAME"),
    username: config:getAsString("DATABASE_USER"),
    password: config:getAsString("DATABASE_PASSWORD"),
    dbOptions: { useSSL: false}
};

service<http:Service> org bind { port: 9090 } {
        @http:ResourceConfig {
        methods: ["POST"],
        path: "/employees"
    }
    employees(endpoint caller, http:Request req) {
        //Extract data from payload
        json payload = check req.getJsonPayload();
        int id = check <int> payload.id;
        string name = payload.name.toString();
        int age = check <int> payload.age;
        float salary = check <float> payload.salary;

        //Start a transaction
        transaction with retries = 2 {
            //Update first table
            int count = check employeeDB->update(
              "INSERT INTO employee (id, name, age) VALUES (?,?,?)", id, name, age);
            log:printInfo("Inserted count to employee table:" + count);
            //Update second table
            count = check salaryDB->update("INSERT INTO salary (id, value)
               VALUES (?, ?)", id, salary);
            log:printInfo("Inserted count to salaryw table:" + count);
        } onretry {
            log:printError("Transaction failed, retrying ...");
        }

        //Generate and send the response
        http:Response res = new;
        res.setPayload("Account added for: " + untaint name + "\n");
        caller->respond(res) but {
            error e => log:printError("Error in responding", err = e)
        };
    }
}
