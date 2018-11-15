import ballerina/mysql;
import ballerina/io;

endpoint mysql:Client mysqlDB {
    host: "localhost",
    port: 3306,
    name: "ballerinademo",
    username: "demouser",
    password: "password@123",
    dbOptions: { useSSL: false}
};

type Employee record {
    int id;
    int age;
    string name;
};

public function main(string... args) {
    //Iterating table
    var ret1 = mysqlDB->select("SELECT id, age, name from employee", Employee);
    match ret1 {
        table tableEmployee => {
            table<Employee> dt = tableEmployee;
            foreach row in dt {
                io:println(row.name);
            }
        }
        error e => {
            io:println("Error occured in iteration: " + e.message);
        }
    }

    //Convert to json
    var t1  = check mysqlDB->select("SELECT id, age, name from employee", ());
    var jsonReturned =  <json>t1;
    match jsonReturned {
        json jsonData => {
            io:print("JSON: ");
            io:println(jsonData);
        }
        error e => {
            io:println("Error occured in json conversion: " + e.message);
        }
    }

    //Convert to xml
    var t2  = check mysqlDB->select("SELECT id, age, name from employee", ());
    var xmlReturned =  <xml>t2;
    match xmlReturned {
        xml xmlData => {
            io:print("XML: ");
            io:println(xmlData);
        }
        error e => {
            io:println("Error occured in xml conversion: " + e.message);
        }
    }

}
