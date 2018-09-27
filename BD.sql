CREATE TABLE "Cities " (
    cityid           INTEGER NOT NULL,
    "Description "   VARCHAR2(255),
    codepostal       INTEGER,
    countryid        INTEGER NOT NULL
);

ALTER TABLE "Cities " ADD CONSTRAINT cities_pk PRIMARY KEY ( cityid );

CREATE TABLE countries (
    countryid     INTEGER NOT NULL,
    description   VARCHAR2(255),
    moneda        NUMBER
);

ALTER TABLE countries ADD CONSTRAINT countries_pk PRIMARY KEY ( countryid );

CREATE TABLE entities_banking (
    entitybankid   INTEGER NOT NULL,
    description    VARCHAR2(255)
);

ALTER TABLE entities_banking ADD CONSTRAINT entities_banking_pk PRIMARY KEY ( entitybankid );

CREATE TABLE rols (
    rolid            INTEGER NOT NULL,
    "Description "   VARCHAR2(255)
);

ALTER TABLE rols ADD CONSTRAINT rols_pk PRIMARY KEY ( rolid );

CREATE TABLE states (
    stateid          INTEGER NOT NULL,
    "Description "   VARCHAR2(255)
);

ALTER TABLE states ADD CONSTRAINT states_pk PRIMARY KEY ( stateid );

ALTER TABLE "Cities "
    ADD CONSTRAINT "Cities _Countries_FK" FOREIGN KEY ( countryid )
        REFERENCES countries ( countryid );