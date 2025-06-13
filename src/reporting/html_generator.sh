#!/bin/bash
# ===========================================
# HTML_Report
# ===========================================
#
# Erstellt eine HTML datei mit den Reports noder öffnet dies





# HTML-Report erstellen
create_html_report() {
    local output_dir=$1
    local html_file="$output_dir/scan_report.html"

    [[ -z "$output_dir" ]] && { log_error "create_html_report: output_dir Parameter fehlt!"; return 1; }

    mkdir -p "$output_dir"

    cat >"$html_file" <<'EOF'
<!DOCTYPE html>
<html lang="de">
<head>
    <meta charset="UTF-8">
    <title>Penetration Test Report</title>
    <style>
        body         { font-family: Arial, sans-serif; margin: 20px; }
        .header      { background:#2c3e50; color:#fff; padding:20px; border-radius:6px; }
        .success     { color:#27ae60; }
        .warning     { color:#f39c12; }
        .error       { color:#e74c3c; }
        .info        { color:#3498db; }
        .host-section{ border:1px solid #ddd; margin:20px 0; padding:15px; border-radius:6px;
                       background:#fafafa; box-shadow:0 0 5px rgba(0,0,0,.05); }
        h2           { margin-top:0; }
        pre          { background:#f8f9fa; padding:10px; overflow-x:auto; border-radius:4px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Penetration Test Report</h1>
        <p>Datum: $(date)</p>
        <p>Autor: Pascal Hocher</p>
    </div>
EOF
    echo "$html_file"
}

add() {
    add_to_html "$html_file" "<h3>Offene Ports:</h3>" "info" true
    add_to_html "$html_file" "<pre>$(head -20 "$output_dir/port_scan_$ip.txt")</pre>" "info" true
    # Service
    add_to_html "$html_file" "<h3>Service Detection:</h3>" "info" true
    add_to_html "$html_file" "<pre>$(head -20 "$output_dir/service_scan_$ip.txt")</pre>" "info" true
    # Vuln
    add_to_html "$html_file" "<h3>Vulnerability Scan:</h3>" "warning" true
    add_to_html "$html_file" "<pre>$(head -20 "$output_dir/vulnerability_$ip.txt")</pre>" "warning" true
    # OS
    add_to_html "$html_file" "<h3>OS Detection:</h3>" "info" true
    add_to_html "$html_file" "<pre>$(head -20 "$output_dir/os_scan_$ip.txt")</pre>" "info" true
    # UPD
    add_to_html "$html_file" "<h3>UDP Scan:</h3>" "info" true
    add_to_html "$html_file" "<pre>$(head -20 "$output_dir/udp_scan_$ip.txt")</pre>" "info" true
}

add_to_html() {
    local html_file=$1
    local content=$2
    local class=${3:-"info"}
    local raw=${4:-false}

    [[ -z "$html_file" || -z "$content" ]] && { log_error "add_to_html: Parameter fehlen!"; return 1; }

    # Bei Bedarf escapen
    if [[ "$raw" != true ]]; then
        content=$(echo "$content" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g')
    fi

    echo "<div class=\"$class\">$content</div>" >>"$html_file"
}





finalize_html_report() {
    local html_file=$1
    [[ -z "$html_file" ]] && { log_error "finalize_html_report: html_file Parameter fehlt!"; return 1; }

    cat >>"$html_file" <<'EOF'
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