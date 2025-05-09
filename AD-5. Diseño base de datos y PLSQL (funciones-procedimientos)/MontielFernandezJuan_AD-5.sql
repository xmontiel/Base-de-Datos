CREATE DATABASE BIBLIOTECA;
USE BIBLIOTECA;

CREATE TABLE USUARIOS (
	CODUSU INT PRIMARY KEY AUTO_INCREMENT,
	NOMBRE VARCHAR(100) NOT NULL,
    APELLIDO VARCHAR(100) NOT NULL,
	TLF VARCHAR(15) UNIQUE,
	EMAIL VARCHAR(120),
	DISTRITO VARCHAR(20),
	OBSERVACIONES MEDIUMTEXT
);

CREATE TABLE LIBROS (
	CODLIB INT PRIMARY KEY AUTO_INCREMENT,
    TITULO VARCHAR(100) NOT NULL,
    ISBN VARCHAR(12) UNIQUE NOT NULL,
    GENERO VARCHAR(20) NOT NULL,
    PAG INTEGER NOT NULL,
	OBSERVACIONES MEDIUMTEXT
);

CREATE TABLE PRESTAMOS (
	CODPRE INT PRIMARY KEY AUTO_INCREMENT,
    CODUSU INT NOT NULL,
    CODLIB INT NOT NULL,
    FECHAPRES DATE,
    FECHADEVO DATE,
    DIASPENALIZA INTEGER,
    NIVELSANCION VARCHAR(20),
	MENSAJE MEDIUMTEXT,
    FOREIGN KEY (CODUSU) REFERENCES USUARIOS (CODUSU)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CODLIB) REFERENCES LIBROS (CODLIB)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE SANCIONADOS (
	CODUSU INT NOT NULL,
    FECHAPRES DATE,
    DIASPENALIZA INTEGER,
    MENSAJE MEDIUMTEXT NOT NULL,
    FOREIGN KEY (CODUSU) REFERENCES USUARIOS(CODUSU)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

SELECT * FROM USUARIOS;
CALL ALTA_USUARIO('Jose','García','+34678678678','jose@proton.ch','Murcia','n/a');
CALL ALTA_USUARIO('Pedro','Martínez','+34666666666','pedro@pedrito.es','Carabanchel','n/a');
CALL ALTA_USUARIO('Pamela','Anderson','+34677777777','pamela@gmail.es','Hortaleza','n/a');
CALL ALTA_USUARIO('Mario','Duplantier','+35674563477','gojira@gmail.es','Ondres','n/a');

SELECT * FROM LIBROS;
CALL ALTA_LIBRO('La historia interminable','555555','Novela Fantástica',352,'n/a');
CALL ALTA_LIBRO('Momo','666666','Novela Fantástica',125,'n/a');
CALL ALTA_LIBRO('El Silmarilion','777777','Novela Épica',220,'Muy gastado');
CALL ALTA_LIBRO('La sociedad industrial y su futuro','88888','Ensayo',100,'n/a');

SELECT * FROM PRESTAMOS;
CALL ALTA_PRESTAMO(1,2,"2025-04-15",DATE_ADD("2025-04-15", INTERVAL 7 DAY),DATEDIFF(curdate(), DATE_ADD("2025-04-15", INTERVAL 7 DAY)),"","");
CALL ALTA_PRESTAMO(2,3,"2025-04-22",DATE_ADD("2025-04-22", INTERVAL 7 DAY),DATEDIFF(curdate(), DATE_ADD("2025-04-22", INTERVAL 7 DAY)),"","");
CALL ALTA_PRESTAMO(3,1,"2025-05-03",DATE_ADD("2025-05-03", INTERVAL 7 DAY),DATEDIFF(curdate(), DATE_ADD("2025-05-03", INTERVAL 7 DAY)),"","");
CALL ALTA_PRESTAMO(4,4,"2024-05-03",DATE_ADD("2024-05-03", INTERVAL 7 DAY),DATEDIFF(curdate(), DATE_ADD("2024-05-03", INTERVAL 7 DAY)),"","");

CALL GESTOR();

SELECT * FROM SANCIONADOS;

/* PROCEDIMIENTO ALTA_LIBRO
CREATE DEFINER=`root`@`localhost` PROCEDURE `ALTA_LIBRO`(
    IN TITULO2 VARCHAR(100),
	IN ISBN2 VARCHAR(12),
	IN GENERO2 VARCHAR(20),
    IN PAG2 INTEGER,
    IN OBSERVACIONES2 MEDIUMTEXT
)
BEGIN
	INSERT INTO LIBROS (TITULO,ISBN,GENERO,PAG,OBSERVACIONES)
	VALUES (TITULO2,ISBN2,GENERO2,PAG2,OBSERVACIONES2);
END
*/

/* PROCEDIMIENTO ALTA_PRESTAMO
CREATE DEFINER=`root`@`localhost` PROCEDURE `ALTA_PRESTAMO`(
	IN CODUSU2 INTEGER,
    IN CODLIB2 INTEGER,
	IN FECHAPRES2 DATE,
	IN FECHADEVO2 DATE,
    IN DIASPENALIZA2 INTEGER,
    IN NIVELSANCION2 VARCHAR(20),
    IN MENSAJE2 MEDIUMTEXT
)
BEGIN
	INSERT INTO PRESTAMOS (CODUSU,CODLIB,FECHAPRES,FECHADEVO,DIASPENALIZA,NIVELSANCION,MENSAJE)
	VALUES (CODUSU2,CODLIB2,FECHAPRES2,FECHADEVO2,DIASPENALIZA2,NIVELSANCION2,MENSAJE2);
END
*/

/* PROCEDIMIENTO ALTA_USUARIO
CREATE DEFINER=`root`@`localhost` PROCEDURE `ALTA_USUARIO`(
	IN NOMBRE2 VARCHAR(100),
    IN APELLIDO2 VARCHAR(100),
	IN TLF2 VARCHAR(15),
	IN EMAIL2 VARCHAR(120),
	IN DISTRITO2 VARCHAR(20),
	IN OBSERVACIONES2 MEDIUMTEXT
)
BEGIN
	INSERT INTO USUARIOS (NOMBRE,APELLIDO,TLF,EMAIL,DISTRITO,OBSERVACIONES)
	VALUES (NOMBRE2,APELLIDO2,TLF2,EMAIL2,DISTRITO2,OBSERVACIONES2);
END
*/

/* PROCEDIMIENTO GESTOR
CREATE DEFINER=`root`@`localhost` PROCEDURE `GESTOR`()
BEGIN
	DECLARE CODPRE2 INT;
    DECLARE CODUSU2 INT;
    DECLARE CODLIB2 INT;
	DECLARE FECHAPRES2 DATE;
    DECLARE FECHADEVO2 DATE;
    DECLARE DIASPENALIZA2 INT;
	DECLARE NIVELSANCION2 VARCHAR(20);
	DECLARE MENSAJE2 MEDIUMTEXT;
    DECLARE NOMBRE2 VARCHAR(100);
    DECLARE APELLIDO2 VARCHAR(100);
    
	DECLARE CONTADOR INT;
    DECLARE REGISTROS INT;
    
    SET CONTADOR = 1;
    SET REGISTROS = (SELECT MAX(CODPRE) FROM PRESTAMOS);
    
    WHILE CONTADOR <= REGISTROS DO		
		
        SET MENSAJE2 = NULL;
        
		SELECT CODPRE, CODUSU, CODLIB, FECHAPRES, FECHADEVO, DIASPENALIZA
        INTO CODPRE2, CODUSU2, CODLIB2, FECHAPRES2, FECHADEVO2, DIASPENALIZA2
        FROM PRESTAMOS
        WHERE CODPRE = CONTADOR;
		
        SELECT NOMBRE, APELLIDO
        INTO NOMBRE2, APELLIDO2
        FROM USUARIOS
        WHERE CODUSU = CODUSU2;
        
        SET NIVELSANCION2 = SANCION_USUARIO(FECHAPRES2);
        
        IF NIVELSANCION2 = "GRAVE" OR NIVELSANCION2 = "MUY GRAVE" THEN
        SET MENSAJE2 = MENSAJE_SANCION(NOMBRE2,APELLIDO2,FECHAPRES2,CODPRE2,DIASPENALIZA2,NIVELSANCION2);
        INSERT INTO SANCIONADOS (CODUSU, FECHAPRES, DIASPENALIZA, MENSAJE)
        VALUES (CODUSU2, FECHAPRES2, DIASPENALIZA2, MENSAJE2);
        END IF;
        
        UPDATE PRESTAMOS SET NIVELSANCION = NIVELSANCION2, MENSAJE = MENSAJE2 WHERE CODPRE = CONTADOR;
        
        SET CODPRE2 = NULL;
		SET CONTADOR = CONTADOR + 1;
        
    END WHILE;

END
*/

/* FUNCIÓN SANCION_USUARIO
CREATE DEFINER=`root`@`localhost` FUNCTION `SANCION_USUARIO`(FECHAPRES DATE) RETURNS varchar(20) CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN
  DECLARE DIAS INT;
  SET DIAS = DATEDIFF(CURDATE(), FECHAPRES);

  IF dias <= 7 THEN
    RETURN 'ACTIVO';
  ELSEIF dias <= 12 THEN
    RETURN 'GRAVE';
  ELSE
    RETURN 'MUY GRAVE';
  END IF;
END
*/

/* FUNCIÓN MENSAJE_SANCION
CREATE DEFINER=`root`@`localhost` FUNCTION `MENSAJE_SANCION`(
	NOMBRE VARCHAR(100),
    APELLIDO VARCHAR(100),
    FECHAPRES DATE,
    CODPRE INT,
    DIASPENALIZA INT,
    NIVELSANCION VARCHAR(20)
) RETURNS mediumtext CHARSET utf8mb4 COLLATE utf8mb4_general_ci
BEGIN
	DECLARE MENSAJE MEDIUMTEXT;
    
    SET MENSAJE = CONCAT(
    'Estimado usuario ', NOMBRE, ' ', APELLIDO,
    ', el pasado día ', FECHAPRES,
    ' realizó un préstamo en nuestra biblioteca con código ', CODPRE,
    ' y ha superado la fecha de entrega prevista en ', DIASPENALIZA,
    ' días, por lo que le corresponde una sanción ', NIVELSANCION, '.'
  );
    
RETURN MENSAJE;
END
*/
