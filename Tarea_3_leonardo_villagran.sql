/* Tarea 3: Consultas en Múltiples Tablas de DesafioLatam para el módulo: SQL (G27) */

/* Nombre: Leonardo Villagrán Chicago */

/*1.- Crea y agrega al entregable las consultas para completar el setup de acuerdo a lo
pedido. (1 Punto)*/

/* Creación de la base de datos */

create database desafio3_leonardo_villagran_512;

/* Crear la tabla usuarios*/

CREATE TABLE usuarios (
  id serial PRIMARY KEY,
  email varchar(50),
  nombre varchar(50),
  apellido varchar(50),
  rol varchar(50)
);

/* Crear la tabla posts*/

CREATE TABLE posts (
  id serial PRIMARY KEY,
  titulo varchar,
  contenido text,
  fecha_creacion timestamp DEFAULT CURRENT_TIMESTAMP,
  fecha_actualizacion timestamp DEFAULT CURRENT_TIMESTAMP,
  destacado boolean,
  usuario_id bigint
);


/* Crear la tabla comentarios*/

CREATE TABLE comentarios (
  id serial PRIMARY KEY,
  contenido text,
  fecha_creacion timestamp,
  usuario_id bigint,
  post_id bigint
);

/* Insertar usuarios*/

INSERT INTO usuarios (email, nombre, apellido, rol)
VALUES 
  ('juanperez@gmail.com', 'Juan', 'Pérez', 'usuario'),
  ('mariagarcia@gmail.com', 'María', 'García', 'usuario'),
  ('luisfernandez@gmail.com', 'Luis', 'Fernández', 'administrador'),
  ('anatorres@gmail.com', 'Ana', 'Torres', 'usuario'),
  ('carlosrodriguez@gmail.com', 'Carlos', 'Rodríguez', 'usuario');


/* Insertar postss*/

INSERT INTO posts (titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id) VALUES
('Mi primer auto', 'Compré mi primer auto y estoy muy emocionado!', '2023-04-19 21:01:37.364334', NOW(), true, 3),
('El mejor auto deportivo', 'Este auto es el mejor para los amantes de la velocidad!', '2023-04-20 21:01:37.364334', NOW(), true, 3),
('Consejos para cuidar tu auto', 'Aquí te damos algunos tips para mantener tu auto en buen estado', '2023-04-21 21:01:37.364334', NOW(), false, 4),
('Mejoras para tu auto', 'Descubre cómo puedes mejorar el rendimiento de tu auto', '2023-04-22 21:01:37.364334', NOW(), false, 5),
('Los autos del futuro', 'Estos son los autos que revolucionarán la forma en que nos movilizamos', '2023-04-23 21:01:37.364334', NOW(), false, NULL);


/* Insertar comentarios*/

INSERT INTO comentarios (contenido, fecha_creacion, usuario_id, post_id)
VALUES ('¡Excelente posts sobre autos!', '2023-04-25 21:01:37.364334', 1, 1),
('Totalmente de acuerdo, me encantó', '2023-04-26 21:01:37.364334', 2, 1),
('Qué interesante, no lo sabía', '2023-04-27 21:01:37.364334', 3, 1),
('Buen punto, gracias por compartir', '2023-04-28 21:01:37.364334', 1, 2),
('Me gustaría saber más sobre esto', '2023-04-29 21:01:37.364334', 2, 2);

/*2. Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.
nombre e email del usuario junto al título y contenido del posts. (1 Punto)*/


SELECT a.nombre, a.email, b.titulo, b.contenido  FROM usuarios as a INNER JOIN posts as b ON a.id = b.usuario_id;

/* 3. Muestra el id, título y contenido de los posts de los administradores. El
administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
(1 Punto).*/

SELECT id AS id_post, titulo, contenido FROM posts 
WHERE usuario_id IN (SELECT id FROM usuarios WHERE rol = 'administrador');

/* 4. Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id
e email del usuario junto con la cantidad de post de cada usuario. (1 Punto)
*/


SELECT a.id, a.email, COUNT(b.id) AS cantidad_posts
FROM usuarios as  a
LEFT JOIN posts b ON a.id = b.usuario_id
GROUP BY a.id, a.email;


/* 5. Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene
un único registro y muestra solo el email. (1 Punto)
*/

SELECT a.email FROM usuarios a
INNER JOIN ( SELECT usuario_id, COUNT(*) as num_posts FROM posts GROUP BY usuario_id ORDER BY num_posts DESC LIMIT 1) as b ON a.id = b.usuario_id;

/*6. Muestra la fecha del último posts de cada usuario. (1 Punto)
Hint: Utiliza la función de agregado MAX sobre la fecha de creación.
*/

SELECT a.nombre, a.apellido, a.email, TO_CHAR(max(b.fecha_creacion), 'DD-MM-YYYY') AS fecha_ultimo_post
FROM usuarios a
inner JOIN posts as b ON a.id = b.usuario_id
GROUP BY a.nombre, a.apellido, a.email
order by a.apellido;


/*7. Muestra el título y contenido del posts (artículo) con más comentarios. (1 Punto)*/

SELECT p.titulo, p.contenido, c.num_comentarios
FROM posts AS p
INNER JOIN (
    SELECT post_id, COUNT(*) as num_comentarios
    FROM comentarios
    GROUP BY post_id
    ORDER BY num_comentarios DESC
    LIMIT 1
) AS c ON p.id = c.post_id;

/* 8. Muestra en una tabla el título de cada posts, el contenido de cada posts y el contenido
de cada comentario asociado a los posts mostrados, junto con el email del usuario
que lo escribió. (1 Punto)
*/

SELECT p.titulo as post_titulo, p.contenido as post_contenido, c.contenido as comentario_contenido, u.email from posts as p
inner join comentarios as c on p.id=c.post_id
INNER JOIN usuarios AS u ON u.id=c.usuario_id;

/* 9. Muestra el contenido del último comentario de cada usuario. (1 Punto)
 */

SELECT a.nombre, a.apellido, c.contenido, TO_CHAR(c.fecha_creacion, 'DD-MM-YYYY') AS fecha_ultimo_comentario
FROM comentarios AS c
INNER JOIN ( SELECT usuario_id, MAX(fecha_creacion) AS ultima_fecha FROM comentarios GROUP BY usuario_id) AS u ON c.usuario_id = u.usuario_id 
INNER JOIN usuarios AS a ON a.id=u.usuario_id
where c.fecha_creacion = u.ultima_fecha
ORDER BY c.usuario_id;

/* 10. Muestra los emails de los usuarios que no han escrito ningún comentario. (1 Punto)
*/

SELECT a.email, COUNT(c.id) as cantidad_comentarios
FROM usuarios a LEFT JOIN comentarios c
ON a.id = c.usuario_id
GROUP BY a.email,a.id
having COUNT(c.id)=0;



