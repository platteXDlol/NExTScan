#!/bin/bash
# ===========================================
# netzwerke
# ===========================================
#
# sammelt alle erreichbaren IPs



# Hostname to IP
hostname_finder() {
    local hostname=$1

    local ip=$(dig +short "$hostname" 2>/dev/null | head -1)
    if [[ -n "$ip" ]] && validate_ip "$ip"; then
        echo "$ip"
        return 0
    else
        echo ""
        return 1
    fi
}


# Funktion zum Testen der Erreichbarkeit
check_ip_reachability() {
    local target_ip=$1

    if ping -c 1 -W 3 "$target_ip" &>/dev/null; then
        echo "✓ $target_ip ist erreichbar"
        reachable_ips+=("$target_ip")
        return 0
    else
        echo "✗ $target_ip ist nicht erreichbar"
        unreachable_ips+=("$target_ip")
        return 1
    fi
}




# All Rechable IPs in Network
network_ips() {
    local network=$1
    log_info "Scanne Netzwerk $network..."
    
    # Arrays leeren für neuen Scan
    reachable_ips=()
    unreachable_ips=()
    
    # Host Discovery
    nmap -sn "$network" -oG - | awk '/Up$/{print $2}'

    # Jede gefundene IP testen
    while read -r ip; do
        if [[ -n "$ip" ]] && validate_ip "$ip"; then
            check_ip_reachability "$ip"
        fi
    done < temp_ips.txt
    
    rm -f temp_ips.txt
    
    log_info "Netzwerk-Scan abgeschlossen. Gefunden: ${#reachable_ips[@]} erreichbare IPs"
    
    # Automatisch alle gefundenen IPs scannen
    if [ ${#reachable_ips[@]} -gt 0 ]; then
        # Neues output_dir für Netzwerk-Scan
        local network_output_dir="scan_reports/scan_results_$(date +%Y%m%d_%H%M%S)"
        mkdir -p "$network_output_dir"
        start_scanning "$network_output_dir"
    else
        log_warning "Keine erreichbaren IPs zum Scannen gefunden"
    fi
}