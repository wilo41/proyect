from django.shortcuts import render, redirect, get_object_or_404
from django.db import connection
from .models import categoria, subcategoria, usuario, roles, domiciliario, producto
from django.contrib.auth.hashers import make_password, check_password
from django.db.models import Q

def LadingPage(request):
    categorias = categoria.objects.all().prefetch_related('subcategoria_set')
    username = request.session.get('username', None)
    first_name = request.session.get('first_name', None)
    return render(request, 'LadingPage.html', {
        'categorias': categorias,
        'username': username,
        'first_name': first_name
    })

#region categorias
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
# endregion


# region subcategorias
# Listado de subcategorías
def listadosubcategorias(request):
    subcategorias = subcategoria.objects.all()
    categorias = categoria.objects.all()
    return render(request, 'crud/subcategorias.html', {'subcategorias': subcategorias, 'categorias': categorias})

# Insertar subcategoría
def insertarsubcategoria(request):
    if request.method == "POST":
        if request.POST.get('nombre') and request.POST.get('categoria_id'):
            nueva_subcategoria = subcategoria()
            nueva_subcategoria.NombresubCategoria = request.POST.get('nombre')
            nueva_subcategoria.categoria = categoria.objects.get(IdCategoria=request.POST.get('categoria_id'))
            nueva_subcategoria.save()
            return redirect('listadosubcategorias')
    categorias = categoria.objects.all()
    return render(request, 'crud/subcategorias.html', {'categorias': categorias})

# Borrar subcategoría
def borrarsubcategoria(request, id_subcategoria):
    subcategoria_obj = subcategoria.objects.get(IdSubCategoria=id_subcategoria)
    subcategoria_obj.delete()
    return redirect('listadosubcategorias')

# Actualizar subcategoría
def actualizarsubcategoria(request, id_subcategoria):
    subcategoria_obj = subcategoria.objects.get(IdSubCategoria=id_subcategoria)
    if request.method == "POST":
        if request.POST.get('nombre') and request.POST.get('categoria_id'):
            subcategoria_obj.NombresubCategoria = request.POST.get('nombre')
            subcategoria_obj.categoria = categoria.objects.get(IdCategoria=request.POST.get('categoria_id'))
            subcategoria_obj.save()
            return redirect('listadosubcategorias')
    else:
        categorias = categoria.objects.all()
        return render(request, 'crud/subcategorias.html', {'subcategoria': subcategoria_obj, 'categorias': categorias})
#endregion


# region login
def registro(request):
    if request.method == "POST":
        if (request.POST.get('PrimerNombre') and request.POST.get('OtrosNombres') and 
            request.POST.get('PrimerApellido') and request.POST.get('SegundoApellido') and 
            request.POST.get('Correo') and request.POST.get('NombreUsuario') and 
            request.POST.get('Contraseña')):
            
            rol_default = roles.objects.get(IdRol=3)  # Asigna el rol predeterminado
            nuevo_usuario = usuario(
                PrimerNombre=request.POST.get('PrimerNombre'),
                OtrosNombres=request.POST.get('OtrosNombres'),
                PrimerApellido=request.POST.get('PrimerApellido'),
                SegundoApellido=request.POST.get('SegundoApellido'),
                Correo=request.POST.get('Correo'),
                NombreUsuario=request.POST.get('NombreUsuario'),
                Contraseña=make_password(request.POST.get('Contraseña')),
                idRol=rol_default  # Asegurarse de que el rol sea 3
            )   
            nuevo_usuario.save()
            return redirect('login')
    return render(request, 'login/registro.html') 


def login(request):
    if request.method == "POST":
        correo = request.POST.get('correo')
        contraseña = request.POST.get('contraseña')

        # Buscar usuario
        try:
            user = usuario.objects.get(Correo=correo)
            if check_password(contraseña, user.Contraseña):
                request.session['user_id'] = user.IdUsuario
                request.session['username'] = user.NombreUsuario
                request.session['nombre'] = f"{user.PrimerNombre} {user.PrimerApellido}"
                return redirect('Ladingpage')
        except usuario.DoesNotExist:
            pass

        # Buscar domiciliario
        try:
            domi = domiciliario.objects.get(Correo=correo)
            if check_password(contraseña, domi.Contraseña):
                request.session['user_id'] = domi.IdDomiciliario
                request.session['username'] = domi.NombreDomiciliario
                request.session['nombre'] = domi.NombreDomiciliario
                return redirect('Ladingpage')
        except domiciliario.DoesNotExist:
            pass

        return render(request, 'login/login.html', {'error': 'Credenciales inválidas'})
    
    return render(request, 'login/login.html')

from django.contrib import messages

def logout(request):
    request.session.flush()
    messages.success(request, "Has cerrado sesión correctamente.")  # Mensaje de confirmación
    return redirect('Ladingpage')


def insertarusuario(request):
    if request.method == "POST":
        if (request.POST.get('PrimerNombre') and request.POST.get('OtrosNombres') and
            request.POST.get('PrimerApellido') and request.POST.get('SegundoApellido') and
            request.POST.get('Correo') and request.POST.get('NombreUsuario') and
            request.POST.get('Contraseña')):

            rol_default = roles.objects.get(IdRol=3)  # Asigna el rol predeterminado
            nuevo_usuario = usuario(
                PrimerNombre=request.POST.get('PrimerNombre'),
                OtrosNombres=request.POST.get('OtrosNombres'),
                PrimerApellido=request.POST.get('PrimerApellido'),
                SegundoApellido=request.POST.get('SegundoApellido'),
                Correo=request.POST.get('Correo'),
                NombreUsuario=request.POST.get('NombreUsuario'),
                Contraseña=make_password(request.POST.get('Contraseña')),
                idRol=rol_default
            )
            nuevo_usuario.save()
            return redirect('crudUsuarios')  # Redirige a la lista de usuarios
    return redirect('crudUsuarios')


def editarusuario(request, id_usuario):
    usuario_obj = usuario.objects.get(IdUsuario=id_usuario)
    if request.method == "POST":
        usuario_obj.PrimerNombre = request.POST.get('PrimerNombre')
        usuario_obj.OtrosNombres = request.POST.get('OtrosNombres')
        usuario_obj.PrimerApellido = request.POST.get('PrimerApellido')
        usuario_obj.SegundoApellido = request.POST.get('SegundoApellido')
        usuario_obj.Correo = request.POST.get('Correo')
        usuario_obj.NombreUsuario = request.POST.get('NombreUsuario')
        if request.POST.get('Contraseña'):
            usuario_obj.Contraseña = make_password(request.POST.get('Contraseña'))
        usuario_obj.save()
        return redirect('crudUsuarios')
    return render(request, 'crud/editar_usuario.html', {'usuario': usuario_obj})


def borrarusuario(request, id_usuario):
    usuario_obj = usuario.objects.get(IdUsuario=id_usuario)
    usuario_obj.delete()
    return redirect('crudUsuarios')

        
#endregion


#region domiciliario
# Insertar domiciliario
def insertardomiciliario(request):
    if request.method == "POST":
        try:
            # Asignar automáticamente el rol de domiciliario
            rol_domiciliario = roles.objects.get(IdRol=2)

            # Crear el domiciliario con los datos del formulario
            nuevo_domiciliario = domiciliario(
                TipoDocumento=request.POST.get('TipoDocumento'),
                Documento=request.POST.get('Documento'),
                NombreDomiciliario=request.POST.get('NombreDomiciliario'),
                PrimerApellido=request.POST.get('PrimerApellido'),
                SegundoApellido=request.POST.get('SegundoApellido'),
                Celular=request.POST.get('Celular'),
                Ciudad=request.POST.get('Ciudad'),  # Captura la ciudad
                Correo=request.POST.get('Correo'),
                Contraseña=make_password(request.POST.get('Contraseña')),
                IdRol=rol_domiciliario  # Asignar el rol de domiciliario
            )

            nuevo_domiciliario.save()

            return redirect('crudDomiciliarios')
        except roles.DoesNotExist:
            return render(request, 'crud/insertar_domiciliario.html', {'error': 'El rol especificado no existe en el sistema.'})
    
    return render(request, 'crud/insertar_domiciliario.html')




def editardomiciliario(request, id_domiciliario):
    domiciliario_obj = get_object_or_404(domiciliario, IdDomiciliario=id_domiciliario)
    
    if request.method == "POST":
        domiciliario_obj.TipoDocumento = request.POST.get('TipoDocumento')
        domiciliario_obj.Documento = request.POST.get('Documento')
        domiciliario_obj.NombreDomiciliario = request.POST.get('NombreDomiciliario')
        domiciliario_obj.PrimerApellido = request.POST.get('PrimerApellido')
        domiciliario_obj.SegundoApellido = request.POST.get('SegundoApellido')
        domiciliario_obj.Celular = request.POST.get('Celular')
        domiciliario_obj.Ciudad = request.POST.get('Ciudad')
        domiciliario_obj.Correo = request.POST.get('Correo')
        if request.POST.get('Contraseña'):
            domiciliario_obj.Contraseña = make_password(request.POST.get('Contraseña'))
        domiciliario_obj.save()
        return redirect('crudDomiciliarios')
    
    return render(request, 'crud/editar_domiciliario.html', {'domiciliario': domiciliario_obj})




# Borrar domiciliario
def borrardomiciliario(request, id_domiciliario):
    domiciliario_obj = domiciliario.objects.get(IdDomiciliario=id_domiciliario)
    domiciliario_obj.delete()
    return redirect('crudDomiciliarios')

#endregion


#region productos
def insertarproducto(request):
    if request.method == "POST":
        if (request.POST.get('Nombre') and request.POST.get('Descripcion') and
            request.POST.get('Precio') and request.POST.get('Cantidad') and
            request.POST.get('FechaVence') and request.POST.get('IdSubCategoria')):
            
            nuevo_producto = producto(
                Nombre=request.POST.get('Nombre'),
                Descripcion=request.POST.get('Descripcion'),
                Precio=request.POST.get('Precio'),
                Cantidad=request.POST.get('Cantidad'),
                FechaVence=request.POST.get('FechaVence'),
                IdSubCategoria=subcategoria.objects.get(IdSubCategoria=request.POST.get('IdSubCategoria')),
                Img=request.FILES.get('Img')
            )
            nuevo_producto.save()
            return redirect('crudProductos')
    return render(request, 'crud/productos.html')

def editarproducto(request, id_producto):
    producto_obj = get_object_or_404(producto, IdProducto=id_producto)
    if request.method == "POST":
        producto_obj.Nombre = request.POST.get('Nombre')
        producto_obj.Descripcion = request.POST.get('Descripcion')
        producto_obj.Precio = request.POST.get('Precio')
        producto_obj.Cantidad = request.POST.get('Cantidad')
        producto_obj.FechaVence = request.POST.get('FechaVence')
        if request.POST.get('IdSubCategoria'):
            producto_obj.IdSubCategoria = subcategoria.objects.get(IdSubCategoria=request.POST.get('IdSubCategoria'))
        if request.FILES.get('Img'):
            producto_obj.Img = request.FILES.get('Img')
        producto_obj.save()
        return redirect('crudProductos')
    return render(request, 'crud/editar_producto.html', {'producto': producto_obj})

def borrarproducto(request, id_producto):
    producto_obj = get_object_or_404(producto, IdProducto=id_producto)
    producto_obj.delete()
    return redirect('crudProductos')
#endregion


def perfiles(request):
    if not request.session.get('user_id'):
        return redirect('login')
    
    try:
        user = usuario.objects.get(IdUsuario=request.session['user_id'])
        
        if request.method == 'POST':
            # Verificar si es una actualización de datos o solo de imagen
            if 'profile-pic' in request.FILES:
                # Solo actualizar imagen
                user.imagen_perfil = request.FILES['profile-pic']
                user.save()
                return JsonResponse({
                    'status': 'success',
                    'new_image_url': user.imagen_perfil.url if user.imagen_perfil else '/static/img/perfil.png'
                })
            else:
                # Actualizar datos del perfil
                user.PrimerNombre = request.POST.get('primerNombre', user.PrimerNombre)
                user.OtrosNombres = request.POST.get('segundoNombre', user.OtrosNombres)
                user.PrimerApellido = request.POST.get('primerApellido', user.PrimerApellido)
                user.SegundoApellido = request.POST.get('segundoApellido', user.SegundoApellido)
                user.NombreUsuario = request.POST.get('nombreUsuario', user.NombreUsuario)
                
                if request.POST.get('contrasena'):
                    user.Contraseña = make_password(request.POST.get('contrasena'))
                
                user.save()
                request.session['nombre'] = f"{user.PrimerNombre} {user.PrimerApellido}"
                return redirect('perfiles')
        
        return render(request, 'perfiles.html', {
            'usuario': user,
            'imagen_perfil': user.imagen_perfil.url if user.imagen_perfil else '/static/img/perfil.png'
        })
        
    except usuario.DoesNotExist:
        return redirect('login')

from django.http import JsonResponse

def eliminar_foto_perfil(request):
    if request.method == 'POST' and request.session.get('user_id'):
        try:
            user = usuario.objects.get(IdUsuario=request.session['user_id'])
            if user.imagen_perfil:
                user.imagen_perfil.delete()
                user.imagen_perfil = None
                user.save()
            return JsonResponse({
                'status': 'success',
                'new_image_url': '/static/img/perfil.png'
            })
        except usuario.DoesNotExist:
            pass
    return JsonResponse({'status': 'error'}, status=400)




def crudCategorias(request):
    return render(request, 'crud/categorias.html')

def crudSubCategorias(request):
    subcategorias = subcategoria.objects.all()
    categorias = categoria.objects.all()
    return render(request, 'crud/subcategorias.html', {'subcategorias': subcategorias, 'categorias': categorias})

def crudProductos(request):
    productos = producto.objects.all()  # Obtener todos los productos
    subcategorias = subcategoria.objects.all()  # Obtener todas las subcategorías
    return render(request, 'crud/productos.html', {'productos': productos, 'subcategorias': subcategorias})

def crudDomiciliarios(request):
    domiciliarios = domiciliario.objects.filter(IdRol=2)  
    return render(request, 'crud/domiciliarios.html', {'domiciliarios': domiciliarios})


def crudUsuarios(request):
    usuarios = usuario.objects.filter(idRol=3)  
    return render(request, 'crud/usuarios.html', {'usuarios': usuarios})


def recuperarContraseña(request):
    return render(request, 'login/recuperarcontraseña.html')

def pedido(request):
    return render(request, 'pedido.html')

def codigo(request):
    return render(request, 'login/codigo.html')

def nuevaContraseña(request):
    return render(request, 'login/nuevaContraseña.html')



def carrito(request):
    return render(request, 'carrito/carrito.html')

def lencerias(request):
    # Obtener la categoría de lencería
    categoria_lenceria = categoria.objects.get(NombreCategoria='Lencería')
    
    # Filtrar productos que pertenecen a la categoría de lencería o a sus subcategorías
    productos = producto.objects.filter(IdSubCategoria__categoria=categoria_lenceria)
    
    return render(request, 'carrito/lencerias.html', {'productos': productos})

def vibradores(request):
    # Obtener la categoría de vibradores
    categoria_vibrador = categoria.objects.get(NombreCategoria='vibradores')  # Cambiado a get
    
    # Filtrar productos que pertenecen a la categoría de vibradores o a sus subcategorías
    productos = producto.objects.filter(IdSubCategoria__categoria=categoria_vibrador)
    
    return render(request, 'carrito/vibradores.html', {'productos': productos})

def disfraces(request):
    # Obtener la categoría de disfraces
    categoria_disfraces = categoria.objects.get(NombreCategoria='Lencería')  # Cambiado a 'Lencería'
    
    # Filtrar productos que pertenecen a la categoría de lencería o a sus subcategorías
    productos = producto.objects.filter(IdSubCategoria__categoria=categoria_disfraces)
    
    return render(request, 'carrito/disfraces.html', {'productos': productos})

def dildos(request):
    # Obtener la categoría de dildos
    categoria_dildo = categoria.objects.get(NombreCategoria='Dildos')  # Cambiado a get
    
    # Filtrar productos que pertenecen a la categoría de dildos o a sus subcategorías
    productos = producto.objects.filter(IdSubCategoria__categoria=categoria_dildo)
    
    return render(request, 'carrito/dildos.html', {'productos': productos})

def productosCarrito(request):
    productos = producto.objects.all()  # Obtener todos los productos
    return render(request, 'carrito/productos.html', {'productos': productos})




