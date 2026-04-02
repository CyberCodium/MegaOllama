#!/bin/bash

# ===================================================
#   OLLAMA INSTALLER - 3000 MODELOS Y HERRAMIENTAS  |     
#                                                   |
#   Carga catálogo desde archivo modelos.txt        |
#                                                   |
#     |Copyright  |  E.B.G |    2026     |          |
#     |All rights reserved | Propietary  |          |
#                                                   |
#     -Sección especializada CIBERSEGURIDAD         |
#                                                   |
#     -Sección especializada PROGRAMACIÓN           |
# ===================================================

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
NC='\033[0m' # No Color
BOLD='\033[1m'

# ------------------------------
# 1. MODELOS PRINCIPALES (RECOMENDADOS)
# ------------------------------
PRINCIPALES=(
"llama3.1:8b"
"llama3:8b"
"mistral:7b"
"phi3:mini"
"deepseek-coder:1.3b"
"qwen:1.5b"
"tinyllama:1.1b"
"gemma:2b"
"llama2:7b"
"codellama:7b"
)

# ------------------------------
# 2. PALABRAS CLAVE PARA FILTRADO
# ------------------------------
# Ciberseguridad
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

# Programación
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
# 3. VARIABLES GLOBALES DEL CATÁLOGO
# ------------------------------
declare -A MODELOS_RAM
declare -A MODELOS_CAT
declare -A MODELOS_DESC
declare -A MODELOS_SIZE
declare -A MODELOS_SIZE_HUMAN

# ------------------------------
# 4. FUNCIONES DE CÁLCULO Y FORMATO
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
# 5. CARGAR CATÁLOGO DESDE ARCHIVO JS
# ------------------------------
load_catalog() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local catalog_file="$script_dir/modelos.txt"
    
    if [[ ! -f "$catalog_file" ]]; then
        echo -e "${RED}❌ ERROR: No se encontró el archivo '$catalog_file'${NC}"
        echo ""
        echo "📋 NECESITAS CREAR EL ARCHIVO modelos.txt"
        echo "============================================"
        echo "1. Crea un archivo llamado 'modelos.txt' en la misma carpeta que este script"
        echo "2. Copia y pega TU LISTA COMPLETA en el archivo"
        echo "3. El archivo debe contener el catálogo en formato JavaScript:"
        echo ""
        echo "   const OLLAMA_MODELS_CATALOGUE = ["
        echo "       { name: \"llama3:8b\", size: 4760350489, category: \"General\", description: \"Modelo base Meta 2024\" },"
        echo "       ..."
        echo "   ];"
        echo ""
        echo "💡 CONSEJO: Tu lista ya tiene el formato correcto, solo guarda como 'modelos.txt'"
        echo ""
        read -p "Presiona ENTER para salir..."
        exit 1
    fi
    
    echo -e "${CYAN}⏳ Cargando catálogo desde '$catalog_file'...${NC}"
    
    local line_number=0
    local loaded=0
    local skipped=0
    
    while IFS= read -r line; do
        ((line_number++))
        
        # Saltar líneas vacías, comentarios, y declaraciones JS
        [[ -z "$line" ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*// ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*const ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*\] ]] && { ((skipped++)); continue; }
        [[ "$line" =~ ^[[:space:]]*}[[:space:]]*,?$ ]] && { ((skipped++)); continue; }
        
        # Si la línea contiene 'name:' entonces es un modelo
        if [[ "$line" =~ name: ]]; then
            # Extraer valores con sed - manejar espacios
            name=$(echo "$line" | sed -n 's/.*name:[[:space:]]*"\([^"]*\)".*/\1/p')
            size=$(echo "$line" | sed -n 's/.*size:[[:space:]]*\([0-9]*\).*/\1/p')
            category=$(echo "$line" | sed -n 's/.*category:[[:space:]]*"\([^"]*\)".*/\1/p')
            description=$(echo "$line" | sed -n 's/.*description:[[:space:]]*"\([^"]*\)".*/\1/p')
            
            # Validar que todos los campos estén presentes
            if [[ -n "$name" && -n "$size" && -n "$category" && -n "$description" ]]; then
                # Añadir a los arrays
                MODELOS_RAM["$name"]=$(calc_ram "$size")
                MODELOS_CAT["$name"]="$category"
                MODELOS_DESC["$name"]="$description"
                MODELOS_SIZE["$name"]="$size"
                MODELOS_SIZE_HUMAN["$name"]=$(format_size "$size")
                ((loaded++))
            else
                echo -e "${YELLOW}⚠️  Línea $line_number ignorada (faltan campos): $line${NC}"
                ((skipped++))
            fi
        fi
    done < "$catalog_file"
    
    echo -e "${GREEN}✅ Catálogo cargado:${NC}"
    echo -e "   • Modelos válidos: ${GREEN}$loaded${NC}"
    echo -e "   • Líneas ignoradas: ${YELLOW}$skipped${NC}"
    echo -e "   • Total en memoria: ${CYAN}${#MODELOS_RAM[@]}${NC}"
    echo ""
}

# ------------------------------
# 6. MOSTRAR CABECERA
# ------------------------------
show_header() {
    clear
    echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════========═╗${NC}"
    echo -e "${PURPLE}║    ${BOLD}OLLAMA  INSTALLER - 3000 MODELOS Y HERRAMIENTAS          ║${NC}"
    echo -e "${PURPLE}║    ${CYAN}E.B.G  | Copyright | 2026  |  All rights reserved.       ║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════========══╝${NC}"
    echo ""
}

# ------------------------------
# 7. FUNCIÓN PARA MOSTRAR Y SELECCIONAR MODELOS
# ------------------------------
seleccionar_modelos() {
    local title="$1"
    shift
    local models_array=("$@")
    local total=${#models_array[@]}
    
    show_header
    echo -e "${YELLOW}$title${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if [[ $total -eq 0 ]]; then
        echo -e "${RED}❌ No se encontraron modelos.${NC}"
        read -p "Presiona ENTER para volver..."
        menu
        return 1
    fi
    
    printf "%-4s %-35s %-12s %-25s %s\n" "No." "Modelo" "Tamaño" "RAM" "Descripción"
    echo "---------------------------------------------------------------------------------------------------"
    
    local i=1
    for m in "${models_array[@]}"; do
        local size_human="${MODELOS_SIZE_HUMAN[$m]:-Desconocido}"
        local ram="${MODELOS_RAM[$m]:-Desconocida}"
        local desc="${MODELOS_DESC[$m]:-Sin descripción}"
        local cat="${MODELOS_CAT[$m]:-General}"
        
        # Color por categoría
        local color=$NC
        case "$cat" in
            *"Programación"*) color=$CYAN ;;
            *"General"*) color=$WHITE ;;
            *"Chat"*) color=$GREEN ;;
            *"Instructivo"*) color=$YELLOW ;;
            *"Seguridad"*) color=$RED ;;
            *"Hacking"*) color=$RED ;;
            *"Penetration"*) color=$RED ;;
            *"Offensive"*) color=$RED ;;
            *"Cybersecurity"*) color=$RED ;;
            *"Exploit"*) color=$RED ;;
            *"Malware"*) color=$RED ;;
            *"Forensics"*) color=$RED ;;
            *"Pentest"*) color=$RED ;;
            *"OSCP"*) color=$RED ;;
            *"OSCE"*) color=$RED ;;
            *) color=$NC ;;
        esac
        
        printf "%-4s ${color}%-35s${NC} %-12s %-25s %s\n" "$i" "$m" "$size_human" "$ram" "$desc"
        ((i++))
    done
    
    echo ""
    printf "%b" "$YELLOW▶ Selecciona números (ej: 1,3,5) o 0 para TODOS: $NC"
    read selection
    
    local selected=()
    if [[ "$selection" == "0" ]]; then
        selected=("${models_array[@]}")
    else
        IFS=',' read -ra indices <<< "$selection"
        for idx in "${indices[@]}"; do
            if [[ $idx =~ ^[0-9]+$ ]] && [[ $idx -ge 1 ]] && [[ $idx -le $total ]]; then
                selected+=("${models_array[$((idx-1))]}")
            fi
        done
    fi
    
    echo ""
    echo -e "${GREEN}📦 Modelos seleccionados (${#selected[@]}):${NC}"
    for model in "${selected[@]}"; do
        echo "  ✓ $model (${MODELOS_SIZE_HUMAN[$model]}, RAM: ${MODELOS_RAM[$model]})"
    done
    echo ""
    
    if [[ ${#selected[@]} -eq 0 ]]; then
        echo -e "${YELLOW}⚠️  No se seleccionó ningún modelo.${NC}"
        read -p "Presiona ENTER para volver..."
        menu
        return 1
    fi
    
    printf "%b" "¿Continuar con la instalación? (s/N): "
    read confirm
    if [[ ! "$confirm" =~ ^[Ss]$ ]]; then
        menu
        return 1
    fi
    
    for model in "${selected[@]}"; do
        echo -e "${CYAN}→${NC} Instalando $model..."
        ollama pull "$model"
    done
    
    read -p "✅ Instalación completada. Presiona ENTER para volver..."
    menu
    return 0
}

# ------------------------------
# 8. MENÚ PRINCIPAL
# ------------------------------
show_menu() {
    show_header
    echo -e "${YELLOW}📋 MENÚ PRINCIPAL${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e " ${GREEN}1)${NC} 📥 Instalar modelos principales (selección múltiple)"
    echo -e " ${GREEN}2)${NC} 🔍 Buscar modelo por nombre"
    echo -e " ${GREEN}3)${NC} 📂 Buscar por categoría"
    echo -e " ${GREEN}4)${NC} 📋 Mostrar lista completa (300+)"
    echo -e " ${GREEN}5)${NC} 💾 Instalar según RAM disponible"
    echo -e " ${GREEN}6)${NC} 🗑️  Desinstalar modelo"
    echo -e " ${GREEN}7)${NC} 📊 Ver modelos instalados"
    echo -e " ${GREEN}8)${NC} 🔒 Modelos de Ciberseguridad"
    echo -e " ${GREEN}9)${NC} 💻 Modelos de Programación"
    echo -e " ${GREEN}10)${NC} ❌ Salir"
    echo ""
    printf "%b" "$YELLOW▶ Selecciona una opción (1-10): $NC"
    read op
}

# ------------------------------
# 9. INSTALAR MODELOS PRINCIPALES
# ------------------------------
instalar_principales() {
    seleccionar_modelos "📥 MODELOS PRINCIPALES RECOMENDADOS" "${PRINCIPALES[@]}"
}

# ------------------------------
# 10. MENÚ CIBERSEGURIDAD
# ------------------------------
menu_ciberseguridad() {
    show_header
    echo -e "${YELLOW}🔒 MODELOS DE CIBERSEGURIDAD${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}📚 Categorías incluidas:${NC}"
    echo "  Pentesting • Hacking • Malware • Forensics • Exploits • Web Security"
    echo "  Network Security • Cryptography • Cloud Security • Mobile Security"
    echo ""
    read -p "Presiona ENTER para ver la lista..."
    
    # Filtrar modelos de ciberseguridad
    local security_models=()
    for m in "${!MODELOS_CAT[@]}"; do
        local cat_lower=$(echo "${MODELOS_CAT[$m]}" | tr '[:upper:]' '[:lower:]')
        local desc_lower=$(echo "${MODELOS_DESC[$m]}" | tr '[:upper:]' '[:lower:]')
        for kw in "${SECURITY_KEYWORDS[@]}"; do
            if [[ "$cat_lower" == *"$kw"* ]] || [[ "$desc_lower" == *"$kw"* ]]; then
                security_models+=("$m")
                break
            fi
        done
    done
    
    # Ordenar por nombre
    IFS=$'\n' sorted=($(sort <<<"${security_models[*]}"))
    unset IFS
    security_models=("${sorted[@]}")
    
    echo ""
    echo -e "${GREEN}🔍 Encontrados ${#security_models[@]} modelos de ciberseguridad${NC}"
    echo ""
    read -p "Presiona ENTER para continuar..."
    
    seleccionar_modelos "🔒 MODELOS DE CIBERSEGURIDAD (${#security_models[@]})" "${security_models[@]}"
}

# ------------------------------
# 11. MENÚ PROGRAMACIÓN
# ------------------------------
menu_programacion() {
    show_header
    echo -e "${YELLOW}💻 MODELOS DE PROGRAMACIÓN${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "${CYAN}📚 Categorías incluidas:${NC}"
    echo "  Programación • Código • Python • JavaScript • Java • C++ • C# • Go • Rust"
    echo "  CodeLlama • StarCoder • WizardCoder • Qwen Coder • DeepSeek Coder"
    echo ""
    read -p "Presiona ENTER para ver la lista..."
    
    # Filtrar modelos de programación
    local programming_models=()
    for m in "${!MODELOS_CAT[@]}"; do
        local cat_lower=$(echo "${MODELOS_CAT[$m]}" | tr '[:upper:]' '[:lower:]')
        local desc_lower=$(echo "${MODELOS_DESC[$m]}" | tr '[:upper:]' '[:lower:]')
        for kw in "${PROGRAMMING_KEYWORDS[@]}"; do
            if [[ "$cat_lower" == *"$kw"* ]] || [[ "$desc_lower" == *"$kw"* ]]; then
                programming_models+=("$m")
                break
            fi
        done
    done
    
    # Ordenar por nombre
    IFS=$'\n' sorted=($(sort <<<"${programming_models[*]}"))
    unset IFS
    programming_models=("${sorted[@]}")
    
    echo ""
    echo -e "${GREEN}🔍 Encontrados ${#programming_models[@]} modelos de programación${NC}"
    echo ""
    read -p "Presiona ENTER para continuar..."
    
    seleccionar_modelos "💻 MODELOS DE PROGRAMACIÓN (${#programming_models[@]})" "${programming_models[@]}"
}

# ------------------------------
# 12. BÚSQUEDA POR NOMBRE
# ------------------------------
buscar_nombre() {
    show_header
    echo -e "${YELLOW}🔍 BUSCAR MODELO POR NOMBRE${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    printf "%b" "$CYAN▶ Introduce parte del nombre: $NC"
    read q
    
    if [[ -z "$q" ]]; then
        menu
        return
    fi
    
    echo ""
    echo -e "${GREEN}📋 RESULTADOS DE BÚSQUEDA:${NC}"
    printf "%-35s %-12s %-25s %s\n" "Modelo" "Tamaño" "RAM" "Categoría"
    echo "--------------------------------------------------------------------------------"
    
    local found=()
    for m in "${!MODELOS_RAM[@]}"; do
        if [[ $m == *"$q"* ]]; then
            found+=("$m")
        fi
    done
    
    if [[ ${#found[@]} -eq 0 ]]; then
        echo -e "${RED}❌ No se encontraron modelos con '$q'${NC}"
    else
        for m in "${found[@]}"; do
            printf "%-35s %-12s %-25s %s\n" "$m" "${MODELOS_SIZE_HUMAN[$m]}" "${MODELOS_RAM[$m]}" "${MODELOS_CAT[$m]}"
        done
    fi
    
    echo ""
    printf "%b" "$YELLOW▶ Escribe el nombre EXACTO para instalar (o ENTER para volver): $NC"
    read inst
    if [[ -n "$inst" ]] && [[ -n "${MODELOS_RAM[$inst]}" ]]; then
        echo -e "${GREEN}📦 Instalando $inst...${NC}"
        ollama pull "$inst"
        read -p "✅ Completado. Presiona ENTER para volver..."
    fi
    menu
}

# ------------------------------
# 13. BÚSQUEDA POR CATEGORÍA
# ------------------------------
buscar_categoria() {
    show_header
    echo -e "${YELLOW}📂 BUSCAR POR CATEGORÍA${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    printf "%b" "$CYAN▶ Introduce categoría (ej: Programación, Chat, Seguridad): $NC"
    read cat
    
    if [[ -z "$cat" ]]; then
        menu
        return
    fi
    
    echo ""
    echo -e "${GREEN}📋 MODELOS EN CATEGORÍA '$cat':${NC}"
    printf "%-35s %-12s %-25s %s\n" "Modelo" "Tamaño" "RAM" "Categoría"
    echo "--------------------------------------------------------------------------------"
    
    local found=()
    for m in "${!MODELOS_CAT[@]}"; do
        if [[ "${MODELOS_CAT[$m]}" == *"$cat"* ]]; then
            found+=("$m")
        fi
    done
    
    if [[ ${#found[@]} -eq 0 ]]; then
        echo -e "${RED}❌ No se encontraron modelos en categoría '$cat'${NC}"
    else
        for m in "${found[@]}"; do
            printf "%-35s %-12s %-25s %s\n" "$m" "${MODELOS_SIZE_HUMAN[$m]}" "${MODELOS_RAM[$m]}" "${MODELOS_CAT[$m]}"
        done
    fi
    
    echo ""
    printf "%b" "$YELLOW▶ Escribe el nombre EXACTO para instalar (o ENTER para volver): $NC"
    read inst
    if [[ -n "$inst" ]] && [[ -n "${MODELOS_RAM[$inst]}" ]]; then
        echo -e "${GREEN}📦 Instalando $inst...${NC}"
        ollama pull "$inst"
        read -p "✅ Completado. Presiona ENTER para volver..."
    fi
    menu
}

# ------------------------------
# 14. LISTA COMPLETA
# ------------------------------
lista_completa() {
    show_header
    echo -e "${YELLOW}📋 LISTA COMPLETA DE MODELOS (300+)${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    echo -e "${CYAN}📊 Mostrando todos los modelos en catálogo...${NC}"
    echo ""
    
    local total=0
    for m in "${!MODELOS_RAM[@]}"; do
        printf "%-35s %-12s %-25s %s\n" "$m" "${MODELOS_SIZE_HUMAN[$m]}" "${MODELOS_RAM[$m]}" "${MODELOS_CAT[$m]}"
        ((total++))
    done
    
    echo ""
    echo -e "${GREEN}📈 Total de modelos en catálogo: $total${NC}"
    echo ""
    printf "%b" "$YELLOW▶ Escribe el nombre EXACTO para instalar (o ENTER para volver): $NC"
    read inst
    if [[ -n "$inst" ]] && [[ -n "${MODELOS_RAM[$inst]}" ]]; then
        echo -e "${GREEN}📦 Instalando $inst...${NC}"
        ollama pull "$inst"
        read -p "✅ Completado. Presiona ENTER para volver..."
    fi
    menu
}

# ------------------------------
# 15. INSTALAR SEGÚN RAM DISPONIBLE
# ------------------------------
instalar_por_ram() {
    show_header
    echo -e "${YELLOW}💾 INSTALAR SEGÚN RAM DISPONIBLE${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Detectar RAM
    if command -v free &> /dev/null; then
        ram_total=$(free -g | awk '/Mem:/ {print $2}')
        ram_swap=$(free -g | awk '/Swap:/ {print $2}')
    elif command -v sysctl &> /dev/null; then
        ram_total=$(($(sysctl hw.memsize | awk '{print $2}') / 1024 / 1024 / 1024))
        ram_swap=0
    else
        echo -e "${RED}❌ No se pudo detectar la RAM. Por favor, introduce manualmente:${NC}"
        printf "%b" "RAM disponible en GB: "
        read ram_total
    fi
    
    ram_usable=$((ram_total * 80 / 100))  # Usar 80% como máximo seguro
    
    echo -e "${CYAN}🖥️  Información del sistema:${NC}"
    echo "   RAM total: ${ram_total}GB"
    echo "   RAM usable (80%): ${ram_usable}GB"
    echo ""
    echo -e "${GREEN}📋 Modelos que caben en ${ram_usable}GB:${NC}"
    echo ""
    
    local compatible=()
    for m in "${!MODELOS_RAM[@]}"; do
        ram_req=$(echo "${MODELOS_RAM[$m]}" | sed 's/[^0-9]//g')
        if [[ -n "$ram_req" ]] && [[ $ram_req -le $ram_usable ]]; then
            compatible+=("$m")
        fi
    done
    
    # Ordenar por RAM requerida
    IFS=$'\n' sorted=($(sort -t '|' -k2,2n <<<"${compatible[*]}"))
    unset IFS
    compatible=("${sorted[@]}")
    
    printf "%-35s %-12s %-25s %s\n" "Modelo" "Tamaño" "RAM Recomendada" "Categoría"
    echo "------------------------------------------------------------------------------------------"
    
    for m in "${compatible[@]}"; do
        printf "%-35s %-12s %-25s %s\n" "$m" "${MODELOS_SIZE_HUMAN[$m]}" "${MODELOS_RAM[$m]}" "${MODELOS_CAT[$m]}"
    done
    
    echo ""
    echo -e "${CYAN}📊 Modelos compatibles: ${#compatible[@]}${NC}"
    echo ""
    printf "%b" "$YELLOW▶ Escribe el nombre EXACTO para instalar (o ENTER para volver): $NC"
    read inst
    if [[ -n "$inst" ]] && [[ -n "${MODELOS_RAM[$inst]}" ]]; then
        echo -e "${GREEN}📦 Instalando $inst...${NC}"
        ollama pull "$inst"
        read -p "✅ Completado. Presiona ENTER para volver..."
    fi
    menu
}

# ------------------------------
# 16. DESINSTALAR MODELO
# ------------------------------
desinstalar_modelo() {
    show_header
    echo -e "${YELLOW}🗑️  DESINSTALAR MODELO${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    # Listar modelos instalados
    if command -v ollama &> /dev/null; then
        installed=$(ollama list 2>/dev/null | tail -n +2 | awk '{print $1}')
        if [[ -z "$installed" ]]; then
            echo -e "${YELLOW}⚠️  No hay modelos instalados actualmente.${NC}"
            read -p "Presiona ENTER para volver..."
            menu
            return
        fi
        
        echo -e "${CYAN}📋 Modelos instalados:${NC}"
        echo ""
        printf "%-35s %-12s %-25s\n" "Modelo" "Tamaño" "Fecha"
        echo "--------------------------------------------------------------"
        
        for model in $installed; do
            size=$(ollama list | grep "^$model" | awk '{print $2}')
            created=$(ollama list | grep "^$model" | awk '{print $3, $4}')
            printf "%-35s %-12s %-25s\n" "$model" "$size" "$created"
        done
        
        echo ""
        printf "%b" "$YELLOW▶ Escribe el nombre EXACTO del modelo a desinstalar: $NC"
        read inst
        
        if [[ -n "$inst" ]]; then
            echo ""
            printf "%b" "$RED▶ ¿Estás SEGURO de desinstalar '$inst'? (s/N): $NC"
            read confirm
            if [[ "$confirm" =~ ^[Ss]$ ]]; then
                echo -e "${YELLOW}🗑️  Desinstalando $inst...${NC}"
                ollama rm "$inst"
                echo -e "${GREEN}✅ Modelo desinstalado${NC}"
            else
                echo -e "${CYAN}❌ Cancelado${NC}"
            fi
        fi
    else
        echo -e "${RED}❌ Ollama no está instalado o no está en PATH${NC}"
    fi
    
    read -p "Presiona ENTER para volver..."
    menu
}

# ------------------------------
# 17. VER MODELOS INSTALADOS
# ------------------------------
ver_instalados() {
    show_header
    echo -e "${YELLOW}📊 MODELOS INSTALADOS${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    
    if command -v ollama &> /dev/null; then
        echo -e "${CYAN}📋 Lista de modelos en tu sistema:${NC}"
        echo ""
        ollama list
    else
        echo -e "${RED}❌ Ollama no está instalado o no está en PATH${NC}"
    fi
    
    echo ""
    read -p "Presiona ENTER para volver..."
    menu
}

# ------------------------------
# 18. FUNCIÓN MENÚ PRINCIPAL
# ------------------------------
menu() {
    show_menu
    case $op in
        1) instalar_principales ;;
        2) buscar_nombre ;;
        3) buscar_categoria ;;
        4) lista_completa ;;
        5) instalar_por_ram ;;
        6) desinstalar_modelo ;;
        7) ver_instalados ;;
        8) menu_ciberseguridad ;;
        9) menu_programacion ;;
        10) 
            echo -e "${GREEN}👋 ¡Hasta pronto!${NC}"
            exit 0
            ;;
        *) 
            echo -e "${RED}❌ Opción inválida${NC}"
            sleep 1
            menu
            ;;
    esac
}

# ------------------------------
# 19. INICIO
# ------------------------------
# Verificar que ollama esté instalado
if ! command -v ollama &> /dev/null; then
    show_header
    echo -e "${RED}❌ ERROR: Ollama no está instalado${NC}"
    echo ""
    echo "Por favor, instala Ollama primero:"
    echo -e "${CYAN}curl -fsSL https://ollama.ai/install.sh | sh${NC}"
    echo ""
    read -p "Presiona ENTER para salir..."
    exit 1
fi

# Cargar catálogo desde archivo
load_catalog

# Ejecutar menú
menu
