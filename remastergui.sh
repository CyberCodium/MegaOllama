#!/bin/bash

# ╔══════════════════════════════════════════════════════════════════╗
# ║         MEGAOLLAMA - REMASTER GUI EDITION                       ║
# ║         Instalador Gráfico de Modelos Ollama                    ║
# ║                                                                  ║
# ║   Interfaz gráfica para gestión de +3000 modelos Ollama         ║
# ║   Carga catálogo desde archivo modelos.txt                      ║
# ║                                                                  ║
# ║   Copyright  ©  E.B.G  |  2026  |  All Rights Reserved         ║
# ║   Proprietary Software – Uso No Comercial                       ║
# ║                                                                  ║
# ║   - Sección especializada CIBERSEGURIDAD                        ║
# ║   - Sección especializada PROGRAMACIÓN                          ║
# ║   - Instalación por RAM disponible                              ║
# ╚══════════════════════════════════════════════════════════════════╝

# ------------------------------
# CONFIGURACIÓN DE COLORES
# ------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# ------------------------------
# VERIFICAR DEPENDENCIAS GUI
# ------------------------------
check_gui_deps() {
    if command -v whiptail &>/dev/null; then
        GUI_TOOL="whiptail"
    elif command -v dialog &>/dev/null; then
        GUI_TOOL="dialog"
    else
        echo -e "${RED}❌ ERROR: Se requiere 'whiptail' o 'dialog' para la interfaz gráfica.${NC}"
        echo ""
        echo "  Instala con:"
        echo -e "  ${CYAN}sudo apt install whiptail${NC}   (Debian/Ubuntu)"
        echo -e "  ${CYAN}sudo dnf install newt${NC}       (Fedora/RHEL)"
        echo ""
        exit 1
    fi
}

# ------------------------------
# PALABRAS CLAVE – CIBERSEGURIDAD
# ------------------------------
SECURITY_KEYWORDS=(
    "seguridad" "hacking" "pentesting" "offensive" "cybersecurity"
    "redteam" "blueteam" "exploit" "malware" "forensics" "vulnerability"
    "cve" "metasploit" "nmap" "burp" "wireshark" "kali" "parrot"
    "oscp" "osce" "ceh" "gpen" "penetration" "recon" "osint"
    "sqli" "xss" "csrf" "ssrf" "rce" "lfi" "idor" "xxe"
    "reverse engineering" "disassembly" "decompilation" "yara"
    "hashcat" "john" "hydra" "sqlmap" "nikto" "dirb"
    "cloud security" "aws security" "azure security" "gcp security"
    "container security" "kubernetes" "docker" "iot security"
    "mobile security" "android" "frida" "mobsf"
    "password" "bruteforce" "dictionary" "rainbow"
    "social engineering" "phishing" "spear" "whaling"
    "wireless" "wifi" "wpa2" "wpa3" "aircrack" "kismet"
    "crypto" "cryptography" "tls" "ssl" "certificate"
    "compliance" "gdpr" "hipaa" "pci" "iso" "nist"
)

# ------------------------------
# PALABRAS CLAVE – PROGRAMACIÓN
# ------------------------------
PROGRAMMING_KEYWORDS=(
    "programación" "código" "coding" "developer" "programmer"
    "python" "javascript" "java" "cpp" "csharp" "go" "rust" "php"
    "ruby" "swift" "kotlin" "typescript" "sql" "html" "css"
    "bash" "shell" "powershell" "scripting"
    "codellama" "codegemma" "starcoder" "wizardcoder" "qwen coder"
    "deepseek coder" "codebooga" "replit" "instruct code" "codegen"
    "soulcoder" "phind" "stablelm" "dolly" "mpt" "falcon"
    "baichuan" "internlm" "xverse" "llama" "mistral" "gemma" "phi"
    "math" "matemáticas" "reasoning" "razonamiento"
)

# ------------------------------
# VARIABLES GLOBALES DEL CATÁLOGO
# ------------------------------
declare -A MODELOS_RAM
declare -A MODELOS_CAT
declare -A MODELOS_DESC
declare -A MODELOS_SIZE
declare -A MODELOS_SIZE_HUMAN

# ------------------------------
# FUNCIONES DE CÁLCULO Y FORMATO
# ------------------------------
calc_ram() {
    local size=$1
    if [[ $size -eq 0 ]]; then
        echo "Desconocida"
    elif [[ $size -lt 2000000000 ]]; then
        echo "2 GB"
    elif [[ $size -lt 5000000000 ]]; then
        echo "4-6 GB"
    elif [[ $size -lt 9000000000 ]]; then
        echo "8-12 GB"
    elif [[ $size -lt 20000000000 ]]; then
        echo "16-24 GB"
    elif [[ $size -lt 40000000000 ]]; then
        echo "32-48 GB"
    else
        echo "64 GB+"
    fi
}

format_size() {
    local bytes=$1
    if [[ $bytes -eq 0 ]]; then
        echo "Desconocido"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "${bytes} B"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$(echo "scale=2; $bytes/1048576" | bc) MB"
    else
        echo "$(echo "scale=2; $bytes/1073741824" | bc) GB"
    fi
}

# ------------------------------
# CARGAR CATÁLOGO DESDE ARCHIVO
# ------------------------------
load_catalog() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local catalog_file="$script_dir/modelos.txt"

    if [[ ! -f "$catalog_file" ]]; then
        $GUI_TOOL --title "❌ ERROR" --msgbox \
            "No se encontró el archivo:\n$catalog_file\n\nCrea modelos.txt en la misma carpeta que este script." \
            12 60
        exit 1
    fi

    local line_number=0
    local loaded=0
    local skipped=0

    while IFS= read -r line; do
        ((line_number++))
        [[ -z "$line" ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*// ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*const ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*\] ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*}[[:space:]]*,?$ ]] && { ((skipped++)); continue; }

        if [[ "$line" =~ name: ]]; then
            local name size category description
            name=$(echo "$line" | sed -n 's/.*name:[[:space:]]*"\([^"]*\)".*/\1/p')
            size=$(echo "$line" | sed -n 's/.*size:[[:space:]]*\([0-9]*\).*/\1/p')
            category=$(echo "$line" | sed -n 's/.*category:[[:space:]]*"\([^"]*\)".*/\1/p')
            description=$(echo "$line" | sed -n 's/.*description:[[:space:]]*"\([^"]*\)".*/\1/p')

            if [[ -n "$name" && -n "$size" && -n "$category" && -n "$description" ]]; then
                MODELOS_RAM["$name"]=$(calc_ram "$size")
                MODELOS_CAT["$name"]="$category"
                MODELOS_DESC["$name"]="$description"
                MODELOS_SIZE["$name"]="$size"
                MODELOS_SIZE_HUMAN["$name"]=$(format_size "$size")
                ((loaded++))
            else
                ((skipped++))
            fi
        fi
    done < "$catalog_file"

    echo -e "${GREEN}✅ Catálogo cargado: $loaded modelos${NC}"
}

# ------------------------------
# INSTALAR MODELO SELECCIONADO
# ------------------------------
instalar_modelo() {
    local model="$1"
    clear
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║    ${BOLD}MEGAOLLAMA - REMASTER GUI  |  E.B.G  |  2026          ║${NC}"
    echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}→ Instalando: ${BOLD}$model${NC}"
    echo -e "  Tamaño : ${MODELOS_SIZE_HUMAN[$model]}"
    echo -e "  RAM    : ${MODELOS_RAM[$model]}"
    echo -e "  Categ. : ${MODELOS_CAT[$model]}"
    echo ""
    ollama pull "$model"
    echo ""
    read -rp "✅ Instalación completada. Presiona ENTER para volver..."
}

# ------------------------------
# MENÚ DE SELECCIÓN DE MODELOS (GUI)
# ------------------------------
gui_seleccionar_modelos() {
    local title="$1"
    shift
    local models_array=("$@")
    local total=${#models_array[@]}

    if [[ $total -eq 0 ]]; then
        $GUI_TOOL --title "Sin resultados" --msgbox "No se encontraron modelos." 8 40
        return
    fi

    # Construir lista para whiptail/dialog (tag item status)
    local checklist_items=()
    for m in "${models_array[@]}"; do
        local label="${m} [${MODELOS_SIZE_HUMAN[$m]} | RAM: ${MODELOS_RAM[$m]}]"
        checklist_items+=("$m" "$label" "OFF")
    done

    local selected
    selected=$($GUI_TOOL --title "$title" \
        --checklist "Selecciona modelos (ESPACIO para marcar, ENTER para confirmar):" \
        30 90 20 \
        "${checklist_items[@]}" \
        3>&1 1>&2 2>&3) || return

    [[ -z "$selected" ]] && return

    # Limpiar comillas del output de whiptail
    local models_to_install
    IFS=' ' read -ra models_to_install <<< "$(echo "$selected" | tr -d '"')"

    for model in "${models_to_install[@]}"; do
        instalar_modelo "$model"
    done
}

# ------------------------------
# MENÚ PRINCIPAL (GUI)
# ------------------------------
menu_principal() {
    while true; do
        local choice
        choice=$($GUI_TOOL --title "MEGAOLLAMA – Remaster GUI  |  E.B.G  |  2026" \
            --menu "Selecciona una opción:" \
            22 70 12 \
            "1" "📥  Instalar modelos principales (selección múltiple)" \
            "2" "🔍  Buscar modelo por nombre" \
            "3" "📂  Buscar por categoría" \
            "4" "📋  Lista completa de modelos" \
            "5" "💾  Instalar según RAM disponible" \
            "6" "🗑️   Desinstalar modelo" \
            "7" "📊  Ver modelos instalados" \
            "8" "🔒  Modelos de Ciberseguridad" \
            "9" "💻  Modelos de Programación" \
            "10" "❌  Salir" \
            3>&1 1>&2 2>&3) || break

        case "$choice" in
            1) gui_instalar_principales ;;
            2) gui_buscar_nombre ;;
            3) gui_buscar_categoria ;;
            4) gui_lista_completa ;;
            5) gui_instalar_por_ram ;;
            6) gui_desinstalar ;;
            7) gui_ver_instalados ;;
            8) gui_ciberseguridad ;;
            9) gui_programacion ;;
            10) break ;;
        esac
    done
    clear
    echo -e "${GREEN}👋 ¡Hasta pronto! – MegaOllama Remaster GUI  |  E.B.G  |  2026${NC}"
    echo ""
}

# ------------------------------
# OPCIÓN 1 – MODELOS PRINCIPALES
# ------------------------------
PRINCIPALES=(
    "llama3.1:8b" "llama3:8b" "mistral:7b" "phi3:mini"
    "deepseek-coder:1.3b" "qwen:1.5b" "tinyllama:1.1b"
    "gemma:2b" "llama2:7b" "codellama:7b"
)

gui_instalar_principales() {
    gui_seleccionar_modelos "📥 Modelos Principales Recomendados" "${PRINCIPALES[@]}"
}

# ------------------------------
# OPCIÓN 2 – BUSCAR POR NOMBRE
# ------------------------------
gui_buscar_nombre() {
    local query
    query=$($GUI_TOOL --title "🔍 Buscar por nombre" \
        --inputbox "Introduce parte del nombre del modelo:" \
        8 60 "" 3>&1 1>&2 2>&3) || return

    [[ -z "$query" ]] && return

    local found=()
    for m in "${!MODELOS_RAM[@]}"; do
        [[ "$m" == *"$query"* ]] && found+=("$m")
    done

    IFS=$'\n' found=($(sort <<<"${found[*]}")); unset IFS
    gui_seleccionar_modelos "🔍 Resultados: '$query'" "${found[@]}"
}

# ------------------------------
# OPCIÓN 3 – BUSCAR POR CATEGORÍA
# ------------------------------
gui_buscar_categoria() {
    local cat
    cat=$($GUI_TOOL --title "📂 Buscar por categoría" \
        --inputbox "Introduce la categoría (ej: Programación, Chat, Seguridad):" \
        8 65 "" 3>&1 1>&2 2>&3) || return

    [[ -z "$cat" ]] && return

    local found=()
    for m in "${!MODELOS_CAT[@]}"; do
        [[ "${MODELOS_CAT[$m]}" == *"$cat"* ]] && found+=("$m")
    done

    IFS=$'\n' found=($(sort <<<"${found[*]}")); unset IFS
    gui_seleccionar_modelos "📂 Categoría: '$cat'" "${found[@]}"
}

# ------------------------------
# OPCIÓN 4 – LISTA COMPLETA
# ------------------------------
gui_lista_completa() {
    local all_models=()
    for m in "${!MODELOS_RAM[@]}"; do
        all_models+=("$m")
    done
    IFS=$'\n' all_models=($(sort <<<"${all_models[*]}")); unset IFS
    gui_seleccionar_modelos "📋 Lista Completa (${#all_models[@]} modelos)" "${all_models[@]}"
}

# ------------------------------
# OPCIÓN 5 – INSTALAR POR RAM
# ------------------------------
gui_instalar_por_ram() {
    local ram_choice
    ram_choice=$($GUI_TOOL --title "💾 Instalar según RAM" \
        --menu "¿Cuánta RAM tiene tu sistema?" \
        16 55 6 \
        "2"  "2 GB  – modelos muy ligeros" \
        "4"  "4 GB  – modelos compactos" \
        "8"  "8 GB  – modelos medianos" \
        "16" "16 GB – modelos avanzados" \
        "32" "32 GB – modelos grandes" \
        "64" "64 GB – modelos muy grandes" \
        3>&1 1>&2 2>&3) || return

    local ram_filter
    case "$ram_choice" in
        2)  ram_filter="2 GB" ;;
        4)  ram_filter="4-6 GB" ;;
        8)  ram_filter="8-12 GB" ;;
        16) ram_filter="16-24 GB" ;;
        32) ram_filter="32-48 GB" ;;
        64) ram_filter="64 GB+" ;;
        *)  return ;;
    esac

    local found=()
    for m in "${!MODELOS_RAM[@]}"; do
        [[ "${MODELOS_RAM[$m]}" == "$ram_filter" ]] && found+=("$m")
    done

    IFS=$'\n' found=($(sort <<<"${found[*]}")); unset IFS
    gui_seleccionar_modelos "💾 Modelos para $ram_filter RAM (${#found[@]})" "${found[@]}"
}

# ------------------------------
# OPCIÓN 6 – DESINSTALAR MODELO
# ------------------------------
gui_desinstalar() {
    local installed
    installed=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')

    if [[ -z "$installed" ]]; then
        $GUI_TOOL --title "Sin modelos" --msgbox "No hay modelos instalados actualmente." 8 45
        return
    fi

    local checklist_items=()
    while IFS= read -r m; do
        checklist_items+=("$m" "$m" "OFF")
    done <<< "$installed"

    local selected
    selected=$($GUI_TOOL --title "🗑️ Desinstalar Modelos" \
        --checklist "Selecciona los modelos a eliminar:" \
        25 70 15 \
        "${checklist_items[@]}" \
        3>&1 1>&2 2>&3) || return

    [[ -z "$selected" ]] && return

    local models_del
    IFS=' ' read -ra models_del <<< "$(echo "$selected" | tr -d '"')"

    for model in "${models_del[@]}"; do
        ollama rm "$model" && \
            echo -e "${GREEN}✅ Eliminado: $model${NC}" || \
            echo -e "${RED}❌ Error al eliminar: $model${NC}"
    done

    read -rp "Presiona ENTER para continuar..."
}

# ------------------------------
# OPCIÓN 7 – VER INSTALADOS
# ------------------------------
gui_ver_instalados() {
    local info
    info=$(ollama list 2>/dev/null)

    if [[ -z "$info" ]]; then
        $GUI_TOOL --title "📊 Modelos Instalados" --msgbox "No hay modelos instalados." 8 40
        return
    fi

    $GUI_TOOL --title "📊 Modelos Instalados" --scrolltext --textbox /dev/stdin 25 80 <<< "$info"
}

# ------------------------------
# OPCIÓN 8 – CIBERSEGURIDAD
# ------------------------------
gui_ciberseguridad() {
    local security_models=()
    for m in "${!MODELOS_CAT[@]}"; do
        local cat_lower desc_lower
        cat_lower=$(echo "${MODELOS_CAT[$m]}" | tr '[:upper:]' '[:lower:]')
        desc_lower=$(echo "${MODELOS_DESC[$m]}" | tr '[:upper:]' '[:lower:]')
        for kw in "${SECURITY_KEYWORDS[@]}"; do
            if [[ "$cat_lower" == *"$kw"* ]] || [[ "$desc_lower" == *"$kw"* ]]; then
                security_models+=("$m")
                break
            fi
        done
    done
    IFS=$'\n' security_models=($(sort <<<"${security_models[*]}")); unset IFS
    gui_seleccionar_modelos "🔒 Ciberseguridad (${#security_models[@]} modelos)" "${security_models[@]}"
}

# ------------------------------
# OPCIÓN 9 – PROGRAMACIÓN
# ------------------------------
gui_programacion() {
    local programming_models=()
    for m in "${!MODELOS_CAT[@]}"; do
        local cat_lower desc_lower
        cat_lower=$(echo "${MODELOS_CAT[$m]}" | tr '[:upper:]' '[:lower:]')
        desc_lower=$(echo "${MODELOS_DESC[$m]}" | tr '[:upper:]' '[:lower:]')
        for kw in "${PROGRAMMING_KEYWORDS[@]}"; do
            if [[ "$cat_lower" == *"$kw"* ]] || [[ "$desc_lower" == *"$kw"* ]]; then
                programming_models+=("$m")
                break
            fi
        done
    done
    IFS=$'\n' programming_models=($(sort <<<"${programming_models[*]}")); unset IFS
    gui_seleccionar_modelos "💻 Programación (${#programming_models[@]} modelos)" "${programming_models[@]}"
}

# ══════════════════════════════
#  INICIO DEL PROGRAMA
# ══════════════════════════════
check_gui_deps

if ! command -v ollama &>/dev/null; then
    echo -e "${RED}❌ ERROR: Ollama no está instalado.${NC}"
    echo ""
    echo "  Instala Ollama con:"
    echo -e "  ${CYAN}curl -fsSL https://ollama.ai/install.sh | sh${NC}"
    echo ""
    exit 1
fi

load_catalog
menu_principal
