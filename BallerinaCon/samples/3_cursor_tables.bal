
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
    //Cursor based table table
    var ret1 = mysqlDB->select("SELECT id, age, name from employee", Employee);
    match ret1 {
        table tableEmployee => {
            table<Employee> dt = tableEmployee;
            foreach row in dt {
                io:println(row);
            }
            io:println("2nd iteration:");
            foreach row in dt {
                io:println(row);
            }
            
        }
        error e => {
            io:println("Error occured in iteration: " + e.message);
        }
    }

}
