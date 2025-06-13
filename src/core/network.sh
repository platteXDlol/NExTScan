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
    log_info "Get all IPs in Network $network..."
    
    # Host Discovery
    nmap -sn "$network" -oG - | awk '/Up$/{print $2}'
}