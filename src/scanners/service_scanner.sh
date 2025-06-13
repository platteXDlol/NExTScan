#!/bin/bash
# ===========================================
# Service Scanner Module für NExTScan
# ===========================================
#
# Scanns von verschiedenen ports



# Service-spezifische Checks
check_services() {
    local ip=$1
    local output_dir=$2
    local service_file="$output_dir/services_$ip.txt"
    
    log_info "Überprüfe spezifische Services auf $ip..."
    echo "=== Service Check für $ip ===" > "$service_file"
    echo "Datum: $(date)" >> "$service_file"
    echo "" >> "$service_file"
    
    # SSH Check (Port 22)
    if nc -z "$ip" 22 2>/dev/null; then
        log_warning "SSH Service (Port 22) gefunden"
        echo "[SSH] Service aktiv auf $ip:22" >> "$service_file"
        
        # SSH Banner grabbing
        echo "SSH Banner:" >> "$service_file"
        timeout 5 nc "$ip" 22 2>/dev/null | head -3 >> "$service_file"
        echo "" >> "$service_file"
    fi
    
    # HTTP Check (Port 80)
    if nc -z "$ip" 80 2>/dev/null; then
        log_info "HTTP Service (Port 80) gefunden"
        echo "[HTTP] Service aktiv auf $ip:80" >> "$service_file"
        echo "HTTP Headers:" >> "$service_file"
        curl -I -m 10 "http://$ip" >> "$service_file" 2>&1
        echo "" >> "$service_file"
    fi
    
    # HTTPS Check (Port 443)
    if nc -z "$ip" 443 2>/dev/null; then
        log_info "HTTPS Service (Port 443) gefunden"
        echo "[HTTPS] Service aktiv auf $ip:443" >> "$service_file"
        echo "HTTPS Headers:" >> "$service_file"
        curl -I -k -m 10 "https://$ip" >> "$service_file" 2>&1
        echo "" >> "$service_file"
    fi
    
    # FTP Check (Port 21)
    if nc -z "$ip" 21 2>/dev/null; then
        log_warning "FTP Service (Port 21) gefunden"
        echo "[FTP] Service aktiv auf $ip:21" >> "$service_file"
        echo "FTP Banner:" >> "$service_file"
        timeout 5 nc "$ip" 21 2>/dev/null | head -2 >> "$service_file"
        echo "" >> "$service_file"
    fi
    
    # SMB Check (Port 445)
    if nc -z "$ip" 445 2>/dev/null; then
        log_warning "SMB Service (Port 445) gefunden"
        echo "[SMB] Service aktiv auf $ip:445" >> "$service_file"
        echo "" >> "$service_file"
    fi
    
    # Telnet Check (Port 23)
    if nc -z "$ip" 23 2>/dev/null; then
        log_warning "Telnet Service (Port 23) gefunden - UNSICHER!"
        echo "[TELNET] Service aktiv auf $ip:23 - UNSICHER!" >> "$service_file"
        echo "" >> "$service_file"
    fi
    
    log_success "Service Check für $ip abgeschlossen"
}