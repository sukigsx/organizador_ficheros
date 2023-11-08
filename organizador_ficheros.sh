#!/bin/bash

#colores
#ejemplo: echo -e "${verde} La opcion (-e) es para que pille el color.${borra_colores}"

rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores
#figlet wmctrl git

#funcion de comprobar conexion a internet
#para que funciones necesita:
#   conexion ainternet
#   la paleta de colores
#   software: ping
conexion(){
if ping -c1 google.com &>/dev/null
then
    conexion="SI"
    echo ""
    echo -e " Conexion a internet = ${verde}SI${borra_colores}"
else
    conexion="NO"
    echo ""
    echo -e " Conexion a internet = ${rojo}NO${borra_colores}"
fi
}

#actualizar el script
actualizar_script(){
archivo_local="organizador_ficheros.sh" # Nombre del archivo local
ruta_repositorio="https://github.com/sukigsx/organizador_ficheros.git" #ruta del repositorio para actualizar y clonar con git clone

# Obtener la ruta del script
descarga=$(dirname "$(readlink -f "$0")")
git clone $ruta_repositorio /tmp/comprobar >/dev/null 2>&1

diff $descarga/$archivo_local /tmp/comprobar/$archivo_local >/dev/null 2>&1


if [ $? = 0 ]
then
    #esta actualizado, solo lo comprueba
    echo ""
    echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
    echo ""
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    actualizado="SI"
else
    #hay que actualizar, comprueba y actualiza
    echo ""
    echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
    echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
    sleep 3
    mv /tmp/comprobar/$archivo_local $descarga
    chmod -R +w /tmp/comprobar
    rm -R /tmp/comprobar
    echo ""
    echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
    echo -e ""
    read -p " Pulsa una tecla para continuar." pause
    exit
fi
}

#funcion software necesario
software_necesario(){
echo ""
echo -e " Comprobando el software necesario."
echo ""
software="which git diff ping figlet" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for paquete in $software
do
which $paquete 2>/dev/null 1>/dev/null 0>/dev/null #comprueba si esta el programa llamado programa
sino=$? #recojemos el 0 o 1 del resultado de which
contador="1" #ponemos la variable contador a 1
    while [ $sino -gt 0 ] #entra en el bicle si variable programa es 0, no lo ha encontrado which
    do
        if [ $contador = "4" ] || [ $conexion = "no" ] 2>/dev/null 1>/dev/null 0>/dev/null #si el contador es 4 entre en then y sino en else
        then #si entra en then es porque el contador es igual a 4 y no ha podido instalar o no hay conexion a internet
            clear
            echo ""
            echo -e " ${amarillo}NO se ha podido instalar ${rojo}$paquete${amarillo}.${borra_colores}"
            echo -e " ${amarillo}Intentelo usted con la orden: (${borra_colores}sudo apt install $paquete ${amarillo})${borra_colores}"
            echo -e ""
            echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
            echo ""; read p
            echo ""
            exit
        else #intenta instalar
            echo " Instalando $paquete. Intento $contador/3."
            sudo apt install $paquete -y 2>/dev/null 1>/dev/null 0>/dev/null
            let "contador=contador+1" #incrementa la variable contador en 1
            which $paquete 2>/dev/null 1>/dev/null 0>/dev/null #comprueba si esta el programa en tu sistema
            sino=$? ##recojemos el 0 o 1 del resultado de which
        fi
    done
echo -e " [${verde}ok${borra_colores}] $paquete."
software="SI"
done
}

# EMPIEZA LO GORDO
#wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz >/dev/null 2>&1
clear
echo ""
conexion
echo ""
if [ $conexion = "SI" ]
then
    #si hay internet
    software_necesario
    actualizar_script
else
    #no hay internet
    software_necesario
fi

sleep 2
clear
#wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
echo -e "${rosa}"; figlet -c sukigsx; echo -e "${borra_colores}"
echo ""
echo -e "${verde} Diseñado por sukigsx / Contacto:   scripts@mbbsistemas.es${borra_colores}"
echo -e "${verde}                                    https://repositorio.mbbsistemas.es/${borra_colores}"
echo ""
echo -e "${verde} Nombre del script < $? > Organiza por ext de ficheros.  ${borra_colores}"
echo ""
echo -e "${verde} Le indicas la ruta donde tienes los ficheros a organizar.  ${borra_colores}"
echo -e "${verde} Le indicas la ruta de destino que puede ser la misma.  ${borra_colores}"
echo -e "${verde} Y el solo en esa misma ruta te crea tantas carpetas como tipos de archivo ${borra_colores}"
echo -e "${verde} y mueve todos los ficheros oranizados en su carpeta.  ${borra_colores}"
echo ""

# Solicitar la ruta de entrada
read -p " Ingrese la ruta del directorio de origen: " dir_origen

# Verificar si la ruta de entrada es válida
if [ ! -d "$dir_origen" ]
then
    echo ""
    echo -e "${rojo} La ruta de origen no es válida.${borra_colores}"
    exit 1
fi

# Solicitar la ruta de salida
read -p " Ingrese la ruta del directorio de destino: " dir_destino

# Verificar si la ruta de salida es válida
if [ ! -d "$dir_destino" ]
then
    echo -e "${rojo} La ruta de destino no es válida.${borra_colores}"
    exit 1
fi

# Recorremos todos los archivos en el directorio de origen y sus subdirectorios
find "$dir_origen" -type f | while read -r file; do
    # Obtener la extensión del archivo (tipo de archivo) y convertirla a minúsculas
    file_extension=$(echo "${file##*.}" | tr '[:upper:]' '[:lower:]')

    # Crear la carpeta para el tipo de archivo si no existe en el directorio de destino
    if [ ! -d "$dir_destino/$file_extension" ]; then
        mkdir -p "$dir_destino/$file_extension"
    fi

    # Mover el archivo al directorio correspondiente en el directorio de destino
    cp "$file" "$dir_destino/$file_extension/"
done

echo ""
echo -e " Archivos copiados y organizados exitosamente.${borra_colores}"
echo ""
echo -e " Los ficheros originales estan en ${verde}$dir_origen.${borra_colores}"
echo -e " Y los organizados en ${verde}$dir_destino.${borra_colores}"
echo ""
exit
