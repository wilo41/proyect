-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2024 at 05:55 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sexshop`
--

-- --------------------------------------------------------

--
-- Table structure for table `calificacion`
--

CREATE TABLE `calificacion` (
  `IdCalificacion` int(11) NOT NULL,
  `Calificacion` int(2) NOT NULL,
  `IdProducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `carritocompras`
--

CREATE TABLE `carritocompras` (
  `IdCarrito` int(11) NOT NULL,
  `NombreProducto` varchar(100) NOT NULL,
  `Cantidad` int(11) NOT NULL,
  `Imagen` text NOT NULL,
  `PrecioEnvio` int(11) NOT NULL,
  `PrecioTotal` bigint(7) NOT NULL,
  `PrecioProductos` bigint(7) NOT NULL,
  `DescripcionProducto` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categoria`
--

CREATE TABLE `categoria` (
  `IdCategoria` int(11) NOT NULL,
  `NombreCategoria` varchar(80) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `chat`
--

CREATE TABLE `chat` (
  `IdChat` int(11) NOT NULL,
  `FechaHora` datetime NOT NULL,
  `ContenidoMensaje` longtext NOT NULL,
  `Multimedia` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`Multimedia`)),
  `Notificaciones` longtext NOT NULL,
  `HistorialChat` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`HistorialChat`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ciudad`
--

CREATE TABLE `ciudad` (
  `IdCiudad` int(11) NOT NULL,
  `NombreCiudad` varchar(255) NOT NULL,
  `NombreDepartamento` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cuentabancaria`
--

CREATE TABLE `cuentabancaria` (
  `IdCuentaBancaria` int(11) NOT NULL,
  `TipoCuenta` varchar(45) NOT NULL,
  `NumeroCuenta` int(11) NOT NULL,
  `MontoTransaccion` int(11) NOT NULL,
  `NombreUsuario` varchar(100) NOT NULL,
  `TipoDocumento` varchar(45) NOT NULL,
  `NumeroDocumento` int(11) NOT NULL,
  `IdMetodoPago` int(11) NOT NULL,
  `IdUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `domiciliario`
--

CREATE TABLE `domiciliario` (
  `IdDomiciliario` int(11) NOT NULL,
  `TipoDocumento` varchar(45) NOT NULL,
  `Documento` int(11) NOT NULL,
  `NombreDomiciliario` varchar(100) NOT NULL,
  `PrimerApellido` varchar(45) NOT NULL,
  `SegundoApellido` varchar(45) NOT NULL,
  `Celular` int(11) NOT NULL,
  `HorarioDisponibilidad` datetime NOT NULL,
  `IdCiudad` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `formaentrega`
--

CREATE TABLE `formaentrega` (
  `IdFormaEntrega` int(11) NOT NULL,
  `NombreCliente` varchar(100) NOT NULL,
  `NombreDomiciliario` varchar(100) NOT NULL,
  `Direccion` varchar(80) NOT NULL,
  `FechaEnrega` date NOT NULL,
  `IdDomiciliario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `metodopago`
--

CREATE TABLE `metodopago` (
  `IdMetodoPago` int(11) NOT NULL,
  `FormaPago` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pedido`
--

CREATE TABLE `pedido` (
  `IdPedido` int(11) NOT NULL,
  `CodigoPedido` int(11) NOT NULL,
  `FechaCompra` datetime NOT NULL,
  `CantidadProducto` int(11) NOT NULL,
  `NombreProducto` varchar(100) NOT NULL,
  `NombreCliente` varchar(100) NOT NULL,
  `PrecioTotal` bigint(7) NOT NULL,
  `MetodoDePago` varchar(45) NOT NULL,
  `PrecioProductos` bigint(7) NOT NULL,
  `IdCiudad` int(11) NOT NULL,
  `IdDomiciliario` int(11) NOT NULL,
  `IdUsuario` int(11) NOT NULL,
  `IdCuentaBancaria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pedidoxproducto`
--

CREATE TABLE `pedidoxproducto` (
  `IdProducto` int(11) NOT NULL,
  `IdPedido` int(11) NOT NULL,
  `IdPedidoxProducto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `productos`
--

CREATE TABLE `productos` (
  `IdProducto` int(11) NOT NULL,
  `Img` text NOT NULL,
  `Nombre` varchar(100) NOT NULL,
  `Descripcion` varchar(255) NOT NULL,
  `Cantidad` int(3) NOT NULL,
  `Precio` int(7) NOT NULL,
  `FechaVence` date NOT NULL,
  `IdCategoria*` int(11) NOT NULL,
  `IdCarritoCompra` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `recuperarcontraseña`
--

CREATE TABLE `recuperarcontraseña` (
  `IdRecuperarContraseña` int(11) NOT NULL,
  `CodigoVerificacion` int(11) NOT NULL,
  `NuevaContraseña` varchar(50) NOT NULL,
  `ConfirmacionContraseña` varchar(50) NOT NULL,
  `IdUsuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `registropedido`
--

CREATE TABLE `registropedido` (
  `IdRegistroPedido` int(11) NOT NULL,
  `TipoDocumento` varchar(45) NOT NULL,
  `NumeroDocumento` int(11) NOT NULL,
  `NombreUsuario` varchar(45) NOT NULL,
  `Direccion` varchar(45) NOT NULL,
  `NumeroCelular` int(11) NOT NULL,
  `IdPedido` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `IdRol` int(11) NOT NULL,
  `TipoRol` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `subcategoria`
--

CREATE TABLE `subcategoria` (
  `IdSubCategoria` int(11) NOT NULL,
  `NombreSubCategoria` varchar(45) NOT NULL,
  `IdCategoria` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `usuario`
--

CREATE TABLE `usuario` (
  `IdUsuario` int(11) NOT NULL,
  `PrimerNombre` varchar(255) NOT NULL,
  `OtrosNombres` varchar(255) NOT NULL,
  `PrimerApellido` varchar(255) NOT NULL,
  `SegundoApellido` varchar(255) NOT NULL,
  `Correo` varchar(255) NOT NULL,
  `NombreUsuario` varchar(45) NOT NULL,
  `Contraseña` varchar(50) NOT NULL,
  `idRol` int(11) NOT NULL,
  `IdChat` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `calificacion`
--
ALTER TABLE `calificacion`
  ADD PRIMARY KEY (`IdCalificacion`),
  ADD UNIQUE KEY `idCalificacion_UNIQUE` (`IdCalificacion`),
  ADD UNIQUE KEY `IdProducto_UNIQUE` (`IdProducto`),
  ADD KEY `fk_Calificacion_Productos1_idx` (`IdProducto`);

--
-- Indexes for table `carritocompras`
--
ALTER TABLE `carritocompras`
  ADD PRIMARY KEY (`IdCarrito`),
  ADD UNIQUE KEY `id_producto_UNIQUE` (`IdCarrito`);

--
-- Indexes for table `categoria`
--
ALTER TABLE `categoria`
  ADD PRIMARY KEY (`IdCategoria`),
  ADD UNIQUE KEY `TipoCategoria*_UNIQUE` (`IdCategoria`);

--
-- Indexes for table `chat`
--
ALTER TABLE `chat`
  ADD PRIMARY KEY (`IdChat`),
  ADD UNIQUE KEY `id_chat*_UNIQUE` (`IdChat`);

--
-- Indexes for table `ciudad`
--
ALTER TABLE `ciudad`
  ADD PRIMARY KEY (`IdCiudad`),
  ADD UNIQUE KEY `codigo_postal*_UNIQUE` (`IdCiudad`);

--
-- Indexes for table `cuentabancaria`
--
ALTER TABLE `cuentabancaria`
  ADD PRIMARY KEY (`IdCuentaBancaria`),
  ADD UNIQUE KEY `IdCuentaBancaria_UNIQUE` (`IdCuentaBancaria`),
  ADD UNIQUE KEY `NumeroCuenta_UNIQUE` (`NumeroCuenta`),
  ADD KEY `fk_CuentaBancaria_MetodoPago1_idx` (`IdMetodoPago`),
  ADD KEY `fk_CuentaBancaria_Usuario1_idx` (`IdUsuario`);

--
-- Indexes for table `domiciliario`
--
ALTER TABLE `domiciliario`
  ADD PRIMARY KEY (`IdDomiciliario`),
  ADD UNIQUE KEY `IdDomicilio_UNIQUE` (`IdDomiciliario`),
  ADD UNIQUE KEY `CodigoPostal_UNIQUE` (`IdCiudad`),
  ADD KEY `fk_Domicilio_Ciudad1_idx` (`IdCiudad`);

--
-- Indexes for table `formaentrega`
--
ALTER TABLE `formaentrega`
  ADD PRIMARY KEY (`IdFormaEntrega`),
  ADD UNIQUE KEY `Codigo_UNIQUE` (`IdFormaEntrega`),
  ADD KEY `fk_FormaEntrega_Domicilio1_idx` (`IdDomiciliario`);

--
-- Indexes for table `metodopago`
--
ALTER TABLE `metodopago`
  ADD PRIMARY KEY (`IdMetodoPago`);

--
-- Indexes for table `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`IdPedido`),
  ADD UNIQUE KEY `id_pedido_UNIQUE` (`IdPedido`),
  ADD KEY `fk_pedido_ciudad1_idx` (`IdCiudad`),
  ADD KEY `fk_pedido_Domicilio1_idx` (`IdDomiciliario`),
  ADD KEY `fk_pedido_Usuario1_idx` (`IdUsuario`),
  ADD KEY `fk_Pedido_CuentaBancaria1_idx` (`IdCuentaBancaria`);

--
-- Indexes for table `pedidoxproducto`
--
ALTER TABLE `pedidoxproducto`
  ADD PRIMARY KEY (`IdPedidoxProducto`),
  ADD UNIQUE KEY `IdProducto_UNIQUE` (`IdProducto`),
  ADD UNIQUE KEY `id_pedido_UNIQUE` (`IdPedido`),
  ADD UNIQUE KEY `IdPedidoxProducto_UNIQUE` (`IdPedidoxProducto`),
  ADD KEY `fk_PEDIDOXPRODUCTO_Productos1_idx` (`IdProducto`),
  ADD KEY `fk_PEDIDOXPRODUCTO_pedido1_idx` (`IdPedido`);

--
-- Indexes for table `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`IdProducto`),
  ADD UNIQUE KEY `idproducto*_UNIQUE` (`IdProducto`),
  ADD UNIQUE KEY `TipoCategoria*_UNIQUE` (`IdCategoria*`),
  ADD KEY `fk_Productos_Categoria1_idx` (`IdCategoria*`),
  ADD KEY `fk_Productos_CarritoCompras1_idx` (`IdCarritoCompra`);

--
-- Indexes for table `recuperarcontraseña`
--
ALTER TABLE `recuperarcontraseña`
  ADD PRIMARY KEY (`IdRecuperarContraseña`),
  ADD UNIQUE KEY `IdRecuperarContraseña_UNIQUE` (`IdRecuperarContraseña`),
  ADD KEY `fk_RecuperarContraseña_Usuario1_idx` (`IdUsuario`);

--
-- Indexes for table `registropedido`
--
ALTER TABLE `registropedido`
  ADD PRIMARY KEY (`IdRegistroPedido`),
  ADD UNIQUE KEY `idRegistroPedido_UNIQUE` (`IdRegistroPedido`),
  ADD KEY `fk_RegistroPedido_Pedido1_idx` (`IdPedido`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`IdRol`),
  ADD UNIQUE KEY `IdRol_UNIQUE` (`IdRol`);

--
-- Indexes for table `subcategoria`
--
ALTER TABLE `subcategoria`
  ADD PRIMARY KEY (`IdSubCategoria`),
  ADD UNIQUE KEY `idSubCategoria_UNIQUE` (`IdSubCategoria`),
  ADD KEY `fk_SubCategoria_Categoria1_idx` (`IdCategoria`);

--
-- Indexes for table `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`IdUsuario`),
  ADD UNIQUE KEY `correo_UNIQUE` (`Correo`),
  ADD UNIQUE KEY `Id_Usuario_UNIQUE` (`IdUsuario`),
  ADD UNIQUE KEY `NombreUsuario_UNIQUE` (`NombreUsuario`),
  ADD UNIQUE KEY `Contraseña_UNIQUE` (`Contraseña`),
  ADD KEY `fk_usuario_roles1_idx` (`idRol`),
  ADD KEY `fk_Usuario_Chat1_idx` (`IdChat`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `calificacion`
--
ALTER TABLE `calificacion`
  MODIFY `IdCalificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `carritocompras`
--
ALTER TABLE `carritocompras`
  MODIFY `IdCarrito` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categoria`
--
ALTER TABLE `categoria`
  MODIFY `IdCategoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `chat`
--
ALTER TABLE `chat`
  MODIFY `IdChat` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ciudad`
--
ALTER TABLE `ciudad`
  MODIFY `IdCiudad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `cuentabancaria`
--
ALTER TABLE `cuentabancaria`
  MODIFY `IdCuentaBancaria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `domiciliario`
--
ALTER TABLE `domiciliario`
  MODIFY `IdDomiciliario` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `formaentrega`
--
ALTER TABLE `formaentrega`
  MODIFY `IdFormaEntrega` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `metodopago`
--
ALTER TABLE `metodopago`
  MODIFY `IdMetodoPago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pedido`
--
ALTER TABLE `pedido`
  MODIFY `IdPedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `productos`
--
ALTER TABLE `productos`
  MODIFY `IdProducto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `recuperarcontraseña`
--
ALTER TABLE `recuperarcontraseña`
  MODIFY `IdRecuperarContraseña` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `registropedido`
--
ALTER TABLE `registropedido`
  MODIFY `IdRegistroPedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `IdRol` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `subcategoria`
--
ALTER TABLE `subcategoria`
  MODIFY `IdSubCategoria` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `usuario`
--
ALTER TABLE `usuario`
  MODIFY `IdUsuario` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `calificacion`
--
ALTER TABLE `calificacion`
  ADD CONSTRAINT `fk_Calificacion_Productos1` FOREIGN KEY (`IdProducto`) REFERENCES `productos` (`IdProducto`);

--
-- Constraints for table `cuentabancaria`
--
ALTER TABLE `cuentabancaria`
  ADD CONSTRAINT `fk_CuentaBancaria_MetodoPago1` FOREIGN KEY (`IdMetodoPago`) REFERENCES `metodopago` (`IdMetodoPago`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_CuentaBancaria_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `domiciliario`
--
ALTER TABLE `domiciliario`
  ADD CONSTRAINT `fk_Domicilio_Ciudad1` FOREIGN KEY (`IdCiudad`) REFERENCES `ciudad` (`IdCiudad`);

--
-- Constraints for table `formaentrega`
--
ALTER TABLE `formaentrega`
  ADD CONSTRAINT `fk_FormaEntrega_Domicilio1` FOREIGN KEY (`IdDomiciliario`) REFERENCES `domiciliario` (`IdDomiciliario`);

--
-- Constraints for table `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `fk_Pedido_CuentaBancaria1` FOREIGN KEY (`IdCuentaBancaria`) REFERENCES `cuentabancaria` (`IdCuentaBancaria`),
  ADD CONSTRAINT `fk_pedido_Domicilio1` FOREIGN KEY (`IdDomiciliario`) REFERENCES `domiciliario` (`IdDomiciliario`),
  ADD CONSTRAINT `fk_pedido_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`),
  ADD CONSTRAINT `fk_pedido_ciudad1` FOREIGN KEY (`IdCiudad`) REFERENCES `ciudad` (`IdCiudad`);

--
-- Constraints for table `pedidoxproducto`
--
ALTER TABLE `pedidoxproducto`
  ADD CONSTRAINT `fk_PEDIDOXPRODUCTO_Productos1` FOREIGN KEY (`IdProducto`) REFERENCES `productos` (`IdProducto`),
  ADD CONSTRAINT `fk_PEDIDOXPRODUCTO_pedido1` FOREIGN KEY (`IdPedido`) REFERENCES `pedido` (`IdPedido`);

--
-- Constraints for table `productos`
--
ALTER TABLE `productos`
  ADD CONSTRAINT `fk_Productos_CarritoCompras1` FOREIGN KEY (`IdCarritoCompra`) REFERENCES `carritocompras` (`IdCarrito`),
  ADD CONSTRAINT `fk_Productos_Categoria1` FOREIGN KEY (`IdCategoria*`) REFERENCES `categoria` (`IdCategoria`);

--
-- Constraints for table `recuperarcontraseña`
--
ALTER TABLE `recuperarcontraseña`
  ADD CONSTRAINT `fk_RecuperarContraseña_Usuario1` FOREIGN KEY (`IdUsuario`) REFERENCES `usuario` (`IdUsuario`);

--
-- Constraints for table `registropedido`
--
ALTER TABLE `registropedido`
  ADD CONSTRAINT `fk_RegistroPedido_Pedido1` FOREIGN KEY (`IdPedido`) REFERENCES `pedido` (`IdPedido`);

--
-- Constraints for table `subcategoria`
--
ALTER TABLE `subcategoria`
  ADD CONSTRAINT `fk_SubCategoria_Categoria1` FOREIGN KEY (`IdCategoria`) REFERENCES `categoria` (`IdCategoria`);

--
-- Constraints for table `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `fk_Usuario_Chat1` FOREIGN KEY (`IdChat`) REFERENCES `chat` (`IdChat`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_usuario_roles1` FOREIGN KEY (`idRol`) REFERENCES `roles` (`IdRol`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
