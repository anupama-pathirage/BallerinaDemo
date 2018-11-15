import ballerina/config;
import ballerina/mysql;
import ballerina/io;

endpoint mysql:Client mysqlDB {
    host: config:getAsString("DATABASE_HOST"),
    port: config:getAsInt("DATABASE_PORT"),
    name: config:getAsString("DATABASE_NAME"),
    username: config:getAsString("DATABASE_USER"),
    password: config:getAsString("DATABASE_PASSWORD"),
    dbOptions: { useSSL: false}
};

type Employee record {
    int id;
    int age;
    string name;
};

public function main(string... args) {
    string s1 = args[0];
        table<Employee> t1 = check mysqlDB->select("SELECT id, age, name from employee 
                    where name = ?" , Employee, s1);
        foreach row in t1 {
            io:println(row);
        }
    
}

function isValid(string s) returns boolean {
    if (s.contains("=")) {
        return false;
    } else {
        return true;
    }
}
