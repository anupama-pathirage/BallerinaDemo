import ballerina/http;
import ballerina/log;
import ballerina/mysql;

endpoint mysql:Client mysqlDB {
    host: "localhost",
    port: 3306,
    name: "ballerinademo",
    username: "demouser",
    password: "password@123",
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
            int count = check mysqlDB->update(
              "INSERT INTO employee (id, name, age) VALUES (?,?,?)", id, name, age);
            log:printInfo("Inserted count to employee table:" + count);
            //Update second table
            count = check mysqlDB->update("INSERT INTO salary2 (id, value)
               VALUES (?, ?)", id, salary);
            log:printInfo("Inserted count to salary table:" + count);
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

//curl http://localhost:9090/org/employees -d "{\"id\":12, \"name\": \"John\", \"age\":55, \"salary\":250.4}" -H "Content-Type: application/json"
