#!/bin/bash
# ===========================================
# Nmap snanns
# ===========================================
#
# Alle Scanns mit Nmap


# Vulnerability Scann
vul_scan() {
    local target=$1
    local output_dir=$2
    
    log_info "Suche nach bekannten Schwachstellen auf $target..."
    
    # Vulnerability Scripts ausführen
    nmap --script vuln "$target" -oN "$output_dir/vulnerability_$target.txt" > /dev/null 2>&1
    
    # Kritische Schwachstellen zählen - FIX: Zeilenumbrüche entfernen
    local critical_vulns=$(grep -c "CRITICAL" "$output_dir/vulnerability_$target.txt" 2>/dev/null | tr -d '\n' || echo "0")
    local high_vulns=$(grep -c "HIGH" "$output_dir/vulnerability_$target.txt" 2>/dev/null | tr -d '\n' || echo "0")

    
    if [ "$critical_vulns" -gt 0 ] || [ "$high_vulns" -gt 0 ]; then
        log_warning "Gefunden: $critical_vulns kritische und $high_vulns hohe Schwachstellen"
    else
        log_success "Keine kritischen Schwachstellen gefunden"
    fi
}  


# Standard Nmap Port Scan
port_scan() {
    local target=$1
    local output_dir=$2
    
    log_info "Starte Port-Scan für $target..."
    
    # Häufige Ports scannen
    local common_ports="21,22,23,25,53,80,110,143,443,993,995,4444,8080,3389"
    
    nmap -sS -O -sV -p "$common_ports" "$target" -oN "$output_dir/port_scan_$target.txt" > /dev/null 2>&1
    
    # Offene Ports extrahieren
    grep "open" "$output_dir/port_scan_$target.txt" | awk '{print $1, $3, $4, $5}' > "$output_dir/open_ports_$target.txt"
    
    local open_ports=$(wc -l < "$output_dir/open_ports_$target.txt")
    log_success "Gefunden: $open_ports offene Ports auf $target"
}



# Service Detection und Version
service_detection() {
    local target=$1
    local output_dir=$2
    
    log_info "Analysiere Services auf $target..."
    
    # Detaillierter Service-Scan
    nmap -sV -sC --script=default,vuln "$target" -oN "$output_dir/service_scan_$target.txt" > /dev/null 2>&1
    
    log_success "Service-Analyse für $target abgeschlossen"
}


os_detection() {
    local target=$1
    local output_dir=$2
    
    log_info "Bestimme Betriebssystem für $target..."
    
    # OS Detection
    nmap -O "$target" -oN "$output_dir/os_scan_$target.txt" > /dev/null 2>&1
    
    if grep -q "OS details:" "$output_dir/os_scan_$target.txt"; then
        log_success "Betriebssystem für $target erkannt"
    else
        log_warning "Betriebssystem für $target konnte nicht erkannt werden"
    fi
}


udp_scan() {
    local target=$1
    local output_dir=$2
    
    log_info "Starte UPD-Scan für $target..."
    
    # UPD Scan
    local udp_ports="53,67,68,69,123,161,162,514"
    nmap -sU -p "$upd_ports" "$target" -oN "$output_dir/upd_scan_$target.txt" > /dev/null 2>&1

    local open_udp=$(grep "open" "$output_dir/upd_scan_$target.txt" | wc -l)
    log_success "Gefunden: $open_udp offene UPD-Ports auf $target"
}