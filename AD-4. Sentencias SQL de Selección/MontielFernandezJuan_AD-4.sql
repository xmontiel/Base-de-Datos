/*
AD-4. Sentencias SQL de Selección
*/

/*
0. Importamos la base de datos a MySQL Workbench. Para ello crearemos un nuevo "Schema" al que importar mediante la pestaña "Administration"
Elegimos el archivo NBA.sql en la opción "Import from Self-Contained File" y pulsamos "New.." en la sección "Default Target Schema". Lo nombramos "NBA".
Actualizamos en la pestaña "Schemas" y ya nos aparecería la base de datos importada. La seleccionamos para trabajar sobre ella.
*/
use nba;
/*
1. Muestra todos los datos que contienen las tablas, para ello deberías ejecutar los comandos SQL (DML) necesarios
(analiza bien cada una de las tablas, para poder resolver las siguientes preguntas).
*/
select * from equipos;
select * from estadisticas;
select * from jugadores;
select * from partidos;
/*
2. Equipos que forman parte de la conferencia Oeste(West).
*/
select nombre, conferencia
from equipos
where conferencia = "west";
/*
3. Equipos cuyo nombre comienza por H y termina por S.
*/
select nombre from equipos where nombre like 'h%s';
/*
4. ¿Cuántos jugadores argentinos juegan en la NBA?.
*/
select procedencia, count(procedencia) as numero_jugadores
from jugadores
where procedencia = "argentina";
/*
5. Jugadores españoles que juegan en los equipos Lakers y Raptors.
*/
select nombre, procedencia, nombre_equipo
from jugadores
where procedencia = "spain" and nombre_equipo = "lakers"
or procedencia = "spain" and nombre_equipo = "raptors";
/*
6. Jugadores que no proceden de Florida, Utah o España.
*/
select nombre, procedencia
from jugadores
where procedencia <> "florida" and procedencia <> "utah" and procedencia <> "spain";
/*
7. Visualizar el número de jugadores españoles y franceses, con el país correspondiente.
*/
select procedencia, count(procedencia) as numero_jugadores
from jugadores
where procedencia = "spain" or procedencia = "france"
group by procedencia;
/*
8.  Muestra el jugador que más puntos a metido en la NBA.
NO TENEMOS MANERA DE OBTENER ESTA INFORMACIÓN, YA QUE NO TENEMOS UNA COLUMNA QUE NOS INDIQUE CUANTOS PUNTOS
HA METIDO CADA JUGADOR Y TAMPOCO PODEMOS CALCULARLO YA QUE NO HAY UNA COLUMNA CON LOS PARTIDOS QUE HA JUGADO CADA JUGADOR
PARA PODER MULTIPLICAR POR LA TABLA DE PUNTOS MEDIOS POR PARTIDO.
EN SU LUGAR, MIRAREMOS EL JUGADOR CON LA TEMPORADA CON MÁS PUNTOS DE MEDIA POR PARTIDO.
EN ESTA QUERY APRECIAMOS QUE APARECE SHAVIK RANDOLPH COMO EL PRIMERO CON UNA MEDIA DISPARATADA, LO CUAL NOS INDICA
QUE SUS PUNTOS POR PARTIDO EN AMBAS TEMPORADAS ESTÁN MAL INTRODUCIDAS (SEGURAMENTE FALTE EL PUNTO DECIMAL).
LA RESPUESTA MÁS PLAUSIBLE ES POR TANTO KOBE BRYANT EN LA TEMPORADA 05/06 CON 35.4 PUNTOS POR PARTIDO.
*/
select temporada, nombre, puntos_por_partido from estadisticas
inner join jugadores on estadisticas.jugador = jugadores.codigo order by puntos_por_partido desc limit 1;
select temporada, nombre, puntos_por_partido from estadisticas
inner join jugadores on estadisticas.jugador = jugadores.codigo order by puntos_por_partido desc;
/*
9. ¿Cuántos jugadores tiene cada equipo de la conferencia Este (East)?.
*/
select nombre_equipo, count(nombre_equipo) as numero_jugadores, conferencia from jugadores
inner join equipos on jugadores.nombre_equipo = equipos.nombre
where conferencia = "east" group by nombre_equipo;
/*
10. ¿Cuál es la temporada en la que Lebrón James consiguió más puntos por partido? 
*/
select temporada, nombre, puntos_por_partido from jugadores
inner join estadisticas on jugadores.codigo = estadisticas.jugador
where nombre = "lebron james" order by puntos_por_partido desc limit 1;
