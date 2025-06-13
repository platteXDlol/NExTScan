#!/bin/bash
# ===========================================
# HTML_Report
# ===========================================
#
# Erstellt eine HTML datei mit den Reports noder öffnet dies





# HTML-Report erstellen
# HTML Report initialisieren
create_html_report() {
    local output_dir=$1
    local html_file="$output_dir/scan_report.html"
    
    # Validierung hinzufügen
    if [[ -z "$output_dir" ]]; then
        log_error "create_html_report: output_dir Parameter fehlt!"
        return 1
    fi
    
    # Stelle sicher dass Verzeichnis existiert
    mkdir -p "$output_dir"
    
    cat > "$html_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Penetration Test Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .header { background: #2c3e50; color: white; padding: 20px; }
        .success { color: #27ae60; }
        .warning { color: #f39c12; }
        .error { color: #e74c3c; }
        .info { color: #3498db; }
        .host-section { border: 1px solid #ddd; margin: 10px 0; padding: 15px; }
        pre { background: #f8f9fa; padding: 10px; overflow-x: auto; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Penetration Test Report</h1>
        <p>Datum: $(date)</p>
        <p>Autor: Pascal Hocher</p>
    </div>
EOF
    
    echo "$html_file"  # Gibt Pfad zurück
}

add_to_html() {
    local html_file=$1
    local content=$2
    local class=${3:-"info"}
    
    # Validierung
    if [[ -z "$html_file" ]] || [[ -z "$content" ]]; then
        log_error "add_to_html: Parameter fehlen!"
        return 1
    fi
    
    # HTML-Zeichen escapen für Sicherheit
    content=$(echo "$content" | sed 's/</\&lt;/g; s/>/\&gt;/g')
    
    echo "<div class=\"$class\">$content</div>" >> "$html_file"
}

finalize_html_report() {
    local html_file=$1
    
    if [[ -z "$html_file" ]]; then
        log_error "finalize_html_report: html_file Parameter fehlt!"
        return 1
    fi
    
    cat >> "$html_file" << EOF
</body>
</html>
EOF
    log_success "HTML-Report erstellt: $html_file"
}








# Letzten HTML Report öffnen
open_last_report() {
    log_info "Suche nach letztem HTML Report..."
    
    # Finde neuesten scan_results Ordner
    local latest_dir=$(ls -dt scan_reports/scan_results_* 2>/dev/null | head -1)
    
    if [ -z "$latest_dir" ]; then
        log_error "Keine Scan-Ergebnisse gefunden!"
        log_info "Führe zuerst einen Scan durch!"
        return 1
    fi
    
    # Suche HTML Report im Ordner
    local html_file=$(find "$latest_dir" -name "scan_report.html" | head -1)
    
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