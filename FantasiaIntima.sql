
-- Creamos la base de datos --

CREATE DATABASE FantasiaIntima;

USE FantasiaIntima;

--             USUARIO         --




-- Creamos la tabla de Roles --

CREATE TABLE Roles (
  IdRol INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  TipoRol VARCHAR(30) NOT NULL,
  UNIQUE INDEX IdRol_UNIQUE (IdRol ASC)
);

-- Creamos la tabla de Chat --
CREATE TABLE Chat
(

  IdChat INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  FechaHora DATETIME NOT NULL,
  ContenidoMensaje LONGTEXT NOT NULL,
  Multimedia JSON NOT NULL,
  Notificaciones LONGTEXT NOT NULL,
  UNIQUE INDEX id_chat_UNIQUE (IdChat ASC)

);


-- Creamos la tabla Base Usuario --
CREATE TABLE Usuario
(

  IdUsuario INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  TipoIdentificacion VARCHAR(45) NOT NULL,
  Identificacion BIGINT(14) NOT NULL,
  PrimerNombre VARCHAR(255) NOT NULL,
  OtrosNombres VARCHAR(255) NOT NULL,
  PrimerApellido VARCHAR(255) NOT NULL,
  SegundoApellido VARCHAR(255) NOT NULL,
  FechaNacimiento DATE NOT NULL,
  Celular BIGINT(14) NOT NULL,
  CuentaBancaria BIGINT(12) NOT NULL,
  Correo VARCHAR(255) NOT NULL,
  Direccion VARCHAR(80) NOT NULL,
  idRol INT NOT NULL,
  idChat INT NOT NULL,
  FOREIGN KEY (idRol) REFERENCES Roles (IdRol),
  FOREIGN KEY (idChat) REFERENCES Chat (IdChat)

);




--             PEDIDO         --



CREATE TABLE Ciudad
(

  IdCiudad INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  NombreCiudad VARCHAR(255) NOT NULL,
  NombreDepartamento VARCHAR(45) NOT NULL,
  UNIQUE INDEX codigo_postal_UNIQUE (IdCiudad ASC)

);


CREATE TABLE CarritoCompras
(

  IdCarrito INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Fecha DATE NOT NULL,
  Hora TIME NOT NULL,
  Descripcion VARCHAR(255) NOT NULL,
  UNIQUE INDEX descripcion_UNIQUE (Descripcion ASC),
  UNIQUE INDEX id_producto_UNIQUE (IdCarrito ASC)

);



CREATE TABLE Domicilio 
(

  IdDomicilio INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Direccion VARCHAR(80) NOT NULL,
  FechaEntrega DATE NOT NULL,
  HoraEntrega TIME NOT NULL,
  NombreDomiciliario VARCHAR(100) NOT NULL,
  NombreUsuario VARCHAR(100) NOT NULL,
  PrecioTotal BIGINT(6) NOT NULL,
  Factura VARCHAR(45) NOT NULL,
  IdCiudad INT NOT NULL,
  UNIQUE INDEX IdDomicilio_UNIQUE (IdDomicilio ASC),
  FOREIGN KEY (IdCiudad) REFERENCES Ciudad (IdCiudad)

);


CREATE TABLE FormaEntrega
(

  IdCodigo INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  HorarioDisponible DATETIME NOT NULL,
  NombreCliente VARCHAR(100) NOT NULL,
  NombreDomiciliario VARCHAR(100) NOT NULL,
  Direccion VARCHAR(80) NOT NULL,
  Celular BIGINT(14) NOT NULL,
  IdDomicilio INT NOT NULL,
  UNIQUE INDEX Codigo_UNIQUE (IdCodigo ASC),
  FOREIGN KEY (IdDomicilio) REFERENCES Domicilio (IdDomicilio)

);

CREATE TABLE MetodoPago
(

  IdMetodoPago INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  TipoCuenta VARCHAR(60) NOT NULL,
  FormaPago VARCHAR(60) NOT NULL,
  NumeroCuenta INT NOT NULL,
  UNIQUE INDEX numero_cuenta_UNIQUE (IdMetodoPago ASC),
  UNIQUE INDEX NumeroCuenta_UNIQUE (NumeroCuenta ASC) 

);


-- Creamos la tabla base Pedido --
CREATE TABLE Pedido(
  IdPedido INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  PrecioTotal BIGINT(7) NOT NULL,
  FechaPedido DATE NOT NULL,
  CodigoPedido INT(6) NOT NULL,
  IdCiudad INT NOT NULL,
  IdCarrito INT NOT NULL,
  IdDomicilio INT NOT NULL,
  IdUsuario INT NOT NULL,
  IdMetodoPago INT NOT NULL,
  FOREIGN KEY (IdCiudad) REFERENCES Ciudad (IdCiudad),
  FOREIGN KEY (IdCarrito) REFERENCES CarritoCompras (IdCarrito),
  FOREIGN KEY (IdDomicilio) REFERENCES Domicilio (IdDomicilio),
  FOREIGN KEY (IdUsuario) REFERENCES Usuario (IdUsuario),
  FOREIGN KEY (IdMetodoPago) REFERENCES MetodoPago (IdMetodoPago)

);

CREATE TABLE Categoria
(

  IdCategoria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  NombreCategoria VARCHAR(80) NOT NULL,
  UNIQUE INDEX TipoCategoria_UNIQUE (IdCategoria ASC)

);


CREATE TABLE Productos
(

  IdProducto INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Img TEXT(250) NOT NULL,
  Nombre VARCHAR(100) NOT NULL,
  Descripcion VARCHAR(255) NOT NULL,
  Cantidad INT(3) NOT NULL,
  Precio INT(7) NOT NULL,
  FechaVence DATE NOT NULL,
  IdCategoria INT NOT NULL,
  FOREIGN KEY (IdCategoria) REFERENCES Categoria (IdCategoria)


);

CREATE TABLE PEDIDOXPRODUCTO 
(

  IdProducto INT PRIMARY KEY NOT NULL,
  IdPedido INT NOT NULL,
  IdPedidoxProducto INT NOT NULL,
  UNIQUE INDEX IdProducto_UNIQUE (IdProducto ASC),
  UNIQUE INDEX id_pedido_UNIQUE (IdPedido ASC),
  FOREIGN KEY (IdProducto)REFERENCES Productos (IdProducto),
  FOREIGN KEY (IdPedido)REFERENCES Pedido (IdPedido)

);

CREATE TABLE Devolucion
(

  IdDevolucion INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  FechaDevolucion DATE NOT NULL,
  FechaPedido DATE NOT NULL,
  CodigoPedido INT(6) NOT NULL,
  PrecioTotal BIGINT(7) NOT NULL,
  PrecioParcial BIGINT(7) NOT NULL,
  UNIQUE INDEX codigo_postal_UNIQUE (IdDevolucion ASC) ,
  UNIQUE INDEX CodigoPedido_UNIQUE (CodigoPedido ASC) 

);

CREATE TABLE PEDIDOXDEVOLUCION
(

  IdPedidoxDevolucion INT PRIMARY KEY NOT NULL,
  IdPedido INT NOT NULL,
  IdDevolucion INT NOT NULL,
  UNIQUE INDEX id_pedido_UNIQUE (IdPedido ASC),
  UNIQUE INDEX IdPedidoxDevolucion_UNIQUE (IdPedidoxDevolucion ASC),
  UNIQUE INDEX IdDevolucion_UNIQUE (IdDevolucion ASC),
  FOREIGN KEY (IdPedido) REFERENCES Pedido (IdPedido),
  FOREIGN KEY (IdDevolucion) REFERENCES Devolucion (IdDevolucion)
);

CREATE TABLE Calificacion
(

  IdCalificacion INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  Calificacion INT(2) NOT NULL,
  IdProducto INT NOT NULL,
  UNIQUE INDEX idCalificacion_UNIQUE (IdCalificacion ASC),
  FOREIGN KEY (IdProducto) REFERENCES Productos (IdProducto)

);

CREATE TABLE Comentarios
(

  Id_Comentarios INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  FechaHora DATETIME NOT NULL,
  Comentario VARCHAR(255) NOT NULL,
  IdProducto INT NOT NULL,
  UNIQUE INDEX Id_Comentarios_UNIQUE (Id_Comentarios ASC),
  FOREIGN KEY (IdProducto) REFERENCES Productos (IdProducto)

);


CREATE TABLE SubCategoria 
(

  IdSubCategoria INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
  NombreSubCategoria VARCHAR(45) NOT NULL,
  IdCategoria INT NOT NULL,
  UNIQUE INDEX idSubCategoria_UNIQUE (IdSubCategoria ASC),
  FOREIGN KEY (IdCategoria) REFERENCES Categoria (IdCategoria)
  
);