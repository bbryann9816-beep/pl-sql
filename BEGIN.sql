BEGIN
  DBMS_OUTPUT.PUT_LINE('Hola mundo!');
END;
/

CREATE TABLE operadores (
  id_operador NUMBER PRIMARY KEY,
  nombre      VARCHAR2(50),
  apellido    VARCHAR2(50)
);

CREATE TABLE robots (
  id_robot  NUMBER PRIMARY KEY,
  nombre    VARCHAR2(50)
);

CREATE TABLE ordenes_trabajo (
    id_orden        NUMBER PRIMARY KEY,
    id_operador     NUMBER,
    id_robot        NUMBER,
    created_at      DATE,
    CONSTRAINT      fk_operador
    FOREIGN KEY     (ID_OPERADOR)
    REFERENCES      operadores(id_operador),
    CONSTRAINT      fk_robot
    FOREIGN KEY     (id_robot)
    REFERENCES      robots(id_robot)
);

-- Operadores
INSERT INTO operadores VALUES (1, 'Juan', 'Perez');
INSERT INTO operadores VALUES (2, 'Maria', 'Lopez');
INSERT INTO operadores VALUES (3, 'Carlos', 'Garcia');

-- Robots
INSERT INTO robots VALUES (1, 'RoboX');
INSERT INTO robots VALUES (2, 'RoboY');
INSERT INTO robots VALUES (3, 'RoboZ');

-- Ordenes de trabajo
INSERT INTO ordenes_trabajo VALUES (1, 1, 1, SYSDATE);
INSERT INTO ordenes_trabajo VALUES (2, 1, 2, SYSDATE);
INSERT INTO ordenes_trabajo VALUES (3, 2, 1, SYSDATE);
INSERT INTO ordenes_trabajo VALUES (4, 3, 3, SYSDATE);
INSERT INTO ordenes_trabajo VALUES (5, 2, 2, SYSDATE);

-- Guardar cambios
COMMIT;



--
INSERT INTO operadores VALUES (1, 'Juan', 'Perez');
INSERT INTO operadores VALUES (2, 'Maria', 'Lopez');
INSERT INTO operadores VALUES (3, 'Carlos', 'Garcia');
COMMIT;

SELECT * FROM operadores;

INSERT INTO operadores 
VALUES (1, 'Juan', 'Perez');

SELECT * FROM operadores;

DECLARE
        v_nombre VARCHAR2(50);
BEGIN
        SELECT  nombre
        INTO    v_nombre
        FROM    operadores
        WHERE   id_operador = 1;

DBMS_OUTPUT.PUT_LINE ('Operador: ' || v_nombre);
END;
/

DECLARE
        v_nombre   VARCHAR2(50);
        v_apellido VARCHAR2(50);
BEGIN
        SELECT nombre, apellido
        INTO v_nombre, v_apellido
        FROM operadores
        WHERE id_operador = 1;

  DBMS_OUTPUT.PUT_LINE('Operador: ' 
    || v_nombre || ' ' || v_apellido);
END;
/

DECLARE
  v_nombre VARCHAR2(50);
BEGIN
  SELECT nombre
  INTO v_nombre
  FROM operadores
  WHERE id_operador = 2;

  IF v_nombre = 'Juan' THEN
    DBMS_OUTPUT.PUT_LINE('Hola Juan!');
  ELSE
    DBMS_OUTPUT.PUT_LINE('No eres Juan');
  END IF;
END;
/

SELECT * FROM operadores;

SELECT * FROM ordenes_trabajo;

SELECT * FROM robots;

DECLARE
        v_nombre VARCHAR2 (50);
BEGIN
        SELECT  nombre
        INTO    v_nombre
        FROM    operadores
        WHERE   id_operador = 3;

        IF v_nombre = 'Juan' THEN
            DBMS_OUTPUT.PUT_LINE ('Hola Juan');
        ELSE
            DBMS_OUTPUT.PUT_LINE ('No eres Juan');
        END IF;
    END;
    /             

DECLARE
        v_nombre VARCHAR2 (50);
BEGIN
        SELECT  nombre
        INTO    v_nombre
        FROM    operadores
        WHERE   id_operador = 3;

        IF v_nombre = 'Juan' THEN
            DBMS_OUTPUT.PUT_LINE ('Hola Juan');
        ELSIF
            v_nombre = 'Maria' THEN
            DBMS_OUTPUT.PUT_LINE ('Hola Maria');
        ELSE
            DBMS_OUTPUT.PUT_LINE ('No te conozco');
        END IF;
    END;
    /             


BEGIN
        FOR i IN 1..3 LOOP
         DBMS_OUTPUT.PUT_LINE ('Operador ID: ' || i);
        END LOOP;
        END;
        / 


DECLARE
        v_nombre VARCHAR2 (50);
BEGIN
        FOR i IN 1..3 LOOP
        SELECT  nombre
        INTO    v_nombre
        FROM    operadores
        WHERE   id_operador = i;

            DBMS_OUTPUT.PUT_LINE ('Operador: ' || v_nombre);
        END LOOP;
    END;
    /  

BEGIN
  FOR reg IN (SELECT nombre FROM operadores) LOOP
    DBMS_OUTPUT.PUT_LINE('Operador: ' || reg.nombre);
  END LOOP;
END;
/

DECLARE
  CURSOR c_operadores IS
    SELECT nombre FROM operadores;
  
  v_nombre VARCHAR2(50);
BEGIN
  OPEN c_operadores;
  
  LOOP
    FETCH c_operadores INTO v_nombre;
    EXIT WHEN c_operadores%NOTFOUND;
    
    DBMS_OUTPUT.PUT_LINE('Operador: ' || v_nombre);
  END LOOP;
  
  CLOSE c_operadores;
END;
/


DECLARE
  v_nombre VARCHAR2(50);
BEGIN
  SELECT nombre
  INTO v_nombre
  FROM operadores
  WHERE id_operador = 99;

  DBMS_OUTPUT.PUT_LINE('Operador: ' || v_nombre);

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('El operador no existe!');
END;
/


--procediminetos alamcenados de PL/SQL 
--en un bloque PL/SQL se guarda en la BD.
--lo puedes llamar cuantas veces quieras
--es como una funcion que ya conoces

CREATE OR REPLACE PROCEDURE
mostrar_operador (p_id IN NUMBER) AS v_nombre VARCHAR (50);
BEGIN
  SELECT nombre
  INTO v_nombre
  FROM operadores
  WHERE id_operador = p_id;

  DBMS_OUTPUT.PUT_LINE('Operador: ' || v_nombre);

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('El operador no existe!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido!');
END;
/
EXEC mostrar_operador (1);


-- Que es una funcion?
--Es igual que un prcedimineto pero retorna un valor
--funcion = ejecuta y retorna
--procedimiento = solo ejecucta


CREATE OR REPLACE FUNCTION
obtener_nombre (p_id IN NUMBER) 
 RETURN VARCHAR2 AS 
    v_nombre VARCHAR2 (50);
BEGIN
  SELECT nombre
  INTO v_nombre
  FROM operadores
  WHERE id_operador = p_id;

  RETURN v_nombre;

EXCEPTION
 WHEN NO_DATA_FOUND THEN
    RETURN 'No existe!';

END;
/

begin
    DBMS_OUTPUT.PUT_LINE(obtener_nombre(1));
END;
/    

EXEC mostrar_operador(1);

-- Que es un trigger?
--es un bloque PL/SQL que se ejecuta automaticamente
--se activa cuando haces: INSERT, UPDATE o DELETE
--NO se necesita llamarlo
--Oracle lo ejecuta solo

CREATE OR REPLACE TRIGGER tr_guardar_fecha
BEFORE INSERT ON ordenes_trabajo
FOR EACH ROW
BEGIN
    :NEW.fecha_creacion := SYSDATE;
END;
/        

--Crear un procedimiento que reciba un id_operador, muestre sus órdenes de trabajo usando un cursor, y maneje excepciones si no existe
CREATE OR REPLACE PROCEDURE
reporte_operador (p_id IN NUMBER) AS v_nombre VARCHAR (50);
BEGIN
  SELECT nombre
  INTO v_nombre
  FROM operadores
  WHERE id_operador = p_id;

  DBMS_OUTPUT.PUT_LINE('Operador: ' || v_nombre);

    FOR reg IN (SELECT  id_orden, id_robot, created_at 
                FROM    ordenes_trabajo 
                WHERE   id_operador = p_id) LOOP
    DBMS_OUTPUT.PUT_LINE('Orden: ' || reg.id_orden || 'Robot: ' || reg.id_robot || 'Fecha: ' || reg.created_at);
  END LOOP;

  EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('El operador no existe!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido!');
END; 
/
EXEC mostrar_operador (1);



CREATE OR REPLACE FUNCTION
 total_ordenes (p_id IN NUMBER)
 RETURN NUMBER AS v_total NUMBER;

 BEGIN
    SELECT  COUNT(*)
    INTO    v_total
    FROM    ordenes_trabajo
    WHERE   id_operador = p_id;
 
RETURN  v_total;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 0;
END;
/

BEGIN
      DBMS_OUTPUT.PUT_LINE('Total: ' || total_ordenes(1));
END;
/


-- Crea un TRIGGER llamado: "tr_fecha_orden" Que haga lo siguiente: 1️ Se active ANTES de un INSERT 
--2️ En la tabla ordenes_trabajo  3️ Que guarde automáticamente la fecha actual en created_at 
CREATE OR REPLACE TRIGGER
tr_fecha_orden
BEFORE INSERT ON ordenes_trabajo
FOR EACH ROW
BEGIN
    :NEW.created_at := SYSDATE;
END;
/

-- comprobar
INSERT INTO ordenes_trabajo
  (id_orden, id_operador, id_robot)
VALUES
  (10, 1, 1);

-- verificacion
SELECT * FROM ordenes_trabajo
WHERE id_orden = 3; 

DROP TRIGGER tr_guardar_fecha;


--Declara estas variables: 1️ Una para guardarun id_operador 2️ Una para guardar un nombre 3️ Una para guardaruna fecha
DECLARE
  v_id      NUMBER;       
  v_nombre  VARCHAR2(50); 
  v_fecha   DATE;         

BEGIN
  SELECT id_operador,     
         nombre,
         created_at
  INTO   v_id,            
         v_nombre,
         v_fecha
  FROM   operadores
  WHERE  id_operador = 1;

  DBMS_OUTPUT.PUT_LINE(v_nombre); 
END;
/


--Haz un bloque PL/SQL que: 1️ Declare una variable para guardar un nombre 2️ Busque el nombre del operador con id = 1, 3️ Lo imprima con DBMS_OUTPUT

DECLARE
    v_nombre VARCHAR2(50);
BEGIN
    SELECT  nombre
    INTO    v_nombre
    FROM    operadores
    WHERE   id_operador = 1;

    DBMS_OUTPUT.PUT_LINE('Operador: '|| v_nombre);
END;
/        


--Quiero que busques en la tabla OPERADORES: 1️ ¿Qué columnas necesitas? (¿id?, ¿nombre?, ¿qué más?) 
--2️ ¿Qué condición le pondrás al IF para verificar si existe o no? 3️ ¿Qué mensajes quieres mostrar en cada caso?
DECLARE
        v_nombre VARCHAR2 (50);
BEGIN
        SELECT  nombre
        INTO    v_nombre
        FROM    operadores
        WHERE   id_operador = 10;

        IF v_nombre = 'Juan' THEN
            DBMS_OUTPUT.PUT_LINE ('Hola Juan');
        ELSIF v_nombre = 'Maria' THEN
            DBMS_OUTPUT.PUT_LINE ('Hola Maria');
        ELSIF v_nombre = 'Carlos' THEN
            DBMS_OUTPUT.PUT_LINE ('Hola Carlos');         
        ELSE
            DBMS_OUTPUT.PUT_LINE ('No te conozco');
        END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('El operador no existe!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido!');

END;
/  


--Haz un cursor FOR que: 1️ Busque todos los operadores de la tabla operadores 2️ Imprima el nombre de cada uno Sin DECLARE por ahora, solo BEGIN y END 
BEGIN
    FOR reg IN (
        SELECT  nombre
        FROM    operadores
    ) LOOP
     DBMS_OUTPUT.PUT_LINE(reg.nombre);
     END LOOP;
     END;
     /

--Modifica el cursor FOR para que imprima: El nombre Y el id de cada operador Ejemplo de salida: "ID: 1 - Nombre: Juan" "ID: 2 - Nombre: Maria" 
 BEGIN
    FOR reg IN (
        SELECT  nombre,
                id_operador
        FROM    operadores
    ) LOOP
     DBMS_OUTPUT.PUT_LINE('ID: ' || reg.id_operador || ' - Nombre: ' || reg.nombre);
     END LOOP;
     END;
     /   

--Haz un FOR LOOP que:
--1️ Traiga todos los operadores
--2️ Por cada operador imprima: "Operador: Juan - ID: 1"
--3️ Pero solo los que tengan id_operador mayor a 2
 BEGIN
    FOR reg IN (
        SELECT  nombre,
                id_operador
        FROM    operadores
        WHERE   id_operador > 2
    ) LOOP
     DBMS_OUTPUT.PUT_LINE('Nombre: ' || reg.nombre || ' - ID: ' || reg.id_operador);
     END LOOP;
     END;
     /  

--Haz un FOR LOOP que:
--1️ Traiga operadores Y sus órdenes de trabajo con JOIN
--2️ Imprima: "Operador: Juan - Orden: 5"
 BEGIN
    FOR reg IN (
        SELECT  op.nombre,
                op.id_operador,
                ot.id_orden
        FROM    operadores op
        JOIN    ordenes_trabajo ot ON ot.id_operador = op.id_operador 
    ) LOOP
     DBMS_OUTPUT.PUT_LINE('Operador: ' || reg.nombre || ' - Orden: ' || reg.id_orden);
     END LOOP;
     END;
     /

--Haz un bloque PL/SQL que:
--1️ Declare una variable para guardar el nombre del operador
--2️ Busque el operador con id = 2
--3️ Si el nombre es 'Maria' imprima: "Maria es la jefa" Si no imprima: "Operador encontrado: (nombre)"
--4️ Luego haga un FOR LOOP que traiga todas las órdenes de ese operador con JOIN y imprima: "Orden: (id_orden)"
--5️ Si no existe el operador maneje el error con EXCEPTION
DECLARE
        v_nombre    VARCHAR2 (50);
BEGIN
        SELECT  op.nombre
        INTO    v_nombre        
        FROM    operadores op
        WHERE   op.id_operador = 2; 

    IF v_nombre = 'Maria' THEN
        DBMS_OUTPUT.PUT_LINE('Maria es la jefa');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Operador encontrado: ' || v_nombre);
    END IF;    

    FOR reg IN (
        SELECT  op.nombre,
                op.id_operador,
                ot.id_orden
        FROM    operadores op
        JOIN    ordenes_trabajo ot ON ot.id_operador = op.id_operador 
    ) LOOP
     DBMS_OUTPUT.PUT_LINE('Operador: ' || reg.op.nombre || ' - Orden: ' || reg.ot.id_orden);
     END LOOP;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('El operador no existe!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido!');
     END;
     /  


--Crea un procedure llamado "mostrar_operadores" que imprima todos los operadores con FOR LOOP
        CREATE OR REPLACE PROCEDURE 
        mostrar_operador
        IS
BEGIN
        FOR reg IN (
            SELECT  nombre
            FROM    operadores
        )LOOP
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || reg.nombre);
        END LOOP;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido!');
     END mostrar_operador;
     /  
EXEC mostrar_operador;

--Crea un procedure llamado: "buscar_operador" Que reciba un número: p_id NUMBER Y dentro haga SELECT INTO para buscar ese operador e imprima su nombre
        CREATE OR REPLACE PROCEDURE 
        buscar_operador (p_id IN NUMBER) IS v_nombre VARCHAR2(50);

BEGIN
        SELECT      nombre
        INTO        v_nombre
        FROM        operadores
        WHERE       id_operador = p_id;

    DBMS_OUTPUT.PUT_LINE('Operador: '|| v_nombre);
 EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Operador no existe!');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error desconocido!');   
END;
/ 

EXEC buscar_operador(1);
EXEC buscar_operador(2);
EXEC buscar_operador(3);

--Crea un PROCEDURE llamado: "reporte_operador" Que reciba:  p_id IN NUMBER Y haga TODO esto:
--1️ Busque el nombre del operador con SELECT INTO
--2️ Si el nombre es 'Maria' imprima: "Maria es la jefa!" Si no imprima: "Operador: (nombre)"
--3️ Luego con FOR LOOP traiga todas sus órdenes con JOIN e imprima: "Orden: (id_orden)" 
--4️ Con EXCEPTION maneje el NO_DATA_FOUND
CREATE OR REPLACE PROCEDURE
reporte_operador (p_id IN NUMBER) IS v_nombre VARCHAR2 (50);

BEGIN
    SELECT  nombre
    INTO    v_nombre
    FROM    operadores
    WHERE   id_operador = p_id;

    IF v_nombre = 'Maria' THEN
        DBMS_OUTPUT.PUT_LINE('Maria es la jefa');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Operador: ' || v_nombre);
    END IF; 

        FOR reg IN (
            SELECT  op.nombre,
                    ot.id_orden       
            FROM    operadores op
            JOIN    ordenes_trabajo ot ON ot.id_operador = op.id_operador
        )LOOP
        DBMS_OUTPUT.PUT_LINE('Orden: ' || reg.id_orden);
        END LOOP;

 EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Operador no existe!');

END reporte_operador;
/

EXEC reporte_operador(1);
EXEC reporte_operador(2);
EXEC reporte_operador(3);


--EL RETO: Crea un PROCEDURE llamado gestion_pedidos que reciba un ID de operador (p_id).
--Debe buscar el nombre de ese operador y guardarlo en una variable.
--Si el nombre es 'Juan', debe imprimir: "Prioridad Alta para Juan".
--Si no, debe imprimir: "Atención normal para: [nombre]".
--Luego, debe hacer un FOR LOOP con un JOIN entre operadores y ordenes_trabajo pero ¡OJO!: solo debe mostrar las órdenes que le pertenecen a ese ID que recibiste por parámetro.
--Debe tener su sección de EXCEPTION para el caso de que el operador no exista.

CREATE OR REPLACE PROCEDURE
    gestion_pedidos (p_id IN NUMBER) IS v_nombre VARCHAR2 (50);

BEGIN
    SELECT  nombre
    INTO    v_nombre
    FROM    operadores
    WHERE   id_operador = p_id;

    IF v_nombre = 'Juan' THEN
        DBMS_OUTPUT.PUT_LINE('Prioridad alta para Juan');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Atencion normal para: ' || v_nombre);
    END IF;   

    FOR reg IN (
        SELECT  op.nombre,
                ot.id_orden
        FROM    operadores op
        JOIN    ordenes_trabajo ot ON ot.id_operador = op.id_operador
        WHERE   op.id_operador = p_id        
    )LOOP 
        DBMS_OUTPUT.PUT_LINE('Orden: ' || reg.id_orden);
    END LOOP;

     EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('Operador no existe!');

END gestion_pedidos;
/

EXEC gestion_pedidos(1);
EXEC gestion_pedidos(2);
EXEC gestion_pedidos(3);


--Crea una FUNCTION llamada: "obtener_nombre_operador" Que reciba: p_id IN NUMBER Y retorne: El nombre del operador como VARCHAR2 Si no existe, retorna: 'NO EXISTE'
CREATE OR REPLACE FUNCTION
    obtener_nombre_operador (p_id IN NUMBER) 
    RETURN VARCHAR2 IS v_nombre VARCHAR2 (50);

BEGIN
    SELECT  nombre
    INTO    v_nombre
    FROM    operadores
    WHERE   id_operador = p_id;
    RETURN  v_nombre;

     EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RETURN  'No existe';

END obtener_nombre_operador;
/    

SELECT obtener_nombre_operador(1)
FROM dual;

SELECT obtener_nombre_operador(99)
FROM dual;


--Crea un PACKAGE llamado:
--"pkg_operadores"
--SPEC debe tener:
--PROCEDURE: buscar_operador
--FUNCTION: obtener_nombre
--BODY debe tener: El código de cada uno
CREATE OR REPLACE PACKAGE
  pkg_operadores
IS
  PROCEDURE buscar_operador
    (p_id IN NUMBER);

  FUNCTION obtener_nombre
    (p_id IN NUMBER)
    RETURN VARCHAR2;

END pkg_operadores;
/


CREATE OR REPLACE PACKAGE BODY
  pkg_operadores
IS
  PROCEDURE buscar_operador
    (p_id IN NUMBER)
  IS
    v_nombre VARCHAR2(50);
  BEGIN
    SELECT nombre
    INTO   v_nombre
    FROM   operadores
    WHERE  id_operador = p_id;

    DBMS_OUTPUT.PUT_LINE(
      'Operador: ' || v_nombre);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(
        'No existe!');
  END buscar_operador;

  FUNCTION obtener_nombre
    (p_id IN NUMBER)
    RETURN VARCHAR2
  IS
    v_nombre VARCHAR2(50);
  BEGIN
    SELECT nombre
    INTO   v_nombre
    FROM   operadores
    WHERE  id_operador = p_id;

    RETURN v_nombre;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'NO EXISTE';
  END obtener_nombre;

END pkg_operadores;
/

-- PROCEDURE:
EXEC pkg_operadores.buscar_operador(1);

-- FUNCTION:
SELECT pkg_operadores.obtener_nombre(1)
FROM dual;



--Crea un PACKAGE llamado: "pkg_ordenes"
--SPEC debe tener:
--→ 1 PROCEDURE:
--registrar_orden
--(p_id IN NUMBER)
--→ 1 FUNCTION:
--contar_ordenes
--(p_id IN NUMBER)
--RETURN NUMBER
--BODY debe tener:
--PROCEDURE registrar_orden:
--→ Busca el nombre del
--operador con SELECT INTO
--→ Imprime:
--"Orden registrada para: (nombre)"
--→ EXCEPTION para
--NO_DATA_FOUND

--FUNCTION contar_ordenes:
--→ Cuenta cuántas órdenes
--tiene ese operador
--con SELECT COUNT(*)
--INTO variable
--→ Retorna ese número
--→ EXCEPTION retorna 0
CREATE OR REPLACE PACKAGE
  pkg_ordenes
IS
  PROCEDURE registrar_orden
    (p_id IN NUMBER);

  FUNCTION contar_ordenes
    (p_id IN NUMBER)
    RETURN VARCHAR2;

END pkg_ordenes;
/

CREATE OR REPLACE PACKAGE BODY
  pkg_ordenes
IS
  PROCEDURE registrar_orden
    (p_id IN NUMBER)
  IS
    v_nombre VARCHAR2(50);
  BEGIN
    SELECT nombre
    INTO   v_nombre
    FROM   operadores
    WHERE  id_operador = p_id;

    DBMS_OUTPUT.PUT_LINE(
      'Operador: ' || v_nombre);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE(
        'No existe!');
  END registrar_orden;

  FUNCTION contar_ordenes
    (p_id IN NUMBER)
    RETURN VARCHAR2
  IS
    v_total NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO   v_total
    FROM   ordenes_trabajo
    WHERE  id_operador = p_id;

    RETURN v_total;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  END contar_ordenes;

END pkg_ordenes;
/

EXEC pkg_ordenes.registrar_orden();

SELECT pkg_ordenes.contar_ordenes(1)
FROM dual;


--Crea un PACKAGE llamado: "pkg_reporte" Debe tener 2 PROCEDURES y 1 FUNCTION:
--1️⃣ PROCEDURE: ver_operador Recibe p_id Busca el nombre Si es 'Maria': imprime "Jefa: Maria" Si no: imprime "Operador: (nombre)"
--Luego con FOR LOOP + JOIN imprime todas las órdenes de ESE operador EXCEPTION: no existe
--2️⃣ PROCEDURE: listar_todos Sin parámetros FOR LOOP que recorra TODOS los operadores (sin WHERE) Imprime cada nombre
--3️⃣ FUNCTION: total_ordenes Recibe p_id Retorna NUMBER con COUNT(*) de las órdenes de ese operador Si no existe: retorna 0

CREATE OR REPLACE PACKAGE
  pkg_reporte
IS
PROCEDURE ver_operador (p_id IN NUMBER);
PROCEDURE listar_todos;
FUNCTION total_ordenes (p_id IN NUMBER) RETURN NUMBER;
END pkg_reporte;
/

CREATE OR REPLACE PACKAGE BODY
pkg_reporte
IS
PROCEDURE ver_operador (p_id IN NUMBER) IS v_nombre VARCHAR2(50);

BEGIN
  SELECT    nombre
  INTO      v_nombre
  FROM      operadores
  WHERE     id_operador = p_id;


      IF v_nombre = 'Maria' THEN
        DBMS_OUTPUT.PUT_LINE('Jefe: Maria');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Operador: ' || v_nombre);
    END IF; 

  FOR reg in (
                SELECT  op.nombre,
                ot.id_orden
        FROM    operadores op
        JOIN    ordenes_trabajo ot ON ot.id_operador = op.id_operador
        WHERE   op.id_operador = p_id   
  )LOOP
        DBMS_OUTPUT.PUT_LINE('Orden: ' || reg.id_orden);
    END LOOP;

EXCEPTION
      WHEN NO_DATA_FOUND THEN DBMS_OUTPUT.PUT_LINE('No existe!');
  END ver_operador;

PROCEDURE listar_todos
IS
BEGIN
FOR reg IN(
  SELECT    nombre
  FROM      operadores) LOOP

DBMS_OUTPUT.PUT_LINE('Operador: ' || reg.nombre);

END LOOP;
  END listar_todos;

FUNCTION total_ordenes (p_id IN NUMBER) RETURN NUMBER IS v_total NUMBER;

BEGIN
    SELECT COUNT(*)
    INTO   v_total
    FROM   ordenes_trabajo
    WHERE  id_operador = p_id;

    RETURN v_total;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 0;
  END total_ordenes;    

END pkg_reporte;
/  

EXEC pkg_reporte.ver_operador(1);
EXEC pkg_reporte.listar_todos;
SELECT pkg_reporte.total_ordenes(1) FROM dual;


--Crea un bloque PL/SQL con un CURSOR EXPLÍCITO
--llamado c_ordenes que:
--→ Traiga id_orden y id_operador de ordenes_trabajo
--→ Recorra todas las filas 
--→ Imprima cada orden así: "Orden: 1 - Operador: 3" → Cierre el cursor al final
DECLARE
CURSOR c_ordenes IS 
  SELECT  id_orden, id_operador
  FROM    ordenes_trabajo;
v_id_orden         NUMBER;
v_id_operador      NUMBER;

BEGIN
    OPEN c_ordenes;

  LOOP
    FETCH   c_ordenes
    INTO    v_id_orden, v_id_operador;

    EXIT WHEN c_ordenes%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE('Orden: ' || v_id_orden || ' - Operador: ' || v_id_operador);

  END LOOP;

  CLOSE c_ordenes;

  END;
  /

--Crea un PROCEDURE llamado: "ver_ordenes_operador" Que reciba p_id NUMBER Dentro use un CURSOR
--CON PARÁMETRO que: → Traiga las órdenes de ese operador → Use FOR con cursor explícito → Imprima cada orden → Si no hay órdenes imprima "Sin órdenes"  
CREATE OR REPLACE PROCEDURE
  ver_ordenes_operador
  (p_id IN NUMBER)
IS
  CURSOR c_ordenes
    (p_id_param NUMBER) IS
    SELECT id_orden, id_operador
    FROM   ordenes_trabajo
    WHERE  id_operador = p_id_param;

  v_contador NUMBER := 0;

BEGIN
  FOR reg IN c_ordenes(p_id) LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Orden: ' || reg.id_orden ||
      ' - Operador: ' || reg.id_operador);
    v_contador := v_contador + 1;
  END LOOP;

  IF v_contador = 0 THEN
    DBMS_OUTPUT.PUT_LINE(
      'Sin ordenes!');
  END IF;

END ver_ordenes_operador;
/

-- Con operador que tiene órdenes:
EXEC ver_ordenes_operador(1);

-- Con operador sin órdenes:
EXEC ver_ordenes_operador(99);



--Crea un PROCEDURE llamado: ver_ordenes_operador_2, debe recibir: p_id IN NUMBER 
-- Debe hacer esto: 1. buscar todas las ordenes de operador recibido. 2. usar un cursor explicito con parametro. 3. usar FOR reg cursor(p_id) LOOP. 
--4 implimir: orden: 1 orden:2 ....
--si no tiene ordenes, imprimir: sin ordenes para este operador
CREATE OR REPLACE PROCEDURE
  ver_ordenes_operador_2 (p_id IN NUMBER)
 IS
 CURSOR c_ordenes (p_id_param NUMBER) IS
    SELECT  id_orden, id_operador
    FROM    ordenes_trabajo
    WHERE   id_operador = p_id_param;

v_contador NUMBER := 0;

BEGIN

  FOR reg IN c_ordenes(p_id) LOOP

    DBMS_OUTPUT.PUT_LINE(
      'Operador: '|| reg.id_operador ||
      ' - Orden: ' || reg.id_orden);

    v_contador := v_contador + 1;

  END LOOP;

  IF v_contador = 0 THEN
    DBMS_OUTPUT.PUT_LINE(
      'Sin ordenes para este operador');
  END IF;

END ver_ordenes_operador_2;
/

EXEC ver_ordenes_operador_2(1);
EXEC ver_ordenes_operador_2(4);

--Crear PROCEDURE: listar_operadores_ordenes, donde se debe visualizar el nombre del operador y su orden. usa un join en el cursor
CREATE OR REPLACE PROCEDURE
listar_operadores_ordenes (p_id IN NUMBER)
IS
CURSOR c_listar (p_id_param IN NUMBER) 
IS
SELECT  op.nombre, ot.id_orden
FROM    operadores op
JOIN    ordenes_trabajo ot ON ot.id_operador = op.id_operador
WHERE   op.id_operador = p_id_param;

v_contador NUMBER := 0;

BEGIN

  FOR reg IN c_listar(p_id) LOOP

    DBMS_OUTPUT.PUT_LINE(
      'Operador: '|| reg.nombre ||
      ' - Orden: ' || reg.id_orden);

    v_contador := v_contador + 1;

  END LOOP;

  IF v_contador = 0 THEN
    DBMS_OUTPUT.PUT_LINE(
      'Sin ordenes para este operador');
  END IF;

END listar_operadores_ordenes;
/
EXEC listar_operadores_ordenes (4);

---trigger
---consulta













    