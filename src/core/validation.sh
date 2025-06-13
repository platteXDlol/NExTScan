#!/bin/bash
# ===========================================
# Validierung
# ===========================================
#
# Validiert IPs und Netzwerke grob


# Überprüfung Tools installiert
check_requirements() {
    log_info "Überprüfe erforderliche Tools..."

    local tools=("nmap" "netcat" "dig")
    local missing_tools=()

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -ne 0 ]; then
        log_error "Fehlende Tools: ${missing_tools[*]}"
        log_info "Installiere mit: sudo apt-get install ${missing_tools[*]}"
        exit 1
    fi

    log_success "Alle erforderlichen Tools sind verfügbar"
}




# IP-Adresse validieren
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Netzwerk-Range validieren (z.B. 192.168.1.0/24)
validate_network() {
    local network=$1
    if [[ $network =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}$ ]]; then
        return 0
    else
        return 1
    fi
}