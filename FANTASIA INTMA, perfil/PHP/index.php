<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fantasia Intima</title>
    <link rel="stylesheet" href="../CSS/perfil.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
</head>
<body>
    <div class="container">
        <div class="header">
            <img src="../img/logo.png" class="logo">
            <span>FANTASIA INTIMA</span>
        <div class="datos">
            <ul class="nav">
                <li> <i class="bi bi-person-circle"></i> <a href="#">Datos Personales</a></li>
                <li> <i class="bi bi-trash3-fill"></i> <a href="#">Eliminar Cuenta</a></li>
                <li> <i class="bi bi-list-check"></i> <a href="#">Historial De Pedidos</a></li>
                <li> <i class="bi bi-folder-fill"></i> <a href="#">Datos Del Sistema</a></li>
                <li> <i class="bi bi-box-arrow-right"></i> <a href="#">Salir</a></li>
            </ul>
        </div>
    </div>
        <div class="form-container">
            <form action="#">
                <div class="sector1">
                    <label for="primerNombre">Primer Nombre:</label>
                    <input type="text" id="primerNombre" name="primerNombre" required>
    
                    <label style="margin-top: 5px"for="primerApellido">Primer Apellido:</label>
                    <input type="text" id="primerApellido" name="primerApellido" required>
                </div>
    
                <div class="sector2">
                    <label for="segundoNombre">Segundo Nombre:</label>
                    <input type="text" id="segundoNombre" name="segundoNombre">
                    
    
                    <label style="margin-top: 5px"for="segundoApellido">Segundo Apellido:</label>
                    <input type="text" id="segundoApellido" name="segundoApellido">
                </div>
    
                <div class="sector3">
    
                    <label for="contrasena">Contraseña:</label>
                    <input class="contrasena"type="password" id="contrasena" name="contrasena" required>
                    
                </div>
    
                <div class="sector4">
                    
                    <label for="nombreUsuario">Nombre de usuario:</label>
                    <input type="text" id="nombreUsuario" name="nombreUsuario" required>
                    
                </div>
    
                <div class="sector5">
                    <label for="correoElectronico">Correo electrónico:</label>
                    <input type="email" id="correoElectronico" name="correoElectronico" required>
                </div>
                <button style=" margin-top: 10px; " type="submit">Modificar</button>
                <button style=" margin-top: 10px; " type="submit">Guardar</button>
            </form>
        </div>
    </div>
</body>
</html>