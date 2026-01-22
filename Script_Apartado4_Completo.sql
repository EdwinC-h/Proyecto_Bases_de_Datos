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
    hora_llegada datetime not null
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
    foreign key (id_ruta) references rutas(id_ruta),
    foreign key (id_bus) references buses(id_bus),
    foreign key (id_conductor) references conductores(id_conductor)
);

create table boletos(
	id_boleto int primary key auto_increment,
    id_pasajero int,
    id_ruta int,
    id_bus int,
    asiento int check(asiento between 1 and 60) not null,
    precio decimal(5,2) check(precio between 1 and 100.00) not null,
    fecha datetime default current_timestamp,
    foreign key (id_pasajero) references pasajeros(id_pasajero),
    foreign key (id_ruta) references rutas(id_ruta),
    foreign key (id_bus) references buses(id_bus)
);

-- DATOS VALIDOS PARA POBLAR LA BASE DE DATOS CON REGISTROS INICIALES 
INSERT INTO buses (modelo, placa, año, capacidad) VALUES
('Mercedes-Benz OF1721', 'PBA-1234', 2015, 60),
('Hino FC9J', 'PBC-5678', 2018, 45),
('Chevrolet NPR', 'PBD-9012', 2021, 50);

INSERT INTO conductores (nombre, cedula, telefono) VALUES
('Carlos Pérez', '1723456789', '0998765432'),
('María López', '1712345678', '0987654321'),
('José Andrade', '1756789012', '0976543210');

INSERT INTO rutas (origen, destino, hora_salida, hora_llegada) VALUES
('Quito', 'Cayambe', '2026-01-22 07:00:00', '2026-01-22 09:00:00'),
('Quito', 'Mejía (Machachi)', '2026-01-22 08:30:00', '2026-01-22 10:00:00'),
('Quito', 'Pedro Moncayo (Tabacundo)', '2026-01-22 06:00:00', '2026-01-22 08:00:00');

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

----- Subconsulatas -----
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


-------- Creacion de Roles ------
-------- Rol Operador -----------
create role rol_operador;
-------- Asignacion de Roles ------
grant select, insert on flota_de_buses.boletos to rol_operador;
grant select on flota_de_buses.pasajeros to rol_operador;
grant select on flota_de_buses.rutas to rol_operador;
grant select on flota_de_buses.buses to rol_operador;
----------- Rol_administrador -----------
create role rol_administrador;
----------- Asignacion de roles ----------
grant all privileges on flota_de_buses.* to rol_administrador;
-------- Creacion de Usuarios ---------
-------- Usuario Operador -------
create user 'operador'@'localhost'
identified by 'Operador@2026';
----------- Usuario Administrador ---------
create user 'admin_flota'@'localhost'
identified by 'Admin@2026';
-------- Asignacion de los roles a los usuarios ---------
grant rol_operador to 'operador_bus'@'localhost';
grant rol_administrador to 'admin_flota'@'localhost';
