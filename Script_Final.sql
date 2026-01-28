create database flota_de_buses;
use flota_de_buses;

create table pasajeros(
	id_pasajero int primary key auto_increment,
    nombre varchar(200) not null,
    apellido varchar(200) not null,
    email varchar (250) unique,
    telefono varchar (50) not null
);

create table rutas(
	id_ruta int primary key auto_increment,
    origen varchar(350) not null,
    destino varchar(350) not null,
    hora_salida datetime default current_timestamp not null,
    hora_llegada datetime not null,
    check (hora_llegada > hora_salida)
);


create table conductores(
	id_conductor int primary key auto_increment,
    nombre varchar(200) not null,
    cedula varchar(20) not null unique,
    telefono varchar(20) not null
);

create table buses(
	id_bus int primary key auto_increment,
    modelo varchar (100) not null,
    placa varchar (20) not null unique,
    año int not null check(año > 2000),
    capacidad int not null check(capacidad between 1 and 80)
);

create table asignaciones(
	id_asignacion int primary key auto_increment,
    id_ruta int,
    id_bus int,
    id_conductor int,
	fecha datetime default current_timestamp,
    foreign key (id_ruta) references rutas(id_ruta) on delete restrict on update cascade,
    foreign key (id_bus) references buses(id_bus)on delete restrict on update cascade,
    foreign key (id_conductor) references conductores(id_conductor) on delete restrict on update cascade
);

create table boletos(
	id_boleto int primary key auto_increment,
    id_pasajero int,
    id_ruta int,
    id_bus int,
    asiento int check(asiento between 1 and 60) not null,
    precio decimal(5,2) check(precio between 1 and 100.00) not null,
    fecha datetime default current_timestamp,
    foreign key (id_pasajero) references pasajeros(id_pasajero) on delete restrict on update cascade,
    foreign key (id_ruta) references rutas(id_ruta) on delete restrict on update cascade,
    foreign key (id_bus) references buses(id_bus) on delete restrict on update cascade
    
);

-- DATOS VALIDOS PARA POBLAR LA BASE DE DATOS CON REGISTROS INICIALES 
INSERT INTO buses (modelo, placa, año, capacidad) VALUES
('Mercedes-Benz OF1721', 'PBA-1234', 2015, 60),
('Hino FC9J', 'PBC-5678', 2018, 45),
('Chevrolet NPR', 'PBD-9012', 2021, 50);
INSERT INTO buses (modelo, placa, año, capacidad) VALUES
('Scania K400', 'PBE-1122', 2022, 60),
('Volvo B11R', 'PBF-3344', 2023, 55),
('Yutong ZK6129H', 'PBG-5566', 2019, 42),
('Marcopolo Paradiso 1200', 'PBH-7788', 2020, 58),
('Volkswagen 17.230', 'PBI-9900', 2017, 48);
INSERT INTO conductores (nombre, cedula, telefono) VALUES
('Carlos Pérez', '1723456789', '0998765432'),
('María López', '1712345678', '0987654321'),
('José Andrade', '1756789012', '0976543210');

INSERT INTO rutas (origen, destino, hora_salida, hora_llegada) VALUES
('Quito', 'Cayambe', '2026-01-22 07:00:00', '2026-01-22 09:00:00'),
('Quito', 'Mejía (Machachi)', '2026-01-22 08:30:00', '2026-01-22 10:00:00'),
('Quito', 'Pedro Moncayo (Tabacundo)', '2026-01-22 06:00:00', '2026-01-22 08:00:00');
INSERT INTO rutas (origen, destino, hora_salida, hora_llegada) VALUES
('Quito', 'Rumiñahui (Sangolquí)', '2026-01-22 09:00:00', '2026-01-22 10:15:00'),
('Quito', 'Ibarra', '2026-01-22 10:00:00', '2026-01-22 13:00:00'),
('Quito', 'Latacunga', '2026-01-22 11:30:00', '2026-01-22 13:30:00'),
('Quito', 'Ambato', '2026-01-22 13:00:00', '2026-01-22 16:00:00'),
('Quito', 'Santo Domingo', '2026-01-22 14:00:00', '2026-01-22 17:30:00');

INSERT INTO pasajeros (nombre, apellido, email, telefono) VALUES
('Ana', 'Guamán', 'ana.guaman@example.com', '0991122334'),
('Luis', 'Chávez', 'luis.chavez@example.com', '0989988776'),
('Sofía', 'Mora', 'sofia.mora@example.com', '0977766554');

INSERT INTO boletos (id_pasajero, id_ruta, id_bus, asiento, precio, fecha) VALUES
(1, 1, 1, 12, 2.50, '2026-01-22 07:05:00'),
(2, 2, 2, 20, 1.75, '2026-01-22 08:35:00'),
(3, 3, 3, 5, 3.00, '2026-01-22 06:10:00');

INSERT INTO asignaciones (id_ruta, id_bus, id_conductor, fecha) VALUES
(1, 1, 1, '2026-01-22 06:30:00'), 
(2, 2, 2, '2026-01-22 08:00:00'), 
(3, 3, 3, '2026-01-22 05:30:00'); 

select * from conductores;
select * from pasajeros;
select * from asignaciones;
select * from boletos;
select * from buses;
select * from rutas;

-- DATOS NO VALIDOS QUE COMPRUEBAN SI LAS REGLAS DE LAS TABLAS CUMPLEN CON LA LOGICA DE NEGOCIO
-- Año menor a 2000 (violación CHECK)
INSERT INTO buses (modelo, placa, año, capacidad) VALUES
('Volvo B7R', 'PBE-3456', 1999, 55);

-- Capacidad fuera de rango (>80)
INSERT INTO buses (modelo, placa, año, capacidad) VALUES
('Scania K310', 'PBF-7890', 2017, 100);

-- Placa duplicada (violación UNIQUE)
INSERT INTO buses (modelo, placa, año, capacidad) VALUES
('Mercedes-Benz OF1721', 'PBA-1234', 2019, 60);

-- Cédula duplicada (violación UNIQUE)
INSERT INTO conductores (nombre, cedula, telefono) VALUES
('Pedro Salazar', '1723456789', '0991112223');

-- Hora de llegada anterior a la salida (inconsistencia lógica)
INSERT INTO rutas (origen, destino, hora_salida, hora_llegada) VALUES
('Quito', 'Rumiñahui (Sangolquí)', '2026-01-22 09:00:00', '2026-01-22 08:00:00');

-- Asiento fuera de rango (>60)
INSERT INTO boletos (id_pasajero, id_ruta, id_bus, asiento, precio, fecha) VALUES
(1, 1, 1, 75, 2.50, '2026-01-22 07:10:00');

-- Precio fuera de rango (<1)
INSERT INTO boletos (id_pasajero, id_ruta, id_bus, asiento, precio, fecha) VALUES
(2, 2, 2, 15, 0.50, '2026-01-22 08:40:00');


----------------------- Consultas Apartado 4--------------------
-- listar todos los buses disponibles
select * from buses;

-- pasajeros que tienen email registrado
select nombre, apellido, email
from pasajeros
where email is not null;

-- rutas que salen desde quito
select * from rutas
where origen = 'Quito';

-- buses con capacidad mayor a 50
select modelo, placa, capacidad
from buses
where capacidad > 50;

-- conductores cuyo nombre empieza con c
select * from conductores
where nombre like 'C%';

-- boletos con precio mayor a 2 dólares
select * from boletos
where precio > 2;

-- rutas con llegada después de las 09:00
select * from rutas
where hora_llegada > '2026-01-22 09:00:00';

----------- 6 joins en multiples tablas -----------------
-- boletos con datos del pasajero
select p.nombre, p.apellido, b.id_boleto, b.precio
from boletos b
join pasajeros p on b.id_pasajero = p.id_pasajero;

-- boletos con origen y destino de la ruta
select b.id_boleto, r.origen, r.destino, b.precio
from boletos b
join rutas r on b.id_ruta = r.id_ruta;

-- asignaciones con bus y conductor
select a.id_asignacion, bu.placa, c.nombre
from asignaciones a
join buses bu on a.id_bus = bu.id_bus
join conductores c on a.id_conductor = c.id_conductor;

-- boletos con bus asignado
select b.id_boleto, bu.placa, b.asiento
from boletos b
join buses bu on b.id_bus = bu.id_bus;

-- rutas con buses asignados
select r.origen, r.destino, bu.placa
from asignaciones a
join rutas r on a.id_ruta = r.id_ruta
join buses bu on a.id_bus = bu.id_bus;

-- pasajeros y rutas que han utilizado
select p.nombre, p.apellido, r.origen, r.destino
from boletos b
join pasajeros p on b.id_pasajero = p.id_pasajero
join rutas r on b.id_ruta = r.id_ruta;

-------------------- Consultas con SUM,CUNT,AVG--------------------
-- total de ingresos por semana
select week(fecha) as semana, sum(precio) as total_ingresos
from boletos
group by week(fecha);

-- cantidad de boletos vendidos por ruta
select r.origen, r.destino, count(b.id_boleto) as total_boletos
from boletos b
join rutas r on b.id_ruta = r.id_ruta
group by r.id_ruta;

-- promedio de precio de boletos por bus
select bu.placa, avg(b.precio) as precio_promedio
from boletos b
join buses bu on b.id_bus = bu.id_bus
group by bu.placa;

-------------- Funciones Cadena -------------
-- nombre completo del pasajero
select concat(nombre, ' ', apellido) as nombre_completo
from pasajeros;

-- convertir nombres de conductores a mayúsculas
select upper(nombre) as nombre_mayuscula
from conductores;

-- concatena nombre y apellido y genera una descripción legible del boleto
select 
    concat(p.nombre, ' ', p.apellido) as pasajero,
    concat(
        'boleto para la ruta ',
        r.origen,
        ' - ',
        r.destino,
        ' asiento ',
        b.asiento
    ) as descripcion_boleto
from boletos b
join pasajeros p on b.id_pasajero = p.id_pasajero
join rutas r on b.id_ruta = r.id_ruta;

----- Subconsultas -----
-- pasajeros que han comprado boletos
select *
from pasajeros
where id_pasajero in (
    select id_pasajero from boletos
);

-- buses que no tienen boletos vendidos
select *
from buses
where id_bus not in (
    select id_bus from boletos
);

-------- Vistas ----------
-- vista solo con información pública de rutas
create view vista_rutas_publicas as
select origen, destino, hora_salida, hora_llegada
from rutas;

-- vista de ingresos por ruta (sin datos personales)
create view vista_ingresos_ruta as
select r.origen, r.destino, sum(b.precio) as total_ingresos
from boletos b
join rutas r on b.id_ruta = r.id_ruta
group by r.id_ruta;

-- =======================
-- CREACION DE ROLES
-- ==========================
-- 1. Crear Roles 
CREATE ROLE 'rol_operador';
CREATE ROLE 'rol_administrador';

-- 2. Asignar privilegios a los ROLES
GRANT SELECT, INSERT ON flota_de_buses.boletos TO 'rol_operador';
GRANT SELECT ON flota_de_buses.pasajeros TO 'rol_operador';
GRANT SELECT ON flota_de_buses.rutas TO 'rol_operador';
GRANT SELECT ON flota_de_buses.buses TO 'rol_operador';

GRANT ALL PRIVILEGES ON flota_de_buses.* TO 'rol_administrador';

-- 3. Crear Usuarios con el plugin de compatibilidad (por si acaso)
CREATE USER 'operador'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Operador1234';
CREATE USER 'admin_flota'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Admin@2026';

-- 4. Unir Roles con Usuarios
GRANT 'rol_operador' TO 'operador'@'localhost';
GRANT 'rol_administrador' TO 'admin_flota'@'localhost';

-- 5. LA CLAVE: Hacer que el rol se active solo al entrar
SET DEFAULT ROLE ALL TO 'operador'@'localhost', 'admin_flota'@'localhost';

-- 6. Guardar cambios
FLUSH PRIVILEGES;


SELECT user, host FROM mysql.user;

-- =========================
-- CREAR TABLA DE AUDITORIA
-- =========================

create table auditoria (
	id_auditoria int primary key auto_increment,
    tabla varchar(100) not null,
    operacion varchar(10) not null,
    id_registro int not null,
    usuario varchar(100),
    fecha datetime default current_timestamp,
    datos_anteriores JSON,
    datos_nuevos JSON,
    descripcion text
);

show tables;

--  =================================
-- INDICES PARA MEJORAS DE RENDIMIENTO
-- ====================================

create index idx_pasajero_email on pasajeros(email);
create index idx_conductor_cedula on conductores(cedula);
create index idx_bus_placa on buses(placa);
create index idx_ruta_origen_destino on rutas( origen, destino);
create index idx_boleto_pasajero on boletos(id_pasajero);
create index idx_boleto_ruta on boletos(id_ruta);
create index idx_boleto_bus on boletos(id_bus);
create index idx_boleto_fecha on boletos(fecha);
create index idx_asignacion_ruta on asignaciones(id_ruta);
create index idx_asignacion_bus on asignaciones(id_bus);
create index idx_asignacion_conductor on asignaciones(id_conductor);
CREATE INDEX idx_boletos_ruta_bus ON boletos(id_ruta, id_bus);
CREATE INDEX idx_asignaciones_ruta_conductor ON asignaciones(id_ruta, id_conductor);
CREATE INDEX idx_asignaciones_bus_fecha ON asignaciones(id_bus, fecha);
-- ================================
-- TRIGGERS PARA AUDIOTORIA
-- ================================

-- Trigger: insert en pasajeros
delimiter //
create trigger tr_auditoria_insert_pasajeros
after insert on pasajeros
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_nuevos, descripcion)
    values (
        'pasajeros',
        'insert',
        new.id_pasajero,
        user(),
        json_object('nombre', new.nombre, 'apellido', new.apellido, 'email', new.email),
        concat('nuevo pasajero registrado: ', new.nombre, ' ', new.apellido)
    );
end //
delimiter ;

-- Trigger: update en pasajeros
delimiter //
create trigger tr_auditoria_update_pasajeros
after update on pasajeros
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_anteriores, datos_nuevos, descripcion)
    values (
        'pasajeros',
        'update',
        new.id_pasajero,
        user(),
        json_object('nombre', old.nombre, 'apellido', old.apellido, 'email', old.email),
        json_object('nombre', new.nombre, 'apellido', new.apellido, 'email', new.email),
        concat('pasajero actualizado: ', old.nombre, ' -> ', new.nombre)
    );
end //
delimiter ;

-- Trigger: delete en pasajeros
delimiter //
create trigger tr_auditoria_delete_pasajeros
after delete on pasajeros
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_anteriores, descripcion)
    values (
        'pasajeros',
        'delete',
        old.id_pasajero,
        user(),
        json_object('nombre', old.nombre, 'apellido', old.apellido, 'email', old.email),
        concat('pasajero eliminado: ', old.nombre, ' ', old.apellido)
    );
end //
delimiter ;

-- Trigger: insert en boletos
delimiter //
create trigger tr_auditoria_insert_boletos
after insert on boletos
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_nuevos, descripcion)
    values (
        'boletos',
        'insert',
        new.id_boleto,
        user(),
        json_object('id_pasajero', new.id_pasajero, 'precio', new.precio, 'asiento', new.asiento),
        concat('boleto vendido - pasajero id: ', new.id_pasajero, ' - precio: $', new.precio)
    );
end //
delimiter ;

-- Trigger: update en boletos
delimiter //
create trigger tr_auditoria_update_boletos
after update on boletos
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_anteriores, datos_nuevos, descripcion)
    values (
        'boletos',
        'update',
        new.id_boleto,
        user(),
        json_object('precio', old.precio, 'asiento', old.asiento),
        json_object('precio', new.precio, 'asiento', new.asiento),
        concat('boleto actualizado - precio: $', old.precio, ' -> $', new.precio)
    );
end //
delimiter ;

-- Trigger: delete en boletos
delimiter //
create trigger tr_auditoria_delete_boletos
after delete on boletos
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_anteriores, descripcion)
    values (
        'boletos',
        'delete',
        old.id_boleto,
        user(),
        json_object('id_pasajero', old.id_pasajero, 'precio', old.precio),
        concat('boleto eliminado - pasajero id: ', old.id_pasajero)
    );
end //
delimiter ;

-- Trigger: insert en buses
delimiter //
create trigger tr_auditoria_insert_buses
after insert on buses
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_nuevos, descripcion)
    values (
        'buses',
        'insert',
        new.id_bus,
        user(),
        json_object('placa', new.placa, 'modelo', new.modelo, 'capacidad', new.capacidad),
        concat('nuevo bus registrado: ', new.modelo, ' - placa: ', new.placa)
    );
end //
delimiter ;

-- Trigger: update en buses
delimiter //
create trigger tr_auditoria_update_buses
after update on buses
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_anteriores, datos_nuevos, descripcion)
    values (
        'buses',
        'update',
        new.id_bus,
        user(),
        json_object('placa', old.placa, 'capacidad', old.capacidad),
        json_object('placa', new.placa, 'capacidad', new.capacidad),
        concat('bus actualizado - ', old.placa, ' -> ', new.placa)
    );
end //
delimiter ;

-- Trigger: insert en asignaciones
delimiter //
create trigger tr_auditoria_insert_asignaciones
after insert on asignaciones
for each row
begin
    insert into auditoria (tabla, operacion, id_registro, usuario, datos_nuevos, descripcion)
    values (
        'asignaciones',
        'insert',
        new.id_asignacion,
        user(),
        json_object('id_ruta', new.id_ruta, 'id_bus', new.id_bus, 'id_conductor', new.id_conductor),
        concat('nueva asignación - ruta: ', new.id_ruta, ', bus: ', new.id_bus, ', conductor: ', new.id_conductor)
    );
end //
delimiter ;

-- ================================
-- VISTAS PARA AUDITORIA
-- ================================
create view vista_auditoria_completa as
select 
    a.id_auditoria,
    a.tabla,
    a.operacion,
    a.id_registro,
    a.usuario,
    a.fecha,
    a.descripcion,
    a.datos_anteriores,
    a.datos_nuevos
from auditoria a
order by a.fecha desc;

create view vista_auditoria_por_tabla as
select 
    tabla,
    operacion,
    count(*) as total_operaciones,
    max(fecha) as ultima_operacion
from auditoria
group by tabla, operacion
order by tabla, operacion;

create view vista_auditoria_usuarios as
select 
    usuario,
    tabla,
    operacion,
    count(*) as total_operaciones,
    max(fecha) as ultima_fecha
from auditoria
group by usuario, tabla, operacion
order by usuario, ultima_fecha desc;

drop view vista_auditoria_usuarios;
-- ================================
-- CONSULTAS PARA VERIFICAR AUDITORÍA
-- ================================
-- ver todos los registros de auditoría
SELECT * FROM auditoria ORDER BY fecha DESC LIMIT 10;

-- ver auditoría por tabla específica
SELECT * FROM auditoria WHERE tabla = 'boletos' ORDER BY fecha DESC;

-- ver todas las operaciones de un usuario
SELECT * FROM auditoria WHERE usuario LIKE '%admin%' ORDER BY fecha DESC;

-- Ver cambios en un registro específico
SELECT * FROM auditoria WHERE tabla = 'pasajeros' AND id_registro = 1;

-- Resumen de operaciones por tabla
SELECT * FROM vista_auditoria_por_tabla;

-- Resumen de operaciones por usuario
SELECT * FROM vista_auditoria_usuarios;

-- ==================
-- FUNCIONES 
-- ===================

-- Función 1: Calcular tarifa con descuentos por cantidad
DELIMITER //
CREATE FUNCTION fn_calcular_tarifa_con_descuento(
    id_ruta_param INT,
    cantidad_boletos INT
) RETURNS DECIMAL(5,2)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE tarifa_base DECIMAL(5,2);
    DECLARE tarifa_final DECIMAL(5,2);
    
    -- Obtener tarifa promedio de la ruta
    SELECT AVG(precio) INTO tarifa_base
    FROM boletos
    WHERE id_ruta = id_ruta_param;
    
    -- Si no hay tarifa base, usar un valor por defecto
    IF tarifa_base IS NULL THEN
        SET tarifa_base = 2.50;
    END IF;
    
    -- Aplicar descuentos por cantidad
    IF cantidad_boletos >= 10 THEN
        SET tarifa_final = tarifa_base * 0.85;  -- 15% descuento
    ELSEIF cantidad_boletos >= 5 THEN
        SET tarifa_final = tarifa_base * 0.90;  -- 10% descuento
    ELSE
        SET tarifa_final = tarifa_base;
    END IF;
    
    RETURN ROUND(tarifa_final, 2);
END //
DELIMITER ;

-- Función 2: Validar disponibilidad de asiento
DELIMITER //
CREATE FUNCTION fn_asiento_disponible(
    id_bus_param INT,
    id_ruta_param INT,
    asiento_param INT
) RETURNS BOOLEAN
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE asiento_ocupado INT;
    
    -- Contar si el asiento ya está ocupado en esa ruta
    SELECT COUNT(*) INTO asiento_ocupado
    FROM boletos
    WHERE id_bus = id_bus_param
    AND id_ruta = id_ruta_param
    AND asiento = asiento_param;
    
    -- Retornar TRUE si está disponible, FALSE si está ocupado
    RETURN asiento_ocupado = 0;
END //
DELIMITER ;

-- Función 3: Obtener ocupación de un bus en una ruta
DELIMITER //
CREATE FUNCTION fn_ocupacion_ruta_bus(
    id_bus_param INT,
    id_ruta_param INT
) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE total_ocupados INT;
    DECLARE capacidad_total INT;
    DECLARE porcentaje INT;
    
    -- Obtener total de boletos vendidos
    SELECT COUNT(*) INTO total_ocupados
    FROM boletos
    WHERE id_bus = id_bus_param
    AND id_ruta = id_ruta_param;
    
    -- Obtener capacidad del bus
    SELECT capacidad INTO capacidad_total
    FROM buses
    WHERE id_bus = id_bus_param;
    
    -- Calcular porcentaje
    IF capacidad_total > 0 THEN
        SET porcentaje = ROUND((total_ocupados / capacidad_total) * 100, 0);
    ELSE
        SET porcentaje = 0;
    END IF;
    
    RETURN porcentaje;
END //
DELIMITER ;

-- Función 4: Obtener nombre completo de pasajero
DELIMITER //
CREATE FUNCTION fn_nombre_completo_pasajero(
    id_pasajero_param INT
) RETURNS VARCHAR(401)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE nombre_completo VARCHAR(401);
    
    SELECT CONCAT(nombre, ' ', apellido) INTO nombre_completo
    FROM pasajeros
    WHERE id_pasajero = id_pasajero_param;
    
    RETURN COALESCE(nombre_completo, 'Pasajero no encontrado');
END //
DELIMITER ;

-- =============================
-- PROCEDIMIENTOS ALMACENADOS
-- ===============================

-- Procedimiento 1: Comprar boleto (validar disponibilidad)
DELIMITER //
CREATE PROCEDURE sp_comprar_boleto(
    IN p_id_pasajero INT,
    IN p_id_ruta INT,
    IN p_id_bus INT,
    IN p_asiento INT,
    IN p_precio DECIMAL(5,2),
    OUT p_resultado VARCHAR(200),
    OUT p_id_boleto INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_resultado = 'Error: No se pudo completar la compra';
        SET p_id_boleto = -1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- Validar que el pasajero existe
    IF NOT EXISTS(SELECT 1 FROM pasajeros WHERE id_pasajero = p_id_pasajero) THEN
        SET p_resultado = 'Error: Pasajero no existe';
        SET p_id_boleto = -1;
        ROLLBACK;
    ELSEIF NOT EXISTS(SELECT 1 FROM rutas WHERE id_ruta = p_id_ruta) THEN
        SET p_resultado = 'Error: Ruta no existe';
        SET p_id_boleto = -1;
        ROLLBACK;
    ELSEIF NOT EXISTS(SELECT 1 FROM buses WHERE id_bus = p_id_bus) THEN
        SET p_resultado = 'Error: Bus no existe';
        SET p_id_boleto = -1;
        ROLLBACK;
    ELSEIF NOT fn_asiento_disponible(p_id_bus, p_id_ruta, p_asiento) THEN
        SET p_resultado = CONCAT('Error: Asiento ', p_asiento, ' no disponible');
        SET p_id_boleto = -1;
        ROLLBACK;
    ELSE
        -- Insertar el boleto
        INSERT INTO boletos(id_pasajero, id_ruta, id_bus, asiento, precio, fecha)
        VALUES(p_id_pasajero, p_id_ruta, p_id_bus, p_asiento, p_precio, NOW());
        
        SET p_id_boleto = LAST_INSERT_ID();
        SET p_resultado = CONCAT('Boleto comprado exitosamente. ID: ', p_id_boleto);
        COMMIT;
    END IF;
END //
DELIMITER ;

-- Procedimiento 2: Obtener ocupación por ruta
DELIMITER //
CREATE PROCEDURE sp_ocupacion_por_ruta(
    IN p_id_ruta INT
)
BEGIN
    SELECT 
        r.origen,
        r.destino,
        r.hora_salida,
        b.modelo,
        b.placa,
        COUNT(bo.id_boleto) AS pasajeros_actuales,
        b.capacidad,
        ROUND((COUNT(bo.id_boleto) / b.capacidad) * 100, 2) AS porcentaje_ocupacion,
        (b.capacidad - COUNT(bo.id_boleto)) AS asientos_disponibles
    FROM rutas r
    LEFT JOIN asignaciones a ON r.id_ruta = a.id_ruta
    LEFT JOIN buses b ON a.id_bus = b.id_bus
    LEFT JOIN boletos bo ON b.id_bus = bo.id_bus AND r.id_ruta = bo.id_ruta
    WHERE r.id_ruta = p_id_ruta
    GROUP BY r.id_ruta, b.id_bus
    ORDER BY r.hora_salida;
END //
DELIMITER ;

-- Procedimiento 3: Reporte de ingresos por ruta y fecha
DELIMITER //
CREATE PROCEDURE sp_reporte_ingresos(
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    SELECT 
        DATE(b.fecha) AS fecha,
        r.origen,
        r.destino,
        COUNT(b.id_boleto) AS total_boletos,
        SUM(b.precio) AS total_ingresos,
        AVG(b.precio) AS precio_promedio,
        ROUND(SUM(b.precio) / COUNT(b.id_boleto), 2) AS ingreso_por_boleto
    FROM boletos b
    JOIN rutas r ON b.id_ruta = r.id_ruta
    WHERE DATE(b.fecha) BETWEEN p_fecha_inicio AND p_fecha_fin
    GROUP BY DATE(b.fecha), r.id_ruta
    ORDER BY fecha DESC, total_ingresos DESC;
END //
DELIMITER ;

-- Procedimiento 4: Registrar nuevo conductor
DELIMITER //
CREATE PROCEDURE sp_registrar_conductor(
    IN p_nombre VARCHAR(200),
    IN p_cedula VARCHAR(20),
    IN p_telefono VARCHAR(20),
    OUT p_resultado VARCHAR(200),
    OUT p_id_conductor INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_resultado = 'Error: No se pudo registrar el conductor';
        SET p_id_conductor = -1;
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- Validar que la cédula no exista
    IF EXISTS(SELECT 1 FROM conductores WHERE cedula = p_cedula) THEN
        SET p_resultado = 'Error: Cédula ya registrada';
        SET p_id_conductor = -1;
        ROLLBACK;
    ELSE
        INSERT INTO conductores(nombre, cedula, telefono)
        VALUES(p_nombre, p_cedula, p_telefono);
        
        SET p_id_conductor = LAST_INSERT_ID();
        SET p_resultado = CONCAT('Conductor registrado exitosamente. ID: ', p_id_conductor);
        COMMIT;
    END IF;
END //
DELIMITER ;

-- Procedimiento 5: Asignar conductor a ruta y bus
DELIMITER //
CREATE PROCEDURE sp_asignar_conductor_ruta(
    IN p_id_ruta INT,
    IN p_id_bus INT,
    IN p_id_conductor INT,
    OUT p_resultado VARCHAR(200)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_resultado = 'Error: No se pudo asignar el conductor';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    -- Validar existencia de registros
    IF NOT EXISTS(SELECT 1 FROM rutas WHERE id_ruta = p_id_ruta) THEN
        SET p_resultado = 'Error: Ruta no existe';
        ROLLBACK;
    ELSEIF NOT EXISTS(SELECT 1 FROM buses WHERE id_bus = p_id_bus) THEN
        SET p_resultado = 'Error: Bus no existe';
        ROLLBACK;
    ELSEIF NOT EXISTS(SELECT 1 FROM conductores WHERE id_conductor = p_id_conductor) THEN
        SET p_resultado = 'Error: Conductor no existe';
        ROLLBACK;
    ELSE
        INSERT INTO asignaciones(id_ruta, id_bus, id_conductor, fecha)
        VALUES(p_id_ruta, p_id_bus, p_id_conductor, NOW());
        
        SET p_resultado = 'Asignación realizada exitosamente';
        COMMIT;
    END IF;
END //
DELIMITER ;

-- Procedimiento 6: Cancelar boleto
DELIMITER //
CREATE PROCEDURE sp_cancelar_boleto(
    IN p_id_boleto INT,
    OUT p_resultado VARCHAR(200)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET p_resultado = 'Error: No se pudo cancelar el boleto';
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    IF NOT EXISTS(SELECT 1 FROM boletos WHERE id_boleto = p_id_boleto) THEN
        SET p_resultado = 'Error: Boleto no existe';
        ROLLBACK;
    ELSE
        DELETE FROM boletos WHERE id_boleto = p_id_boleto;
        SET p_resultado = 'Boleto cancelado exitosamente';
        COMMIT;
    END IF;
END //
DELIMITER ;

-- ==========================================================
-- EJEMPLOS DE USO DE PROCEDIMIENTOS Y FUNCIONES
-- ==========================================================

-- Ejemplo 1: Usar función para calcular tarifa con descuento
SELECT 
    id_ruta,
    origen,
    destino,
    fn_calcular_tarifa_con_descuento(id_ruta, 5) AS tarifa_con_5_boletos,
    fn_calcular_tarifa_con_descuento(id_ruta, 10) AS tarifa_con_10_boletos
FROM rutas;

-- Ejemplo 2: Usar función para validar disponibilidad
SELECT 
    id_boleto,
    asiento,
    CASE 
        WHEN fn_asiento_disponible(id_bus, id_ruta, asiento + 1) THEN 'Disponible'
        ELSE 'Ocupado'
    END AS asiento_siguiente
FROM boletos
LIMIT 3;

-- Ejemplo 3: Usar función de ocupación
SELECT 
    bu.placa,
    r.origen,
    r.destino,
    CONCAT(fn_ocupacion_ruta_bus(bu.id_bus, r.id_ruta), '%') AS ocupacion
FROM buses bu, rutas r
WHERE bu.id_bus IN (SELECT DISTINCT id_bus FROM boletos)
AND r.id_ruta IN (SELECT DISTINCT id_ruta FROM boletos)
LIMIT 5;

-- Ejemplo 4: Usar función de nombre completo
SELECT 
    fn_nombre_completo_pasajero(id_pasajero) AS pasajero,
    COUNT(*) AS total_boletos,
    SUM(precio) AS total_gastado
FROM boletos
GROUP BY id_pasajero
ORDER BY total_gastado DESC;


-- Ejemplo 6: Usar procedimiento para comprar boleto
CALL sp_comprar_boleto(1, 1, 1, 15, 2.50, @resultado, @id_boleto);
SELECT @resultado AS resultado, @id_boleto AS id_boleto;

-- Ejemplo 7: Usar procedimiento para ocupación por ruta
CALL sp_ocupacion_por_ruta(1);

-- Ejemplo 8: Usar procedimiento para reporte de ingresos
CALL sp_reporte_ingresos('2026-01-01', '2026-01-31');

-- ==============
-- USO DE EXPLAIN
-- ===============

-- explain sobre boletos por ruta
EXPLAIN
SELECT *
FROM boletos
WHERE id_ruta = 1;

-- EXPLAIN con JOIN
EXPLAIN
SELECT p.nombre, p.apellido, r.origen, r.destino
FROM boletos b
JOIN pasajeros p ON b.id_pasajero = p.id_pasajero
JOIN rutas r ON b.id_ruta = r.id_ruta
WHERE b.id_ruta = 1;

-- EXPLAIN CON GROUP BY
EXPLAIN
SELECT r.origen, r.destino, COUNT(b.id_boleto)
FROM boletos b
JOIN rutas r ON b.id_ruta = r.id_ruta
GROUP BY r.id_ruta;

-- EXPLAIN ANALIZE
EXPLAIN ANALYZE
SELECT *
FROM boletos
WHERE id_bus = 1 AND id_ruta = 1;

