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
    
    cat > "$html_file" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>NExTScan Report</title>
    <meta charset="UTF-8">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            margin: 20px; 
            background-color: #f5f5f5;
        }
        .header {
            background-color: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .success { color: #27ae60; font-weight: bold; }
        .error { color: #e74c3c; font-weight: bold; }
        .warning { color: #f39c12; font-weight: bold; }
        .info { color: #3498db; font-weight: bold; }
        pre { 
            background: #ecf0f1; 
            padding: 15px; 
            border-radius: 5px;
            overflow-x: auto;
            border-left: 4px solid #3498db;
        }
        .host-section {
            background: white;
            margin: 20px 0;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .summary {
            display: flex;
            justify-content: space-around;
            background: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .summary div {
            text-align: center;
        }
        .summary h3 {
            margin: 0;
            color: #2c3e50;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🔍 NExTScan Penetration Test Report</h1>
        <p>Erstellt am: $(date)</p>
        <p>Scan durchgeführt von: $(whoami)</p>
    </div>
    
    <div class="summary">
        <div>
            <h3>${#reachable_ips[@]}</h3>
            <p class="success">Erreichbare IPs</p>
        </div>
        <div>
            <h3>${#unreachable_ips[@]}</h3>
            <p class="error">Nicht erreichbare IPs</p>
        </div>
        <div>
            <h3>$(date +%H:%M)</h3>
            <p class="info">Scan-Zeit</p>
        </div>
    </div>
EOF
    
    echo "$html_file"
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
    local html_file="$latest_dir/scan_report.html"
    
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