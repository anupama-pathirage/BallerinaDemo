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
    
    employees(endpoint caller, http:Request req) {
        //Get the cursor table
        table t1 = check mysqlDB->select("SELECT id, age, name from employee", ());
        //Convert the data to json
        json data = check <json>t1;
        //Stream the data out
        http:Response res = new;
        res.setJsonPayload(untaint data);
        caller->respond(res) but { error e => log:printError(
                           "Error sending response", err = e) };
    }
}

//curl -v http://localhost:9090/org/employees