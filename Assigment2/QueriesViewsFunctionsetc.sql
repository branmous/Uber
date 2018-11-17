
--1.Crear una vista llamada "MEDIOS_PAGO_CLIENTES" que contenga las siguientes columnas:
--CLIENTE_ID, NOMBRE_CLIENTE (Si tiene el nombre y el apellido separados en columnas, deberán estar unidas en unasola),MEDIO_PAGO_ID,
--TIPO(TDC,Android,Paypal,Efectivo),DETALLES_MEDIO_PAGO, EMPRESARIAL (FALSO o VERDADERO), NOMBRE_EMPRESA (Si lacolumna Empresarial es falso, este campo aparecerá Nulo)
CREATE OR REPLACE VIEW MEDIOS_PAGO_CLIENTES AS
SELECT USERS.USER_ID, USERS.NAME || ' ' || USERS.lAST_NAME "Name",
        USERS_PAYMENT.USER_PAYMENT_ID, PAYMENT.TYPE,USERS_PAYMENT.IS_BUSINESS,
        USERS_PAYMENT.NAME_BUSINESS
        FROM USERS INNER JOIN USERS_PAYMENT ON USERS.USER_ID = USERS_PAYMENT.USER_ID
        INNER JOIN PAYMENT ON USERS_PAYMENT.PAYMENT_ID = PAYMENT.PAYMENT_ID;


--2Cree una vista que permita listar los viajes de cada cliente ordenados cronológicamente.
 --El nombre de la vista será “VIAJES_CLIENTES”, los campos que tendrá son: FECHA_VIAJE,           
 --NOMBRE_CONDUCTOR, PLACA_VEHICULO, NOMBRE_CLIENTE, VALOR_TOTAL,    
 --TARIFA_DINAMICA (FALSO O VERDADERO), TIPO_SERVICIO (UberX o UberBlack),        
 --CIUDAD_VIAJE. ​(0.25)
CREATE OR REPLACE VIEW VIAJES_CLIENTES AS
SELECT BUSQUEDA.PICKUP,USERS.NAME || ' ' || USERS.lAST_NAME "NOMBRE CONDUCTOR",
VEHICULES.PLATE,BUSQUEDA."NOMBRE PASAJERO",BUSQUEDA.TOTAL,BUSQUEDA.EXTRACOST,
TYPES_SERVICE.DESCRIPTION
FROM 
(SELECT TRIPS.*,USERS.NAME || ' ' || USERS.lAST_NAME "NOMBRE PASAJERO"
    FROM TRIPS INNER JOIN USER_TRIPS ON TRIPS.TRIP_ID = USER_TRIPS.TRIP_ID
    INNER JOIN USERS ON USER_TRIPS.USER_ID = USERS.USER_ID) BUSQUEDA 
    INNER JOIN VEHICULES ON BUSQUEDA.VEHICULE_ID = VEHICULES.VEHICULE_ID 
    INNER JOIN TYPES_SERVICE ON VEHICULES.TYPES_SERVICE_ID = TYPES_SERVICE.TYPES_SERVICE_ID
    INNER JOIN USERS ON VEHICULES.USER_ID = USERS.USER_ID
    ORDER BY BUSQUEDA.PICKUP DESC;

-- 3
--Cree y evidencie el plan de ejecución de la vista VIAJES_CLIENTES. Cree al menos un índice donde                 
--mejore el rendimiento del query y muestre el nuevo plan de ejecución. ​(0.25) 
EXPLAIN PLAN
SET STATEMENT_ID = 'VIAJES_CLIENTES_PLAN' FOR
SELECT * FROM VIAJES_CLIENTES;

SELECT PLAN_TABLE_OUTPUT
FROM TABLE(DBMS_XPLAN.DISPLAY( NULL,'VIAJES_CLIENTES_PLAN','TYPICAL'));

--NEW PLAN
CREATE INDEX USER_NAME ON USERS(NAME,LAST_NAME);

EXPLAIN PLAN
SET STATEMENT_ID = 'VIAJES_CLIENTES_NEW_PLAN' FOR
SELECT * FROM VIAJES_CLIENTES;

SELECT PLAN_TABLE_OUTPUT
FROM TABLE(DBMS_XPLAN.DISPLAY( NULL,'VIAJES_CLIENTES_PLAN','TYPICAL'));

SELECT PLAN_TABLE_OUTPUT
FROM TABLE(DBMS_XPLAN.DISPLAY( NULL,'VIAJES_CLIENTES_NEW_PLAN','TYPICAL'));    

--5.Crear una función llamada VALOR_DISTANCIA que reciba la distancia en kilómetros y el nombre de la ciudad donde se hizo el servicio. 
--Con esta información deberá buscar el valor por cada kilómetro dependiendo de la ciudad donde esté ubicado el viaje. 
--Deberá retornar el resultado de multiplicar la distancia recorrida y el valor de cada kilómetro dependiendo de la ciudad. 
--Si la distancia es menor a 0 kilómetros o la ciudad no es válida deberá levantar una excepción propia. Ejemplo: Viaje_ID: 342 
--que fue hecho en Medellín y la distancia fue 20.68km. En este caso deberá retornar 20.68 * 764.525994 =15810.3976.
CREATE OR REPLACE FUNCTION VALOR_DISTANCIA(KILOMETERS IN NUMBER,CITY IN VARCHAR2)
    RETURN NUMBER
    AS
    
    TOTAL NUMBER :=0;
    VALUE_PER_KILOMETER NUMBER :=0;
    VALUE_INVALID EXCEPTION;
    BEGIN
        IF KILOMETERS >= 0 THEN 
            SELECT CITIES.VALUE_PER_KILOMETER 
            INTO VALUE_PER_KILOMETER
            FROM CITIES 
            WHERE  CITIES.DESCRIPTION = CITY;
            TOTAL := VALUE_PER_KILOMETER * KILOMETERS;
        ELSE
            RAISE VALUE_INVALID;
        END IF;
      RETURN TOTAL;
    EXCEPTION
      WHEN VALUE_INVALID THEN 
        DBMS_OUTPUT.PUT_LINE('La distancia debe ser mayor o igual 0 ');
        RETURN NULL;
      WHEN NO_DATA_FOUND THEN 
        DBMS_OUTPUT.PUT_LINE('La ciudad ' || CITY || ' no existe en los registros de la base de datos');
        RETURN NULL;
END VALOR_DISTANCIA; 

-- 6. Crear una función llamada VALOR_TIEMPO que reciba la cantidad de minutos del servicio y el
--nombre de la ciudad donde se hizo el servicio. Con esta información deberá buscar el valor por cada
--minuto dependiendo de la ciudad donde esté ubicado el viaje. Deberá retornar el resultado de
--multiplicar la distancia recorrida y el valor de cada minuto dependiendo de la ciudad. Si la cantidad de
--minutos es menor a 0 o la ciudad no es válida deberá levantar una excepción propia. Ejemplo:
--Viaje_ID: 342 que fue hecho en Medellín y el tiempo fue 28 minutos. En este caso deberá retornar 28* 178.571429 = 5000.00001
CREATE OR REPLACE FUNCTION VALOR_TIEMPO(QUANTITY_MINUTES IN NUMBER,CITY IN VARCHAR2)
    RETURN NUMBER
    AS 
    
    TOTAL NUMBER :=0;
    VALUE_PER_MINUTE NUMBER :=0;
    VALUE_INVALID EXCEPTION;
    
    BEGIN
    IF QUANTITY_MINUTES >= 0 THEN  
        SELECT CITIES.VALUE_PER_MINUTE 
        INTO VALUE_PER_MINUTE 
        FROM CITIES 
        WHERE  CITIES.DESCRIPTION = CITY;
        TOTAL := VALUE_PER_MINUTE * QUANTITY_MINUTES;
    ELSE
        RAISE VALUE_INVALID;
    END IF;
      RETURN TOTAL;
    EXCEPTION
        WHEN VALUE_INVALID THEN 
            DBMS_OUTPUT.PUT_LINE('Debe ingresar una cantidad de minutos mayor o igual 0 ');
            RETURN NULL;
        WHEN NO_DATA_FOUND THEN 
            DBMS_OUTPUT.PUT_LINE('La ciudad ' || CITY || ' no existe en los registros de la base de datos');
            RETURN NULL;
END VALOR_TIEMPO; 