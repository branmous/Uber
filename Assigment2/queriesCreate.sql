CREATE TABLESPACE Uber Datafile 'Uber.txt' size 25M
extent MANAGEMENT LOCAL AUTOALLOCATE;

Create user MaucoAurelio IDENTIFIED by MaucoAurelio DEFAULT TABLESPACE Uber
QUOTA UNLIMITED on Uber;

GRANT DBA TO MaucoAurelio;

GRANT CONNECT TO DBA;

GRANT CREATE TABLE to DBA;

CREATE TABLE Countries
(
    Country_Id INTEGER NOT NULL,
    Description VARCHAR2(255),
    Coin varchar2(255)
);

ALTER TABLE Countries ADD CONSTRAINT Countries_pk PRIMARY KEY ( Country_Id );

CREATE TABLE States
(
    State_Id INTEGER NOT NULL,
    Description VARCHAR2(255)
);

ALTER TABLE States ADD CONSTRAINT States_pk PRIMARY KEY ( State_Id );

CREATE TABLE Language
(
    Language_Id INTEGER NOT NULL,
    Description VARCHAR2(255)
);

ALTER TABLE Language ADD CONSTRAINT Language_pk PRIMARY KEY ( Language_Id );

CREATE TABLE Roles
(
    Rol_Id INTEGER NOT NULL,
    Description VARCHAR2(255)
);

ALTER TABLE Roles ADD CONSTRAINT Roles_pk PRIMARY KEY ( Rol_Id );

CREATE TABLE Types_Service
(
    Types_Service_Id INTEGER NOT NULL,
    Description VARCHAR2(255)
);

ALTER TABLE Types_Service ADD CONSTRAINT types_service_pk PRIMARY KEY ( Types_Service_Id );


CREATE TABLE Entities_Banking
(
    Entities_Banking_Id INTEGER NOT NULL,
    Description VARCHAR2(255)
);

ALTER TABLE Entities_Banking ADD CONSTRAINT entities_banking_pk PRIMARY KEY ( Entities_Banking_Id );

CREATE TABLE Cities
(
    City_Id INTEGER NOT NULL,
    Description VARCHAR2(255),
    Code_Postal VARCHAR2(255),
    Value_Per_Kilometer NUMERIC,
    Value_Per_Minute NUMERIC,
    Base_Rate numeric,
    Country_Id INTEGER NOT NULL
);

ALTER TABLE Cities ADD CONSTRAINT Cities_pk PRIMARY KEY ( City_Id );
ALTER TABLE Cities
    ADD CONSTRAINT Cities_Countries_FK FOREIGN KEY ( Country_Id )
        REFERENCES Countries ( Country_Id );
        
        
CREATE TABLE Payment
(
    Payment_Id INTEGER NOT NULL,
    Description VARCHAR2(255),
    Type VARCHAR2(255),
    Entities_Banking_Id INTEGER NOT NULL
);

ALTER TABLE Payment ADD CONSTRAINT payment_pk PRIMARY KEY ( Payment_Id );

ALTER TABLE Payment
    ADD CONSTRAINT Payment_Entities_Banking_FK FOREIGN KEY (Entities_Banking_Id)
    REFERENCES Entities_Banking (Entities_Banking_Id);
    
    
CREATE TABLE Users
(
    User_Id INTEGER NOT NULL,
    Name VARCHAR2(255),
    Last_Name VARCHAR2(255),
    Mobile NUMBER,
    Url_Profile VARCHAR2(255),
    Send_Receipts VARCHAR2(255),
    Invite_Code VARCHAR2(255),
    City_Id INTEGER NOT NULL,
    Language_Id INTEGER NOT NULL
);

ALTER TABLE Users ADD CONSTRAINT users_pk PRIMARY KEY ( User_Id );

ALTER TABLE Users
    ADD CONSTRAINT Users_Cities_FK FOREIGN KEY (City_Id)
    REFERENCES Cities (City_Id);

ALTER TABLE Users
    ADD CONSTRAINT Users_Language_FK FOREIGN KEY (Language_Id)
    REFERENCES Language (Language_Id);
    
CREATE TABLE Emails
(
    Email_Id INTEGER NOT NULL,
    Address VARCHAR2(255),
    User_Id INTEGER NOT NULL
);

ALTER TABLE Emails ADD CONSTRAINT Email_pk PRIMARY KEY ( Email_Id );   

ALTER TABLE Emails
    ADD CONSTRAINT Email_Users_FK FOREIGN KEY (Email_Id)
    REFERENCES Users (User_Id);
    
CREATE TABLE Roles_User
(
    Rol_User_Id INTEGER NOT NULL,
    User_Id INTEGER NOT NULL,
    Rol_Id INTEGER NOT NULL
);

ALTER TABLE Roles_User ADD CONSTRAINT Roles_user_pk PRIMARY KEY ( Rol_User_Id );

ALTER TABLE Roles_User
    ADD CONSTRAINT Roles_user_Roles_fk FOREIGN KEY ( Rol_Id )
        REFERENCES Roles ( Rol_Id );

ALTER TABLE Roles_User
    ADD CONSTRAINT Roles_User_Users_FK FOREIGN KEY ( User_Id )
        REFERENCES Users ( User_Id );
        
CREATE TABLE Users_Payment
(
    User_Payment_Id INTEGER NOT NULL,
    Is_Business CHAR(1),
    Name_Business varchar2(50) NULL,
    Active CHAR(1),
    User_Id INTEGER NOT NULL,
    Payment_Id INTEGER NOT NULL
);

ALTER TABLE Users_Payment ADD CONSTRAINT users_payment_pk PRIMARY KEY ( User_Payment_Id );

ALTER TABLE Users_Payment
    ADD CONSTRAINT Users_Payment_Payment_FK FOREIGN KEY ( Payment_Id )
        REFERENCES Payment ( Payment_Id );

ALTER TABLE Users_Payment
    ADD CONSTRAINT Users_Payment_Users_FK FOREIGN KEY ( User_Id )
        REFERENCES Users ( User_Id );
        
CREATE TABLE Promotions
(
    Promotion_Id INTEGER NOT NULL,
    Code INTEGER,
    User_Id INTEGER NOT NULL,
    Discount NUMBER,
    Active CHAR(1)
);

ALTER TABLE Promotions ADD CONSTRAINT promotions_pk PRIMARY KEY ( Promotion_Id );

ALTER TABLE Promotions
    ADD CONSTRAINT Promotions_Users_FK FOREIGN KEY ( User_Id )
        REFERENCES Users ( User_Id );
        
        
CREATE TABLE Vehicules
(
    Vehicule_Id INTEGER NOT NULL,
    Plate VARCHAR2(50),
    Brand VARCHAR2(50),
    Model VARCHAR2(50),
    Year INTEGER NOT NULL,
    User_Id INTEGER NOT NULL,
    Types_Service_Id INTEGER NOT NULL
);

ALTER TABLE Vehicules ADD CONSTRAINT vehicules_pk PRIMARY KEY ( Vehicule_Id );

ALTER TABLE Vehicules
    ADD CONSTRAINT Vehicules_Users_FK FOREIGN KEY ( User_Id )
        REFERENCES Users ( User_Id );

ALTER TABLE Vehicules
    ADD CONSTRAINT Vehicules_Types_Service_FK FOREIGN KEY ( Types_Service_Id )
        REFERENCES Types_Service ( Types_Service_Id );
        
        
CREATE TABLE Trips
(
    Trip_Id INTEGER NOT NULL,
    Pickup DATE,
    Destination_Address VARCHAR2(255),
    origin_address VARCHAR2(255),
    Date_Start DATE,
    Hour_Start TIMESTAMP,
    Date_Finish DATE,
    Hour_Finish TIMESTAMP,
    Distance_Traveled VARCHAR2(255),
    Time_Travel TIMESTAMP,
    Total DECIMAL,
    ExtraCost decimal,
    State_Id INTEGER NOT NULL,
    City_Id INTEGER,
    Vehicule_Id INTEGER NOT NULL
);

ALTER TABLE Trips ADD CONSTRAINT trips_pk PRIMARY KEY ( Trip_Id );

ALTER TABLE Trips
    ADD CONSTRAINT Trips_States_FK FOREIGN KEY ( State_Id )
        REFERENCES states ( State_Id );

ALTER TABLE Trips
    ADD CONSTRAINT Trips_Vehicules_FK FOREIGN KEY ( Vehicule_Id )
        REFERENCES Vehicules ( Vehicule_Id );

ALTER TABLE Trips
    ADD CONSTRAINT Trips_Cities_FK FOREIGN KEY ( City_Id )
        REFERENCES Cities ( City_Id );


CREATE TABLE Fare_Details
(
    Fare_DetailsId INTEGER NOT NULL ,
    Description VARCHAR2(255),
    Value DECIMAL,
    Trip_Id INTEGER NOT NULL
);

ALTER TABLE Fare_Details ADD CONSTRAINT Fare_Details_pk PRIMARY KEY ( Fare_DetailsId );

ALTER TABLE Fare_Details
    ADD CONSTRAINT Fare_DetailsTrips_FK FOREIGN KEY ( Trip_Id )
        REFERENCES Trips ( Trip_Id );
        
CREATE TABLE User_Trips
(
    User_TripsId INTEGER NOT NULL,
    IsShared CHAR(1),
    User_Id INTEGER NOT NULL,
    Trip_Id INTEGER,
    User_Payment_Id INTEGER NOT NULL
);

ALTER TABLE user_trips ADD CONSTRAINT user_trips_pk PRIMARY KEY ( User_TripsId );


ALTER TABLE User_Trips
    ADD CONSTRAINT User_Trips_Users_FK FOREIGN KEY ( User_Id )
        REFERENCES Users ( User_Id );

ALTER TABLE User_Trips
    ADD CONSTRAINT User_Trips_Trips_FK FOREIGN KEY ( Trip_Id )
        REFERENCES Trips ( Trip_Id );

ALTER TABLE User_Trips
    ADD CONSTRAINT User_Trips_User_Payment_FK FOREIGN KEY ( User_Payment_Id )
        REFERENCES Users_Payment ( User_Payment_Id );        












insert into Countries (Country_id, Description, Coin) values (1, 'Colombia', 'CO');

insert into Cities (City_Id, Description, Country_Id, Code_Postal,value_per_kilometer,value_per_minute,base_rate) 
    values (1, 'Medellín', 1, '051059',764.525994,178.571429 ,2500);

insert into Language (Language_Id, Description) values (1, 'Español');

insert into Users (User_Id, Name, Last_Name, Mobile, Url_Profile, Send_Receipts, Invite_Code, City_Id, Language_Id) values (1, 'sebastian', 'palacio', '4895446153', 'http://dummyimage.com/150x224.jpg/ff4444/ffffff','All', 'MbesoPy4d4hL', 1, 1);
insert into Users (User_Id, Name, Last_Name, Mobile, Url_Profile, Send_Receipts, Invite_Code, City_Id, Language_Id) values (2, 'anderson', 'mena', '32456678', 'http://dummyimage.com/150x224.jpg/ff4444/ffffff','All', 'MbesoPy4d3hT', 1, 1);
insert into Users (User_Id, Name, Last_Name, Mobile, Url_Profile, Send_Receipts, Invite_Code, City_Id, Language_Id) values (3, 'brandon', 'Montoya', '3126104754', 'http://dummyimage.com/150x224.jpg/ff4444/ffffff','All', 'MbesoPy4d3hT', 1, 1);

insert into entities_banking (entities_banking_id,description) VALUES (1,'Bancolombia');

insert into Payment (Payment_Id, Description, Type,entities_banking_id) values (1, 'Tarjeta', 'Debito', 1);
insert into Payment (Payment_Id, Description, Type,entities_banking_id) values (2, 'Tarjeta', 'Credito', 1);
insert into Payment (Payment_Id, Description, Type,entities_banking_id) values (3, 'Androip', 'Androip', 1);
insert into Payment (Payment_Id, Description, Type,entities_banking_id) values (4, 'Tarjeta', 'Efectivo', 1);

insert into users_payment (user_payment_id,name_business,is_business,active,payment_id,user_id) values(1,'Telecop',1,1,1,1);
insert into users_payment (user_payment_id,name_business,is_business,active,payment_id,user_id) values(2,'Telecop',1,1,2,1);
insert into users_payment (user_payment_id,is_business,active,payment_id,user_id) values(3,0,1,2,2);
insert into users_payment (user_payment_id,is_business,active,payment_id,user_id) values(4,0,1,2,2);

insert into users_payment (user_payment_id,is_business,active,payment_id,user_id) values(5,0,1,3,3);
insert into users_payment (user_payment_id,is_business,active,payment_id,user_id) values(6,0,1,4,3);

insert into States (State_Id, Description) values (1, 'Pendiente');
insert into States (State_Id, Description) values (2, 'Cancelada');
insert into States (State_Id, Description) values (3, 'Aprobada');

insert into Roles (Rol_Id, Description) values (1,'Usuarios');
insert into Roles (Rol_Id, Description) values (2,'Conductores');



insert into Users (User_Id, Name, Last_Name, Mobile, Url_Profile, Send_Receipts, Invite_Code, City_Id, Language_Id) values (4, 'Neyder', 'Murillo', '456789', 'http://dummyimage.com/150x224.jpg/ff4444/ffffff','All', 'MbedsoPy4d3hT', 1, 1);

insert into Roles_User (Rol_User_Id, User_Id, Rol_Id) values (1, 1, 1);
insert into Roles_User (Rol_User_Id, User_Id, Rol_Id) values (2, 2, 1);
insert into Roles_User (Rol_User_Id, User_Id, Rol_Id) values (3, 3, 1);
insert into Roles_User (Rol_User_Id, User_Id, Rol_Id) values (4, 4, 2);

insert into types_service (types_service_id,description) values(1,'UberX');
insert into types_service (types_service_id,description) values(2,'Uber Black');

insert into Vehicules (vehicule_id, Plate, brand, Model, Year, User_Id, types_service_id) values (1, '55154-1276', 'Suzuki', 'Esteem', 2002, 4, 1);

INSERT INTO "MAUCOAURELIO"."TRIPS" (TRIP_ID, PICKUP, DESTINATION_ADDRESS, ORIGIN_ADDRESS, DATE_START, HOUR_START, DATE_FINISH, HOUR_FINISH, DISTANCE_TRAVELED, TIME_TRAVEL, TOTAL, STATE_ID, CITY_ID, VEHICULE_ID) VALUES ('1', TO_DATE('2018-11-16 13:52:00', 'YYYY-MM-DD HH24:MI:SS'), 'ITM', 'Plaza botero', TO_DATE('2018-11-16 13:52:27', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2018-11-16 13:52:35.293483300', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_DATE('2018-11-16 15:52:40', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2018-11-17 15:52:54.282909100', 'YYYY-MM-DD HH24:MI:SS.FF'), '2', TO_TIMESTAMP('2018-11-16 15:53:11.016803200', 'YYYY-MM-DD HH24:MI:SS.FF'), '40000', '1', '1', '1')


UPDATE "MAUCOAURELIO"."TRIPS" SET HOUR_FINISH = TO_TIMESTAMP('2018-11-16 15:52:54.282909000', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ROWID = 'AAAE5jAAFAAAAFjAAA' AND ORA_ROWSCN = '383184'
INSERT INTO "MAUCOAURELIO"."TRIPS" (TRIP_ID, PICKUP, DESTINATION_ADDRESS, ORIGIN_ADDRESS, DATE_START, HOUR_START, DATE_FINISH, HOUR_FINISH, DISTANCE_TRAVELED, TIME_TRAVEL, TOTAL, EXTRACOST, STATE_ID, CITY_ID, VEHICULE_ID) VALUES ('2', TO_DATE('2018-11-16 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), 'ITM Robledo', 'Plaza botero', TO_DATE('2018-11-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2018-11-17 13:52:35.293483000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_DATE('2018-11-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS'), TO_TIMESTAMP('2018-11-17 15:52:54.282909000', 'YYYY-MM-DD HH24:MI:SS.FF'), '2', TO_TIMESTAMP('2018-11-17 15:53:11.016803000', 'YYYY-MM-DD HH24:MI:SS.FF'), '50000', '1000', '1', '1', '1')

UPDATE "MAUCOAURELIO"."TRIPS" SET PICKUP = TO_DATE('2018-11-17 00:00:00', 'YYYY-MM-DD HH24:MI:SS') WHERE ROWID = 'AAAE5jAAFAAAAFjAAB' AND ORA_ROWSCN = '383215'

                    
INSERT INTO USER_TRIPS (USER_TRIPSID,ISSHARED,USER_ID,TRIP_ID,USER_PAYMENT_ID)
VALUES (1,0,1,1,1);
INSERT INTO USER_TRIPS (USER_TRIPSID,ISSHARED,USER_ID,TRIP_ID,USER_PAYMENT_ID)
VALUES (3,0,2,2,4)     