#!/bin/bash

#toma el control al pulsar control + c
trap ctrl_c INT
function ctrl_c()
{
clear
echo ""
echo -e "${verde} GRACIAS POR UTILIZAR MI SCRIPT${borra_colores}"
echo ""
exit
}

menu_info(){
#muestra el menu de sukigsx
echo ""
echo -e "${rosa}            _    _                  ${azul}   Nombre del script${borra_colores} ( $0 )"
echo -e "${rosa}  ___ _   _| | _(_) __ _ _____  __  ${azul}   Descripcion${borra_colores} (Organiza archivos por extension)"
echo -e "${rosa} / __| | | | |/ / |/ _\ / __\ \/ /  ${azul}   Version            =${borra_colores} $version"
echo -e "${rosa} \__ \ |_| |   <| | (_| \__ \>  <   ${azul}   Conexion Internet  =${borra_colores} $conexion"
echo -e "${rosa} |___/\__,_|_|\_\_|\__, |___/_/\_\  ${azul}   Software necesario =${borra_colores} $software"
echo -e "${rosa}                  |___/             ${azul}   Actualizado        =${borra_colores} $actualizado"
echo -e ""
echo -e "${azul} Contacto:${borra_colores} (Correo scripts@mbbsistemas.com) (Web https://repositorio.mbbsistemas.es)${borra_colores}"
echo ""
}

#colores
#ejemplo: echo -e "${verde} La opcion (-e) es para que pille el color.${borra_colores}"

rojo="\e[0;31m\033[1m" #rojo
verde="\e[;32m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
rosa="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
borra_colores="\033[0m\e[0m" #borra colores

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
}

# === Lógica principal ===
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
