import ballerina/io;

type Employee record {
    int id;
    int age;
    string name;
};

public function main(string... args) {
    table<Employee> tableEmployee = table {
        { key id, age, name },
        [ { 1, 20, "Mary" },
          { 2, 30, "John" },
          { 3, 23, "Jim" }
        ]
    };

    //Iterate the table
    foreach row in tableEmployee {
        io:println(row);
    }

    //Query the table
    io:println("Using query syntax:");
    table<Employee> filteredTable =
                 from tableEmployee where age > 21 select *;
    foreach row in filteredTable {
        io:println(row);
    }
}
