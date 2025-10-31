#!/bin/bash

#!/bin/bash

#VARIABLES PRINCIPALES
# con export son las variables necesarias para exportar al los siguientes script
#variables para el menu_info

export NombreScript="OrganizadorFicheros"
export DescripcionDelScript="Herramienta para organizar ficheros segun la extension del mismo"
export Correo="scripts@mbbsistemas.es"
export Web="repositorio.mbbsistemas.es"
export version="1.0"
conexion="Sin comprobar"
software="Sin comprobar"
actualizado="No se ha podido comprobar la actualizacion del script"

# VARIABLE QUE RECOJEN LAS RUTAS
ruta_ejecucion=$(dirname "$(readlink -f "$0")") #es la ruta de ejecucion del script sin la / al final
ruta_escritorio=$(xdg-user-dir DESKTOP) #es la ruta de tu escritorio sin la / al final

# VARIABLES PARA LA ACTUALIZAION CON GITHUB
NombreScriptActualizar="OrganizadorFicheros.sh" #contiene el nombre del script para poder actualizar desde github
DireccionGithub="https://github.com/sukigsx/organizador_ficheros" #contiene la direccion de github para actualizar el script

#VARIABLES DE SOFTWARE NECESARIO
# Asociamos comandos con el paquete que los contiene [comando a comprobar]="paquete a instalar"
    declare -A requeridos
    requeridos=(
        [git]="git"
        [nano]="nano"
        [curl]="curl"
        [diff]="diff"
        [ping]="ping"
        [find]="find"
    )


#colores
rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e "${azul} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
echo ""
sleep 1
exit
}

menu_info(){
# muestra el menu de sukigsx
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script${borra_colores} ($NombreScript)"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion${borra_colores} ($DescripcionDelScript)"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} (Correo $Correo) (Web $Web)${borra_colores}"
echo ""
}


actualizar_script(){
    # actualizar el script
    #para que esta funcion funcione necesita:
    #   conexion a internet
    #   la paleta de colores
    #   software: git diff

    git clone $DireccionGithub /tmp/comprobar >/dev/null 2>&1

    diff $ruta_ejecucion/$NombreScriptActualizar /tmp/comprobar/$NombreScriptActualizar >/dev/null 2>&1


    if [ $? = 0 ]
    then
        #esta actualizado, solo lo comprueba
        echo ""
        echo -e "${verde} El script${borra_colores} $0 ${verde}esta actualizado.${borra_colores}"
        echo ""
        chmod -R +w /tmp/comprobar
        rm -R /tmp/comprobar
        actualizado="SI"
        sleep 2
    else
        #hay que actualizar, comprueba y actualiza
        echo ""
        echo -e "${amarillo} EL script${borra_colores} $0 ${amarillo}NO esta actualizado.${borra_colores}"
        echo -e "${verde} Se procede a su actualizacion automatica.${borra_colores}"
        sleep 3
        cp -r /tmp/comprobar/* $ruta_ejecucion
        chmod -R +w /tmp/comprobar
        rm -R /tmp/comprobar
        echo ""
        echo -e "${amarillo} El script se ha actualizado, es necesario cargarlo de nuevo.${borra_colores}"
        echo ""
        sleep 2
        exit
    fi
}


software_necesario(){
#funcion software necesario
#para que funcione necesita:
#   conexion a internet
#   la paleta de colores
#   software: which

echo ""
echo -e "${azul} Comprobando el software necesario.${borra_colores}"
echo ""
#which git diff ping figlet xdotool wmctrl nano fzf
#########software="which git diff ping figlet nano gdebi curl konsole" #ponemos el foftware a instalar separado por espacion dentro de las comillas ( soft1 soft2 soft3 etc )
for comando in "${!requeridos[@]}"; do
        which $comando &>/dev/null
        sino=$?
        contador=1
        while [ $sino -ne 0 ]; do
            if [ $contador -ge 4 ] || [ "$conexion" = "no" ]; then
                clear
                echo ""
                echo -e " ${amarillo}NO se ha podido instalar ${rojo}${requeridos[$comando]}${amarillo}.${borra_colores}"
                echo -e " ${amarillo}Inténtelo usted con: (${borra_colores}sudo apt install ${requeridos[$comando]}${amarillo})${borra_colores}"
                echo -e ""
                echo -e " ${rojo}No se puede ejecutar el script sin el software necesario.${borra_colores}"
                echo ""; read p
                echo ""
                exit 1
            else
                echo " Instalando ${requeridos[$comando]}. Intento $contador/3."
                sudo apt install ${requeridos[$comando]} -y &>/dev/null
                let "contador=contador+1"
                which $comando &>/dev/null
                sino=$?
            fi
        done
        echo -e " [${verde}ok${borra_colores}] $comando (${requeridos[$comando]})."
    done

    echo ""
    echo -e "${azul} Todo el software ${verde}OK${borra_colores}"
    software="SI"
    sleep 2
}


conexion(){
#funcion de comprobar conexion a internet
#para que funciones necesita:
#   conexion ainternet
#   la paleta de colores
#   software: ping

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


DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mostrar_ayuda() {
    echo -e "${azul} Organiza archivos por extensión desde una carpeta y sus subcarpetas.${borra_colores}"
    echo
    echo "   ruta_origen           Ruta a escanear (carpeta de origen)"
    echo "   ruta_destino          Ruta donde se organizarán los archivos"
    echo "   copiar|mover          Elige si quieres copiar o mover los archivos"
    echo "   borrar_si|borrar_no   Decide si borrar la carpeta origen después del proceso"
    echo
    echo -e "${azul} Uso:${borra_colores} bash $DIR/$0 (ruta_origen) (ruta_destino) (copiar|mover) (borrar_si|borrar_no)"
    echo -e "      Ejemplo bash $DIR/$0 /home/$(whoami)/original /home/$(whoami)/destino copiar borrar_no"
    echo ""

}

validar_rutas_peligrosas() {
    local ruta="$1"
    case "$ruta" in
        "/"|"/home"|"/root"|"/etc"|"/bin"|"/sbin"|"/usr"|"/var"|"/boot"|"/dev"|"/proc"|"/sys"|"/lib"|"/lib64"|"/opt")
            echo ""
            echo -e "❌ ${rojo}Error:${amarillo} la ruta '${borra_colores}$ruta${amarillo}' es demasiado peligrosa para usarla como origen o destino.${borra_colores}"
            echo ""
            exit 1
            ;;
    esac
}

leer_parametros() {
    read -p " Introduce la ruta a escanear (origen): " origen
    read -p " Introduce la ruta de destino: " destino
    read -p " ¿Deseas copiar o mover los archivos? (copiar/mover): " accion
    read -p " ¿Deseas borrar la carpeta origen después? (borrar_si/borrar_no): " borrar
}

organizar_archivos() {
    local origen="$1"
    local destino="$2"
    local accion="$3"
    local borrar="$4"

    validar_rutas_peligrosas "$origen"
    validar_rutas_peligrosas "$destino"

    if [[ ! -d "$origen" ]]; then
        echo ""
        echo -e " ❌ ${rojo}Error:${amarillo} la ruta de origen no existe.${borra_colores}"
        echo ""
        exit 1
    fi

    if [[ "$borrar" != "borrar_si" && "$borrar" != "borrar_no" ]]; then
        echo
        echo -e " ❌ ${amarillo}Parámetro${borra_colores} $borrar${amarillo} inválido.${borra_colores} Tiene que ser (${azul}borrar_si${borra_colores} o${azul} borrar_no${borra_colores})"
        echo ""
        exit 1
    fi

    if [[ "$accion" != "copiar" && "$accion" != "mover" ]]; then
        echo
        echo -e " ❌ ${amarillo}Parámetro${borra_colores} $accion ${amarillo}invalido.${borra_colores} Tiene que ser (${azul}copiar${borra_colores} o ${azul}mover${borra_colores})"
        echo ""
        exit 1
    fi

    mkdir -p "$destino"
    echo ""
    echo -e " 🔍 ${verde}Escaneando archivos en:${borra_colores} $origen"
    echo -e " 📁 ${verde}Destino:${borra_colores} $destino"
    echo -e " 🚚 ${verde}Acción:${borra_colores} $accion"
    echo -e " 🗑️ ${verde}Borrar carpeta origen:${borra_colores} $borrar"

    find "$origen" -type f | while read -r archivo; do
        extension="${archivo##*.}"
        if [[ "$archivo" == "$extension" ]]; then
            extension="sin_extension"
        fi
        carpeta_destino="$destino/$extension"
        mkdir -p "$carpeta_destino"

        nombre_archivo="$(basename "$archivo")"
        destino_final="$carpeta_destino/$nombre_archivo"

        # Evitar sobrescribir si ya existe
        if [[ -e "$destino_final" ]]; then
            base="${nombre_archivo%.*}"
            ext="${nombre_archivo##*.}"
            contador=1

            if [[ "$base" == "$ext" ]]; then
                ext=""
                while [[ -e "$carpeta_destino/${base}_$contador" ]]; do
                    ((contador++))
                done
                destino_final="$carpeta_destino/${base}_$contador"
            else
                while [[ -e "$carpeta_destino/${base}_$contador.$ext" ]]; do
                    ((contador++))
                done
                destino_final="$carpeta_destino/${base}_$contador.$ext"
            fi
        fi

        if [[ "$accion" == "copiar" ]]; then
            cp "$archivo" "$destino_final"
        elif [[ "$accion" == "mover" ]]; then
            mv "$archivo" "$destino_final"
        else
            echo ""
            echo -e " ❌ ${rojo}Acción no válida:${borra_colores} $accion"
            echo ""
            exit 1
        fi
    done

    if [[ "$borrar" == "borrar_si" ]]; then
        echo ""
        echo -e " 🗑️ ${verde}Borrando carpeta origen y todo su contenido...${borra_colores}"
        rm -rf "$origen"
        echo ""
    fi

    echo -e " ✅ ${verde}Organización completada con éxito.${borra_colores}"
    echo ""
    read pause
}

# === Lógica principal ===
#logica de arranque
#variables de resultado $conexion $software $actualizado
#funciones actualizar_script, conexion, software_necesario

#logica para ejecutar o no ejecutar
#comprobado conexcion
#    si=actualizar_script
#        si=software_necesario
#            si=ejecuta, poner variables a sii todo
#            no=Ya sale el solo desde la funcion
#        no=software_necesario
#            si=ejecuta, variables software="SI", conexion="SI", actualizado="No se ha podiso comprobar actualizacion de script"
#            no=Ya sale solo desde la funcion
#
#    no=software_necesario
#        si=ejecuta, variables software="SI", conexion="NO", actualizado="No se ha podiso comprobar actualizacion de script"
#        no=Ya sale solo desde la funcion


clear
menu_info
conexion
if [ $conexion = "SI" ]; then
    actualizar_script
    if [ $actualizado = "SI" ]; then
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="SI"
            export actualizado="SI"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    else
        software_necesario
        if [ $software = "SI" ]; then
            export software="SI"
            export conexion="NO"
            export actualizado="No se ha podido comprobar la actualizacion del script"
            #bash $ruta_ejecucion/ #PON LA RUTA
        else
            echo ""
        fi
    fi
else
    software_necesario
    if [ $software = "SI" ]; then
        export software="SI"
        export conexion="NO"
        export actualizado="No se ha podido comprobar la actualizacion del script"
        #bash $ruta_ejecucion/ #PON LA RUTA
    else
        echo ""
    fi
fi


DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
clear
echo ""
menu_info
if [[ $# -ne 4 ]]; then
    echo ""
    echo -e " ℹ️ ${amarillo}No se proporcionaron parámetros suficientes.${borra_colores}"
    echo -e "    La ruta del usuario${verde} $(whoami) ${borra_colores}es${verde} $HOME${borra_colores}"
    echo ""
    mostrar_ayuda
    echo
    read -p " ¿Deseas introducir los parámetros ahora? (s/n): " respuesta
    if [[ "$respuesta" == "s" || "$respuesta" == "S" ]]; then
        leer_parametros
        organizar_archivos "$origen" "$destino" "$accion" "$borrar"
    else
        ctrl_c
    fi
else
    organizar_archivos "$1" "$2" "$3" "$4"
fi
