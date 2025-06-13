#!/bin/bash
# ===========================================
# cleanup
# ===========================================
#
# Temp Dateien löschen

cleanup() {
 local dir="$1"

    # Prüfen, ob Verzeichnis existiert
    if [[ ! -d "$dir" ]]; then
        echo "Verzeichnis '$dir' existiert nicht."
        return 1
    fi

    echo "Bereinige .txt-Dateien in: $dir"

    # Durch alle .txt-Dateien iterieren
    find "$dir" -type f -name "*.txt" | while read -r file; do
        echo "Lösche: $file"
        rm -f "$file"
    done

    echo "Bereinigung abgeschlossen."
}

