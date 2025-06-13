#!/bin/bash
# ===========================================
# HTML_Report
# ===========================================
#
# Erstellt eine HTML datei mit den Reports noder öffnet dies





# HTML-Report erstellen
create_html_report() {
    local target=$1
    local output_dir=$2
    local report_file="$output_dir/security_report_$(date +%Y%m%d_%H%M%S).html"
    
    log_info "Generiere Security Report..."
    
    cat > "$report_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Security Assessment Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background-color: #2c3e50; color: white; padding: 20px; text-align: center; }
        .section { margin: 20px 0; padding: 15px; border-left: 4px solid #3498db; }
        .critical { border-left-color: #e74c3c; }
        .warning { border-left-color: #f39c12; }
        .success { border-left-color: #27ae60; }
        .code { background-color: #f8f9fa; padding: 10px; font-family: monospace; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Security Assessment Report</h1>
        <p>Target: $target | Date: $(date)</p>
    </div>
    
    <div class="section">
        <h2>Executive Summary</h2>
        <p>Automated security assessment wurde für $target durchgeführt.</p>
    </div>
    
    <div class="section">
        <h2>Offene Ports</h2>
        <table>
            <tr><th>Port</th><th>Status</th><th>Service</th><th>Version</th></tr>
EOF










    # Offene Ports in Tabelle einfügen
    if [ -f "$output_dir/open_ports_$target.txt" ]; then
        while read line; do
            echo "            <tr><td>$(echo $line | awk '{print $1}')</td><td>$(echo $line | awk '{print $2}')</td><td>$(echo $line | awk '{print $3}')</td><td>$(echo $line | awk '{print $4}')</td></tr>" >> "$report_file"
        done < "$output_dir/open_ports_$target.txt"
    fi
    
    cat >> "$report_file" << EOF
        </table>
    </div>
    
    <div class="section">
        <h2>Empfehlungen</h2>
        <ul>
            <li>Schließe unnötige offene Ports</li>
            <li>Update alle Services auf aktuelle Versionen</li>
            <li>Implementiere Firewall-Regeln</li>
            <li>Regelmäßige Security-Updates durchführen</li>
        </ul>
    </div>
</body>
</html>
EOF
    
    log_success "Report erstellt: $report_file"
}





# Letzten HTML Report öffnen (KORRIGIERT)
open_last_report() {
    log_info "Suche nach letztem HTML Report..."
    
    # Finde neuesten scan_results Ordner (KORRIGIERT)
    local latest_dir=$(ls -dt scan_reports/scan_results_* 2>/dev/null | head -1)
    
    if [ -z "$latest_dir" ]; then
        log_error "Keine Scan-Ergebnisse gefunden!"
        log_info "Führe zuerst einen Scan durch!"
        return 1
    fi
    
    # Suche HTML Report im Ordner
    local html_file=$(find "$latest_dir" -name "security_report_*.html" | head -1)
    
    if [ ! -f "$html_file" ]; then
        log_error "HTML Report nicht gefunden in $latest_dir"
        return 1
    fi
    
    log_success "Öffne Report: $html_file"
    
    # Versuche verschiedene Browser zu verwenden
    if command -v firefox &> /dev/null; then
        firefox "$html_file" 2>/dev/null &
        log_success "Report in Firefox geöffnet"
    elif command -v chromium &> /dev/null; then
        chromium "$html_file" 2>/dev/null &
        log_success "Report in Chromium geöffnet"
    elif command -v google-chrome &> /dev/null; then
        google-chrome "$html_file" 2>/dev/null &
        log_success "Report in Chrome geöffnet"
    elif command -v xdg-open &> /dev/null; then
        xdg-open "$html_file" 2>/dev/null &
        log_success "Report mit Standard-Browser geöffnet"
    else
        log_warning "Kein Browser gefunden!"
        log_info "Öffne manuell: $html_file"
        log_info "Oder verwende: firefox $html_file"
    fi
}