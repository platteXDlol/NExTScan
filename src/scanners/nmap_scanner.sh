#!/bin/bash
# ===========================================
# Nmap snanns
# ===========================================
#
# Alle Scanns mit Nmap



# Vulnerability Scan
vul_scan() {
    local ip=$1
    local output_dir=$2

    log_info "Starte Vulnerability Scan für $ip..."
    local nmap_vuln_file="$output_dir/nmap_vuln_$ip.txt"
    nmap --script vuln "$ip" > "$nmap_vuln_file" 2>&1
    
    if [[ $? -eq 0 ]]; then
        log_success "Vulnerability Scan für $ip abgeschlossen"
    else
        log_warning "Vulnerability Scan für $ip hatte Probleme"
    fi
}

# Standard Nmap Port Scan
nmap_scan() {
    local ip=$1
    local output_dir=$2
    
    log_info "Starte Nmap Port Scan für $ip..."
    local nmap_file="$output_dir/nmap_scan_$ip.txt"
    nmap -sV -sC "$ip" > "$nmap_file" 2>&1
    
    if [[ $? -eq 0 ]]; then
        log_success "Nmap Scan für $ip abgeschlossen"
    else
        log_warning "Nmap Scan für $ip hatte Probleme"
    fi
}


