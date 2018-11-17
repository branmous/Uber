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