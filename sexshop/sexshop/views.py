from django.shortcuts import render, redirect
from django.db import connection
from django.contrib import messages
from django.http import HttpResponse
import random
import smtplib
from django.conf import settings

def LadingPage(request):
    cursor = connection.cursor()
    cursor.execute("CALL listadocategorias()")
    categorias = cursor.fetchall()
    
    # Convertir los resultados en una lista de diccionarios para pasar al template
    categorias = [{'IdCategoria': row[0], 'NombreCategoria': row[1]} for row in categorias]

    return render(request, 'LadingPage.html', {'categorias': categorias})

# region categorias
def insertarcategorias(request):
    if request.method == "POST":
        if request.POST.get('NombreCategoria'):
            insertar = connection.cursor()
            insertar.execute("CALL insertarcategorias(%s)", [request.POST.get('NombreCategoria')])
            return redirect("listadocategorias")
    return render(request, 'listadocategorias')

def listadocategorias(request):
    listado = connection.cursor()
    listado.execute("CALL listadocategorias()")
    categorias = listado.fetchall()
    return render(request, "crud/categorias.html", {"listado": categorias})

def borrarcategoria(request, id_categoria):
    borrar = connection.cursor()
    borrar.execute("CALL borrarcategoria(%s)", [id_categoria])
    return redirect('listadocategorias')

def actualizarcategoria(request, id_categoria):
    if request.method == "POST":
        if request.POST.get('NombreCategoria'):
            actualizar = connection.cursor()
            actualizar.execute("CALL actualizarcategoria(%s, %s)", [id_categoria, request.POST.get('NombreCategoria')])
            return redirect("listadocategorias")
    else:
        categoria = connection.cursor()
        categoria.execute("CALL consultarcategoria(%s)", [id_categoria])
        categoria = categoria.fetchone()
        return render(request, 'crud/editar_categoria.html', {'categoria': categoria})


# region subcategorias
def insertarsubcategorias(request):
    if request.method == "POST":
        if request.POST.get('NombresubCategoria') and request.POST.get('categoria_IdCategoria'):
            try:
                insertar = connection.cursor()
                insertar.execute("CALL insertarsubcategorias(%s, %s)", [request.POST.get('NombresubCategoria'), request.POST.get('categoria_IdCategoria')])
                messages.success(request, "Subcategoría insertada exitosamente.")
                return redirect("listadosubcategorias")
            except Exception as e:
                messages.error(request, f"Error al insertar la subcategoría: {str(e)}")
    
    categorias = connection.cursor()
    categorias.execute("SELECT IdCategoria, NombreCategoria FROM Categoria")
    categorias = categorias.fetchall()
    return render(request, 'crud/subcategorias.html', {'categorias': categorias})

def listadosubcategorias(request):
    categorias = connection.cursor()
    categorias.execute("SELECT IdCategoria, nombreCategoria FROM Categoria")
    categorias = categorias.fetchall()

    subcategorias = connection.cursor()
    subcategorias.execute("""
        SELECT s.id, s.NombresubCategoria, c.NombreCategoria
        FROM Subcategoria s
        JOIN Categoria c ON s.categoria_id = c.id
    """)
    subcategorias = subcategorias.fetchall()

    return render(request, 'crud/subcategorias.html', {'categorias': categorias, 'subcategorias': subcategorias})



def listadosubcategorias(request):
    categorias = connection.cursor()
    categorias.execute("SELECT IdCategoria, nombreCategoria FROM Categoria")
    categorias = categorias.fetchall()

    subcategorias = connection.cursor()
    subcategorias.execute("""
        SELECT s.id, s.NombresubCategoria, c.NombreCategoria
        FROM Subcategoria s
        JOIN Categoria c ON s.categoria_id = c.id
    """)
    subcategorias = subcategorias.fetchall()

    return render(request, 'crud/subcategorias.html', {'categorias': categorias, 'subcategorias': subcategorias})

def borrarsubcategoria(request, id_subcategoria):
    try:
        borrar = connection.cursor()
        borrar.execute("CALL borrarsubcategoria(%s)", [id_subcategoria])
        messages.success(request, "Subcategoría eliminada exitosamente.")
    except Exception as e:
        messages.error(request, f"Error al eliminar la subcategoría: {str(e)}")
    return redirect('listadosubcategorias')

def actualizarsubcategoria(request, id_subcategoria):
    if request.method == "POST":
        if request.POST.get('NombresubCategoria') and request.POST.get('categoria_IdCategoria'):
            try:
                actualizar = connection.cursor()
                actualizar.execute("CALL actualizarsubcategoria(%s, %s, %s)", [id_subcategoria, request.POST.get('NombresubCategoria'), request.POST.get('categoria_IdCategoria')])
                messages.success(request, "Subcategoría actualizada exitosamente.")
            except Exception as e:
                messages.error(request, f"Error al actualizar la subcategoría: {str(e)}")
            return redirect('listadosubcategorias')
    else:
        subcategoria = connection.cursor()
        subcategoria.execute("CALL consultarsubcategoria(%s)", [id_subcategoria])
        subcategoria = subcategoria.fetchone()

        categorias = connection.cursor()
        categorias.execute("SELECT IdCategoria, NombreCategoria FROM Categoria")
        categorias = categorias.fetchall()

        return render(request, 'crud/editar_subcategoria.html', {'subcategoria': subcategoria, 'categorias': categorias})


#endregion
# region login
def insertarusuarios(request):
    if request.method == "POST":
        primer_nombre = request.POST.get('nombre')
        otros_nombres = request.POST.get('otros_nombres', '')
        primer_apellido = request.POST.get('apellido1')
        segundo_apellido = request.POST.get('apellido2')
        correo = request.POST.get('email')
        nombre_usuario = request.POST.get('usuario')
        contraseña = request.POST.get('password')
        id_rol = 3  

        try:
            cursor = connection.cursor()
            cursor.execute("""
                CALL insertarusuario(%s, %s, %s, %s, %s, %s, %s, %s)
            """, [primer_nombre, otros_nombres, primer_apellido, segundo_apellido, correo, nombre_usuario, contraseña, id_rol])
            messages.success(request, "Usuario registrado exitosamente.")
            return redirect('login')
        except Exception as e:
            messages.error(request, f"Error al registrar el usuario: {str(e)}")
    
    return render(request, 'login/registro.html')

#endregion
# region correos
def enviar_codigo_correo(correo):
    codigo = random.randint(100000, 999999)  # Generar un código de 6 dígitos
    cursor = connection.cursor()
    cursor.execute("INSERT INTO codigos_recuperacion (correo, codigo) VALUES (%s, %s)", [correo, codigo])
    
    servidor = smtplib.SMTP('smtp.gmail.com', 587)
    servidor.starttls()
    servidor.login(settings.EMAIL_HOST_USER, settings.EMAIL_HOST_PASSWORD)
    mensaje = f"Tu código de recuperación es: {codigo}. Haz clic en el siguiente enlace para continuar: http://tu_dominio/verificar_codigo/{codigo}/"
    servidor.sendmail(settings.EMAIL_HOST_USER, correo, mensaje)
    servidor.quit()

def recuperarContraseña(request):
    if request.method == "POST":
        correo = request.POST.get('email')
        enviar_codigo_correo(correo)
        messages.success(request, "Se ha enviado un código de recuperación a tu correo.")
        return redirect('login')
    return render(request, 'login/recuperarcontraseña.html')

def verificar_codigo(request, codigo):
    cursor = connection.cursor()
    cursor.execute("SELECT correo FROM codigos_recuperacion WHERE codigo = %s", [codigo])
    resultado = cursor.fetchone()
    
    if resultado:
        return redirect('login')
    else:
        return HttpResponse("Código inválido o expirado.")

#endregion
def perfiles(request):
    return render(request, 'perfiles.html')

def crudCategorias(request):
    return render(request, 'crud/categorias.html')

def crudSubCategorias(request):
    return render(request, 'crud/subcategorias.html')

def crudProductos(request):
    return render(request, 'crud/productos.html')

def crudDomiciliarios(request):
    return render(request, 'crud/domiciliarios.html')

def crudUsuarios(request):
    return render(request, 'crud/usuarios.html')

def login(request):
    return render(request, 'login/login.html')

def registro(request):
    return render(request, 'login/registro.html')



