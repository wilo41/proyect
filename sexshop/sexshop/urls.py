"""
URL configuration for sexshop project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from sexshop.views import LadingPage, listadocategorias, insertarcategorias, borrarcategoria, actualizarcategoria, perfiles, crudCategorias, crudSubCategorias, crudProductos, crudDomiciliarios, crudUsuarios, login, registro, recuperarContraseña, insertarsubcategorias, listadosubcategorias, borrarsubcategoria, actualizarsubcategoria, insertarusuarios, verificar_codigo

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', LadingPage, name='Ladingpage'),
    path('listadocategorias/', listadocategorias, name='listadocategorias'),
    path('insertarcategorias/', insertarcategorias, name='insertarcategorias'),
    path('categorias/borrar/<int:id_categoria>/', borrarcategoria, name='borrarcategoria'),
    path('categorias/actualizar/<int:id_categoria>/', actualizarcategoria, name='actualizarcategoria'),
    path('registro/', registro, name='registro'),
    path('perfiles/', perfiles, name='perfiles'),
    path('crud/categorias', crudCategorias,  name='crudCategorias' ),
    path('crud/subcategorias', crudSubCategorias, name='crudSubCategorias' ),
    path('insertarsubcategorias/', insertarsubcategorias, name='insertarsubcategorias'),
    path('listadosubcategorias/', listadosubcategorias, name='listadosubcategorias'),
    path('subcategorias/borrar/<int:id_subcategoria>/', borrarsubcategoria, name='borrarsubcategoria'),
    path('subcategorias/actualizar/<int:id_subcategoria>/', actualizarsubcategoria, name='actualizarsubcategoria'),
    path('crud/productos', crudProductos, name='crudProductos' ),
    path('crud/domiciliarios', crudDomiciliarios, name='crudDomiciliarios' ),
    path('crud/usuarios', crudUsuarios, name='crudUsuarios' ),
    path('login', login, name='login'),
    path('registro', registro, name='registro'),
    path('login/recuperarContraseña',recuperarContraseña, name='recuperarContraseña'),
    path('insertarusuarios/', insertarusuarios, name='insertarusuarios'),
    path('verificar_codigo/<int:codigo>/', verificar_codigo, name='verificar_codigo'),
]