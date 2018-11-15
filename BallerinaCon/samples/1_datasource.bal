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
    var ret = mysqlDB->update("CREATE TABLE employee(id INT,
                        age INT, name VARCHAR(255), PRIMARY KEY (id))");
    printStatus("Table create Status:", ret);

    ret = mysqlDB->update("CREATE TABLE salary(id INT, 
                        value DECIMAL(10,2), PRIMARY KEY (id))");
    printStatus("Table create Status:", ret);

    //Insert First record
    ret = mysqlDB->update("INSERT INTO employee(id, age, name) 
                            values(?,?,?)", 1, 25, "Anne");
    printStatus("Inserted row count to employee Table:", ret);

    ret = mysqlDB->update("INSERT INTO salary(id, value) 
                            values(?,?)", 1, 2500);
    printStatus("Inserted row count to salary Table:", ret);

    //Insert Second record
    ret = mysqlDB->update("INSERT INTO employee(id, age, name) 
                            values(?,?,?)", 2, 20, "John");
    printStatus("Inserted row count to employee Table:", ret);

    ret = mysqlDB->update("INSERT INTO salary(id, value) 
                            values(?,?)", 2, 1500);
    printStatus("Inserted row count to salary Table:", ret);
}

function printStatus(string message, int|error returned) {
    io:print(message);
    io:println(returned);
}