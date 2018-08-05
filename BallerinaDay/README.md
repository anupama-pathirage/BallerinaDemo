# Ballerina Day Demo 
This demo contains a ballerina service which use ballerina resiliency and security features.

## Pre-Requisites

1. Install Ballerina
2. Instal MySQL database 
3. Download MySQL database driver and copy it to <BALLERINA_HOME>/bre/lib folder

   Ex: In Linux
   ```
   sudo cp mysql-connector-java-5.1.38-bin.jar /usr/lib/ballerina/ballerina-0.980.0/bre/lib/
   ```
4. Run the sql script (sql-script.sql) to populate the table structure in mysql DB.

   Ex: 
   ```
   mysql -u root -p < sql-script.sql
   ```

## Running the sample

1. Run the Taxi backend services.
   ```
   ballerina run backend_taxi.ballerina
   ```

2. Run the Hotel backend services.
   ```
   ballerina run backend_hotel.ballerina
   ```

3. Run the Flight backend services.
   ```
   ballerina run backend_flight.ballerina
   ```

4. Run the travel reservation service.
   ```   
   ballerina run travel_reservation.bal
   ```
   
5. Test the service using following curl command.
   ```
   curl http://localhost:9090/travel/reservation -d "{\"name\": \"Anne\"}" -H "Content-Type: application/json"
   ```
   
