use scripttribyte;
show tables;

/*Para modificar las migraciones ya que los nombres de usuarios se hallan en otra tabla*/
/*alter table users drop column name;
alter table personal_access_tokens drop column name;*/

/*Comentario de prueba*/

create table backoffice(
	codigo int not null auto_increment primary key,
    contrasenia varchar(255) not null,
	created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table turnos(
	idTurno int not null auto_increment primary key,
    horaInicio time not null,
    horaFinal time not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table categorias(
	tipo char not null primary key
);

create table departamentos(
	idDepartamento int not null primary key auto_increment,
    nombre varchar(20) not null
);

create table almacenes(
	idAlmacen int not null auto_increment primary key,
    capacidad int not null,
    direccion VARCHAR(40) not null,
    idDepartamento int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idDepartamento) references departamentos(idDepartamento)
);

create table estanterias(
	identificador int not null auto_increment primary key,
    peso double not null,
    apiladoMaximo int not null,
    idAlmacen int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idAlmacen) references almacenes(idAlmacen)
);

create table usuarios(
	docDeIdentidad int(8) not null primary key,
    nombre varchar(255) not null,
    apellido varchar(20) not null,
    telefono int(10) not null,
    direccion varchar(40) not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table user_usuario(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
	id bigint(20) unsigned not null,
    docDeIdentidad int(8) not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    unique (id, docDeIdentidad),
    foreign key (id) references users(id),
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad)
);

create table choferes(
	docDeIdentidad int(8) not null primary key,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad)
);

create table gerentes(
	docDeIdentidad int(8) not null primary key,
    idAlmacen int not null,
    idTurno int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad),
    foreign key (idAlmacen) references almacenes(idAlmacen),
    foreign key (idTurno) references turnos(idTurno)
);

create table administradores(
	docDeIdentidad int(8) not null primary key,
    backoffice int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad),
    foreign key (backoffice) references backoffice(codigo)
);

create table cargadores(
	docDeIdentidad int(8) not null primary key,
    carnetTransporte int not null,
    idAlmacen int not null,
    idTurno int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references usuarios(docDeIdentidad),
    foreign key (idAlmacen) references almacenes(idAlmacen),
    foreign key (idTurno) references turnos(idTurno)
);

create table licencias(
	idLicencia char(8) not null primary key,
    validoDesde date not null,
    validoHasta date not null,
    docDeIdentidad int(8) not null,
    categoria char not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references choferes(docDeIdentidad),
    foreign key (categoria) references categorias(tipo)
);

create table modelos(
	idModelo int not null primary key auto_increment,
    nombre varchar(255) not null,
    anio year not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table vehiculos(
	idVehiculo int not null primary key auto_increment,
    matricula char(8) not null unique,
    capacidad int not null,
    pesoMaximo int not null,
    modelo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (modelo) references modelos(idModelo)
);

create table maneja(
	docDeIdentidad int(8) not null primary key,
    idVehiculo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (docDeIdentidad) references choferes(docDeIdentidad),
    foreign key (idVehiculo) references vehiculos(idVehiculo)
);

create table tipoArticulo(
	idTipoArticulo int not null auto_increment primary key,
    tipo char not null unique,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table articulos(
	idArticulo int not null auto_increment primary key,
    nombre varchar(50) not null,
    anioCreacion int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table codigoDeBulto(
	codigo int not null primary key auto_increment,
    tipo char not null unique,
    maximoApilado int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table paquetes(
	idPaquete int not null auto_increment primary key,
    cantidadArticulos int not null,
    peso int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime
);

create table articulo_paquete(
	idArticulo int not null primary key,
    idPaquete int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idArticulo) references articulos(idArticulo),
    foreign key (idPaquete) references paquetes(idPaquete)
);

create table destinos(
	idDestino int not null primary key auto_increment,
    direccion varchar(50) not null,
    idDepartamento int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idDepartamento) references departamentos(idDepartamento)
);

create table lotes(
	idLote int not null auto_increment primary key,
    cantidadPaquetes int not null,
    idDestino int not null,
    idAlmacen int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idDestino) references destinos(idDestino),
    foreign key (idAlmacen) references almacenes(idAlmacen)
);

create table estadoEntrega(
	idLote int not null primary key,
	fechaEntrega date not null,
    horaEntrega time not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idLote) references lotes(idLote)
);

create table paquete_lote(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
	idPaquete int not null,
    idLote int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    unique (idPaquete, idLote),
    foreign key (idPaquete) references paquetes(idPaquete),
    foreign key (idLote) references lotes(idLote)
);

create table articulo_tipoArticulo(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
    idArticulo int not null,
    idTipo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
	unique (idArticulo, idTipo),
    foreign key (idArticulo) references articulos(idArticulo),
    foreign key (idTipo) references tipoArticulo(idTipoArticulo)
);

create table paquete_estanteria(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
    idPaquete int not null,
    idEstanteria int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    unique (idPaquete, idEstanteria),
	foreign key (idPaquete) references paquetes(idPaquete),
    foreign key (idEstanteria) references estanterias(identificador)
);

create table paquete_codigoDeBulto(
	idRelacion int not null primary key auto_increment, /*Por Laravel*/
    idPaquete int not null,
    codigo int not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    unique (idPaquete, codigo),
    foreign key (idPaquete) references paquetes(idPaquete),
    foreign key (codigo) references codigoDeBulto(codigo)
);

create table vehiculo_lote_destino(
    idLote int not null primary key,
    fechaEstimada date not null,
    horaEstimada time not null,
    docDeIdentidad int(8) not null,
    created_at timestamp,
    updated_at datetime,
    deleted_at datetime,
    
    foreign key (idLote) references lotes(idLote),
    foreign key (docDeIdentidad) references choferes(docDeIdentidad)
);

INSERT INTO categorias (tipo) VALUES ("A");
INSERT INTO categorias (tipo) VALUES ("B");
INSERT INTO categorias (tipo) VALUES ("C");
INSERT INTO categorias (tipo) VALUES ("D");
INSERT INTO categorias (tipo) VALUES ("E");
INSERT INTO categorias (tipo) VALUES ("F");
INSERT INTO categorias (tipo) VALUES ("G");
INSERT INTO categorias (tipo) VALUES ("H");

INSERT INTO departamentos (nombre) VALUES ("Montevideo");
INSERT INTO departamentos (nombre) VALUES ("Rivera");
INSERT INTO departamentos (nombre) VALUES ("Paysandu");
INSERT INTO departamentos (nombre) VALUES ("Florida");
INSERT INTO departamentos (nombre) VALUES ("Durazno");
INSERT INTO departamentos (nombre) VALUES ("Canelones");
INSERT INTO departamentos (nombre) VALUES ("Flores");
INSERT INTO departamentos (nombre) VALUES ("Maldonado");
INSERT INTO departamentos (nombre) VALUES ("Rocha");
INSERT INTO departamentos (nombre) VALUES ("Artigas");
INSERT INTO departamentos (nombre) VALUES ("Salto");
INSERT INTO departamentos (nombre) VALUES ("Treinta y Tres");
INSERT INTO departamentos (nombre) VALUES ("Soriano");
INSERT INTO departamentos (nombre) VALUES ("San José");
INSERT INTO departamentos (nombre) VALUES ("Tacuarembó");
INSERT INTO departamentos (nombre) VALUES ("Colonia");
INSERT INTO departamentos (nombre) VALUES ("Rio Negro");
INSERT INTO departamentos (nombre) VALUES ("Lavalleja");
INSERT INTO departamentos (nombre) VALUES ("Cerro Largo");

/*Usuarios y claves del sistema*/
CREATE USER 'BackofficeELS' IDENTIFIED BY 'Backoffice2023ELS';
CREATE USER 'APITransito' IDENTIFIED BY 'Transito2023ELS';
CREATE USER 'APIAlmacenes' IDENTIFIED BY 'Almacenes2023ELS';
CREATE USER 'APIAutenticacion' IDENTIFIED BY 'Auth2023ELS';

/*Estudio de los permisos*/
/*Backoffice cuenta con todos los permisos de alta, baja y modificacion
para todas las tablas. Lo unico que lo diferencia del root, es el hecho de que no
cuenta con permisos sobre la tabla "backoffice".*/

/*API Transito cuenta con permisos de SELECT en todas las tablas, para
obtener toda la informacion posible respecto a los paquetes en movimiento, menos en Backoffice.
A su vez, cuenta tambien con UPDATE y CREATE en estadoEntrega para definir la entrega
de un lote de parte de un chofer.*/

/*API Almacen cuenta todos los permisos referentes a paquetes y lotes, así como estanterias,
destinos, y vehiculo_lote_destino para definir lo que ocurre con los respectivos paquetes
y lotes. Cuenta con SELECT en almacenes, articulos y articulo_tipoArticulo para
definir informacion respecto a los paquetes.*/

/*API Transito cuenta con permisos de SELECT en todas las tablas, menos en Backoffice.
A su vez, cuenta tambien con UPDATE y CREATE en estadoEntrega para definir la entrega
de un lote de parte de un chofer.*/

/*Sentencias de asignacion de permisos*/
/*Backoffice*/
GRANT ALL PRIVILEGES ON *.* TO 'BackofficeELS';
REVOKE ALL PRIVILEGES ON backoffice TO 'BackofficeELS'; 

/*API Almacenes*/
GRANT SELECT on almacenes to 'APIAlmacenes';
GRANT SELECT ON articulos TO 'APIAlmacenes';
GRANT SELECT ON articulo_tipoarticulo TO 'APIAlmacenes'; 
GRANT ALL PRIVILEGES ON articulo_paquete TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON paquetes TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON paquete_estanteria TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON paquete_lote TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON paquete_codigodebulto TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON lotes TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON estanterias TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON destinos TO 'APIAlmacenes';
GRANT ALL PRIVILEGES ON vehiculo_lote_destino TO 'APIAlmacenes';

/*API Transito*/
GRANT SELECT ON *.* TO 'APITransito';
GRANT UPDATE, CREATE, SELECT ON estadoEntrega TO 'APITransito';

/*API Autenticacion*/
GRANT ALL PRIVILEGES ON  users TO 'APIAutenticacion';
GRANT ALL PRIVILEGES ON  usuarios TO 'APIAutenticacion';
GRANT ALL PRIVILEGES ON  user_usuario TO 'APIAutenticacion';
GRANT ALL PRIVILEGES ON  migrations TO 'APIAutenticacion';
GRANT ALL PRIVILEGES ON  failed_jobs TO 'APIAutenticacion';
GRANT ALL PRIVILEGES ON  password_resets TO 'APIAutenticacion';
GRANT ALL PRIVILEGES ON  personal_access_tokens TO 'APIAutenticacion';

/*Transacción 0- Insercion de usuario comun*/
START TRANSACTION;

INSERT INTO usuarios (docDeIdentidad, nombre, apellido, telefono, direccion) VALUES (12345678, 'Pepito', 'Perez', 1234567890, 'Peru 2020');
INSERT INTO users (email, password) VALUES ('usuario@usuario.com', 1122334455); 
INSERT INTO user_usuario (id, docDeIdentidad) VALUES (1,12345678);

COMMIT;

/*Transacción 1 - Insercion de gerente*/
START TRANSACTION;

INSERT INTO usuarios (docDeIdentidad, nombre, apellido, telefono, direccion) VALUES (12345670, 'Pepito', 'Perez', 1234567890, 'Peru 2020');
INSERT INTO users (email, password) VALUES ('usuario@usuario.com', 1122334455); 
INSERT INTO user_usuario (id, docDeIdentidad) VALUES (2,12345670);
INSERT INTO gerentes (docDeIdentidad, idAlmacen, idTurno) VALUES (12345670, 1, 1);

COMMIT;

/* 2ª Transacción - Insercion de administradores*/
START TRANSACTION;

INSERT INTO usuarios (docDeIdentidad, nombre, apellido, telefono, direccion) VALUES (12345679, 'Pepito', 'Perez', 1234567890, 'Peru 2020');
INSERT INTO users (email, password) VALUES ('usuario2@usuario.com', 1122334455); 
INSERT INTO user_usuario (id, docDeIdentidad) VALUES (3,12345679);
INSERT INTO administradores (docDeIdentidad, backoffice) VALUES (12345679, 1);

ROLLBACK;

COMMIT;

/* 3ª Transacción - Insercion de choferes*/
START TRANSACTION;

INSERT INTO usuarios (docDeIdentidad, nombre, apellido, telefono, direccion) VALUES (12345680, 'Pepito', 'Perez', 1234567890, 'Peru 2020');
INSERT INTO users (email, password) VALUES ('usuario3@usuario.com', 1122334455); 
INSERT INTO user_usuario (id, docDeIdentidad) VALUES (4,12345680);
INSERT INTO choferes (docDeIdentidad) VALUES (12345680);
INSERT INTO licencias (idLicencia, validoDesde, validoHasta, docDeIdentidad, categoria) VALUES ("31JHA4GG47", 2018-06-04, 2030-08-16, 12345680, "H");

COMMIT;

/* 4ª Transacción - Insercion de cargadores*/
START TRANSACTION;

INSERT INTO usuarios (docDeIdentidad, nombre, apellido, telefono, direccion) VALUES (22345678, 'Pepito', 'Perez', 1234567890, 'Peru 2020');
INSERT INTO users (email, password) VALUES ('usuario4@usuario.com', 1122334455); 
INSERT INTO user_usuario (id, docDeIdentidad) VALUES (5,22345678);
INSERT INTO cargadores (docDeIdentidad, carnetTransporte, idAlmacen, idTurno) VALUES (22345678, "A79WFHH", 1, 1);

COMMIT;

/* 5ª Transacción - Insercion de articulos*/
START TRANSACTION;

INSERT INTO articulos (idArticulo, nombre, anioCreacion) VALUES (21, "Samsung", 2021);
INSERT INTO articulo_tipoArticulo (idArticulo, idTipo) VALUES (21, 1);

COMMIT;

/* 6ª Transacción - Insercion de paquetes*/
START TRANSACTION;

INSERT INTO paquetes (idPaquete, cantidadArticulos, peso) VALUES (5551, 20, 14);
INSERT INTO articulo_paquete (idArticulo, idPaquete) VALUES (21, 5551);

COMMIT;

/* 7ª Transacción - Insercion de lotes*/
START TRANSACTION;

INSERT INTO lotes (cantidadPaquetes, idDestino, idAlmacen) VALUES (30, 1, 1);
INSERT INTO paquete_lote (idPaquete, idLote) VALUES (5551, 30);

COMMIT;

/*Consulta SQL*/
select d.nombre as departamentos, SUM(a.Capacidad) as CapacidadTotal, SUM(l.cantidadpaquetes) as totalpaquetes from departamentos d
join almacenes a on d.idDepartamento = a.idDepartamento
join lotes l on a.IdAlmacen = l.idAlmacen
group by d.nombre;

/*Consulta en algebraRelacional*/
/*π d.nombre, Σ a.Capacidad as CapacidadTotal, Σ l.cantidadpaquetes as totalpaquetes
(ρ d ← departamentos) ⨝
(ρ a ← almacenes) ⨝
(ρ l ← lotes)*/