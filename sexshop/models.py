from django.db import models

class categoria(models.Model):
    IdCategoria = models.AutoField(primary_key=True)  
    NombreCategoria = models.CharField(max_length=80)

    class Meta:
        db_table = 'categoria'


class subcategoria(models.Model):
    IdSubCategoria = models.AutoField(primary_key=True)  
    NombresubCategoria = models.CharField(max_length=45)
    categoria = models.ForeignKey('categoria', on_delete=models.CASCADE, db_column='IdCategoria')  

    class Meta:
        db_table = 'subcategoria'

class usuario(models.Model):
    IdUsuario  = models.AutoField(primary_key=True)  
    PrimerNombre = models.CharField(max_length=255)
    OtrosNombres = models.CharField(max_length=255)
    PrimerApellido = models.CharField(max_length=255)
    SegundoApellido = models.CharField(max_length=255)
    Correo = models.EmailField(max_length=255, unique=True)
    NombreUsuario  = models.CharField(max_length=45)
    Contraseña   = models.CharField(max_length=128)
    idRol = models.ForeignKey('roles', on_delete=models.CASCADE, db_column='IdRol')
    imagen_perfil = models.ImageField(upload_to='profile_images/', null=True, blank=True)
    class Meta:
        db_table = 'usuario'


class roles(models.Model):
    IdRol = models.AutoField(primary_key=True)  
    TipoRol = models.CharField(max_length=30)
    class Meta:
        db_table = 'roles'

class domiciliario(models.Model):
    IdDomiciliario = models.AutoField(primary_key=True)
    TipoDocumento = models.CharField(max_length=45)
    Documento = models.IntegerField(unique=True)
    NombreDomiciliario = models.CharField(max_length=100)
    PrimerApellido = models.CharField(max_length=45)
    SegundoApellido = models.CharField(max_length=45, blank=True, null=True)
    Celular = models.BigIntegerField()
    Ciudad = models.CharField(max_length=45, blank=True, null=True)
    Correo = models.EmailField(max_length=255, unique=True)
    Contraseña = models.CharField(max_length=256, blank=False, null=False)
    IdRol = models.ForeignKey('Roles', on_delete=models.CASCADE, db_column='IdRol', null=True, blank=True)

    class Meta:
        db_table = 'domiciliario'

class producto(models.Model):
    IdProducto = models.AutoField(primary_key=True)  
    Img = models.ImageField(upload_to='productos/')
    Nombre = models.CharField(max_length=100)
    Descripcion = models.CharField(max_length=255)
    Cantidad = models.IntegerField()
    Precio = models.FloatField()
    FechaVence = models.DateField()
    IdSubCategoria = models.ForeignKey('subcategoria', on_delete=models.CASCADE, db_column='IdSubCategoria')

    class Meta:
        db_table = 'productos'



