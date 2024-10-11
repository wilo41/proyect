from django.db import models

class categoria(models.Model):
    NombreCategoria = models.CharField(max_length=80)
    class Meta:
        db_table = 'categoria'

class Subcategoria(models.Model):
    NombresubCategoria = models.CharField(max_length=80)
    categoria = models.ForeignKey('Categoria', on_delete=models.CASCADE)  

    class Meta:
        db_table = 'subcategoria'



# class Usuario(models.Model):
#     PrimerNombre = models.CharField(max_length=80)
#     OtrosNombres = models.CharField(max_length=80)
#     PrimerApellido = models.CharField(max_length=70)
#     SegundoApellido = models.CharField(max_length=70)
#     Correo = models.EmailField(max_length=255)
#     NombreUsuario = models.CharField(max_length=80)
#     Contraseña = models.CharField(max_length=128)
#     idRol = models.ForeignKey('Rol', on_delete=models.CASCADE, related_name='usuarios')
    
#     class Meta:
#         db_table = 'usuario'


