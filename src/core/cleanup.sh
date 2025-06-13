#!/bin/bash
# ===========================================
# cleanup
# ===========================================
#
# Temp Dateien löschen

cleanup() {
 local dir="$1"


    echo "Bereinige Dateien"

    # Durch alle .txt-Dateien iterieren
    find "$dir" -type f -name "*.txt" | while read -r file; do
        rm -f "$file"
    done

    echo "Bereinigung abgeschlossen."
}

