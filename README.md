---------
# organizador_ficheros
* Script desarrollado en bash
*********************************************
* Diseñado por SUKIGSX
* Contacto: scripts@mbbsistemas.es
*********************************************

Este script es útil para organizar archivos por tipo de extension en diferentes carpetas dentro de un directorio de destino, facilitando la gestión y clasificación de los archivos.

# Resumen funcional del script `OrganizadorFicheros`

## Presentación inicial
- Muestra una pantalla con:
  - **Nombre** del script
  - **Descripción**
  - **Versión**
  - **Autoría**
  - **Estado** de conexión / actualización

---

## Comprobaciones previas

### 1. Conexión a Internet
- Verifica si hay red disponible antes de continuar.

### 2. Actualización automática
- Si dispone de conexión, clona su propio repositorio de GitHub.
- Se reemplaza a sí mismo si detecta una versión más reciente.

### 3. Software imprescindible
- Comprueba que existan las siguientes herramientas: `git`, `curl`, `diff`, `ping`, `nano`, `find`.
- Si falta alguna, intenta instalarla con `apt`.

---

## Modo de uso flexible
El script acepta **cuatro parámetros** en línea de comandos:

| Parámetro           | Descripción                                               | Ejemplo                           |
|---------------------|-----------------------------------------------------------|-----------------------------------|
| `ruta_origen`       | Carpeta a escanear                                        | `/home/usuario/Descargas`         |
| `ruta_destino`      | Carpeta donde se ordenará                                 | `/home/usuario/Ordenado`          |
| `copiar` \| `mover` | Acción sobre los archivos                                 | `mover`                           |
| `borrar_si` \| `borrar_no`| Eliminar o conservar la carpeta de origen           | `borrar_si`                       |

## Instalacion  
Clonar el repositorio y ejecutar OrganizadorFicheros.sh

```  
git clone https://github.com/sukigsx/organizador_ficheros.git
```

Tambien puedes utilizar mi script (ejecutar_scripts).

```  
git clone https://github.com/sukigsx/ejecutar_scripts.git  
```
