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

public function main(string... args) {
    var ret = mysqlDB->update("DROP TABLE employee");
    io:print("Status:");
    io:println(ret);

    ret = mysqlDB->update("DROP TABLE salary");

    io:print("Status:");
    io:println(ret);
}